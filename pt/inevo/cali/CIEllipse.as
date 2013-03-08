package pt.inevo.cali
{
	public class CIEllipse extends CIShape
	{
		public var _eliPoints:CIPolygon;
	    public var _points:Array=new Array(4);
	    
	     override public function getName():String { return ("Ellipse"); }
	     
		/*----------------------------------------------------------------------------+
		| Description: In this constructor we define all the features that are used 
		|              to identify ellipses. The set of features are different for 
		|              rotated and non ratated ellipses.
		| Input: rotated - tells if the shapes are rotated or not.
		+----------------------------------------------------------------------------*/
		public function CIEllipse (...params)
		{
			for each(var p:CIPoint in _points)
				p=new CIPoint();
				
			if(params.length<=1)
			{
				 var rotated:Boolean=(params.length>0)?params[0]:true;
				 super(rotated);
		
			    if (rotated)
			        _features = new CIFeatures (CIEvaluate.Pch2_Ach, 13.2, 13.5, 19, 30, // separate from bold circles
			                                    CIEvaluate.Alq_Ach, 0.6, 0.65, 0.71, 0.78,
			                                    CIEvaluate.Hollowness, 0, 0, 0, 0);
			    else
			        _features = new CIFeatures (CIEvaluate.Alt_Abb, 0, 0, 0.4, 0.45,
			                                    CIEvaluate.Alt_Ach, 0.4, 0.43, 0.47, 0.52,
			                                    CIEvaluate.Ach_Abb, 0.6, 0.7, 0.8, 0.9//,
			                                    //&CIEvaluate::scLen_Pch, 0, 0, 1.5, 1.7
			                                    );
			} else {
				var sc:CIScribble=params[0];
				var dom:Number=params[1];
				var dash:Boolean=(params.length>=2)?params[2]:false;
				var bold:Boolean=(params.length>=3)?params[3]:false;

			    _sc=sc;
			    if(sc)
			        setUp(sc);
			    _dashed = dash; 
			    _bold = bold;
			    _open = false;
			    _dom = dom;
			    _features = null;
			    _dashFeature = null;
			}
		}
		
		
		/*----------------------------------------------------------------------------+
		| Description: Makes a clone of the current ellipse.
		+----------------------------------------------------------------------------*/
		override public function clone():*
		{
		    return new CIEllipse(_sc, _dom, _dashed, _bold);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the points of the recognized ellipse
		+----------------------------------------------------------------------------*/
		override public function setUp(sc:CIScribble):void
		{
		    var points:CIList;
		    
		    _sc = sc;
		    if (_rotated)
		        points = sc.enclosingRect().getPoints();
		    else
		        points = sc.boundingBox().getPoints();
		    _points[0] = points.getItemAt(0);
		    _points[1] = points.getItemAt(1);
		    _points[2] = points.getItemAt(2);
		    _points[3] = points.getItemAt(3);
		    _eliPoints = calcEllipse(_points);
		}
		
		// ----- Private Members -----
		public function calcEllipse(points:Array):CIPolygon
		{
		    var a:Number, b:Number, d1:Number, d2:Number;
		    var theta:Number;
		    var np:int=0;
		    var pts:Array=new Array(1000);
		    for(var i:int;i<1000;i++)
		    	pts[i]=new CIPoint();
		    var pt:CIPoint=new CIPoint();
		
		    pt.x = points[1].x;
		    pt.y = points[1].y;
		    theta = CIFunction.angle(points[0], points[3]);
		
			with(Math) {
			    a = sqrt(pow(points[2].x - points[1].x,2) + pow(points[2].y - points[1].y,2)) / 2;
			    b = sqrt(pow(points[0].x - points[1].x,2) + pow(points[0].y - points[1].y,2)) / 2;
			
			    var x:int=0;
			    var y:int=b;
			
			    d1 = pow(b,2)-pow(a,2)*b+pow(a,2)/4;
			    pts[np].x = x;
			    pts[np].y = y;
			    np++;
			
			    while (pow(a,2)*(y-1/2) > pow(b,2)*(x+1)) {
			        if(d1<0) {
				    d1+=pow(b,2)*(2*x+3);
				    x++;
			        }
				else {
			    	    d1+=pow(b,2)*(2*x+3)+pow(a,2)*(-2*y+2);
				    x++;
				    y--;
			        }
			        pts[np].x = x;
			        pts[np].y = y;
			        np++;
			    }
			
			    d2=pow(b,2)*pow(x+1/2,2)+pow(a,2)*pow(y-1,2)-pow(a,2)*pow(b,2);
			    while(y>=-1) {
			    	if(d2<0) {
				    d2+=pow(b,2)*(2*x+2)+pow(a,2)*(-2*y+3);
				    x++;
				    y--;
			        }
				else {
				    d2+=pow(a,2)*(-2*y+3);
				    y--;
			        }
			        pts[np].x = x;
			        pts[np].y = y;
			        np++;
			    }
			
			    np--;
			}			
	    	_eliPoints = rotate(pts, theta, pt, a, b, np);
		    return _eliPoints;
		}
		
		public function rotate(points:Array, theta:Number,  p:CIPoint, a:Number, b:Number,  np:int):CIPolygon
		{
		    var pol:CIPolygon = new CIPolygon();
		    var _ellipsePoints:Array = new Array(4*np);
		    for(var n:int=0;n<4*np;n++)
		    	_ellipsePoints[n]=new CIPoint();

			with(Math) {
			    for (var i:CIPolygon=0; i<np; i++) {
			        _ellipsePoints[i].x =(int)(cos(theta)*(-points[np-i-1].x+a)-sin(theta)*(points[np-i-1].y+b)+p.x);
			        _ellipsePoints[i].y =(int)(sin(theta)*(-points[np-i-1].x+a)+cos(theta)*(points[np-i-1].y+b)+p.y);
			
			        _ellipsePoints[np+i].x =(int)(cos(theta)*(points[i].x+a)-sin(theta)*(points[i].y+b)+p.x);
			        _ellipsePoints[np+i].y =(int)(sin(theta)*(points[i].x+a)+cos(theta)*(points[i].y+b)+p.y);  
			
			        _ellipsePoints[2*np+i].x =(int)(cos(theta)*(points[np-i-1].x+a)-sin(theta)*(-points[np-i-1].y+b)+p.x);
			        _ellipsePoints[2*np+i].y =(int)(sin(theta)*(points[np-i-1].x+a)+cos(theta)*(-points[np-i-1].y+b)+p.y);
			  
			        _ellipsePoints[3*np+i].x =(int)(cos(theta)*(-points[i].x+a)-sin(theta)*(-points[i].y+b)+p.x);
			        _ellipsePoints[3*np+i].y =(int)(sin(theta)*(-points[i].x+a)+cos(theta)*(-points[i].y+b)+p.y);
		    }
			}
		    for (var j:int=0; j<4*np; j++) 
		        pol.addPoint(_ellipsePoints[j]);
		    //delete []_ellipsePoints;
		
		    return pol;
		}
	}
}