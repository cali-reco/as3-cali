package pt.inevo.cali
{
	public class CIGesture
	{
		var _sc:CIScribble;
    	var _features:CIFeatures;
    	var _dom:Number;
    	var _prevGesture:CIGesture;
    
		public function CIGesture (){ _sc = null; _dom = 0; _prevGesture = null; }

    	public function getName():String { return null; }
    	public function getGestureType():String { return null; }
	    public function clone():*{ return null; }
    
    	public function evalGlobalFeatures(sc:CIScribble):Number{ return 0; }
	    public function evalLocalFeatures(sc:CIScribble, _shapesList:CIList):Number{ return 1; }
    	public function getScribble():CIScribble { return _sc; }
	    public function getDom():Number { return _dom; }
    	public function resetDom():void { _dom = 0; }
    
	    public function pushAttribs():void { _prevGesture = clone(); }
    	public function popAttribs():void {}

	
	}
}