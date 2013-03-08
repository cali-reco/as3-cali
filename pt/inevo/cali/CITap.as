package pt.inevo.cali
{
	public class CITap extends CICommand
	{
		var _point:CIPoint;
		
		public function CITap(...params) 
		{ 	
			if(params.length==0)
			{
				_point=new CIPoint();
				_point.x = 0;
				_point.y = 0;
			}
			else
			{
				var sc:CIScribble=params[0];
				var dom:Number=params[1];
				var point:CIPoint=params[2];
			
				_sc = sc; 
				_dom = dom; 
				_point = point; 
				_features = null; 
			}
		}
		
		public function setUp(sc:CIScribble):void
		{
			_point = sc.startingPoint();
			_dom = 1;
			_sc = sc;
		}
	}
}