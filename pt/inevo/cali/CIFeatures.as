package pt.inevo.cali
{
	public class CIFeatures
	{
		var _nodesList:CIList;
		
		public function CIFeatures(...params)
		{
		    _nodesList = new CIList();//CIList<CIFuzzyNode *> ();
		
			for(var i:int=0;i<params.length;i+=1)
			{
			 	var ptrF:Object=params[i]; 
			 	var awa:Number=params[++i];
			 	var a:Number=params[++i];
			 	var b:Number=params[++i];
			 	var bwb:Number=params[++i];
		    	_nodesList.insertTail(new CIFuzzyNode(new CIFuzzySet(a, b, a-awa, bwb-b), ptrF));
		 }
		}
		
	
		
		public function evaluate(sc:CIScribble):Number
		{
		    if (_nodesList) {
		        var tmp:Number;
		        var dom:Number = 1;
		        var nn:int = _nodesList.getNumItems();
		
		        for (var i:int=0; i<nn; i++)
		        {
		            tmp = _nodesList.getItemAt(i).dom(sc);
		            if (tmp < dom)
		                dom = tmp;
		            if (dom == 0)
		                break;
		        }
		        return dom;
		    }
		    else
		        return 0;
		}
	}
}