package pt.inevo.cali
{
	public class CIEvaluate
	{
		public static function Tl_Pch(sc:CIScribble):Number
		{
		    return sc._len / sc.convexHull().perimeter();
		}
		
		public static function Pch2_Ach(sc:CIScribble):Number
		{
		    return Math.pow(sc.convexHull().perimeter(),2) / sc.convexHull().area();
		}
		
		public static function Pch_Ns_Tl(sc:CIScribble):Number
		{
		    return sc.convexHull().perimeter()/(sc.getLen()/sc.getNumStrokes());
		}
		
		public static function Hollowness( sc:CIScribble):Number
		{
		    return sc.ptsInSmallTri();
		}
		
		public static function Ns( sc:CIScribble):Number
		{
		    return sc.getNumStrokes();
		}
		
		public static function Hm_Wbb( sc:CIScribble):Number
		{
		    var pbb:CIList = sc.boundingBox().getPoints(); //CIList<CIPoint> *
		
		    return Math.abs((pbb.getItemAt(0).x - pbb.getItemAt(1).x) / sc.hMovement());
		}
		
		public static function Vm_Hbb( sc:CIScribble):Number
		{
		    var pbb:CIList = sc.boundingBox().getPoints(); //CIList<CIPoint> *
		
		    return Math.abs((pbb.getItemAt(2).y - pbb.getItemAt(1).y) / sc.vMovement());
		}
		
		public static function Hbb_Wbb( sc:CIScribble):Number
		{
		    var pbb:CIList = sc.boundingBox().getPoints(); //CIList<CIPoint> *
		
		    var dw:Number;
		    var dh:Number;
		
		    dw = pbb.getItemAt(1).x - pbb.getItemAt(0).x;
		    dh = pbb.getItemAt(2).y - pbb.getItemAt(1).y;
		
		    if (dw == 0 || dh == 0)
		        return 0;
		
		    var tmp:Number = Math.abs(dh / dw);
		    if (tmp > 1)
		        tmp = 1 / tmp;
		    return tmp;
		}
		
		public static function Her_Wer( sc:CIScribble):Number
		{
		   var pbb:CIList = sc.enclosingRect().getPoints(); //
		
		    var dw:Number, dh:Number;
		
		    dw = CIFunction.distance(pbb.getItemAt(2), pbb.getItemAt(1));
		    dh = CIFunction.distance(pbb.getItemAt(1), pbb.getItemAt(0));
		
		    if (dw == 0 || dh == 0)
		        return 0;
		
		    var tmp:Number = dh / dw;
		    if (tmp > 1)
		        tmp = 1 / tmp;
		    return tmp;
		}
		
		// Area ratios
		public static function Alt_Ach(sc:CIScribble):Number
		{
		    return sc.largestTriangle().area() / sc.convexHull().area();
		}
		
		public static function Ach_Aer(sc:CIScribble):Number
		{
		    return sc.convexHull().area() / sc.enclosingRect().area();
		}
		
		public static function Alt_Aer(sc:CIScribble):Number
		{
		    return sc.largestTriangle().area() / sc.enclosingRect().area();
		}
		
		public static function Ach_Abb(sc:CIScribble):Number
		{
		    return sc.convexHull().area() / sc.boundingBox().area();
		}
		
		public static function Alt_Abb(sc:CIScribble):Number
		{
		    return sc.largestTriangle().area() / sc.boundingBox().area();
		}
		
		public static function Alq_Ach(sc:CIScribble):Number
		{
		    return sc.largestQuad().area() / sc.convexHull().area();
		}
		
		public static function Alq_Aer(sc:CIScribble):Number
		{
		    return sc.largestQuad().area() / sc.enclosingRect().area();
		}
		
		public static function Alt_Alq(sc:CIScribble):Number
		{
		    return sc.largestTriangle().area() / sc.largestQuad().area();
		}
		
		// Perimeter ratios
		public static function Plt_Pch(sc:CIScribble):Number
		{
		    return sc.largestTriangle().perimeter() / sc.convexHull().perimeter();
		}
		
		public static function Pch_Per(sc:CIScribble):Number
		{
		    return sc.convexHull().perimeter()/sc.enclosingRect().perimeter();
		}
		
		public static function Plt_Per(sc:CIScribble):Number
		{
		    return sc.largestTriangle().perimeter()/sc.enclosingRect().perimeter();
		}
		
		public static function Pch_Pbb(sc:CIScribble):Number
		{
		    return sc.convexHull().perimeter() / sc.boundingBox().perimeter();
		}
		
		public static function Plt_Pbb(sc:CIScribble):Number
		{
		    return sc.largestTriangle().perimeter() / sc.boundingBox().perimeter();
		}
		
		public static function Plq_Pch(sc:CIScribble):Number
		{
		    return sc.largestQuad().perimeter() / sc.convexHull().perimeter();
		}
		
		public static function Plq_Per(sc:CIScribble):Number
		{
		    return sc.largestQuad().perimeter() / sc.enclosingRect().perimeter();
		}
		
		public static function Plt_Plq(sc:CIScribble):Number
		{
		    return sc.largestTriangle().perimeter() / sc.largestQuad().perimeter();
		}
	}
}