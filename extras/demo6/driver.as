class Driver 
  {
  static var app : Driver;    
	
  function Driver() 
    {	
    _root.createTextField('cout', _root.getNextHighestDepth(), 80, 620, 800, 30);
    _root.cout.text = "_root.cout.text = ...(your ad here)...        Move reticle with arrows and hit spacebar.";
    
    		
    _root.environment = new Environment();    

	_root.onEnterFrame = function ()
      {
      _root.environment.onEnterFrame();
	  }	  	
	  
	  
	     
    _root.onMouseDown = function()
      {
	  var x:Number = _root._xmouse; 
	  var y:Number = _root._ymouse;
	  var b:Body = new Body;
	  b.rx = x;
	  b.ry = y;
	  	
	  var found:Number = -1;
	  for (var t:Number = 0; t < _root.environment.map.triangles.length; t++)
	    if (GeometryTests.inTriangle(_root.environment.map.triangles[t], b) )
	      found = t;
	  	
	  if (found != -1)
	    _root.cout.text = "Clicked in triangle " + _root.environment.map.triangles[found].ID + ". Bounding edges: (" + _root.environment.map.triangles[found].edgeAB.ID + ":["+_root.environment.map.triangles[found].edgeAB.Tleft.ID+", "+_root.environment.map.triangles[found].edgeAB.Tright.ID+"]"
	                                                                         +", "+ _root.environment.map.triangles[found].edgeBC.ID + ":["+_root.environment.map.triangles[found].edgeBC.Tleft.ID+", "+_root.environment.map.triangles[found].edgeBC.Tright.ID+"]"
	                                                                         +", "+ _root.environment.map.triangles[found].edgeCA.ID+":["+_root.environment.map.triangles[found].edgeCA.Tleft.ID+", "+_root.environment.map.triangles[found].edgeCA.Tright.ID+"]" + ")"
	                                                     + " Angles: (" + _root.environment.map.triangles[found].angleA
	                                                     + ", " + _root.environment.map.triangles[found].angleB
	                                                     + ", " + _root.environment.map.triangles[found].angleC + ")";	                                                     
	                                                     
	  else	    
	     _root.cout.text = "Didn't click in a triangle.";
	  
	  }
    }
  static function main(mc)
    {
    app = new Driver();
    }
  }
