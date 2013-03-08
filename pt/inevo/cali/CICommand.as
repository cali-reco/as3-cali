package pt.inevo.cali
{
	public class CICommand extends CIGesture
	{
		
		public function CICommand() { _sc = null; }

    	override public function getName():String { return null; }
    	override public function getGestureType():String { return "Command"; }
     	override public function clone():*{ return null; }
    
		override public function evalGlobalFeatures(sc:CIScribble):Number
		{
		        _dom = _features.evaluate(sc);
		        if (_dom > 0)
		            _sc = sc;
		        else 
		            _sc = null;
		        return _dom;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Recovers the previous atributes of the command
		+----------------------------------------------------------------------------*/
		override public function popAttribs():void
		{
		    if (_prevGesture) {
		        _sc = _prevGesture.getScribble();
		        _dom = _prevGesture.getDom();
		        //delete _prevGesture;
		        _prevGesture = null;
		    }
		}
	}
}