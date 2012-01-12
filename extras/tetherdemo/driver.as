class Driver 
  {
  static var app : Driver;    
	
  function Driver() 
    {							
    // Create ship.				
    _root.createNumber("nextid");
    _root.nextid = 1;
    
    _root.createSpice("spice1");
	_root.spice1 = new Spice(_root);  
    
    _root.createShip("player1");
    _root.player1 = new Ship(_root);						
	  

	  
	_root.onEnterFrame = function ()
      {
      _root.spice1.onEnterFrame();	
	  _root.player1.onEnterFrame();	  
	  
	  
	  var N:Number = _root.player1.tether.N;
	  var t:Tether = _root.player1.tether;
	  	  	  
	  if ( Math.abs(t.nodes[N-1].r[0]-_root.spice1.r[0]) < 20)			
	    if ( Math.abs(t.nodes[N-1].r[1]-_root.spice1.r[1]) < 20)	      
	      if (t.target == null)
	        t.setTarget(_root.spice1);
	  
	  }	  
	  
    }	  
	
  static function main(mc) 
    {
    app = new Driver();					
    }
  }
