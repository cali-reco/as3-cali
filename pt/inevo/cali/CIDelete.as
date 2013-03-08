package pt.inevo.cali
{
	public class CIDelete extends CICommand
	{
		public function CIDelete(...params)
		{
			if(params.length>0)
			{
				var sc:CIScribble=params[0];
				var dom:Number=params[1];
				_sc = sc; _dom = dom; _features = null;
			} else {
			    _features = new CIFeatures (CIEvaluate.Her_Wer, 0.06, 0.08, 1, 1
			                               // ,&CIEvaluate::Ach_Aer, 0.62, 0.65, 1, 1   // Not bold Arrows
			                               ,CIEvaluate.Tl_Pch, 1.5, 1.9, CIConstants.BIG, CIConstants.BIG    // Identifies
			                               ,CIEvaluate.Hollowness, 0, 3, CIConstants.BIG, CIConstants.BIG  // Not Shapes
			                               ,CIEvaluate.Ns, 1, 1, 1, 1
			                               );
			}
			 
		}

	    override public function clone():* { return new CIDelete(_sc, _dom); }
	    override public function getName():String { return "Delete"; }
	}
}