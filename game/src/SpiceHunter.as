package {

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.events.Event;

import Attract;

import highscores.HighScores;
import highscores.HighScoresEntryScreen;

//com.pixeldroid.r_c4d3.interfaces.IGameRom;
import com.pixeldroid.r_c4d3.interfaces.IGameRom;
import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
import com.pixeldroid.r_c4d3.interfaces.IGameScoresProxy;
import com.pixeldroid.r_c4d3.controls.JoyHatEvent;
import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
import com.pixeldroid.r_c4d3.controls.JoyEventStateEnum;

import legacy.FourPlayerControl;

import upgrade.UpgradeScreen;

import play.Edge;
import play.Triangle;
import play.Particle;
import play.Body;
import play.Ship;
import play.Asteroid;
import play.Spice;
import play.HomeBase;
import play.Environment;

import Assets;
import Screen;

public class SpiceHunter extends Sprite implements IGameRom
  {

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry01")]
  private static const MapEntry01:Class;

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry02")]
  private static const MapEntry02:Class;

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry03")]
  private static const MapEntry03:Class;

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry04")]
  private static const MapEntry04:Class;

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry05")]
  private static const MapEntry05:Class;

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry06")]
  private static const MapEntry06:Class;

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry07")]
  private static const MapEntry07:Class;

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry08")]
  private static const MapEntry08:Class;

  [Embed(source="../swfs/mapEntry.swf", symbol="MapEntry09")]
  private static const MapEntry09:Class;
  
  //[Embed(source="../swfs/mapEntry.swf", symbol="MapEntry10")]
  //private static const MapEntry10:Class;
  
  private var mapSwfs : Array; // array of movieclips
  private var starmapPlaying : Boolean = false;
  private var r_c4d3_acknowledged : Boolean = false;
  private static const movieFPS : Number = 50.0; // desired framerate to play swfs at
                                                 // this does not affect gameplay
  
  private var environment : Environment;
  private var joinup : JoinUp;
  private var upgradeScreen : UpgradeScreen;
  private var attract : Attract;
  private var highScoresEntry : HighScoresEntryScreen;
  private var roundSummary : RoundSummary;
  private var credits : Credits;
  
  private var bonusDatas : Array;
  
  
  private var shipspecs : Array;  
  private var state : int;
  private static const STATE_ATTRACT : int = 0;
  private static const STATE_JOINUP : int = 1;
  private static const STATE_PLAY : int = 2;
  private static const STATE_GARAGE : int = 3;
  // 4 was Congratulations - it wasn't being used at all.  
  private static const STATE_HIGHSCOREENTRY : int = 5;
  private static const STATE_SUMMARY : int = 6;
  private static const STATE_STARMAP : int = 7;
  private static const STATE_CREDITS : int = 8;
  
  private static var MAX_ROUND : int;
 
  private var round : Number;

  private var controls : IGameControlsProxy;

  public function setControlsProxy(value : IGameControlsProxy) : void
    {
    controls = value;
    controls.joystickOpen(0); // activate joystick for player 1
    controls.joystickOpen(1); // activate joystick for player 2
    controls.joystickOpen(2); // activate joystick for player 3
    controls.joystickOpen(3); // activate joystick for player 4
    }

  public function setScoresProxy(value : IGameScoresProxy) : void
    {
    }

  public function enterAttractLoop() : void
    {
    controls.joystickEventState(JoyEventStateEnum.ENABLE, this.stage); // enable event reporting
    FourPlayerControl.instance.connect(controls);
    attract = new Attract(controls,Attract.STATE_TITLE);
    r_c4d3_acknowledged = true;
    }
  
  // entry pointsd
  public function SpiceHunter()
    {
    var i : int;
    
    Assets.init(this);
    Screen.init(this);
    HighScores.init();
    
    mapSwfs = new Array(9);
    
    mapSwfs[0] = new MapEntry01();
    mapSwfs[1] = new MapEntry02();
    mapSwfs[2] = new MapEntry03();
    mapSwfs[3] = new MapEntry04();
    mapSwfs[4] = new MapEntry05();
    
    mapSwfs[5] = new MapEntry06();
    mapSwfs[6] = new MapEntry07();
    mapSwfs[7] = new MapEntry08();
    mapSwfs[8] = new MapEntry09();
    //mapSwfs[9] = new MapEntry10();
    
    for ( i = 0; i < mapSwfs.length; i++ )
      {
      mapSwfs[i].x = 400;
      mapSwfs[i].y = 300;
      }
    
    /*STATE_JOINUP = 0;
    STATE_PLAY = 1;
    STATE_GARAGE = 2;
    STATE_CONGRATULATIONS = 3;
    STATE_ATTRACT = 4;
    */
   
    MAX_ROUND = 10;
    round = 0;
    
    newShipSpecs();
    
    Screen.root.addEventListener(Event.ENTER_FRAME, enterFrame);
    
    // No objects onscreen right now.
    environment = null;
    joinup = null;
    upgradeScreen = null;
    credits = null;
	
    // Start in the Joinup state.
    // state = STATE_JOINUP;
    
    //state = STATE_HIGHSCOREENTRY;
    // Start in the attract state.
    state = STATE_ATTRACT;
    }

  public function enterFrame (event:Event) : void
    {
    if ( !r_c4d3_acknowledged == true )
      return;
    
    switch (state)
      {
      case STATE_ATTRACT:
        if (attract == null)
          attract = new Attract(controls);
        attract.update();
        if (attract.expired) // attract will go until player input is received
          {
          state = STATE_JOINUP;
          attract = null;
          }
        break;
      case STATE_JOINUP:
        if (joinup == null)
          {
          newShipSpecs();
          joinup = new JoinUp(shipspecs);
          }
        joinup.update();
        Screen.draw(); // causes joinup to be drawn.
        if (joinup.isExpired)
          {
          round = 0;            
          state = STATE_PLAY;
          joinup = null;
          }
        return;
      break;  
      case STATE_PLAY:         
        if (environment == null)
          environment = new Environment (shipspecs, round);                         
        environment.onEnterFrame(); 
        if (environment.isExpired) 
          {
          Screen.reset();
          state = STATE_SUMMARY;
          bonusDatas = environment.bonusDatas;
          environment = null;
          }          
        return;  
      case STATE_SUMMARY:
      	if (roundSummary == null)
      	  roundSummary = new RoundSummary (shipspecs, bonusDatas);
      	roundSummary.update();
      	Screen.draw();
      	if (roundSummary.isExpired)
      	  {
      	  // Advance round.
          round++;
          environment = null;
          roundSummary = null;
          if (round < MAX_ROUND)        
            state = STATE_STARMAP;                           
          else
            state = STATE_HIGHSCOREENTRY;
      	  }
      break;  
      case STATE_STARMAP:
        var currentClip : MovieClip = mapSwfs[round-1];
        if ( !starmapPlaying )
          {
          var previousFPS : Number = Screen.root.stage.frameRate;
          Screen.root.stage.frameRate = movieFPS;
          Screen.swfs.addChild( currentClip );
          starmapPlaying = true;
          currentClip.gotoAndPlay(0);
          }
        else if ( currentClip.currentFrame == currentClip.totalFrames )
          {
          currentClip.stop();
          state = STATE_GARAGE;
          starmapPlaying = false;
          Screen.swfs.removeChild( currentClip );
          Screen.root.stage.frameRate = previousFPS;
          }
        break;
      case STATE_GARAGE:
        if (upgradeScreen == null)
          { 
          upgradeScreen = new UpgradeScreen(shipspecs);
          //Screen.background.addChild(upgradeScreen);
          }     
        upgradeScreen.onEnterFrame();
        Screen.draw(); // causes upgradeScreen to be drawn.
        if (upgradeScreen.isExpired)
          {
          state = STATE_PLAY;   
          //Screen.background.removeChild(upgradeScreen);           
          upgradeScreen = null;
          }
        break;
      case STATE_HIGHSCOREENTRY:
      
      /* temp hack is temporarily hacked out.
       // temp hack until high scores no longer updates to server
        state = STATE_CREDITS;
        break;
      // end of temp hack
      */
      
        if ( highScoresEntry == null )
          highScoresEntry = new HighScoresEntryScreen(shipspecs);
        highScoresEntry.update();
        Screen.draw();
        if ( highScoresEntry.expired )
          {
          state = STATE_CREDITS;
          highScoresEntry = null;
          }
        break;
        
      case STATE_CREDITS:
      	if (credits == null)
      	  credits = new Credits ();
      	credits.update ();
      	Screen.draw();
      	if (credits.expired)
      	  {
      	  state = STATE_ATTRACT;
      	  credits = null;	
      	  }
      break;  
      }    
    }
	
	private function newShipSpecs() : void
	  {
    // Initialize ship specs.
    shipspecs = new Array;     
    for (var i:Number =0; i < 4; i++)
      {
      shipspecs[i] = new ShipSpec();      
      // Initialize the ships at various upgrade levels.
      shipspecs[i].playerID = i;   
      shipspecs[i].accountBalance = 0;  
      shipspecs[i].careerEarnings = 0; 
      shipspecs[i].tetherLevel = 1; // 7+i; // 1+3*i;  
      shipspecs[i].reticleLevel = 1; // 1+3*i;  
      shipspecs[i].gravityLevel = 1; // 1+3*i;  
      shipspecs[i].repelLevel = 1; // 1+3*i;                   
      shipspecs[i].shieldLevel = 1;
      }                             
        
    
    // Assign default colors to match cabinet hardware.
    // Joysticks on the physical machine, from left to right:
    // 3-Red 1-Yellow 2-Green 4-Blue
    // Of course, we start counting from zero.
    shipspecs[3-1].teamCode = ShipSpec.RED_TEAM;   
    shipspecs[1-1].teamCode = ShipSpec.YELLOW_TEAM;
    shipspecs[2-1].teamCode = ShipSpec.GREEN_TEAM;
    shipspecs[4-1].teamCode = ShipSpec.BLUE_TEAM;
       
    // Assigning human players and CPU players    
    shipspecs[0].isCPUControlled = false; // Player 1 defaults to human.           
    shipspecs[1].isCPUControlled = true;    
    shipspecs[2].isCPUControlled = true;    
    shipspecs[3].isCPUControlled = true;             
                
    }
}

} // package