package pt.inevo.cali
{
	
	public class CIWavyLine extends CICommand
	{
    	override public function getName():String { return "WavyLine"; }
    
		public function CIWavyLine (...params)
		{
			if(params.length==0)
			{
			    _features = new CIFeatures (CIEvaluate.Her_Wer, 0.06, 0.08, 0.4, 0.45 // separate from lines
			                               //,&CIEvaluate::Hm_Wbb, 0.9, 0.98, 1.1, 1.1   // separate from Arrows
			                               ,CIEvaluate.Tl_Pch, 0.5, 0.55, 1.5, 1.9
			                               ,CIEvaluate.Hollowness, 0, 3, CIConstants.BIG, CIConstants.BIG
			                               ,CIEvaluate.Ns, 1, 1, 1, 1
			                               );
			}
			else
			{
				var sc:CIScribble=params[0];
				var dom:Number=params[1];
				 _sc = sc; 
				 _dom = dom; 
				 _features = null;
			}
		}
		
		override public function clone():* { return new CIWavyLine(_sc, _dom); }
	}
}