package pt.inevo.cali
{
	public class CIPoint
	{
		public var x:int;
		public var y:int;
		var _time:Number;
		
		public function CIPoint(...args) {
			if(args.length>=2)
				x=args[0]; y=args[1];
			if(args.length==3)
				_time=args[2];
		}
		
	}
}