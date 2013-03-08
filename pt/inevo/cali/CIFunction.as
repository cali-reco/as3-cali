package pt.inevo.cali
{
	public class CIFunction
	{
	
		public static function getRotationAngle(a:Number, b:Number, c:Number,d:Number):Number
		{
			var theta1:Number = Math.acos(a);
			var theta2:Number = Math.asin(c);
			
			var angle:Number;
			
			if(theta2>=0){	
				angle=theta1;
			} else {
				angle=-1*theta1;
			} 
			
			return angle;
		}
		public static function triangleArea(p1:CIPoint, p2:CIPoint, p3:CIPoint):Number
		{
		    var area:Number = p1.x * p2.y - p2.x * p1.y;
		    area += p2.x * p3.y - p3.x * p2.y;
		    area += p3.x * p1.y - p1.x * p3.y;
		
		    return Math.abs(area/2);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the area of a rectangle
		+----------------------------------------------------------------------------*/
		public static function quadArea(p1:CIPoint, p2:CIPoint, p3:CIPoint, p4:CIPoint):Number
		{
		    var area:Number = p1.x * p2.y - p2.x * p1.y;
		    area += p2.x * p3.y - p3.x * p2.y;
		    area += p3.x * p4.y - p4.x * p3.y;
		    area += p4.x * p1.y - p1.x * p4.y;
		
		    return Math.abs(area/2);
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the "angle" made by the line defined by the 2 points 
		+----------------------------------------------------------------------------*/
		public static function theta(p:CIPoint,q:CIPoint):Number
		{
		    var dx:int = q.x - p.x, ax = Math.abs(dx),
		    dy = q.y - p.y, ay = Math.abs(dy);
		
		    var t:Number = (ax + ay == 0) ? 0 :  dy / (ax + ay);
		
		    if (dx < 0) 
		        t = 2 - t;
		    else if (dy < 0) 
		        t = 4 + t;
		
		    return t*90;
		};
		
		/*----------------------------------------------------------------------------+
		| Description: Computes the distance between two points
		+----------------------------------------------------------------------------*/
		public static function distance(p:CIPoint, q:CIPoint):Number
		{
		    return Math.sqrt(Math.pow(q.x-p.x,2) + Math.pow(q.y-p.y,2));
		}
		
		public static function left( a:CIPoint, b:CIPoint,c:CIPoint ):Boolean
		{
		    return (a.x * b.y - a.y * b.x + a.y * c.x - a.x * c.y + b.x * c.y - c.x * b.y) > 0;
		}
		
		public static function angle( a:*, b:*):Number
		{
			var res:Number;
			if( (a is CIVector) && (b is CIVector)) {
				 res=Math.atan2(CIFunction.cross(a, b), CIFunction.dot(a, b));
			}
			else if( (a is CIPoint) && (b is CIPoint)) {
				res=Math.atan2(b.y - a.y, b.x - a.x);
			}
				
			return res;
		}
		
		
		/*---------------------------------------------------------------------------+
		| closest: return point on line (p1, p2) which is closer to p3
		+---------------------------------------------------------------------------*/
	   public static function closest(p1:CIPoint,p2:CIPoint,p3:CIPoint):CIPoint
		{
		    var d:int = p2.x - p1.x;
		
		    if (d == 0) 
			return new CIPoint(p1.x, p3.y);
		
		    if (p1 == p3)
		        return p3;
		
		    if (p2 == p3)
		        return p3;
		
		    var m:Number = (p2.y - p1.y) / d;
		
		    if (m == 0)
		         return new CIPoint(p3.x, p1.y);
		
		    var b1:Number = p2.y - m * p2.x,
		          b2 = p3.y + 1/m * p3.x,
		          x = (b2 - b1) / (m + 1/m), 
		          y = m * x + b1;
		
		    return new CIPoint(int(x),int(y));
		}
		
		public static function cross(a:CIVector, b:CIVector):Number {
		    var dx1:int = a.endp.x - a.startp.x, dx2 = b.endp.x - b.startp.x,
		    dy1 = a.endp.y - a.startp.y, dy2 = b.endp.y - b.startp.y;
		    return dx1 * dy2 - dy1 * dx2;
		}
		
		public static function dot(a:CIVector, b:CIVector):Number {
		    var dx1:int = a.endp.x - a.startp.x, dx2 = b.endp.x - b.startp.x,
		    dy1 = a.endp.y - a.startp.y, dy2 = b.endp.y - b.startp.y;
		    return dx1 * dx2 + dy1 * dy2;
		}
	}
}