class Driver 
  {
  static var app : Driver;    
	
  function Driver() 
    {			
    _root.environment = new Environment();    
    _root.createTextField('cout', _root.getNextHighestDepth(), 80, 600, 800, 30);
    _root.cout.text = "_root.cout.text = ...(your ad here)...        Move reticle with arrows and hit spacebar.";
    
	_root.onEnterFrame = function ()
      {
      _root.environment.onEnterFrame();
	  }	  	
    }
    
  static function main(mc)
    {
    app = new Driver();
    }
  }
