package pt.inevo.cali
{
	public class CITriangle extends CIShape
	{
		
		public var _points:Array=new Array(3); // CIPoint
		
		override public function getName():String { return ("Triangle"); }
		/*----------------------------------------------------------------------------+
		| Description: In this constructor we define all the features that are used 
		|              to identify triangles. The set of features are different for 
		|              rotated and non ratated triangles.
		| Input: rotated - tells if the shapes are ratated or not.
		+----------------------------------------------------------------------------*/
		public function CITriangle(...params)
		{
			
			// initialize point array
			for each(var p:* in _points){
				p=new CIPoint();
			}
			
			if(params.length<=1) {
				var rotated:Boolean=(params.length>0)?params[0]:true;
				super(rotated);
			
			    _features = new CIFeatures (CIEvaluate.Alt_Ach, 0.67, 0.77, 1, 1
			                                ,CIEvaluate.Plt_Pch, 0.95, 0.98, 1, 1
			                                ,CIEvaluate.Hollowness, 0, 0, 1, 1
											,CIEvaluate.Pch_Per, 0.78, 0.8, 0.89, 0.945 // Not Lines Dashed
			                                ,CIEvaluate.Alt_Alq, 0.81, 0.87, 1, 1       // Not Copy
			                                ); 
			} else {
				var sc:CIScribble=params[0];
				var a:CIPoint=params[1],b:CIPoint=params[2],c:CIPoint=params[3];
				var dom:Number=params[4];
				var dash:Boolean=(params.length>=5)?params[5]:false;
				var bold:Boolean=(params.length>=6)?params[6]:false;
				_sc=sc;
			    _points[0] = a; 
			    _points[1] = b; 
			    _points[2] = c; 
			    _dashed = dash; 
			    _bold = bold;
			    _dom = dom;
			    _features = null;
			    _dashFeature = null;
			}
		}
		
		

		
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the points of the recognized triangle
		+----------------------------------------------------------------------------*/
		override public function setUp(sc:CIScribble):void
		{
		    var points:CIList;
		    
		    _sc = sc;
		    points = sc.largestTriangle().getPoints();
		    _points[0] = points.getItemAt(0);
		    _points[1] = points.getItemAt(1);
		    _points[2] = points.getItemAt(2);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Makes a clone of the current triangle.
		+----------------------------------------------------------------------------*/
		override public function clone():*
		{
		    return new CITriangle(_sc, _points[0], _points[1], _points[2], _dom, _dashed);
		}
	}
}