package upgrade
{
  import upgrade.UpgradeMenu;
  
  public class UpgradeAI
    {
    // My state variables.	
    private var state : Number;
    private var navigation_target : Number;
    private var cooldown : Number;
    
    private static var STATE_DECIDING : Number;
    private static var STATE_NAVIGATING : Number;
    private static var STATE_DONE : Number;
    
    private static var NAVIGATION_ATTRACT : Number;
    private static var NAVIGATION_REPEL : Number;
    private static var NAVIGATION_RETICLE : Number;
    private static var NAVIGATION_TETHER : Number;
    private static var NAVIGATION_SHIELD : Number;
    private static var NAVIGATION_DONE : Number;
    
    // Context in which this AI opponent exists.
    private var spec : ShipSpec;
    private var menu : UpgradeMenu;
   
  
            
    public function UpgradeAI (_spec : ShipSpec, _menu : UpgradeMenu)
      {
      spec = _spec;
      menu = _menu;
      
      // Readable names of this agents possible states.
      STATE_DECIDING = 0;
      STATE_NAVIGATING = 1;      	
      STATE_DONE = 2;
  
      // Readable names of navigation targets.
      // 0 = Attract.
      // 1 = Repel
      // 2 = Reticle
      // 3 = Tether
      // 4 = Shield
      // 5 = Done      
      NAVIGATION_ATTRACT = 0;
      NAVIGATION_REPEL = 1;
      NAVIGATION_RETICLE = 2;
      NAVIGATION_TETHER = 3;
      NAVIGATION_SHIELD = 4;
      NAVIGATION_DONE = 5;
      
      state = STATE_DECIDING;
      cooldown = 0;
      }
    
    public function update (deltaT:Number) : void
      {
      cooldown -= deltaT;
      if (cooldown > 0)	
        // We're not ready.
        return;
      
      // We are ready. Make a decision.  
      cooldown = Math.random()*20 + 5;
      
      switch (state)
        {
        case STATE_DECIDING:          
          // Establish something to buy. Find which tool is cheapest to upgrade.
          var toolcosts : Array = new Array;
          toolcosts[NAVIGATION_ATTRACT] = menu.attractPrice[spec.gravityLevel+1];
          toolcosts[NAVIGATION_REPEL] = menu.repelPrice[spec.repelLevel+1];
          toolcosts[NAVIGATION_RETICLE] = menu.reticlePrice[spec.reticleLevel+1];
          toolcosts[NAVIGATION_TETHER] = menu.tetherPrice[spec.tetherLevel+1];
          toolcosts[NAVIGATION_SHIELD] = menu.shieldPrice[spec.shieldLevel+1];
          
          // Kludge so that level 10 tools are so expensive we won't buy them.
          var infinity : Number = 100000;
          if (spec.gravityLevel == 10)
            toolcosts[NAVIGATION_ATTRACT] = infinity;
          if (spec.repelLevel == 10)
            toolcosts[NAVIGATION_REPEL] = infinity;
          if (spec.reticleLevel == 10)
            toolcosts[NAVIGATION_RETICLE] = infinity;    
          if (spec.tetherLevel == 10)
            toolcosts[NAVIGATION_TETHER] = infinity;            
          if (spec.shieldLevel == 10)
            toolcosts[NAVIGATION_SHIELD] = infinity;
          
          var best : Number = 0;
          for (var i : Number = 0; i < toolcosts.length; i++)
            if (toolcosts[i] < toolcosts[best])
              best = i;
          // The cheapest tool is now in best.
          // Can we afford it? If so, set navigation target and start moving.
          if (toolcosts[best] < spec.accountBalance)
            navigation_target = best;
          else
            // We can't afford it. Quit the screen.
            navigation_target = NAVIGATION_DONE;            
          state = STATE_NAVIGATING;
          return;
        break;	
        case STATE_NAVIGATING:
          // If I am at my destination, hit the target and change state....
          if (menu.selection == navigation_target)            
            {
            menu.upgrade();
            if (navigation_target == NAVIGATION_DONE)
              state = STATE_DONE;  // Go to waiting state.
            else
              state = STATE_DECIDING; // See if we can make more purchases.
            return;    
            }
          // ... otherwise, continue navigating. Decide which way to go.
          if (menu.selection < navigation_target)
            menu.navigateDown();
          else
            menu.navigateUp();  
        break;
        case STATE_DONE:
          // Do nothing - we are waiting for other players.	
        break;
        }
        
      }
    	
    }
}
