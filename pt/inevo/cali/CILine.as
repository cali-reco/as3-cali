package pt.inevo.cali
{
	public class CILine extends CIShape
	{
		var _points:Array=new Array(2);
		
		public function getPoints():Array 
		{
			return _points;	
		}
		
		override public function getName():String { return ("Line"); }
		/*----------------------------------------------------------------------------+
		| Description: In this constructor we define all the features that are used 
		|              to identify lines. The set of features are different for 
		|              rotated and non ratated lines.
		| Input: rotated - tells if the shapes are ratated or not.
		+----------------------------------------------------------------------------*/
		public function CILine (...params)
		{
			// initialize point array
			for each(var p:* in _points){
				p=new CIPoint();
			}
			
			if(params.length<2) {
				super(params);
				
			    _normalFeature = new CIFeatures (CIEvaluate.Tl_Pch, 0.4, 0.45, CIConstants.BIG, CIConstants.BIG);
			    _dashFeature = new CIFeatures (CIEvaluate.Tl_Pch, 0, 0, 0.4, 0.45,
			                                   CIEvaluate.Pch_Ns_Tl, 5, 10, CIConstants.BIG, CIConstants.BIG);
			
			    _features = new CIFeatures (CIEvaluate.Her_Wer, 0, 0, 0.06, 0.08);
			} else {
				var sc:CIScribble=params[0];
				var a:CIPoint=params[1];
				var b:CIPoint=params[2];
				var dom:Number=params[3];
				var dash:Boolean=params[4];
				var bold:Boolean=params[5];
			
			    _sc=sc;
			    _points[0] = a; 
			    _points[1] = b; 
			    _dashed = dash; 
			    _bold = bold;
			    _open = false;
			    _dom = dom;
			    _features = null;
			    _dashFeature = null;
			}
		}
		
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the points of the recognized line
		+----------------------------------------------------------------------------*/
		override public function setUp(sc:CIScribble):void
		{
		    var points:CIList;
		    
		    _sc = sc;
		    points = sc.enclosingRect().getPoints();
		    _points[0] = points.getItemAt(0);
		    _points[1] = points.getItemAt(2);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Makes a clone of the current line.
		+----------------------------------------------------------------------------*/
		override public function clone():*
		{
		    return new CILine(_sc, _points[0], _points[1], _dom, _dashed, _bold);
		}
	}
}