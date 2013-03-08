package pt.inevo.cali
{
	import pt.inevo.cali.*;
	
	public class CIShape extends CIGesture
	{
		var _dashFeature:CIFeatures;
		var _normalFeature:CIFeatures; 
		var _openFeature:CIFeatures; 
		var _boldFeature:CIFeatures; 
    	var _dashed:Boolean;
    	var _bold:Boolean;
    	var _open:Boolean;
    	var _rotated:Boolean;
    	
    	// VIRTUAL 
    	 public function setUp(sc:CIScribble):void{}
		public function draw(ptr:*):void {}
    	override public function getName():String { return null; }
    	override public function clone():*{ return null; }
    	
    	public function CIShape(...params)
		{
			var rotated:Boolean=(params.length>0)?params[0]:true;
			
		    _sc = null; 
		    _dashed = false;
		    _bold = false;
		    _open = false;
		    _dom = 0;
		    _rotated = rotated;
		    _normalFeature = new CIFeatures( CIEvaluate.Tl_Pch, 0.83, 0.93, CIConstants.BIG, CIConstants.BIG);
		    _dashFeature = new CIFeatures (CIEvaluate.Tl_Pch, 0.2, 0.3, 0.83, 0.93,
		                                   CIEvaluate.Pch_Ns_Tl, 5, 10, CIConstants.BIG, CIConstants.BIG);
		    _openFeature = new CIFeatures (CIEvaluate.Tl_Pch, 0.2, 0.3, 0.83, 0.93);
		    _boldFeature =  new CIFeatures (CIEvaluate.Tl_Pch, 1.5, 3, CIConstants.BIG, CIConstants.BIG);
		}

		override public function getGestureType():String { return "Shape"; }
    	override public function evalLocalFeatures(sc:CIScribble, _shapesList:CIList):Number { return 1; }
    	public function isDashed():Boolean{ return _dashed; }
   		public function isBold():Boolean{ return _bold; }
   		public function isOpen():Boolean{ return _open; }
    
		/*----------------------------------------------------------------------------+
		| Description: Computes the degree of membership for the scribble, taking
		|              into account the fuzzysets for the current shape.
		|              This evaluation is made based on geometric global features.
		| Input: A scribble
		| Output: degree of membership
		| Notes: This method is the same for all shapes.
		+----------------------------------------------------------------------------*/
		override public function evalGlobalFeatures(sc:CIScribble):Number
		{
		    _dom = _features.evaluate(sc);
		    _dashed = false;
		    _bold = false;
		    _open = false;
		    _sc = null;
		   
		    if (_dom) {
		        setUp(sc);
		        if (_normalFeature.evaluate(sc)) {
		            if (_boldFeature.evaluate(sc))
		                _bold = true;
		        }
		        else {
		            _dom *= _dashFeature.evaluate(sc);
		            if (_dom)
		                _dashed = true;
		        }
		    }
		    return _dom;
		}

		/*----------------------------------------------------------------------------+
		| Description: Recover the previous attributes of the shape
		+----------------------------------------------------------------------------*/
		override public function popAttribs():void
		{
		    var shp:CIShape;
		    var sc:CIScribble;
		
		    if (_prevGesture) {
		        shp = (_prevGesture as CIShape);
		        sc = shp.getScribble();
		        if (sc)
		            setUp(shp.getScribble());
		        _dashed = shp.isDashed();
		        _open = shp.isOpen();
		        _bold = shp.isBold();
		        _dom = shp.getDom();
		        //delete shp;
		        _prevGesture = null;
		    }
		}
	}
}