package pt.inevo.cali
{
	public class CIListNode
	{
		var _item:*;
    	var _next:CIListNode;
	    var _prev:CIListNode;
	    var _idx:int;	 // index value of the last item retrieved
	    var _ordValue:Number; // value used to order the list
	    
	    /*----------------------------------------------------------------------------+
		| Description: Returns the Item stored into the list node.
		+----------------------------------------------------------------------------*/
		public function getItem ():* { return _item; }
		
		/*----------------------------------------------------------------------------+
		| Description: Returns a pointer to the next node of the list.
		+----------------------------------------------------------------------------*/
		public function next ():CIListNode { return _next; }
		
		/*----------------------------------------------------------------------------+
		| Description: Returns a pointer to the previous node of the list.
		+----------------------------------------------------------------------------*/
		public function prev ():CIListNode { return _prev; }
		
		/*----------------------------------------------------------------------------+
		| Description: Returns the index value.
		+----------------------------------------------------------------------------*/
		public function getIdx ():int { return _idx; }
		
		/*----------------------------------------------------------------------------+
		| Description: Returns the order value.
		+----------------------------------------------------------------------------*/
		public function getOrdVal ():Number { return _ordValue; }
		
		/*----------------------------------------------------------------------------+
		| Description: Stores or updates the data into the list node.
		+----------------------------------------------------------------------------*/
		public function setItem (item:*):void { _item = item; }
		
		/*----------------------------------------------------------------------------+
		| Description: Sets the value of the pointer to the next node.
		+----------------------------------------------------------------------------*/
		public function setNext (pos:CIListNode):void { _next = pos; }
		
		/*----------------------------------------------------------------------------+
		| Description: Sets the value of the pointer to the previous node.
		+----------------------------------------------------------------------------*/
		public function setPrev (pos:CIListNode):void { _prev = pos; }
		
		/*----------------------------------------------------------------------------+
		| Description: Sets the value of the index value.
		+----------------------------------------------------------------------------*/
		public function setIdx ( idx:int):void { _idx = idx; }
		
		/*----------------------------------------------------------------------------+
		| Description: Sets the value of the order value.
		+----------------------------------------------------------------------------*/
		public function setOrdVal (ordVal:Number):void { _ordValue = ordVal; }
		
		/*-----| "Normal" methods  (Not inline) |-----*/
		/*----------------------------------------------------------------------------+
		| Description: Constructor of the class. Initializes the instance variables 
		| Input: Item - The item we want to store into the list node.
		+----------------------------------------------------------------------------*/
		public function CIListNode(...params)
		{
			var item:*=params[0];
			var ordVal:Number=(params.length==2)?params[1]:0;
		    _item = item;
		    _next = _prev = null;
		    _idx = -1;	// default value, node not numbered.
		    _ordValue = ordVal;
		}
	}
}