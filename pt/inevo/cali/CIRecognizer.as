package pt.inevo.cali
{
	public class CIRecognizer
	{
		var _shapesList:CIList; // CIList<CIGesture *>* 
    	var _alfaCut:Number;
     	var _unknownShape:CIShape;
	 	var _tap:CITap;
	 	
	 	public function CIRecognizer (...params)
		{
			var rotated:Boolean=(params.length>0)?params[0]:true;
			var alfaCut:Number=(params.length>1)?params[1]:0;
    		_alfaCut = alfaCut;
    		_shapesList = new CIList(); //CIList<CIGesture *> ();
    		_unknownShape = new CIUnknown();
			_tap = new CITap();

			

		}
		
		public function addShape(shape:CIShape):void{
			_shapesList.insertTail(shape);
		}
		
		public function addAllShapes(rotated:Boolean):void{
			// Gestures (Shapes and Commands) identified by the recognizer. 
			// The next lines create a list with all gestures identified by the recognizer
			// If you want to add a new gesture to the recognizer, just add it to the list.

			// Commands ----------
			_shapesList.insertTail(new CIDelete());
		    _shapesList.insertTail(new CIWavyLine());
		    //_shapesList.insertTail(new CICopy());
		    //_shapesList.insertTail(new CIMove());
		    //_shapesList.insertTail(new CICross());
		
			// Shapes ------------
		    _shapesList.insertTail(new CILine(rotated));
		    _shapesList.insertTail(new CITriangle(rotated));
		    _shapesList.insertTail(new CIRectangle(rotated));
		    _shapesList.insertTail(new CICircle(rotated));
		    _shapesList.insertTail(new CIEllipse(rotated));
		    //_shapesList.insertTail(new CIDiamond(rotated));
		    //_shapesList.insertTail(new CIArrow(rotated));
		}
		
		/*----------------------------------------------------------------------------+
		| Description: Identifies shapes based on a scribble. It starts by looking
		|              for global geometric features and then for local features
		| Input: sc - A scribble
		| Output: A list of plausible shapes ordered by degree of certainty.
		|
		| Notes: If the application wants to manipulate the gestures returned as new 
		|        entities, it must clone them, because the gestures return by the
		|        recognizer are always the same. (The gestures returned are the ones
		|        created in the recognizer constructor)
		+----------------------------------------------------------------------------*/
		public function recognize(sc:CIScribble):CIList //CIList<CIGesture *> *
		{
		    var val:Number;
		    var val2:Number;
    		var i:int;
   			var nshapes:uint = _shapesList.getNumItems();
		    var _shapes2Return:CIList=new CIList(); //CIList<CIGesture *>* ;
		    //_shapes2Return = new CIList<CIGesture *> ();

		    for (i=0; i<nshapes; i++) {     // set doms of all gestures to zero
		        _shapesList.getItemAt(i).resetDom();
		    }

			if (sc.getLen() < 10) {
				_tap.setUp(sc);
				_shapes2Return.insertInOrder(_tap, 1 - 0);
			} 
			else {
		
				/*
				    if (sc->getNumPoints() == 1) { // This piece of code is used to 
				        CIStroke *strk;            // avoid scribbles of just one point
				        CIList<CIPoint *> *pts;
				
				        strk = (*sc->getStrokes())[0];
				        pts = strk->getPoints();
				        strk->addPoint((*pts)[0]->x,(*pts)[0]->y);
				    }
				*/

				    for (i=0; i<nshapes; i++) {
				        var name:String = _shapesList.getItemAt(i).getName(); // Para apagar
				        val = _shapesList.getItemAt(i).evalGlobalFeatures(sc);
				        if (val > _alfaCut) {
				            val2 = _shapesList.getItemAt(i).evalLocalFeatures(sc, _shapesList);
				            if (val2 < val)
				                val = val2;
				            if (val > _alfaCut) {
				                name = _shapesList.getItemAt(i).getName(); // Para apagar
				                _shapes2Return.insertInOrder(_shapesList.getItemAt(i), 1 - val); 
				                // (1-val) is used because the method insertInOrder creates an
				                // ascendant list, and we want a descendant one.
				            }
				        }
				    }
					}
				
				    if (_shapes2Return.getNumItems() == 0) {
						    _unknownShape.setUp(sc);
						    _shapes2Return.insertInOrder(_unknownShape, 1 - 0);
				    }
				
				    return _shapes2Return;
		}
	}
}