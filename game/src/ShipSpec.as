package {
// This container class is used to exchange information between the "garage" and "gameplay" engines
public class ShipSpec
  {
  // Integer which represents team (essentially, color) 
  public var teamCode:uint;
  public var isCPUControlled:Boolean;
  
  public var playerID:uint;
  
  // Integers 0-10 which represent the upgraded level of each ship stat.
  public var repelLevel:uint;
  public var gravityLevel:uint;
  public var tetherLevel:uint;
  public var reticleLevel:uint;
  public var shieldLevel:uint;
  
   
  // Money in the bank.
  public var accountBalance:uint;
  // Total money accumulated over the games lifetime.
  public var careerEarnings:uint;
  
  public static var RED_TEAM:uint;
  public static var BLUE_TEAM:uint;
  public static var YELLOW_TEAM:uint;
  public static var GREEN_TEAM:uint;  
  

  public function ShipSpec ()
    {
    // Assign code uints for each team.	
    RED_TEAM = 0;	
    BLUE_TEAM = 1;
    YELLOW_TEAM = 2;
    GREEN_TEAM = 3;
    
    playerID = 0;
    
    // You're broke, sucker.
    repelLevel = 0;
    gravityLevel = 0;
    tetherLevel = 0;
    reticleLevel = 0; 
	shieldLevel = 0;
    accountBalance = 0;
    careerEarnings = 0;
    
    // Just some defaults.
    isCPUControlled = false;    
    teamCode = RED_TEAM;
    }
  }

} // end package.