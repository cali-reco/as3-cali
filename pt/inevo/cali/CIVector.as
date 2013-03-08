package pt.inevo.cali
{
	public class CIVector
	{
		var startp:CIPoint;
	    var endp:CIPoint;
	    
	    public function CIVector(pstart:CIPoint, pend:CIPoint)
	    {
	    	startp=pstart; endp=pend;
	    }
	    
	    public function length():Number
		{ 
		    return CIFunction.distance(startp, endp); 
		}
	}
}