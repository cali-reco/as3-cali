package pt.inevo.cali
{
	public class CIStroke
	{
		var _points:CIList;//<CIPoint *> *
		var _len:Number;
		var _speed:Number;
		var _lastPoint:CIPoint=new CIPoint();
		var _firstTime:Number;
		
		public function getNumPoints():int	// Number of points of the stroke
	    { return _points.getNumItems(); }
	    
	    public function getLen():Number		// Stroke length
	    { return _len; }
	    
	    public function getPoints():CIList {   // List of points of the stroke
	    	return _points; 
	    }
	    
	    public function getDrawingSpeed():Number	    // Average drawing speed 
	    { return _speed; }
	    
		public function CIStroke()
		{
		    _points = new CIList();
		    _len = 0;
		    _speed = 0;
		    _firstTime = 0;
		}
		/*----------------------------------------------------------------------------+
		| Description: Adds a point to the stroke. Inserts the point at the end of 
		|              the list of points, computes the new length of the stroke and 
		|              the drawing speed.
		|
		| Input: Point coordenates (x,y) and the temporal mark in milliseconds.
		+----------------------------------------------------------------------------*/
		public function addPoint (...args):void
		{
			var x:int=args[0];
			var y:int=args[1];
			var time:Number=((args.length==3)?args[2]:0);
			
		    _points.insertTail(new CIPoint(x,y,time));
		    if (getNumPoints() > 1) {
		        _len += Math.sqrt(Math.pow(_lastPoint.x - x,2) + Math.pow(_lastPoint.y - y,2));
		        if (time == _firstTime)
		            _speed = CIConstants.BIG;
		        else
			    _speed =  _len / (time - _firstTime);
		    } 
		    else
			_firstTime = time;
		
		    _lastPoint.x = x;
		    _lastPoint.y = y;
		}
	}
}