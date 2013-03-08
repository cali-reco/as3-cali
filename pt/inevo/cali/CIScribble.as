package pt.inevo.cali
{
	public class CIScribble
	{
		var _len:Number;
    	var _totalSpeed:Number;
    	var _strokes:CIList; //CIList<CIStroke *> *

    	var _boundingBox:CIPolygon;    // The points are order
    	var _convexHull:CIPolygon; 
    	var _largestTriangleOld:CIPolygon; 
    	var _enclosingRect:CIPolygon; 
    	var _largestQuadOld:CIPolygon; 
    	var _largestTriangle:CIPolygon; 
    	var _largestQuad:CIPolygon; 
    
		public function CIScribble () 
		{
		    _len = 0;
		    _totalSpeed = 0;
		    _strokes = new CIList(); //<CIStroke *> ();
		
		    _boundingBox = null;
		    _convexHull = null;
		    _largestTriangleOld = null;
		    _largestTriangle = null;
		    _largestQuadOld = null;
		    _largestQuad = null;
		    _enclosingRect = null;
		}
		
		public function getNumStrokes():int		// Number of strokes of the scribble
        { return _strokes.getNumItems() }
        
        public function getStrokes():CIList  // List of strokes of the scribble
        { return _strokes; }
        
        public function getLen():Number// Scribble length
        { return _len; }
        
        public function getAvgSpeed():Number	// Drawing average speed of the scribble
        { return _totalSpeed/getNumStrokes(); }
        
		/*----------------------------------------------------------------------------+
		| Description: Creates a copy (a clone) of the current scribble.
		| Output: A new scribble like the current one.
		+----------------------------------------------------------------------------*/
		public function clone():CIScribble
		{
		    var ns:int, np:int;
		    var strk:CIStroke;
		    var stroke:CIStroke;
		    var pts:CIList; //<CIPoint *> *
		    var scribb:CIScribble = new CIScribble();
		 
		    ns = getNumStrokes();
		    var s:int;
		    for (s=0; s<ns; s++) {
		        strk = _strokes.getItemAt(s);
		        stroke = new CIStroke();
		        np = strk.getNumPoints();
		        pts = strk.getPoints();
		        var p:int;
		        for (p=0; p<np; p++) {
		            stroke.addPoint(pts.getItemAt(p).x, pts.getItemAt(p).y, pts.getItemAt(p).getTime());
		        }
		        scribb.addStroke(stroke);
		    }
		    return scribb;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Adds a new stroke to the end of the list of strokes manipulated
		|              by the scribble. It also computes the new length of the scribble
		|              and the new drawing speed.
		| Input: A stroke
		+----------------------------------------------------------------------------*/
		public function addStroke(stroke:CIStroke):void
		{
		    _len += stroke.getLen();
		    _totalSpeed += stroke.getDrawingSpeed();
		    _strokes.insertTail(stroke);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Pops out the last stroke of the scribble
		| Output: The last stroke
		+----------------------------------------------------------------------------*/
		public function popStroke():CIStroke
		{
		    var strk:CIStroke;
		
		    strk = _strokes.pop();
		    _len -= strk.getLen();
		    _totalSpeed -= strk.getDrawingSpeed();
		
		    _boundingBox = null;
		    _convexHull = null;
		    _largestTriangle = null;
		    _largestTriangleOld = null;
		    _largestQuadOld = null;
		    _largestQuad = null;
		    _enclosingRect = null;
		
		    return strk;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the correct timeout, based on the drawing speed.
		| Output: Timeout, in milliseconds
		| Notes: Actually it returns a constant value, because the formula used to 
		|        the "best" timeout is not very good. We are searching for a better one :-)
		+----------------------------------------------------------------------------*/
		public function getTimeOut():int
		{
		    return 550; // to delete <<<<<<<<<<
		
		    var avs:Number = getAvgSpeed();
		    if (avs >= 900)
		        return TIMEOUT_BASE + 0;
		    else if (avs <= 100)
		        return TIMEOUT_BASE + 400;
		    else // y=-0.5*x+450
		        return (int) (TIMEOUT_BASE + (-0.5*avs + 450));
		}
		
		// ------------- Polygons
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the convex hull of the scribble, using the Graham's
		|              algorithm. After the computation of the convex hull, we perform
		|              a simple filtration to eliminate points that are very close.
		| Output: A polygon that is the convex hull.
		+----------------------------------------------------------------------------*/
		public function convexHull():CIPolygon
		{
		    if (_convexHull == null) {
		        _convexHull = new CIPolygon();
		        var ordedPoints:CIList = new CIList(false);//CIList<CIPoint *> (false);
		        var min:CIPoint;
				var tmp:CIPoint;
		        var np:int;
		        var i:int;
		        var pts:CIList; //<CIPoint> *
		
		        min = findLowest();
		        ordedPoints = ordPoints(ordedPoints,min);
		        np = ordedPoints.getNumItems();
		        _convexHull.push(ordedPoints.getItemAt(np-1));
		        _convexHull.push(ordedPoints.getItemAt(0));
		        
		        pts = _convexHull.getPoints();
		        i=1;
		        var nc:int  = _convexHull.getNumPoints();
		        while (np>2 && i<np) {
		            if (CIFunction.left(pts.getItemAt(nc-2), pts.getItemAt(nc-1), ordedPoints.getItemAt(i))) {
		                _convexHull.push(ordedPoints.getItemAt(i));
		                i++;
		                nc++;
		            }
		            else {
		                tmp = _convexHull.pop();
		                nc--;
		            }
		        }
		        
		        _convexHull = filterConvexHull(); // reduce the number of points
		    }
		    return _convexHull;
		}
		
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the bounding box of the convex hull.
		| Output: A polygon that is the bounding box.
		+----------------------------------------------------------------------------*/
		public function boundingBox():CIPolygon
		{
		    if (_boundingBox == null) {
			    convexHull();
		
		        var pts:CIList = _convexHull.getPoints(); //CIList<CIPoint> *
		        var np:int = _convexHull.getNumPoints();
			    var x1:int;
			    var x2:int;
			    var y1:int;
			    var y2:int;
		
			    x1=x2= pts.getItemAt(0).x;
			    y1=y2=pts.getItemAt(0).y;
		  
		  		var i:int;
		        for ( i = 0; i < np ; i++) {
			    if (pts.getItemAt(i).x < x1)
			        x1 = pts.getItemAt(i).x;
			    if (pts.getItemAt(i).x > x2)
			        x2 = pts.getItemAt(i).x;
			    if (pts.getItemAt(i).y < y1)
			        y1 = pts.getItemAt(i).y;
			    if (pts.getItemAt(i).y > y2)
			        y2 = pts.getItemAt(i).y;
		        }
		
			    // Tranfer the points to a polygon
			    _boundingBox = new CIPolygon();
			    _boundingBox.addPoint(new CIPoint(x1,y1));
			    _boundingBox.addPoint(new CIPoint(x2,y1));
			    _boundingBox.addPoint(new CIPoint(x2,y2));
			    _boundingBox.addPoint(new CIPoint(x1,y2));
			    _boundingBox.addPoint(new CIPoint(x1,y1));
		    }
		    return _boundingBox;
		}  
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the largest triangle that fits inside the convex hull
		| Output: A polygon that is the largest triangle.
		| Notes: We used the algorithm described by J.E. Boyce and D.P. Dobkin.
		+----------------------------------------------------------------------------*/
		public function largestTriangle():CIPolygon
		{
		    if (_largestTriangle == null) {
			    convexHull();
			    
			    var pa:CIPoint;
			    var pb:CIPoint;
			    var pc:CIPoint;
			    var ia:int;
			    var ib:int;
			    var ic:int;
			    var i:int;
			    
		        var ripa:int;
		        var ripb:int;
		        var ripc:int;// indexes of rooted triangle
		        
			    var area:Number;
			    var triArea:Number;
			    
		        var numPts:int = _convexHull.getNumPoints();
		        var pts:CIList = _convexHull.getPoints(); //CIList<CIPoint> *
		
		        if (numPts <= 3) {
				    _largestTriangle = new CIPolygon();
				    for (i=0; i<numPts; i++)
					    _largestTriangle.addPoint(pts.getItemAt(i));
				    for (i= numPts; i < 4; i++)
					    _largestTriangle.addPoint(pts.getItemAt(0));
		            return _largestTriangle;
		        }
		
			// computes one rooted triangle with root in the first point of the convex hull
		        ia = 0;
		        area = 0;
		        triArea = 0;
		        for(ib=1; ib <= numPts-2; ib++) {
		            if (ib >= 2)
		                ic = ib + 1;
		            else
		                ic = 2;
		            area = compRootedTri (pts, ia, ib, ic, numPts);
		            if (area > triArea) {
		                triArea = area;
		                ripa = ia;
		                ripb = ib;
		                ripc = ic;
		            }
		        } // ripa, ripb and ripc are the indexes of the points of the rooted triangle
		
		
				// computes other triangles and choose the largest one
		        var finalArea:Number = triArea;
		        var pf0:int;
		        var pf1:int;
		        var pf2:int;   // indexes of the final points
		        var fipa:int;
		        var fipb:int;
		        var fipc:int;
		        var ib0:int;

		        pf0 = ripa;
		        pf1 = ripb;
		        pf2 = ripc;
		
		        for(ia=ripa+1; ia<= ripb; ia++) {
		            triArea = 0;
		            if (ia == ripb)
		                ib0 = ripb + 1;
		            else
		                ib0 = ripb;
		            area = 0;
		            for(ib=ib0; ib <= ripc; ib++) {
		                if (ib == ripc)
		                    ic = ripc + 1;
		                else
		                    ic = ripc;
		                area = compRootedTri (pts, ia, ib, ic, numPts);
		                if (area > triArea) {
		                    triArea = area;
		                    fipa = ia;
		                    fipb = ib;
		                    fipc = ic;
		                }
		            }
		            if(triArea > finalArea) {
		                finalArea = triArea;
		                pf0 = fipa;
		                pf1 = fipb;
		                pf2 = fipc;
		            }
		        }
		
			// Tranfer the points to a polygon
			    _largestTriangle = new CIPolygon();
			    _largestTriangle.addPoint(pts.getItemAt(pf0));
			    _largestTriangle.addPoint(pts.getItemAt(pf1));
			    _largestTriangle.addPoint(pts.getItemAt(pf2));
			    _largestTriangle.addPoint(pts.getItemAt(pf0));
		    }
		    return _largestTriangle;
		}  
		
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the largest quadrilateral that fits inside the convex hull
		| Output: A polygon that is the largest quadrilateral.
		| Notes: We used the algorithm described by J.E. Boyce and D.P. Dobkin.
		+----------------------------------------------------------------------------*/
		public function largestQuad():CIPolygon
		{
		    if (_largestQuad == null) {
			    convexHull();
			    
			    var pa:CIPoint;
			    var pb:CIPoint;
			    var pc:CIPoint;
			    var i:int;
			    var ia:int;
			    var ib:int;
			    var ic:int;
			    var ic0:int;
			    var ripa:int;// indexes for rooted triangle
			    var ripb:int;
			    var ripc:int;

			    var area:Number;
			    var triArea:Number;
			    var numPts:int = _convexHull.getNumPoints();
		        var pts:CIList = _convexHull.getPoints(); // CIList<CIPoint> *
		
		        if (numPts <= 4) {
					_largestQuad = new CIPolygon();
					for (i=0; i<numPts; i++)
						_largestQuad.addPoint(pts.getItemAt(i));
				    for (i= numPts; i < 5; i++)
					_largestQuad.addPoint(pts.getItemAt(0));
		            return _largestQuad;
				}
		
		// computes one rooted triangle        
		        ia = 0;
		        area = 0;
		        triArea = 0;
		        for(ib=1; ib <= numPts-2; ib++) {
		            if (ib >= 2)
		                ic = ib + 1;
		            else
		                ic = 2;
		            area = compRootedTri (pts, ia, ib, ic, numPts);
		            if (area > triArea) {
		                triArea = area;
		                ripa = ia;
		                ripb = ib;
		                ripc = ic;
		            }
		        }
		
		// computes the rooted quadrilateral based on a rooted triangle
		        var fipa:int;
		        var fipb:int;
		        var fipc:int;
		        var fipd:int; // indexes for final values
		        var id:int;
		        var ib0:int;
		        var quadArea:Number;
		
		        quadArea = 0;
		        for(ib=ripa+1; ib<= ripb; ib++) {
		            if (ib == ripb)
		                ic0 = ripb + 1;
		            else
		                ic0 = ripb;
		            for(ic=ic0; ic <= ripc; ic++) {
		                if (ic == ripc)
		                    id = ripc + 1;
		                else
		                    id = ripc;
		                area = compRootedQuad (pts, ia, ib, ic, id, numPts);
		                if (area > quadArea) {
		                    quadArea = area;
		                    fipa = ia;
		                    fipb = ib;
		                    fipc = ic;
		                    fipd = id;
		                }
		            }
		        }
		
				// computes other quadrilaterals and choose the largest one
		        var pf0:int;
		        var pf1:int;
		        var pf2:int;
		        var pf3:int;
		        var finalArea:Number = quadArea;
		        pf0 = fipa;
		        pf1 = fipb;
		        pf2 = fipc;
		        pf3 = fipd;
		        ripa = fipa;
		        ripb = fipb;
		        ripc = fipc;
		        var ripd:int = fipd;
		
		        for(ia=ripa+1; ia<= ripb; ia++) {
		            if (ia == ripb)
		                ib0 = ripb + 1;
		            else
		                ib0 = ripb;
		
		            quadArea = 0;
		            area = 0;
		            for(ib=ib0; ib <= ripc; ib++) {
		                if (ib == ripc)
		                    ic0 = ripc + 1;
		                else
		                    ic0 = ripc;
		                for (ic=ic0; ic <= ripd; ic++) {
		                    if (ic == ripd)
		                        id = ripd + 1;
		                    else
		                        id = ripd;
		                    area = compRootedQuad (pts, ia, ib, ic, id, numPts);
		                    if (area > quadArea) {
		                        quadArea = area;
		                        fipa = ia;
		                        fipb = ib;
		                        fipc = ic;
		                        fipd = id;
		                    }
		                }
		            }
		            if(quadArea > finalArea) {
		                finalArea = quadArea;
		                pf0 = fipa;
		                pf1 = fipb;
		                pf2 = fipc;
		                pf3 = fipd;
		            }
		        }
		
		   // Tranfer the points to a polygon
			    _largestQuad = new CIPolygon();
			    _largestQuad.addPoint(pts.getItemAt(pf0));
			    _largestQuad.addPoint(pts.getItemAt(pf1));
			    _largestQuad.addPoint(pts.getItemAt(pf2));
			    _largestQuad.addPoint(pts.getItemAt(pf3));
			    _largestQuad.addPoint(pts.getItemAt(pf0));
		    }
		    return _largestQuad;
		}
		
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the enclosing rectangle (rotated) that includes the 
		|              convex hull
		| Output: A polygon that is a rotated rectangle.
		| Notes:
		+----------------------------------------------------------------------------*/
		public function enclosingRect():CIPolygon
		{
		    if (_enclosingRect == null) {
			    convexHull();
		
			    var num:int = _convexHull.getNumPoints();
		        var pts:CIList = _convexHull.getPoints(); // CIList<CIPoint> *
			    var minx:Number;
			    var miny:Number;
			    var maxx:Number;
			    var maxy:Number;
			    var minxp:int;
			    var minyp:int;
			    var maxxp:int;
			    var maxyp:int;
			    var ang:Number;
			    var dis:Number;
			    var xx:Number;
			    var yy:Number;
			    var area:Number;
			    var min_area:Number;
			    var p1x:int,p1y:int,p2x:int,p2y:int,p3x:int,p3y:int,p4x:int,p4y:int;
		
		        if (num < 2) {  // is just a point
			        _enclosingRect = new CIPolygon();
			        _enclosingRect.addPoint(pts.getItemAt(0));
			        _enclosingRect.addPoint(pts.getItemAt(0));
			        _enclosingRect.addPoint(pts.getItemAt(0));
			        _enclosingRect.addPoint(pts.getItemAt(0));
			        _enclosingRect.addPoint(pts.getItemAt(0));
		        }
		        else if (num < 3) {  // is a line with just two points
			        _enclosingRect = new CIPolygon();
			        _enclosingRect.addPoint(pts.getItemAt(0));
			        _enclosingRect.addPoint(pts.getItemAt(1));
			        _enclosingRect.addPoint(pts.getItemAt(1));
			        _enclosingRect.addPoint(pts.getItemAt(0));
			        _enclosingRect.addPoint(pts.getItemAt(0));
		        }
		        else {  // ok it's normal :-)
			        for(var i:int=0; i<num-1; i++) {
			            for(var a:int=0; a<num; a++) {
				            var v1:CIVector= new CIVector(pts.getItemAt(i),pts.getItemAt(i+1));
				            var v2:CIVector= new CIVector(pts.getItemAt(i),pts.getItemAt(a));
				            ang = CIFunction.angle(v1,v2);
			              
		                    dis = v2.length();
				            xx=dis*Math.cos(ang);
				            yy=dis*Math.sin(ang);
			              
				            if(!a) {
				                minx=maxx=xx;
				                miny=maxy=yy;
				                minxp=maxxp=minyp=maxyp=0;
				            }
				            if(xx<minx) {
				                minxp=a;
				                minx=xx;
				            }
				            if(xx>maxx) {
				                maxxp=a;
				                maxx=xx;
				            }
				            if(yy<miny) {
				                minyp=a;
				                miny=yy;
				            }
				            if(yy>maxy) {
				                maxyp=a;
				                maxy=yy;
				            }
			                    
			            }   
			            var p1:CIPoint = CIFunction.closest(pts.getItemAt(i),pts.getItemAt(i+1),pts.getItemAt(minxp));
			            var p2:CIPoint = CIFunction.closest(pts.getItemAt(i),pts.getItemAt(i+1),pts.getItemAt(maxxp));
		      
				    	var paux:CIPoint = new CIPoint(pts.getItemAt(i).x+100,pts.getItemAt(i).y);
			            var v3:CIVector= new CIVector(pts.getItemAt(i), paux);
			            var v4:CIVector= new CIVector(pts.getItemAt(i),pts.getItemAt(i+1));
			            ang = CIFunction.angle(v3,v4);

		      
			            var paux1:CIPoint=new CIPoint(int(p1.x+100*Math.cos(ang+CIConstants.M_PI_2)),int(p1.y+100*Math.sin(ang+CIConstants.M_PI_2)));
			            var paux2:CIPoint=new CIPoint(int(p2.x+100*Math.cos(ang+CIConstants.M_PI_2)),int(p2.y+100*Math.sin(ang+CIConstants.M_PI_2)));
		      
			            var p3:CIPoint = CIFunction.closest(p2,paux2,pts.getItemAt(maxyp));
			            var p4:CIPoint = CIFunction.closest(p1,paux1,pts.getItemAt(maxyp));
		      
			            area=CIFunction.quadArea(p1,p2,p3,p4);
		      
			            if ((!i)||(area < min_area))
			            {
				            min_area = area;
				            p1x=p1.x;p1y=p1.y;p2x=p2.x;p2y=p2.y;p3x=p3.x;p3y=p3.y;p4x=p4.x;p4y=p4.y;
			            }
			        }
			        _enclosingRect = new CIPolygon();
			        _enclosingRect.addPoint(new CIPoint(p1x,p1y));
			        _enclosingRect.addPoint(new CIPoint(p2x,p2y));
			        _enclosingRect.addPoint(new CIPoint(p3x,p3y));
			        _enclosingRect.addPoint(new CIPoint(p4x,p4y));
			        _enclosingRect.addPoint(new CIPoint(p1x,p1y));
		        }
		    }
		    return _enclosingRect;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Returns the first point of the scribble.
		+----------------------------------------------------------------------------*/
		public function startingPoint():CIPoint
		{
		    return ((_strokes.getItemAt(0)).getPoints()).getItemAt(0);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Returns the last point of the scribble.
		+----------------------------------------------------------------------------*/
		public function endingPoint():CIPoint
		{
		    var strk:CIStroke = _strokes.getItemAt(getNumStrokes()-1);
		
		    return (strk.getPoints()).getItemAt(strk.getNumPoints()-1);
		}
		
		
		/*----------------------------------------------------------------------------+
		| Description: Writes all the points of the scribble to a file
		+----------------------------------------------------------------------------*/
		/*
		public function writeTo(ofstream& of):void
		{
		    int ns, np;
		    CIStroke *strk;
		    CIList<CIPoint *> *pts;
		 
		    ns = getNumStrokes();
		    of << ns << endl; 
		    for (int s=0; s<ns; s++) {
		        strk = (*_strokes)[s];
		        np = strk->getNumPoints();
		        pts = strk->getPoints();
		        of << np << endl;
		        for (int p=0; p<np; p++) {
		            of << (*pts)[p]->x << " " << (*pts)[p]->y << " " << (*pts)[p]->getTime() << "\n";
		        }
		    }
		}*/
		
		/*----------------------------------------------------------------------------+
		| Description: Reads all the points of the scribble from a file
		+----------------------------------------------------------------------------*/
		/*
		void CIScribble::readFrom(ifstream& ar, bool useTime) 
		{
		    int ns, np, i, k, x, y;
		    double t = 0;
		    CIStroke *strk;
		
		    ar >> ns;
		    for(i=0; i < ns; i++) {
		        ar >> np;
		        for(k=0; k < np; k++) {
		            if (useTime)
		                ar >> x >> y >> t;
		            else
		                ar >> x >> y;
		            if (k==0)
		                strk = new CIStroke();
		            strk->addPoint(x,y,t);
		        }
		        addStroke(strk);
		    }
		}*/
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the number of points inside a small triangle, computed
		|              from the largest triangle.
		| Output: Number of points inside.
		| Notes: Some of the lines commented were used to return a list with the points
		|        inside.
		+----------------------------------------------------------------------------*/
		public function ptsInSmallTri ():int
		{
		    //CIPolygon *inP = new CIPolygon();
		    var tri:CIPolygon = smallTriangle();
		    var points:CIList = tri.getPoints(); //<CIPoint> *
		    var pt:Array=new Array(3);  // CIPoint -  points of the triangle
		    var cp:CIPoint; // current point of the scribble
		    var m:Array=new Array(3); //double
		    var dx:Number;
		    var dy:Number;
		    var x:Array=new Array(3); // double
		    var i:int;
		    var inter:int;
		    var ns:int, np:int;
		    var strk:CIStroke;
		    var pts:CIList; // CIList<CIPoint *> *
		    var empty:int = 0; // number of points inside the triangle
		
		    for (i=0; i<3; i++)
		        pt[i] = points.getItemAt(i);  // just to be faster!
		
		    for (i=0; i<3; i++) {
		        dx = pt[i].x - pt[(i+1)%3].x;
		        if (dx == 0) {
		            m[i] = CIConstants.BIG;
		            continue;
		        }
		        dy = pt[i].y - pt[(i+1)%3].y;
		        m[i] = dy/dx;
		    }
		
		// Computation of the number of points of the scribble inside the triangle
		
		    ns = getNumStrokes();
		    for (var s:int=0; s<ns; s++) {
		        strk = _strokes.getItemAt(s);
		        np = strk.getNumPoints();
		        pts = strk.getPoints();
		        for (var p:int=0; p<np; p++) {
		            cp = pts.getItemAt(p);
		            inter = 0;
		            if (cp.x >= pt[0].x && cp.x >= pt[1].x && cp.x >= pt[2].x)
		                continue;
		            else if (cp.x <= pt[0].x && cp.x <= pt[1].x && cp.x <= pt[2].x)
		                continue;
		            else if (cp.y >= pt[0].y && cp.y >= pt[1].y && cp.y >= pt[2].y)
		                continue;
		            else if (cp.y <= pt[0].y && cp.y <= pt[1].y && cp.y <= pt[2].y)
		                continue;
		            else {
		                for (i=0; i<3; i++) {
		                    if (m[i] == 0)
		                        continue;
		                    else if (m[i] >= CIConstants.BIG) {
		                        x[i] = pt[i].x;
		                        if (x[i] >= cp.x)
		                            inter++;
		                    }
		                    else {
		                        x[i] = (cp.y - pt[i].y + m[i]*pt[i].x)/m[i];
		                        if (x[i] >= cp.x && (x[i] < ((pt[i].x > pt[(i+1) %3].x) ? pt[i].x : pt[(i+1) %3].x))
		)                           inter++;
		                    }
		                }
		                if (inter % 2)
		                    empty++;
		
		                    //inP->addPoint(cp);
		            }
		        }
		    }
		    //return inP;
		    
		    return empty;
		}
		
		
		/*----------------------------------------------------------------------------+
		| Description: Return the number of points of the scribble
		+----------------------------------------------------------------------------*/
		public function getNumPoints():int
		{
		    var ns:int, nPoints:int;
		    
		    nPoints = 0;
		    ns = getNumStrokes();
		    for (var s:int=0; s<ns; s++)
		        nPoints += _strokes.getItemAt(s).getNumPoints();
		    return nPoints;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the sum of all the absolute movements in X
		+----------------------------------------------------------------------------*/
		public function hMovement():Number
		{
		    var ns:int, np:int;
		    var strk:CIStroke;
		    var pts:CIList; //CIList<CIPoint *> *
		    var mov:Number;
		
		    mov = 0;
		    ns = getNumStrokes();
		    for (var s:int=0; s<ns; s++) {
		        strk = _strokes.getItemAt(s);
		        np = strk.getNumPoints();
		        pts = strk.getPoints();
		        for (var p:int=0; p<np-1; p++) {
		            mov += Math.abs(pts.getItemAt(p+1).x - pts.getItemAt(p).x);
		        }
		    }
		    return mov;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the sum of all the absolute movements in Y
		+----------------------------------------------------------------------------*/
		public function vMovement():Number
		{
		    var ns:int, np:int;
		    var strk:CIStroke;
		    var pts:CIList; //CIList<CIPoint *> *
		    var mov:Number;
		
		    mov = 0;
		    ns = getNumStrokes();
		    for (var s:int=0; s<ns; s++) {
		        strk = _strokes.getItemAt(s);
		        np = strk.getNumPoints();
		        pts = strk.getPoints();
		        for (var p:int=0; p<np-1; p++) {
		            mov += Math.abs(pts.getItemAt(p+1).y - pts.getItemAt(p).y);
		        }
		    }
		    return mov;
		}
		
		// ------------------------------------------------------------
		// ------ Private Members -------------------------------------
		
		/*----------------------------------------------------------------------------+
		| Description: Computes a small triangle that is 60% of the largest triangle.
		| Output: A polygon
		| Notes:
		+----------------------------------------------------------------------------*/
		public function smallTriangle():CIPolygon
		{
		    var tri:CIPolygon = new CIPolygon();
		    var points:CIList; //CIList<CIPoint> *
		    var p1:CIPoint=new CIPoint(), p2:CIPoint=new CIPoint(), p3:CIPoint=new CIPoint();
		    var m1:CIPoint=new CIPoint(), m2:CIPoint=new CIPoint(), m3:CIPoint=new CIPoint();
		    var t1:CIPoint=new CIPoint(), t2:CIPoint=new CIPoint(), t3:CIPoint=new CIPoint();
		
		    if (!_largestTriangle)
		        largestTriangle();
		
			if (_largestTriangle == null)
				points = null;
		
		    points = _largestTriangle.getPoints();
		
		    p1 = points.getItemAt(0);
		    p2 = points.getItemAt(1);
		    p3 = points.getItemAt(2);
		
		    m1.x = p3.x + (p1.x - p3.x)/2;
		    m1.y = p3.y + (p1.y - p3.y)/2;
		    m2.x = p1.x + (p2.x - p1.x)/2;
		    m2.y = p1.y + (p2.y - p1.y)/2;
		    m3.x = p2.x + (p3.x - p2.x)/2;
		    m3.y = p2.y + (p3.y - p2.y)/2;
		
		    t1.x = (int)(m3.x + (p1.x - m3.x)*0.6);
		    t1.y = (int)(m3.y + (p1.y - m3.y)*0.6);
		    t2.x = (int)(m1.x + (p2.x - m1.x)*0.6);
		    t2.y = (int)(m1.y + (p2.y - m1.y)*0.6);
		    t3.x = (int)(m2.x + (p3.x - m2.x)*0.6);
		    t3.y = (int)(m2.y + (p3.y - m2.y)*0.6);
		
		    tri.addPoint(t1);
		    tri.addPoint(t2);
		    tri.addPoint(t3);
		    tri.addPoint(t1);
		
		    return tri;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Reduce the number of points from the convex hull, eliminating 
		|              the points that are too close (5 pixels).
		+----------------------------------------------------------------------------*/
		public function filterConvexHull():CIPolygon
		{
		    var _convexHull2:CIPolygon = new CIPolygon();
		    var np:int, i:int;
		    var pts:CIList;//CIList<CIPoint> *
		    var pt:CIPoint, pti:CIPoint, aux:CIPoint;
		
		    pts = _convexHull.getPoints();
		    np = _convexHull.getNumPoints();
		    pt = pts.getItemAt(0);
		    _convexHull2.push(pt);
		    for (i=1; i<np; i++) {
		        pti = pts.getItemAt(i);
		        if (CIFunction.distance(pt, pti) > 5) {
		            _convexHull2.push(pti);
		            pt = pti;
		        }
		        else if (i == np-1)
		            _convexHull2.push(pts.getItemAt(0));
		    }
		   
		    return _convexHull2;
		}
		
		
		/*----------------------------------------------------------------------------+
		| Description: Selects the point with the lowest y
		+----------------------------------------------------------------------------*/
		public function findLowest():CIPoint 
		{
		    var min:CIPoint;
		    var ns:int, np:int, s:int, p:int;
		    var pts:CIList; //CIList<CIPoint *> *
		
		    min = (_strokes.getItemAt(0).getPoints()).getItemAt(0); // gets the first point of the first stroke
		    ns = getNumStrokes();
		    for (s=0; s<ns; s++) {
		        np = _strokes.getItemAt(s).getNumPoints();
		        pts = _strokes.getItemAt(s).getPoints();
		        for (p=0; p<np; p++) 
		            if (pts.getItemAt(p).y < min.y)
		                min = pts.getItemAt(p);
		            else if (pts.getItemAt(p).y == min.y && pts.getItemAt(p).x > min.x)
		                min = pts.getItemAt(p);
		    }
		    return min;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Order all scribble points by angle.
		| Output: A list of points order by angle
		| Notes: This method is used during the computation of the convex hull.
		+----------------------------------------------------------------------------*/
		public function ordPoints(ordedPoints:CIList, min:CIPoint):CIList //CIList<CIPoint *> *
		{
		    var ns:int, np:int, s:int, p:int;
		    var pts:CIList; // <CIPoint *> *
		    var ptr:CIListNode; //<CIPoint *> *
		    var ang:Number;
		
		    ordedPoints.insertInOrder(min, 0);
		
		    ns = getNumStrokes();
		    for (s=0; s<ns; s++) {
		        np = _strokes.getItemAt(s).getNumPoints();
		        pts = _strokes.getItemAt(s).getPoints();
		        for (p=0; p<np; p++) {
		            ang = CIFunction.theta (min, pts.getItemAt(p));
		            ptr = ordedPoints.insertInOrder(pts.getItemAt(p), ang);
		            if (ptr) { // there is another point with the same angle
		                       // so we compute the distance and save the big one.
		                if (CIFunction.distance(min, pts.getItemAt(p)) > CIFunction.distance(min,ptr.getItem()))
		                    ptr.setItem(pts.getItemAt(p));
		            }
		        }
		    }
		    return ordedPoints;
		}
		
		
		/*----------------------------------------------------------------------------+
		| Description: Auxiliar method used during the computation of the largest triangle
		+----------------------------------------------------------------------------*/
		public function compRootedTri(pts:CIList, ripa:int, ripb:int, ripc:int, np:int):Number
		{
			var pa:CIPoint,pb:CIPoint,pc:CIPoint;
			var ia:int, ib:int, ic:int;
			var area:Number, _trigArea:Number = 0;
		
		// computes one rooted triangle        
		    ia = ripa;
		    ib = ripb;
		    for(ic=ripc; ic < np - 1; ic++ ) {
			    pa = pts.getItemAt(ia);
			    pb = pts.getItemAt(ib);
			    pc = pts.getItemAt(ic);
			    if( (area=CIFunction.triangleArea(pa, pb, pc)) > _trigArea ) {
		            ripc = ic;
			        _trigArea = area;
			    }
		        else {
		            break;
		        }
		    }
		    return _trigArea;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Auxiliar method used during the computation of the largest 
		|              quadrilateral
		+----------------------------------------------------------------------------*/
		public function compRootedQuad(pts:CIList, ripa:int, ripb:int, ripc:int, ripd:int, np:int):Number
		{
			var pa:CIPoint,pb:CIPoint,pc:CIPoint,pd:CIPoint;
			var id:int;
		
			var area:Number, _trigArea:Number = 0;
		
		// computes one rooted triangle        
			pa = pts.getItemAt(ripa);
			pb = pts.getItemAt(ripb);
			pc = pts.getItemAt(ripc);
		    for(id=ripd; id < np - 1; id++ ) {
		        pd = pts.getItemAt(id);
			    if( (area=CIFunction.quadArea(pa, pb, pc, pd)) > _trigArea ) {
		                ripd = id;
			    _trigArea = area;
			    }
		        else {
		            break;
		        }
		    }
		    return _trigArea;
		}
		
		
		// ------------------------------------------------------------
		/* This cicle uses all the points of the scribble
		    int ns, np;
		    CIStroke *strk;
		    CIList<CIPoint *> *pts;
		
		        ns = getNumStrokes();
		        for (int s=0; s<ns; s++) {
		            strk = (*_strokes)[s];
		            np = strk->getNumPoints();
		            pts = strk->getPoints();
		            for (int p=0; p<np; p++) {
		
		                // do something with the points.
		                // (*pts)[p]
		
		            }
		        }
		
		  */
		
		//---------- To Delete one day ------------------
		
		public function largestTriangleOld():CIPolygon
		{
		    if (_largestTriangleOld == null) {
			convexHull();
			
			var p1:CIPoint ,p2:CIPoint ,p3:CIPoint;
			var _trigPts:Array=new Array(3);
			for each(var t:* in _trigPts)
				t=new CIPoint();
			
			var i:int,j:int,k:int;
			var area:Number, _trigArea:Number = 0;
			var numPts:int = _convexHull.getNumPoints();
		    var pts:CIList = _convexHull.getPoints();
		  
			for( i=0; i < numPts; i++ )
			    for( j=0; j< numPts; j++ )
				for( k=0; k<numPts; k++ ) {
				    p1 = pts.getItemAt(i);
				    p2 = pts.getItemAt(j);
				    p3 = pts.getItemAt(k);
				    if( (area=CIFunction.triangleArea(p1, p2, p3)) > _trigArea ) {
					_trigPts[0]=p1;
					_trigPts[1]=p2;
					_trigPts[2]=p3;
					_trigArea = area;
				    }
				}
		
			// Tranfer the points to a polygon
			_largestTriangleOld = new CIPolygon();
			_largestTriangleOld.addPoint(_trigPts[0]);
			_largestTriangleOld.addPoint(_trigPts[1]);
			_largestTriangleOld.addPoint(_trigPts[2]);
			_largestTriangleOld.addPoint(_trigPts[0]);
		    }
		    return _largestTriangleOld;
		}  
		
		
		public function largestQuadOld():CIPolygon 
		{
		    if (_largestQuadOld == null) {
			convexHull();
			
			var p1:CIPoint,p2:CIPoint,p3:CIPoint,p4:CIPoint;
			var _trigPts:Array=new Array(4);
			for(var t:* in _trigPts)
				t=new CIPoint();
				
			var i:int,j:int,k:int,l:int;
			var area:Number, _quadArea:Number = 0;
			var numPts:int = _convexHull.getNumPoints();
		    var pts:CIList = _convexHull.getPoints();
		  
			for( i=0; i < numPts; i++ )
			    for( j=0; j< numPts; j++ )
				for( k=0; k<numPts; k++ )
				    for( l=0; l<numPts; l++ ) {
				    p1 = pts.getItemAt(i);
				    p2 = pts.getItemAt(j);
				    p3 = pts.getItemAt(k);
				    p4 = pts.getItemAt(l);
				    if( (area=CIFunction.quadArea(p1, p2, p3, p4)) > _quadArea ) {
					_trigPts[0]=p1;
					_trigPts[1]=p2;
					_trigPts[2]=p3;
					_trigPts[3]=p4;
					_quadArea = area;
				    }
				}
		
			// Tranfer the points to a polygon
			_largestQuadOld = new CIPolygon();
			_largestQuadOld.addPoint(_trigPts[0]);
			_largestQuadOld.addPoint(_trigPts[1]);
			_largestQuadOld.addPoint(_trigPts[2]);
			_largestQuadOld.addPoint(_trigPts[3]);
			_largestQuadOld.addPoint(_trigPts[0]);
		    }
		    return _largestQuadOld;
		}
	}
}