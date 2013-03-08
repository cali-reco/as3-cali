package pt.inevo.cali
{
	public class CIRectangle extends CIShape
	{
		 public var _points:Array=new Array(4); // CIPoint
		 
		/*----------------------------------------------------------------------------+
		| Description: In this constructor we define all the features that are used 
		|              to identify rectangles. The set of features are different for 
		|              rotated and non ratated rectangles.
		| Input: rotated - tells if the shapes are rotated or not.
		+----------------------------------------------------------------------------*/
		public function CIRectangle(...params)
		{
			// initialize point array
			for each(var p:* in _points){
				p=new CIPoint();
			}
			
			if(params.length<=1)
			{
				var rotated:Boolean=(params[0])?params[0]:true;
				super(rotated);
				 if (rotated)
			        _features = new CIFeatures (CIEvaluate.Ach_Aer, 0.75, 0.85, 1, 1, // separate from diamonds
			                                    CIEvaluate.Alq_Aer, 0.72, 0.78, 1, 1,
			                                    CIEvaluate.Hollowness, 0, 0, 1, 1);
			    else
			        _features = new CIFeatures (CIEvaluate.Ach_Abb, 0.8, 0.83, 1, 1,
			                                    CIEvaluate.Pch_Pbb, 0.87, 0.9, 1, 1,
			                                    CIEvaluate.Alt_Abb, 0.45, 0.47, 0.5, 0.52//,
			                                    //&CIEvaluate::scLen_Pch, 0, 0, 1.5, 1.7
			                                    );
			}
			else
			{
				var sc:CIScribble=params[0];
				var a:CIPoint=params[1];
				var b:CIPoint=params[2];
				var c:CIPoint=params[3];
				var d:CIPoint=params[4];
				var dom:Number=params[5];
				var dash:Boolean=(params[6])?params[6]:false;
				var bold:Boolean=(params[7])?params[7]:false;
		
			    _sc=sc;
			    _points[0] = a; 
			    _points[1] = b; 
			    _points[2] = c; 
			    _points[3] = d;
			    _dashed = dash; 
			    _bold = bold;
			    _open = false;
			    _dom = dom;
			    _features = null;
			    _dashFeature = null;
			}
		   
		}
		
		override public function draw(ptr:*):void {}
    	override public function getName():String{ return ("Rectangle"); }
    
		/*----------------------------------------------------------------------------+
		| Description: Makes a clone of the current rectangle.
		+----------------------------------------------------------------------------*/
		override public function clone():*
		{
		    return new CIRectangle(_sc, _points[0], _points[1], _points[2], _points[3], _dom, _dashed, _bold);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the points of the recognized rectangle
		+----------------------------------------------------------------------------*/
		override public function setUp(sc:CIScribble):void
		{
		    var points:CIList;
		    
		    _sc = sc;
		    points = sc.enclosingRect().getPoints();
		    _points[0] = points.getItemAt(0);
		    _points[1] = points.getItemAt(1);
		    _points[2] = points.getItemAt(2);
		    _points[3] = points.getItemAt(3);
		}
	}
}