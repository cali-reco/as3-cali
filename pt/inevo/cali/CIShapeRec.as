package pt.inevo.cali
{
	public class CIShapeRec
	{
		var _rec:CIRecognizer;
    	var _sc:CIScribble;
    	var _stroke:CIStroke;
		var _ZERO:Number;
    
		public function CIShapeRec()
		{
		    _rec = new CIRecognizer(true);
		    _sc = null;
		    _stroke = null;
		
			var now:Date=new Date();
			//_ftime(&_timeInfo);
			_ZERO = now.millisecondsUTC; //* 1000 + _timeInfo.millitm;
		}
		
		public function addAllRecognShapes(rotate:Boolean):void{
			_rec.addAllShapes(rotate);
		}
		
		public function addRecognShape(shape:CIShape):void{
			_rec.addShape(shape);
		}
		
		public function initScribble():void
		{
		    _sc = new CIScribble();
		    _stroke = new CIStroke();
		}
		
		public function addPoint(x:int, y:int,time:Number):void 
		{
		    _stroke.addPoint(x, y, time);
		}
		
		public function getGestures():Array{
			 var result:Array=new Array();
			 _sc.addStroke(_stroke);
		
		    var gest:CIList = _rec.recognize(_sc); //<CIGesture *>* 

		    var ng:int = gest.getNumItems();
			var shp:CIShape;
		
		
		    for (var g:int=0; g<ng; g++) {
		    	 var ge:CIGesture=gest.getItemAt(g);
		    	 //if(ge.getName()!="Unknown")
	   			    result.push(gest.getItemAt(g));
   			}
   			    
   			return result;
		}
		
		public function recognize():String
		{
		    _sc.addStroke(_stroke);
		
		    var gest:CIList = _rec.recognize(_sc); //<CIGesture *>* 

		    var ng:int = gest.getNumItems();
		    var result:String="";
			var shp:CIShape;
		
		/* Construction of the string to return
		   This is the format:
		   <Gesture Name> <Type> <dom> <enclosing rect> <bounding box> <n. points> <points>
		   If it recognizes more than one gesture then they will be separeted by ":"
		*/
		
		    for (var g:int=0; g<ng; g++) {
   			    var ge:CIGesture=gest.getItemAt(g);
				if (g==0) 
					result+=ge.getName(); // gesture name
				else
					result+=" : "+ge.getName(); // gesture name
				if (ge.getGestureType()=="Shape") {
					shp = ge as CIShape;
					if (shp.isDashed())
						result+=" D";		// shape is dashed
					if (shp.isOpen())
						result+=" O";		// shape is unknown and open
					if (shp.isBold())
						result+=" B";		// shape is bold
					else
						result+=" S";		// shape is solid
				}
				else
					result+=" C";			// gesture is a command
		
				result+=ge.getDom()*100;	// dom
		
				// Enclosing rectangle
				var pts:CIList = ge.getScribble().enclosingRect().getPoints();
				result+=pts.getItemAt(0).x+" "+pts.getItemAt(0).y+" "+pts.getItemAt(1).x+" "+pts.getItemAt(1).y;
				result+=pts.getItemAt(2).x+" "+pts.getItemAt(2).y+" "+pts.getItemAt(3).x+" "+pts.getItemAt(3).y;
		
				// Bounding box
				pts = ge.getScribble().boundingBox().getPoints();
				result+=pts.getItemAt(0).x+" "+pts.getItemAt(0).y+" "+pts.getItemAt(2).x+" "+pts.getItemAt(2).y;
		
				/*
				if (gest.getItemAt(g).getGestureType()=="Shape") {
					shp = gest.getItemAt(g);
					var name:String = gest.getItemAt(g).getName();
					if(name=="Unknown" || name=="Ellipse") {
						result+=" 0";
					} else if(!strcmp("Triangle", name)) {
						var ln:CITriangle  = CITriangle(shp);
						sprintf(result,"%s 3 %d %d", result, ln->_points[0].x, ln->_points[0].y);
						sprintf(result,"%s %d %d", result, ln->_points[1].x, ln->_points[1].y);
						sprintf(result,"%s %d %d", result, ln->_points[2].x, ln->_points[2].y);
					} else if(!strcmp("Circle", name)) {
						CICircle *ln = (CICircle*)shp;
						sprintf(result,"%s 2 %d %d", result, ln->_center.x, ln->_center.y);
						sprintf(result,"%s %d %d", result, ln->_radius, ln->_radius);
					} else if(!strcmp("Line", name)) {
						CILine *ln = (CILine*)shp;
						sprintf(result,"%s 2 %d %d", result, ln->_points[0].x, ln->_points[0].y);
						sprintf(result,"%s %d %d", result, ln->_points[1].x, ln->_points[1].y);
					} else if(!strcmp("Arrow", name)) {
						CIArrow *ln = (CIArrow*)shp;
						sprintf(result,"%s 2 %d %d", result, ln->_points[0].x, ln->_points[0].y);
						sprintf(result,"%s %d %d", result, ln->_points[1].x, ln->_points[1].y);
					} else if(!strcmp("Rectangle", name)) {
						CIRectangle *ln = (CIRectangle*)shp;
						sprintf(result,"%s 4 %d %d", result, ln->_points[0].x, ln->_points[0].y);
						sprintf(result,"%s %d %d", result, ln->_points[1].x, ln->_points[1].y);
						sprintf(result,"%s %d %d", result, ln->_points[2].x, ln->_points[2].y);
						sprintf(result,"%s %d %d", result, ln->_points[3].x, ln->_points[3].y);
					} else {
						CIDiamond *ln = (CIDiamond*)shp;
						sprintf(result,"%s 4 %d %d", result, ln->_points[0].x, ln->_points[0].y);
						sprintf(result,"%s %d %d", result, ln->_points[1].x, ln->_points[1].y);
						sprintf(result,"%s %d %d", result, ln->_points[2].x, ln->_points[2].y);
						sprintf(result,"%s %d %d", result, ln->_points[3].x, ln->_points[3].y);
					}
				}*/
			}
		
			_stroke = null;
			_sc = null;
		    
		    return result;
		}
		
		/*
		public function getTime():Number
		{
			_ftime(&_timeInfo);
			return (_timeInfo.time * 1000 + _timeInfo.millitm) - _ZERO;
		}*/
	}
}