package pt.inevo.cali
{
	public class CIPolygon
	{
		var _area:Number;
    	var _perim:Number;
    	var _points:CIList; // CIList<CIPoint> *
    	
    	public function CIPolygon ()
		{
		    _points = new CIList();//CIList<CIPoint>(); 
		    _area = 0;
		    _perim = 0;
		}
		
		public function addPoint(...args):void{
			 switch(args.length) {
			 	case 1:
			 		_points.insertTail(args[0]); 
			 		break;
			 	case 2:
			 		_points.insertTail(new CIPoint(args[0],args[1])); 
			 		break;
			 }
			 
		}
		
		public function getPoints():CIList 
		{ return _points; }
		
		public function getNumPoints():Number	// Number of points of the polygon
        { return _points.getNumItems(); }
		
		public function push(pt:CIPoint):void
		{ _points.insertTail(pt); }
			
    	public function pop():CIPoint 
        { return _points.pop(); }
        
		/*----------------------------------------------------------------------------+
		| Description: Computes the area of the polygon, using a general algorithm.
		| Output: the area
		+----------------------------------------------------------------------------*/
		public function area():Number
		{
		    if (_area == 0) {
			var numPoints:int = _points.getNumItems();
		    if (numPoints < 3) {
		        _area = CIConstants.ZERO;
		        return _area;
		    }
		
			for (var i:int = 0; i < numPoints - 1; i++) {
			    _area += _points.getItemAt(i).x * _points.getItemAt(i+1).y - _points.getItemAt(i+1).x * _points.getItemAt(i).y;
			}
			_area /= 2;
			if (_area == 0)
			    _area = CIConstants.ZERO;
		    }
		    return Math.abs(_area);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the perimeter of the polygon, using a general algorithm.
		| Output: the perimeter
		+----------------------------------------------------------------------------*/
		public function perimeter():Number
		{
		    if (_perim == 0) {
			var numPoints:int = _points.getNumItems();
		
			for (var i:int = 0; i < numPoints - 1; i++) {
		        _perim += CIFunction.distance(_points.getItemAt(i), _points.getItemAt(i+1));
			}
			if (_perim == 0)
			    _perim = CIConstants.ZERO;
		
		        if (numPoints < 3)
		            _perim *= 2;
		   }
		    return _perim;
		}
	}
}