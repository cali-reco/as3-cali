package pt.inevo.cali
{
	public class CIFuzzyNode
	{
		var _fuzzySet:CIFuzzySet;
    	var _ptrFunc:*;
    	
		public function CIFuzzyNode (fuzzy:CIFuzzySet, ptrF:*)
		{
		    _ptrFunc = ptrF;
		    _fuzzySet = fuzzy;
		}

		/*----------------------------------------------------------------------------+
		| Description: Computes the degree of membership for the current scribble, 
		|              using the fuzzyset and the function feature of the FuzzyNode.
		| Input: a scribble
		| Output: the value of the degree of membership
		| Notes:
		+----------------------------------------------------------------------------*/
		public function dom(sc:CIScribble):Number
		{
		    if (_ptrFunc) {
			 var ev:CIEvaluate = new CIEvaluate();
			var tmp:Number = _ptrFunc.call(ev,sc);
		
			if (_fuzzySet)
		            return _fuzzySet.degOfMember(tmp);
		        else
		            return 0;
		    }
		    else
			    return 0;
		}
	}
}