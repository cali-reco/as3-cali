package pt.inevo.cali
{
	public class CIUnknown extends CIShape
	{
		public function CIUnknown(...params)
		{
			if(params.length>0)
			{
				var sc:CIScribble=params[0];
				var dom:Number=params[1];
				_sc = sc; _dom = dom;
			}
			_features = null; 
		}
		
		public function evaluate(sc:CIScribble) { return 0;}
		
		override public function draw(ptr:*):void{}
    	override public function getName():String{ return ("Unknown"); }

	    override public function clone():* { return new CIUnknown(_sc, _dom); }
	    
	    /*----------------------------------------------------------------------------+
		| Description: Computes some features of the unknown gesture, like if it is 
		|              solid, dashed or bold.
		| Input: A scribble.
		+----------------------------------------------------------------------------*/
		override public function setUp(sc:CIScribble):void
		{
		    _sc = sc;
		    _dashed = false;
		    _bold = false;
		    _open = false;
		    _dom = 1;
		
		    if (_dashFeature.evaluate(sc))
		        _dashed = true;
		    else if (_openFeature)
		        if (_openFeature.evaluate(sc))
		            _open = true;
		        else
		            if (_boldFeature.evaluate(sc))
		                _bold = true;
		
		}
	}
}