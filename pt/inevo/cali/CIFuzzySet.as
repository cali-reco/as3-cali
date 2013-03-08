package pt.inevo.cali
{
	public class CIFuzzySet
	{
		// Variables
    	var  _a:Number;   // smallest u st N(u) = 1 
	   var _b:Number;   // biggest  u st N(u) = 1 
	   var _wa:Number;  // width of left slope (wa) st  N(a - wa) = 0
	   var _wb:Number;  // width of right slope (wb) st N(b + wb) = 0
	   
	   public function CIFuzzySet(...params)
	   { 
	   		var a:Number=params[0];
	   		var b:Number=params[1];
	   		var wa:Number=(params.length>2)?params[2]:0;
	   		var wb:Number=(params.length>3)?params[3]:0;
	   		init (a, b, wa, wb); 
	   	};

		public function degOfMember(value:Number):Number
		{
		    if ((value < (_a - _wa)) || (value > (_b + _wb)) )
			return 0;   
		    else if (value >= _a && value <= _b)
			return 1;
		    else if (value > _b && (value <= _b + _wb))
			return 1.0 - (value - _b) / _wb;
		    else if (value < _a && (value >= _a - _wa))
			return 1.0 + (value - _a) / _wa;
		    else {
			// cerr << "Invalid fuzzy set" << endl;
			//abort();
			return 0.0;
		    }
		}
		
		/*----------------------------------------------------------------------+
		| Description: Evaluate the distance to the fuzzy set
		| Input:  value - point of evaluation
		| Output: distance
		+----------------------------------------------------------------------*/
		public function distance (value:Number):Number
		{
		    var low:Number = _a - _wa; 
		    var high:Number = _b + _wb;
		
		    if ( (value >= low) && (value <= high) ) return 0;
		    else if (value < low) return (low - value);
		    else return (value - high);
		}
		
		/*----------------------------------------------------------------------+
		| Description: Verify if the current fuzzy set is intersected by the
		|	      fuzzy set fs.
		| Input:  fs - a fuzzy set
		| Output: true if they intersect each other, false otherwise
		+----------------------------------------------------------------------*/
		public function intersects(fs:CIFuzzySet):Boolean
		{
		    if (fs == null) return false;
		    if ((fs._b + fs._wb) < (_a - _wa) || ((fs._a - fs._wa) > (_b + _wb)))
			return false;
		    else
			return true;
		}
		
		/*----------------------------------------------------------------------+
		| Description: Verify if the value belongs to the fuzzy set
		| Input:  value
		| Output: true if it belongs, false otherwise
		+----------------------------------------------------------------------*/
		public function isInSet(value:Number):Boolean
		{
		    if (value < (_a - _wa) || (value > (_b + _wb)))
		        return false;
		    else
		        return true;
		}
		
		/*---------------| Private members of the class |-----------------------*/
		
		/*----------------------------------------------------------------------+
		| Description: Check fuzzy set limits
		| Input:  CIFuzzy set values
		| Output: true if ok, false otherwise
		+----------------------------------------------------------------------*/
		public function checkFuzzySet( a:Number, b:Number, wa:Number, wb:Number)
		{
		  return (a <= b) && (wa >= 0) && (wb >= 0);
		}
		
		/*----------------------------------------------------------------------+
		| Description: Create a fuzzy set from 4 values
		| Input:  a, b, wa, wb - Values that define the limits of the fuzzy set
		+----------------------------------------------------------------------*/
		public function init (a:Number, b:Number, wa:Number, wb:Number):void
		{
		    if (checkFuzzySet(a, b, wa, wb)) {
			_a = a; _b = b;
			_wa = wa; _wb = wb;
		    }
		    else {
			// cerr << "Attempting to create invalid fuzzy set" << a << b << wa << wb << endl;
			//abort();
		    }
		}
	}
}