package pt.inevo.cali
{
	public class CICircle extends CIShape
	{
		
	    public var _radius:int;
	    public var _center:CIPoint=new CIPoint();
	    public var _points:Array=new Array(4); //CIPoint
	    
		public function CICircle(...params) //bool rotated=true
		{
			// initialize point array
			for each(var p:* in _points){
				p=new CIPoint();
			}
			
			if(params.length<=1){
				super(params);
				 _features = new CIFeatures (CIEvaluate.Pch2_Ach, 12.5, 12.5, 13.2, 13.5,
		                                	CIEvaluate.Hollowness, 0, 0, 0, 0);
			} else {
				var sc:CIScribble=params[0];
				var dom:Number=params[1];
				var dash:Boolean=(params[3])?params[3]:false;
				var bold:Boolean=(params[4])?params[4]:false;
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
	
	    override public function draw(ptr:*):void {}
	    override public function getName():String { return ("Circle"); }
		
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the center and the radius of the recognized circle
		+----------------------------------------------------------------------------*/
		override public function setUp(sc:CIScribble):void
		{
		    var points:CIList;
		    var pt1:CIPoint, pt2:CIPoint, pt3:CIPoint;
		    var d1:Number, d2:Number;
		    
		    _sc = sc;
		    points = sc.boundingBox().getPoints();
		    _points[0] = points.getItemAt(0);
		    _points[1] = points.getItemAt(1);
		    _points[2] = points.getItemAt(2);
		    _points[3] = points.getItemAt(3);
		    with(Math) {
		    d1 = sqrt(pow(_points[0].x-_points[1].x,2) + pow(_points[0].y-_points[1].y,2));
		    d2 = sqrt(pow(_points[2].x-_points[1].x,2) + pow(_points[2].y-_points[1].y,2));
		    }
		    _radius = (int)((d1+d2)/2/2);
		    _center.x = (int)(_points[0].x + d2/2);
		    _center.y = (int)(_points[0].y + d1/2);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Makes a clone of the current circle.
		+----------------------------------------------------------------------------*/
		override public function clone():*
		{
		    return new CICircle(_sc, _dom, _dashed, _bold);
		}
	}
}