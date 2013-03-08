package pt.inevo.cali
{
	public class CIList
	{	
    	var _first:CIListNode;
   	 	var _last:CIListNode;
    	var _current:CIListNode;
    	var _count:int;
    	var _acceptRepeated:Boolean;
    	
    	
	
		/*-----| Item retrieval methods  |-----*/
		/*----------------------------------------------------------------------------+
		| Description: Returns the first/last Item of the list.
		+----------------------------------------------------------------------------*/
		public function getFirstItem():* { return _first.getItem(); }
		
		public function getLastItem():*{ return _last.getItem(); }
		
		/*----------------------------------------------------------------------------+
		| Description: Gets/Sets the value of the Item at the specified position.
		+----------------------------------------------------------------------------*/
		public function getItemAt(param:*):*
		{ 
			var res:*;
			
			if(param is CIListNode) {
				var pos:CIListNode=param;
				res=pos.getItem(); 
			} else {
				var index:int=param;
				var dif1:int, dif2:int, i:int, idx:int=0;
			    var ptr:CIListNode;
			
			    if (index <0 || index >= _count) {}
				//exit (-8);  // Index out of bounds
			
			    // distances to the index position, from the begining, the end and the
			    // middle.
			    
			    if (_current) {
			        idx = _current.getIdx();
				dif1 = index - idx;
			    }
			    else
				dif1 = _count;
			    dif2 = _count - index -1;
			    
			    if (index < Math.abs(dif1) && index < dif2) {
				ptr = _first;
				for (i=0; i<index; i++)
				    ptr = ptr.next();
			    }
			    else if (Math.abs(dif1) < index && Math.abs(dif1) < dif2) {
				ptr = _current;
				if (dif1 > 0)
				    for (i=idx; i<index; i++)
					ptr = ptr.next();
				else
				    for (i=idx; i>index; i--)
					ptr = ptr.prev();
			    }
			    else {
				ptr = _last;
				for (i=_count-1; i>index; i--)
				    ptr = ptr.prev();
			    }
			    if (_current)
				_current.setIdx(-1);
			    _current = ptr;
			    _current.setIdx(index);
			    res=(_current.getItem());	
			}
			return res;
		}
		
		public function setItemAt (pos:CIListNode, item:*):void 
		{ pos.setItem(item); }
		
		
		/*-----| Iteration methods  |-----*/
		/*----------------------------------------------------------------------------+
		| Description: Gets a pointer to the first/last node of the list.
		+----------------------------------------------------------------------------*/
		public function getHeadPosition():CIListNode { return _first; }
		
		public function getTailPosition():CIListNode { return _last; }
		
		
		/*-----| Status methods  |-----*/
		/*----------------------------------------------------------------------------+
		| Description: Returns the number of nodes of the list.
		+----------------------------------------------------------------------------*/
		public function getNumItems():int { return _count; }
		
		/*----------------------------------------------------------------------------+
		| Description: Verify if the list is empty.
		+----------------------------------------------------------------------------*/
		public function isEmpty():Boolean { return (_count==0); }
		
		/*----------------------------------------------------------------------------+
		| Description: Verify if position points to the first/last node of the list.
		+----------------------------------------------------------------------------*/
		public function isFirst(pos:CIListNode):Boolean { return (pos == _first); }
		
		public function isLast (pos:CIListNode):Boolean { return (pos == _last); }
		
		
		/*----------------------------------------------------------------------------+
		|			    Normal methods (Not inline)
		+----------------------------------------------------------------------------*/
		public function CIList(...params)
		{
			var acceptRepeated:Boolean=(params.length>0)?params[0]:true;
		    _first = _last = _current = null;
		    _count = 0;
		    _acceptRepeated = acceptRepeated;
		}
		
		public function pop():*
		{
		    var tmp:*;
		
		    tmp = _last.getItem();
		    if (_last != _first) {
		        _last = _last.prev();
		        //delete _last.next();
		        _last.setNext(null);
		        _count--;
		    }
		
		    return tmp;
		}
		
		/*-----| Item insertion methods |-----*/
		/*----------------------------------------------------------------------------+
		| Description: Inserts a new node at the begin/end of the list, and returns a 
		|	      pointer to that node.
		| Input: The item we want to add to the list.
		| Output: A pointer to the new node
		+----------------------------------------------------------------------------*/
		public function insertHead (item:*):CIListNode
		{
		    var pos:CIListNode = new CIListNode(item);
		    pos.setNext(_first);
		    pos.setPrev(null);
		    if (_first)
			_first.setPrev(pos);
		    else
			_last = pos;
		    _first = pos;
		    _count++;
		    return _first;
		}
		
		public function insertTail(item:*):CIListNode
		{
		    var pos:CIListNode = new CIListNode(item);
		    pos.setNext(null);
		    pos.setPrev(_last);
		    if (_last)
			_last.setNext(pos);
		    else
			_first = pos;
		    _last = pos;
		    _count++;
		    return _last;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Inserts a new node in ascendent order. If exists a node with
		|              the same ordValue, the insertion is not performed.
		| Input: The item we want to add to the list, and its order value.
		| Output: NULL if there is no node with the same ordValue, 
		|         or a pointer to the node with the same ordValue.
		+----------------------------------------------------------------------------*/
		public function insertInOrder (item:*,ordVal:Number):CIListNode
		{
		    var pos:CIListNode = new CIListNode(item, ordVal);
		    var ptr:CIListNode;
		
		    if (_first) {
			ptr = _first;
			while(ptr.next() && ptr.getOrdVal() < ordVal)
			    ptr = ptr.next();
		
		        if (!_acceptRepeated && ptr.getOrdVal() == ordVal) // we found a node with the same ordVal
		            return ptr;
		        else
		            if (!ptr.next() && ptr.getOrdVal() < ordVal) {
		                pos.setNext(null);
		                pos.setPrev(_last);
		                if (_last)
			            _last.setNext(pos);
		                else
			            _first = pos;
		                _last = pos;
		            }
			    else {
			        pos.setNext(ptr);
			        if (ptr.prev())
				    ptr.prev().setNext(pos);
			        else
				    _first = pos;
			        pos.setPrev(ptr.prev());
			        ptr.setPrev(pos);
			    }
		    }
		    else {
		        pos.setNext(null);
			pos.setPrev(null);
			_first = _last = pos;
		    }
		    _count++;
		    return null;  // insertion OK!
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Inserts a new node before/after the node pointed by pos, and 
		|	      returns a pointer to that new node.
		| Input: The item we want to add to the list and the position.
		| Output: A pointer to the new node
		+----------------------------------------------------------------------------*/
		public function insertBefore (pos:CIListNode, item:*):CIListNode
		{
			var np:CIListNode = new CIListNode(item);
		
		    if (pos != _first) {
		        np.setNext(pos);
		        pos.prev().setNext(np);
			np.setPrev(pos.prev());
			pos.setPrev(np);
			_count++;
			return np;
		    }
		    else
			return insertHead(item);
		}
		
		public function insertAfter (pos:CIListNode, item:*):CIListNode
		{
		    var np:CIListNode = new CIListNode(item);
		
		    if (pos != _last) 
			return insertBefore(pos.next(), item);
		    else
			return insertTail(item);
		}
		
		/*-----| Iteration methods |-----*/
		/*----------------------------------------------------------------------------+
		| Description: Returns the Item pointed by pos, and makes pos point to the 
		|	       next/prev node in the list.
		|
		| Input: pos - current node of the list
		| Output: The item of the current node, and a new value for pos, ie. a pointer 
		|	  to the next/prev node in the list.
		+----------------------------------------------------------------------------*/
		public function getNextItem (pos:CIListNode):*
		{
		    var item:* = pos.getItem();
		
		    pos = pos.next();
		    return item;
		}
		public function getPrevItem (pos:CIListNode):*
		{
		    var item:* = pos.getItem();
		
		    pos = pos.prev();
		    return item;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Remove the node pointed by pos
		| Input: pos - A pointer to the node
		+----------------------------------------------------------------------------*/
		public function removeAt (pos:CIListNode):void
		{
		    pos.prev().setNext(pos.next());
		    pos.next().setPrev(pos.prev());
		    //delete pos;
		    _count--;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Remove all nodes from the list, but the list still exists.
		+----------------------------------------------------------------------------*/
		public function removeAllNodes ():void
		{
		    deleteAll(_first);
		    _count = 0;
		    _first = null;
		    _last = null;
		    _current = null;
		}
		
		/*----------------------------------------------------------------------------+
		| Description: 
		+----------------------------------------------------------------------------*/
		public function findItem (item:*, pos:CIListNode):CIListNode
		{
		    if (!pos)
			pos = _first;
		    while(pos && (item != pos.getItem()))
			pos = pos.next();
		    return pos;
		}
		
		
		
		/*----------------------------------------------------------------------------+
		|		     Protected members of the class
		+----------------------------------------------------------------------------*/
		
		/*----------------------------------------------------------------------------+
		| Description: Delete recursively all the nodes of the list.
		+----------------------------------------------------------------------------*/
		protected function deleteAll (pos:CIListNode):void
		{
		    if (pos != null) {
			deleteAll(pos.next());
			//delete pos;
		    }
		}
	}
}