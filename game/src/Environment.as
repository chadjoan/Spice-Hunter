package {

import Assets;
import PlaytimeControls;

import flash.ui.Keyboard;
import flash.events.KeyboardEvent;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.media.Sound;

public class Environment
  {
  public var asteroids:Array;          // A list for storing asteroids active in the domain.
  private var new_asteroids:Array;     // A list for storing the new asteroids which enter from the sides of the map.
  public var asteroidTrigger : Number; // Threshold (in mass) at which a new asteroid is made.
  
  public var spices:Array;             // List of active spices. Public so that CPUships can walk the array so find spice to chase.
  private var new_spices : Array;      // A list for storing new spice which enters from the sides of the map.
  public var spiceTrigger : Number;    // Threshold (in mass) at which new spice is made.
  
  public var homebases:Array;   // List of homebases[4]. Public so that CPUships can find homebase to return spice to.
  public var ships:Array;       // List of ships[4]. Public so that the PlayerControls may see it.
  public var bonusDatas : Array // List of BonusData[4].

  public var animations:Array; // List of animations. Implemented in Animation.as (extended by Explosion and SpiceGlob, and others)
  public var anchors:Array;     // List of anchors. Implemented in Anchor.as
  
  
  private var dummyNodes : Array; // For seeding map information that is more useful to CPU opponents.    
  public var map:NavigationMap;   // A helper object for CPUShip planning. Implemented in NavigationMap.as
  
  private var controls : PlaytimeControls;
  
  private var mapUpdateFrame1 : Number;  // These two state variables are used to periodically update the map.
  private var mapUpdateFrame2 : Number;  // Every 10 frames, a cleanup is done, while every 100 frames a complete regen is done.
  
  private var scoreLoopers:Array;        // These are display widgets for illustrating player score. Implemented in ScoreLooper.as
  private var go321 : Go321;             // A display widget for implementing the 3-2-1-GO! countdown. Implemented in Go321.as
  private var triggeredControls:Boolean; // A flag that indicates whether or not controls have been hooked by this environment
                                         // Initialized to false, set to true when controls are added after go321.isDone()  
  public var shipspecs:Array;            // A reference to a list of shipspecs[4] - describes each ships score, upgrades, teamColor, 
                                         // and whether it is CPU or Player controlled. See ShipSpec.as
  
  public var isExpired:Boolean;       // Flag indicating this environment has expired.
  
  public var bg:Bitmap;               // A handle to the background image - store it so we can properly remove it in expire()
  private var fpsDisplay:FPSDisplay;  // Handles timing - not just a display object so don't delete this. It also regulates the timestep of the mainloop.
  private var gameClock:GameClock;    // The visual widget for the countdown timer    
 
  public var levelDuration : Number;  // Duration of the environment until expiration. Can be set by the Level.
  public var levelMusic : Sound;      // Music, can be set by the Level.       
  private var level : Level;          // Extensible class for implementing different levels.
  
  
         
  // Constructs a new game environment. Accepts an array of ship specifications as input.
  public function Environment (_shipspecs:Array, round : Number )
    {            
    var i : Number;    
    shipspecs = _shipspecs;
    
    asteroids = new Array;    
    new_asteroids = new Array;
    asteroidTrigger = 0.0;
    
    spices = new Array;
    new_spices = new Array;
    spiceTrigger = 0.0;
    
    homebases = new Array;
    ships = new Array;
    animations = new Array;
    anchors = new Array;
       
    triggeredControls = false;
    isExpired = false;    
    
    bg = null;
    levelDuration = 180;
    levelMusic = null;
    
    // Initialize base locations to the corners.    
    // Upper left - player 3.
    homebases[2] = new HomeBase(shipspecs[2]);
    homebases[2].rx = 0;
    homebases[2].ry = 0;        
    // Lower left - player 1.
    homebases[0] = new HomeBase(shipspecs[0]);
    homebases[0].rx = 0;
    homebases[0].ry = 600;    
    // Lower right - player 2.
    homebases[1] = new HomeBase(shipspecs[1]);
    homebases[1].rx = 800;
    homebases[1].ry = 600;       
    // Upper right - player 4.
    homebases[3] = new HomeBase(shipspecs[3]);
    homebases[3].rx = 800;
    homebases[3].ry = 0;        
    for (var hb:Number=0; hb< homebases.length; hb++)
      homebases[hb].updatePosition();
    
    // Create bonus datas
    bonusDatas = new Array;
    for (i = 0; i < 4; i++)
      bonusDatas[i] = new BonusData();
        
    // Create ships.    
    for (i=0; i < 4; i++)
      switch (shipspecs[i].isCPUControlled)
        {
        case false: ships[i] = new Ship(shipspecs[i], this); break;
        case true: ships[i] = new CPUShip(shipspecs[i], this);  break;        
        }    

    // Initialize ship positions near homebases.
    // Upper left - player 3.
    ships[2].rx = 70;
    ships[2].ry = 50;               
    // Lower left - player 1.
    ships[0].rx = 80;
    ships[0].ry = 600-70;    
    // Lower right - player 2.            
    ships[1].rx = 800-70;
    ships[1].ry = 600-50;                    
    // Upper right - player 4.
    ships[3].rx = 800-70;
    ships[3].ry = 50;             
    
    // Initialize reticles on ships.
    for (i = 0; i < 4; i++)
      {
      ships[i].reticle.rx = ships[i].rx;
      ships[i].reticle.ry = ships[i].ry;
      }    

    // Make map dummy nodes.
    dummyNodes = new Array;
    dummyNodes.push ( new DummyMapNode(2,300) );
    dummyNodes.push ( new DummyMapNode(267,598) );
    dummyNodes.push ( new DummyMapNode(267,2) );
    dummyNodes.push ( new DummyMapNode(533,598) );
    dummyNodes.push ( new DummyMapNode(533,2) );
    dummyNodes.push ( new DummyMapNode(798,300) );
                  
    // Initialize scoreLoopers.     
    scoreLoopers = new Array;
    for (i=0; i<4; i++)
      {
      scoreLoopers[i] = new ScoreLooper(shipspecs[i]);
      scoreLoopers[i].setTargetScore(0);
      }
    // Plant their positions.
    // Upper left - player 3
    scoreLoopers[2].rx = homebases[2].rx + 65;
    scoreLoopers[2].ry = homebases[2].ry + 10;
    // Lower left  - player 1
    scoreLoopers[0].rx = homebases[0].rx + 65;
    scoreLoopers[0].ry = homebases[0].ry - 10 - ScoreLooper.FONTHEIGHT * (1 + ScoreLooper.NDIGITS / (ScoreLooper.NDIGITS+1) );
    // Lower right - player 2
    scoreLoopers[1].rx = homebases[1].rx - 65 - ScoreLooper.FONTWIDTH*ScoreLooper.NDIGITS;
    scoreLoopers[1].ry = homebases[1].ry - 10 - ScoreLooper.FONTHEIGHT * (1 + ScoreLooper.NDIGITS / (ScoreLooper.NDIGITS+1) );
    // Upper right - player 4
    scoreLoopers[3].rx = homebases[3].rx - 65 - ScoreLooper.FONTWIDTH*ScoreLooper.NDIGITS;
    scoreLoopers[3].ry = homebases[3].ry + 10;
    
        
    // Get a level.
    var NMaps : Number = 10;
    // var mapCode:Number = Math.round(Math.random() * NMaps );    
    switch (round % NMaps)
      {
      case 0:      
      	level = new Level_0;
      break;
      
      case 1:
      	level = new Level_1;
      break 	
      
      case 2:
      	level = new Level_2;
      break 

      case 3:      
      	level = new Level_3;
      break;
      
      case 4:
      	level = new Level_4;
      break; 	
      
      case 5:
      	level = new Level_5;
      break; 

      case 6:      
      	level = new Level_6;
      break;
      
      case 7:
      	level = new Level_7;
      break; 	
      
      case 8:
      	level = new Level_8;
      break;

      case 9:
      	level = new Level_9;
      break;
      }         
    // Let the level initialize us. We trust it.   
    level.initializeIntoEnvironment (this);
    level.updateAnchors(this,0);    

    if (bg != null)    
      Screen.background.addChild( bg );
    
    // Initialize navigation map for CPU players.
    initializeMap();       
    mapUpdateFrame1 = 0;
    mapUpdateFrame2 = 10;        
    
    // Make a new Go321 - it initializes in state 3, ready to update/draw.
    go321 = new Go321(level.name);
    fpsDisplay = new FPSDisplay();    
    gameClock = null;    
    }
  
  public function onEnterFrame() : void
    {
    // I don't think this can ever happen, but just in case...
    if (isExpired)
      return;	    
    
    // Update the frame rate counter - we can figure out our relative timestep from its FPS field.
    fpsDisplay.update();
    var deltaT : Number = 25.0 / fpsDisplay.FPS;
    
    // Lots of weird odds and ends here at the beginning. This code is mostly 
    // associated with starting and shutting down the environment properly.
    // --------------------------------------------------------- <weird>    
    // Activates / progresses the start countdown. This is happening at the beginning of the round.	    
    if (!go321.isDone() )
      go321.update(deltaT);           
    // Trigger these operations just once.  
    if (go321.isDone() && !triggeredControls)  	    
      {
      // Start accepting input.
      controls = new PlaytimeControls(this, shipspecs );	
      triggeredControls = true;
      go321.expire();      
      // Start up the level countdown clock.
      gameClock = new GameClock(levelDuration);      
      // Start playing music if the level has established a tune.
      if (levelMusic != null)
        Utility.playSound ( levelMusic );
      }          
    // Detects the countdown/zero conditions. This is happening at the end of the round.
    if (gameClock != null)   
      {
      gameClock.update(deltaT);      
      // Times up? Run the destructor - expire() method.
      if (gameClock.clockIsZero() )
        {
        expire(); 
        return;
        }
      }
    // --------------------------------------------------------- </weird>
    // It's all regular stuff from here on out.
    
    // Clears hud lineart (reticles) - must be done every frame or they leave droppings.	
    Screen.hud.graphics.clear();
    // Clears midground graphics - tethers and beams are on that plane (so they are under most objects but above the background)
    Screen.midground.graphics.clear();  
    
    updateCPUShipAI ();  
     
    // Apply level forces to objects - only after countdown is over.
    if ( go321.isDone() )
      level.applyForcesIntoEnvironment(this, deltaT); 
          
    var loop1:int;                
    for (loop1 = 0; loop1 < ships.length; loop1++)
      ships[loop1].updateVelocity(deltaT);
    
    // Check for collisions among EVERYTHING (whew) and apply all sorts of rules (globbing spice, splitting asteroids, etc)
    // Lots of stuff happens in this function.
    handleCollisions();
    
    // Special handler for spice / homebase collision - which is where scoring and some bonus things popup.
    handleScoring ();    
           
    // Update asteroid positions.
    for (loop1=0; loop1 < asteroids.length; loop1++)         
      asteroids[loop1].updatePosition(deltaT);	        
    // Update anchor positions.
    level.updateAnchors(this, deltaT);
    for (loop1=0; loop1 < anchors.length; loop1++)         
      anchors[loop1].updatePosition();	         
    // Update spice positions.
    for (loop1=0; loop1 < spices.length; loop1++)    
      spices[loop1].updatePosition(deltaT);     
    // Update ship positions.
    for (loop1=0; loop1 < ships.length; loop1++)
      ships[loop1].updatePosition(deltaT);        
    // Update animations (advance a frame)
    for (loop1 = 0; loop1 < animations.length; loop1++)
      animations[loop1].update(deltaT);    
    // Update scoreLooper animations (advance a frame)    
    for (loop1 = 0; loop1 < scoreLoopers.length; loop1++)
      scoreLoopers[loop1].update(deltaT);      
    
    
    // The tether are unique gameplay objects that have their own, nonstandard updates.
    updateTethers(deltaT);        
               
    // An expired thing should be removed from the Screen and popped out of storage into the bit bucket. Three cases:
    //   1.  asteroids get expired when they explode.
    //   2.  spice gets expired when it is globbed or dragged home.
    //   3.  animations get expired when the have played through all their frames.
    removeExpiredThings ();
    
    // Make reticles stick to objects - this triggers a search under each reticle and
    // makes each one track whatever is underneath it, a little bit.        
    reticleSearch();      
    
    // Self-explanatories...
    createNewAsteroids (deltaT);
    createNewSpice (deltaT);       
    }
  
  public function updateTethers(deltaT : Number) : void
    {
    var loop1 : Number;
    var loop2 : Number;
    var loop3 : Number;	
    	
    // For stability reasons, the "stiff" tether has to be updated at a very rapid frequency
    // (relative to the other objects in the map). The rate here is 10 times the global
    // clock rate. If the tether is made more stiff (ie increase the maximum spec.tetherLevel), 
    // this number will have to grow even more.    
    var iter: Number;
    var upsampleRate: Number = 10;
    var tetherFudge:Number = deltaT;
    // Cludge here. An unintended consequence of making the game frame-rate independent is that
    // at low frame rates, the timestep (deltaT) can get sufficiently large that the tether goes
    // courant-friedrichs-lewy unstable. The snippet below clamps the tether update rate when the 
    // timestep gets too large. The drawback is that the tether behavior is not truly framerate 
    // independent - at low frame rates it is not physically realistic. But it sure beats Inf's / NaN's.   
    if (tetherFudge > 1)
      tetherFudge = 1;    
    for (iter = 0; iter < upsampleRate; iter++)
      {
      for (loop3 = 0; loop3 < ships.length; loop3++)        
        ships[loop3].tether.updatePosition(upsampleRate,tetherFudge);
      // Handle collisions between Tether nodes and asteroids by momentum exchange.        
      // Modeling the interaction (collision) of tethers and asteroids is 
      // very expensive because it must be performed so often - deeply nested loop.            
      /*
      for (loop3 = 0; loop3 < ships.length; loop3++)
        for (loop1 = 0; loop1 < asteroids.length; loop1++)
          for (loop2 = 0; loop2 < ships[loop3].tether.nodes.length; loop2++)
            if (ships[loop3].tether.state == Tether.TETHER_ATTACHED)
              if (collisionCheck(ships[loop3].tether.nodes[loop2], asteroids[loop1]) && ships[loop3].tether.target != asteroids[loop1])                       
                momentumExchangeElastic (ships[loop3].tether.nodes[loop2], asteroids[loop1]);                                 
      */
      // Tether / asteroid interactions are currently disabled.
      }      
    // Draw all the tethers - positions have changed.      
    for (loop3 = 0; loop3 < ships.length; loop3++)        
      ships[loop3].tether.draw();    	
    }
  
  public function handleScoring () : void
    {
    var loop1 : Number;
    var loop2 : Number;
    var loop3 : Number;
    
    // Handle collisions between Spices and Homebases by eliminating the spice and updating the Homebases score.
    for (loop1=0; loop1 < spices.length; loop1++)
      for (loop2=0; loop2 < homebases.length; loop2++)
        if (!spices[loop1].isExpired)
        if ( collisionCheck(spices[loop1], homebases[loop2]) )
          {
          // Split score among teammates. All other bases allied to homebases[loop2] get a cut too.          
          // Count up number of allied players.
          var NAlliedPlayers : Number = 0;
          for (loop3 = 0; loop3 < 4; loop3++)
            if (homebases[loop3].spec.teamCode == homebases[loop2].spec.teamCode)
              NAlliedPlayers++;          
          // Give 2:1 shares. Homebases[loop2] gets the dominant share (2 parts). Everyone else gets 1 part. Here's how this shakes out:
          // NAllies - Shares
          //    1    - 100%
          //    2    - 66%, 33%
          //    3    - 50%, 25%, 25%
          //    4    - 40%, 20%, 20%, 20%
          for (loop3 = 0; loop3 < 4; loop3++)
            if (homebases[loop3].spec.teamCode == homebases[loop2].spec.teamCode )
              {
              if (loop3 == loop2)
                {
                homebases[loop3].addScore ( Math.round ( 2.0 * spices[loop1].value() / (NAlliedPlayers+1.0) ) );	
                scoreLoopers[loop3].setTargetScore(homebases[loop3].score);
                }
              else
                {
                homebases[loop3].addScore ( Math.round ( 1.0 * spices[loop1].value() / (NAlliedPlayers+1.0) ) );
                scoreLoopers[loop3].setTargetScore(homebases[loop3].score);
                }
              }
          Utility.playSound( new Assets.Score() );
                  
          // Check for bonus status. 
          // Is this spice fingerprinted? A fingerprint is applied when spice is released deliberately by a player. (a detectable, keystoke, event).
          if (spices[loop1].fingerprint != null)
            // Is this spice fingerprinted by a player who is allied to this base?
            if (spices[loop1].fingerprint.releaser.spec.teamCode == homebases[loop2].spec.teamCode)
              {
              // Compute distance from the release point to the homebase point.
              var dx_bonus:Number = homebases[loop2].rx - spices[loop1].fingerprint.release_x;
              var dy_bonus:Number = homebases[loop2].ry - spices[loop1].fingerprint.release_y;
              var dl_bonus:Number = Math.sqrt (dx_bonus*dx_bonus + dy_bonus*dy_bonus);
              // Is this distance far enough away to count as a long shot?
              if (dl_bonus > 200.0)
                {
                // Update the appropriate players bonus record. Which player gets rewarded is NOT(!) indicated by the homebase index, 
                // but rather by the fingerprint.releaser's index. Why? Imagine player 1 and player 2 are on the same team, and player 2
                // makes a skill shot into player 1's base. Player 2 should get the credit for the good shot, not player 1.
                // Player 1 still nets the scoring of the spice into his base, however.                
                bonusDatas[ spices[loop1].fingerprint.releaser.spec.playerID ].numberLongShots++;
                // Display a rewarding graphic / sound.
                Utility.playSound (new Assets.nice_shot );
                var ns : NiceShot = new NiceShot ( Screen.hud, spices[loop1].fingerprint.releaser.spec.teamCode,
                	                               spices[loop1].fingerprint.release_x,
                	                               spices[loop1].fingerprint.release_y, 
                	                               homebases[loop2].rx,
                	                               homebases[loop2].ry );
                ns.rx = spices[loop1].fingerprint.release_x;
                ns.ry = spices[loop1].fingerprint.release_y;
                ns.radius = 50;
                animations.push(ns);           
                }
              }
          
          // Update timeOfLastScore member of bonusDatas
          if (gameClock != null)
            bonusDatas[loop2].timeOfLastScore = gameClock.state;          
          // Update bigSpiceHauls member of bonusDatas          
          if (spices[loop1].mass > 10.0)
            {
            bonusDatas[loop2].bigSpiceHauls++;
            // Add a new "motherlode" graphic. loop2 indicates which homebase corner it should be placed at.
            var ml : Motherlode = new Motherlode (Screen.hud, homebases[loop2].spec.teamCode);
            ml.radius = 50;
            // Establish an x-y for this animation - near a base corner. But shifted in towards (400,300).
            // How much should we offset in?
            var mlrx : Number = 100;
            var mlry : Number = 120;
            switch (loop2)            
              {
              case 0: ml.rx = mlrx;     ml.ry = 600-mlry; break; // lower left
              case 1: ml.rx = 800-mlrx; ml.ry = 600-mlry; break; // lower right
              case 2: ml.rx = mlrx;     ml.ry = mlry;     break; // upper left.
              case 3: ml.rx = 800-mlrx; ml.ry = mlry;     break; // upper right.
              }      
            animations.push(ml);   
            // Make a mega-spice noise.
            Utility.playSound (new Assets.bigspicebonus );                   
            }            
          // Pitch the spice away.
          spices[loop1].expire();
          }
    
    	
    }
  
  
  public function updateCPUShipAI () : void
    {
    var loop1 : Number;
    
    // Updating the navigation map for CPU players.
    mapUpdateFrame1++;	           
    map.computeDualPositions();
    if (mapUpdateFrame1 == 10)
      {
      // Clean up the existing map using edge flips.	
      map.computeAngles();	
      map.cleanUp();
      map.makeDualGraph();   
      
      mapUpdateFrame1 = 0;            
      mapUpdateFrame2++;      
      }    
    if (mapUpdateFrame2 == 10)     
      {
      // Make a new map from scratch.	
      initializeMap();  
      mapUpdateFrame2 = 0;      
      }
    
    // Displaying the map to the screen.  
    // map.draw(Screen.hud);
    // map.drawDualGraph(Screen.hud);        
    
    // Update AI for all CPU controlled ships - only after countdown is over.
    if ( go321.isDone() )
      {      
      for (loop1 = 0; loop1 < ships.length; loop1++)
        if (ships[loop1].spec.isCPUControlled)
          ships[loop1].updateAI();                     
      }	
    }
  
  public function handleCollisions () : void
    {
    var loop1 : Number;
    var loop2 : Number;
    var loop3 : Number;
    var flag : Boolean;
            
    // Handle collisions between Asteroids by exchanging momentum.
    for (loop1=0; loop1 < asteroids.length; loop1++)
      for (loop2=loop1+1; loop2 < asteroids.length; loop2++)        
        if (!asteroids[loop1].isExpired && !asteroids[loop2].isExpired)
        if ( collisionCheck (asteroids[loop1], asteroids[loop2]) )
          {
          var exchange:Number = momentumExchangeElastic (asteroids[loop1], asteroids[loop2]);
          momentumExchangeAngular (asteroids[loop1], asteroids[loop2]);
          Utility.playSound( new Assets.AstAstCollide() );                    
          // How much momentum was exchanged? If it's too much, destroy the asteroids.
          if (exchange/asteroids[loop1].mass > 1)
            // This collision was hard enough to split or destroy asteroid1            
            {
            flag = asteroidSplit(asteroids[loop1], asteroids[loop2]);
            // Flag is false if no new asteroids were created (asteroids[loop1] was too small to split). If that's the case, make some spice (sometimes)
            if (!flag && Math.random() < 0.5)
              {
              spices.push(new Spice () );
              spices[spices.length-1].rx = asteroids[loop1].rx;
              spices[spices.length-1].ry = asteroids[loop1].ry;
              }
            }
          if (exchange/asteroids[loop2].mass > 1)
            // This collision was hard enough to split or destroy asteroid2            
            {
            flag = asteroidSplit(asteroids[loop2], asteroids[loop1]);                
            // Flag is false if no new asteroids were created (asteroids[loop2] was too small to split). If that's the case, make some spice (sometimes)
            if (!flag && Math.random() < 0.5)
              {
              spices.push(new Spice () );
              spices[spices.length-1].rx = asteroids[loop2].rx;
              spices[spices.length-1].ry = asteroids[loop2].ry;
              }            
            }
          }
              
    // Handle collisions between Asteroid and Spice by exchanging momentum.
    for (loop1=0; loop1 < asteroids.length; loop1++)
      for (loop2=0; loop2 < spices.length; loop2++)
       if (!asteroids[loop1].isExpired && !spices[loop2].isExpired)
        if ( collisionCheck (asteroids[loop1], spices[loop2]) )
          {
          Utility.playSound( new Assets.AstSpiceCollide() );	
          momentumExchangeElastic (asteroids[loop1], spices[loop2]);
          momentumExchangeAngular (asteroids[loop1], spices[loop2]);
          }
    
    // Handle collisions between anchors and asteroids by reflection.
    for (loop1=0; loop1 < asteroids.length; loop1++)
      for (loop2=0; loop2 < anchors.length; loop2++)
        if (!asteroids[loop1].isExpired)
          if ( collisionCheck(asteroids[loop1], anchors[loop2]) )
            momentumExchangeElastic (asteroids[loop1], anchors[loop2]);
    
    // Handle collisions between anchors and ships by reflection
    for (loop1=0; loop1 < ships.length; loop1++)
      for (loop2=0; loop2 < anchors.length; loop2++)        
        if ( collisionCheck(ships[loop1], anchors[loop2]) )
          {
          momentumExchangeElastic (ships[loop1], anchors[loop2]);
          // Update numberCollisions member of bonus data (for tracking "good driver" status)
          bonusDatas[loop1].numberCollisions++;
          }

    // Handle collisions between anchors and spices by reflection.
    for (loop1=0; loop1 < spices.length; loop1++)
      for (loop2=0; loop2 < anchors.length; loop2++)
        if (!spices[loop1].isExpired)
          if ( collisionCheck(spices[loop1], anchors[loop2]) )
            momentumExchangeElastic (spices[loop1], anchors[loop2]);
            
    // Handle collisions between Spices by globbing - lots of code here because spice globbing 
    // involves a lot of possibilities to spawn bonuses.
    for (loop1=0; loop1 < spices.length; loop1++)
      for (loop2=loop1+1; loop2 < spices.length; loop2++)
        if (!spices[loop1].isExpired && !spices[loop2].isExpired)
        if ( collisionCheck (spices[loop1], spices[loop2]) )
          {
          // Glob momentum into s1.	
          momentumExchangeInelastic (spices[loop1], spices[loop2]);
          spices[loop1].setMass (spices[loop1].mass + spices[loop2].mass);
          // Trigger a redraw, with larger mass.                                        
          spices[loop1].draw();  
          // Add a globbing animation.          
          var sg : SpiceGlob = new SpiceGlob(Screen.midground);
          sg.radius = spices[loop1].collision_radius*4;
          sg.rx = spices[loop1].rx;
          sg.ry = spices[loop1].ry;
          sg.boundTo = spices[loop1];
          animations.push(sg);
          
          // Update the fingerprint data.
          // If spice2 has a fingerprint, give it to spice1 too.
          if (spices[loop2].fingerprint != null)
            spices[loop1].fingerprint = spices[loop2].fingerprint;
                            
          // Remove the visual sprite of s2. 
          spices[loop2].expire();           
          
          // Search through ships - if any tether references s2, change its target to s1.
          for (loop3 = 0; loop3 < ships.length; loop3++)
            if (ships[loop3].tether.target == Body(spices[loop2]) )
              {
              ships[loop3].tether.target = Body(spices[loop1]);
              // This spice is attached - clear its fingerprint.
              spices[loop1].fingerprint = null;
              }
          
          // If the spice is still fingerprinted, that means someone has flung it successfully into another spice.
          // Award a combo bonus.
          if (spices[loop1].fingerprint != null)
            {
            bonusDatas[ spices[loop1].fingerprint.releaser.spec.playerID ].combos++;           	            
            // Add a "spice combo" graphic - put it on top of spices[loop1].
            var spicecombo : SpiceComboAnim = new SpiceComboAnim(Screen.hud, spices[loop1].fingerprint.releaser.spec.teamCode);
            spicecombo.radius = 50;
            spicecombo.boundTo = spices[loop1];
            spicecombo.boundTo_enableRotation = false;
            animations.push(spicecombo);
            // Play the spice combo sound.
            Utility.playSound (new Assets.combosound);                        	
            }
          
          // If the spice is tethered, that means someone made a combo with their tether.
          // The bonus can only be trigged if everyone who has this spice tethered is allied.
          var listOfTetherers : Array = new Array;
          for (loop3 = 0; loop3 < ships.length; loop3++)
            if (ships[loop3].tether.target == Body(spices[loop1]) )
              listOfTetherers.push(ships[loop3]);
          if (listOfTetherers.length > 0)
            {
            // Is everyone who has tethered this spice on the same team?	
            var allAreAllied : Boolean = true;
            for (loop3 = 1; loop3 < listOfTetherers.length; loop3++)
              if (listOfTetherers[loop3].spec.teamCode != listOfTetherers[0].spec.teamCode)
                allAreAllied = false;
            if (allAreAllied)
              {
              // Give em all a bonus.	
              for (loop3 = 0; loop3 < listOfTetherers.length; loop3++)
                bonusDatas[listOfTetherers[loop3].spec.playerID].combos++;
              // Add a spice combo graphic.
              var spicecombo2 : SpiceComboAnim = new SpiceComboAnim(Screen.hud, listOfTetherers[0].spec.teamCode);
              spicecombo2.radius = 50;
              spicecombo2.boundTo = spices[loop1];
              spicecombo2.boundTo_enableRotation = false;
              animations.push(spicecombo2);
              // Play the spice combo sound.
              Utility.playSound (new Assets.combosound);      
              }              
            }
          
          // Play the spice glob sound.              
          Utility.playSound( new Assets.SpiceSpiceCollide() );          
          }
    
    
    // Handle collisions between Asteroids and Homebases by reflection (elastic collision in which one object is immobile/has huge mass).
    for (loop1=0; loop1 < asteroids.length; loop1++)
      for (loop2=0; loop2 < homebases.length; loop2++)
        if (!asteroids[loop1].isExpired)
          if ( collisionCheck(asteroids[loop1], homebases[loop2]) )
            momentumExchangeReflection (asteroids[loop1], homebases[loop2]);
    
    // Handle collisions between Ships and Asteroids by momentum exchange (for now)
    for (loop1=0; loop1 < asteroids.length; loop1++)
      for (loop2=0; loop2 < ships.length; loop2++)
        if (!asteroids[loop1].isExpired)
          if ( collisionCheck (asteroids[loop1], ships[loop2]) )
            {
            momentumExchangeElastic (asteroids[loop1], ships[loop2]);            
            // Update numberCollisions member of bonus data (for tracking "good driver" status)
            bonusDatas[loop2].numberCollisions++;
            }
    
    // Change: ships no longer collide with homebase, they can drive right over it - I feel this makes it easier to get spice in deliberately.    
    // Instead, this check is used to retract the tether a little bit when a ship is over it's allied homebase.    
    /*
    for (loop1=0; loop1 < ships.length; loop1++)   
       for (loop2=0; loop2 < homebases.length; loop2++)
          if ( collisionCheck(ships[loop1], homebases[loop2]) ) 
            if ( ships[loop1].spec.teamCode == homebases[loop2].spec.teamCode )
              if (ships[loop1].tether.target != null)
                ships[loop1].tether.recoilALittle(deltaT); 
    */
    // Actually I scrapped this whole thing - it was not very noticeable at all. Ships drive over homebase, and nothing happens.
            
            
                
        
    // Handle collisions between Ships and other Ships by momentum exchange. Update good driver / demolition derby statistics.
    for (loop1=0; loop1 < ships.length; loop1++)   
       for (loop2=loop1+1; loop2 < ships.length;loop2++)
          if ( collisionCheck(ships[loop1], ships[loop2]) )
            {
            momentumExchangeElastic (ships[loop1], ships[loop2]);   
            // Update shipCollisions member of bonus data (for tracking "demolition derby" status)
            bonusDatas[loop1].shipCollisions++;
            bonusDatas[loop2].shipCollisions++;
            // Update numberCollisions member of bonus data (for tracking "good driver" status)
            bonusDatas[loop1].numberCollisions++;
            bonusDatas[loop2].numberCollisions++;
            }
    }
  
  public function removeExpiredThings () : void
    {    
    var loop1 : Number;
    var loop2 : Number;
    
    // Remove expired asteroids.
    loop1 = 0;
    while (loop1 < asteroids.length)
      if (asteroids[loop1].isExpired)
        {
        // Trigger a map rebuild.	
        mapUpdateFrame1	= 0;
        mapUpdateFrame2	= 10;
        // A Gotcha - fixing references to objects that no longer exist. Truly ugly code.		
        for (loop2 = 0; loop2 < ships.length; loop2++)
          {          
          if (ships[loop2].gravityTarget == Body(asteroids[loop1]) )
            {
            ships[loop2].gravityTarget = null;
            ships[loop2].triggerReset(Ship.GRAVITY_SNAP_EVENT);
            }
          if (ships[loop2].repelTarget == Body(asteroids[loop1]) )
            {
            ships[loop2].repelTarget = null;  
            ships[loop2].triggerReset(Ship.REPEL_SNAP_EVENT);
            }
          if (ships[loop2].tether.target == Body(asteroids[loop1]) )
            {
            ships[loop2].triggerReset(Ship.TETHER_SNAP_EVENT);
            ships[loop2].tether.startRecoil();
            }   
          }
        // Remove this asteroid from storage.          
        asteroids[loop1] = asteroids[asteroids.length-1];
        asteroids.pop();                
        }
      else
       loop1++;
    
    // Remove expired spices.
    loop1 = 0;
    while (loop1 < spices.length)
      if (spices[loop1].isExpired)
        {
        // Trigger a map rebuild.	
        mapUpdateFrame1 = 0;
        mapUpdateFrame2	= 10;
        // A Gotcha - fixing references to objects that no longer exist. Truly ugly code.		
        for (loop2 = 0; loop2 < ships.length; loop2++)
          {          
          if (ships[loop2].gravityTarget == Body(spices[loop1]) )
            {
            ships[loop2].gravityTarget = null;
            ships[loop2].triggerReset(Ship.GRAVITY_SNAP_EVENT);
            }
          if (ships[loop2].repelTarget == Body(spices[loop1]) )
            {
            ships[loop2].repelTarget = null;  
            ships[loop2].triggerReset(Ship.REPEL_SNAP_EVENT);
            }          
          if (ships[loop2].tether.target == Body(spices[loop1]) )
            {
            ships[loop2].triggerReset(Ship.TETHER_SNAP_EVENT);	                                
            ships[loop2].tether.startRecoil();
            }   
            
          }
        // Remove this spice from storage.	
        spices[loop1] = spices[spices.length-1];
        spices.pop();	        
        }
      else
       loop1++;
    
    // Remove expired animations.
    loop1 = 0;
    while (loop1 < animations.length)
      if (animations[loop1].isExpired)
        {
        animations[loop1] = animations[animations.length-1];
        animations.pop();	
        }
      else
        loop1++;
    	
    }
  
  
  public function createNewAsteroids (deltaT : Number) : void
    {
    var loop1 : Number;
    
    // New asteroid creation:
    // Compute how much asteroid mass is currently on the map (in asteroids), or queued up (in new_asteroids).
    var massCounter:Number = 0.0;
    for (loop1 = 0; loop1 < asteroids.length; loop1++)
      massCounter += asteroids[loop1].mass;
    for (loop1 = 0; loop1 < new_asteroids.length; loop1++)
      massCounter += new_asteroids[loop1].mass;
    if (massCounter < asteroidTrigger)
      {
      // Create a new asteroids outside the border, have it drift into the map.	
      var a : Asteroid = new Asteroid();
      // Pick a random edge, normalized coordinate, and target position.
      var edge:Number = Math.round(Math.random()*4.0);
      if (edge == 4) 
        edge = 0;
      var targetx:Number = Math.random()*600+100;
      var targety:Number = Math.random()*400+100;
      var norm_coordinate:Number = Math.random();
      // Set initial position.
      switch (edge)
        {
        case 0: a.rx = norm_coordinate*600 + 100; a.ry = -a.collision_radius; break;
        case 1: a.rx = norm_coordinate*600 + 100; a.ry = 600+a.collision_radius; break;
        case 2: a.rx = -a.collision_radius; a.ry = norm_coordinate*400 + 100; break;
        case 3:	a.rx = 800+a.collision_radius; a.ry = norm_coordinate*400+100; break;        
        }
      // Compute direction to target position.
      var norm_x : Number = targetx - a.rx;
      var norm_y : Number = targety - a.ry;
      var norm_l : Number = Math.sqrt (norm_x*norm_x + norm_y*norm_y);
      norm_x /= norm_l;
      norm_y /= norm_l;      
      
      // Set initial veloicity.
      var v:Number = Math.random()*1.0 + 0.5; 
      a.vx = norm_x * v;
      a.vy = norm_y * v;            
      // Add asteroids to the "new" list. New asteroids are not eligible for any collision / tool interaction.
      new_asteroids.push(a);
      }
         
    // Update new_asteroids positions. The updatePositionOutSide() method ignores the boundary "bounceClip" routine.
    for (loop1=0; loop1 < new_asteroids.length; loop1++)         
      new_asteroids[loop1].updatePositionOutside(deltaT);
    
    // Promote new_asteroids into asteroids once they are completely in the domain.
    loop1 = 0;
    while (loop1 < new_asteroids.length)
      {      
      if (new_asteroids[loop1].rx > new_asteroids[loop1].collision_radius)
        if (new_asteroids[loop1].ry > new_asteroids[loop1].collision_radius)
          if (new_asteroids[loop1].rx < 800-new_asteroids[loop1].collision_radius)   
            if (new_asteroids[loop1].ry < 600-new_asteroids[loop1].collision_radius)
              {
              asteroids.push(new_asteroids[loop1]);
              new_asteroids[loop1] = new_asteroids[new_asteroids.length-1];
              new_asteroids.pop();              
              loop1--;    
              }
      loop1++;
      }                	
    }
  
  
  public function createNewSpice (deltaT : Number) : void
    {    
    
    // New spice creation:
    // Compute how much spice mass is currently on the map (in asteroids), or queued up (in new_spices).
    var massCounter : Number= 0.0;
    var loop1:Number;
    for (loop1 = 0; loop1 < spices.length; loop1++)
      massCounter += spices[loop1].mass;
    for (loop1 = 0; loop1 < new_spices.length; loop1++)
      massCounter += new_spices[loop1].mass;
    
    
    // New spice creation - selective positioning to aid the least wealthy player.
    if (massCounter < spiceTrigger)
      {    
      // Compute least wealthy player - player 0 is default in the event of a tie.
      var leastWealthyPlayer : Number = 0;    
      for (loop1 = 1; loop1 < 4; loop1++)
        if (homebases[loop1].score + shipspecs[loop1].careerEarnings < homebases[leastWealthyPlayer].score + shipspecs[leastWealthyPlayer].careerEarnings)
          leastWealthyPlayer = loop1;      
      // Which player is which again?
      // 0 - lower left.
      // 1 - lower right.
      // 2 - upper left.
      // 3 - upper right.
      
      // Cook up some spice.
      var s:Spice = new Spice();
      
      // Try to code this so you can handle all four cases in a data driven manner...
      // Y-position of the horizontal edge which is incident upon this players homebase.
      var horz_edge_y : Array = [600+s.collision_radius, 600+s.collision_radius, -s.collision_radius, -s.collision_radius];
      // X-position of this vertical edge which is incident upon this players homebase.
      var vert_edge_x : Array = [-s.collision_radius, 800+s.collision_radius, -s.collision_radius, 800+s.collision_radius];
      // Offset position of their 300x200 target zone.
      var targetzone_x : Array = [100, 400, 100, 400];
      var targetzone_y : Array = [300, 300, 100, 100];
            
      // Pick a vertical or horizontal edge randomly.
      if (Math.random() > 0.5)
        {
        // Drift in from horizontal edge.	
        s.rx = Math.random()*300 + targetzone_x[leastWealthyPlayer];
        s.ry = horz_edge_y[leastWealthyPlayer];        
        }
      else
        {
        // Drift in from vertical edge.	
        s.rx = vert_edge_x[leastWealthyPlayer];
        s.ry = Math.random()*200 + targetzone_y[leastWealthyPlayer];
        }
      // Pick a random position in the target zone.
      var targetx : Number = Math.random()*300+targetzone_x[leastWealthyPlayer];
      var targety : Number = Math.random()*200+targetzone_y[leastWealthyPlayer];
      // Compute direction to target position.
      var norm_x : Number = targetx - s.rx;
      var norm_y : Number = targety - s.ry;
      var norm_l : Number = Math.sqrt (norm_x*norm_x + norm_y*norm_y);
      norm_x /= norm_l;
      norm_y /= norm_l;      
      
      // Set initial veloicity.
      var v : Number = Math.random()*0.5 + 0.25; 
      s.vx = norm_x * v;
      s.vy = norm_y * v;            
      // Add spice to the "new" list. New asteroids are not eligible for any collision / tool interaction.
      new_spices.push(s);
      }
      
    // Old spice (ha) creation - random positioning.  
    /*  
    if (massCounter < spiceTrigger)
      {
      // Create a new spice outside the border, have it drift into the map.	
      var s : Spice = new Spice();
      // Pick a random edge, normalized coordinate, and target position.
      var edge : Number = Math.round(Math.random()*4.0);
      if (edge == 4) 
        edge = 0;
      var targetx : Number = Math.random()*600+100;
      var targety : Number = Math.random()*400+100;
      var norm_coordinate : Number = Math.random();
      // Set initial position.
      switch (edge)
        {
        case 0: s.rx = norm_coordinate*600 + 100; s.ry = -s.collision_radius; break;
        case 1: s.rx = norm_coordinate*600 + 100; s.ry = 600+s.collision_radius; break;
        case 2: s.rx = -s.collision_radius; s.ry = norm_coordinate*400 + 100; break;
        case 3:	s.rx = 800+s.collision_radius; s.ry = norm_coordinate*400+100; break;        
        }
      // Compute direction to target position.
      var norm_x : Number = targetx - s.rx;
      var norm_y : Number = targety - s.ry;
      var norm_l : Number = Math.sqrt (norm_x*norm_x + norm_y*norm_y);
      norm_x /= norm_l;
      norm_y /= norm_l;      
      
      // Set initial veloicity.
      var v : Number = Math.random()*0.5 + 0.25; 
      s.vx = norm_x * v;
      s.vy = norm_y * v;            
      // Add spice to the "new" list. New asteroids are not eligible for any collision / tool interaction.
      new_spices.push(s);
      }
    */
         
    // Update new_spices positions. The updatePositionOutSide() method ignores the boundary "bounceClip" routine.
    for (loop1=0; loop1 < new_spices.length; loop1++)         
      new_spices[loop1].updatePositionOutside(deltaT);
    
    // Promote new_spices into spices once they are completely in the domain.
    loop1 = 0;
    while (loop1 < new_spices.length)
      {      
      if (new_spices[loop1].rx > new_spices[loop1].collision_radius)
        if (new_spices[loop1].ry > new_spices[loop1].collision_radius)
          if (new_spices[loop1].rx < 800-new_spices[loop1].collision_radius)   
            if (new_spices[loop1].ry < 600-new_spices[loop1].collision_radius)
              {
              spices.push(new_spices[loop1]);
              new_spices[loop1] = new_spices[new_spices.length-1];
              new_spices.pop();              
              loop1--;    
              }
      loop1++;
      }            
    
    	
    }
  
  
  public function collisionCheck (b1:Particle, b2:Particle) : Boolean
    {    
    // Compute difference in positions.    
    var dx:Number = b2.rx - b1.rx;
    var dy:Number = b2.ry - b1.ry;
    var d:Number = Math.sqrt(dx*dx + dy*dy);    
    // Do the collision_radii of the two Bodies overlap?    
    return (d < b1.collision_radius + b2.collision_radius);    	
    }
  
  
  public function momentumExchangeInelastic (b1:Body, b2:Body) : void  
    {
    // Exchange momentum routine which is perfectly inelastic (objects adhere - b2 globs into b1)
    b1.vx = (b1.mass*b1.vx + b2.vx*b2.mass)/(b1.mass+b2.mass);
    b1.vy = (b1.mass*b1.vy + b2.vy*b2.mass)/(b1.mass+b2.mass);
    
    // Reposition at a weighted centroid of the two Bodies.
    var frac1:Number = b1.mass / (b1.mass+b2.mass);
    var frac2:Number = 1-frac1;
    b1.rx = frac1 * b1.rx + frac2 * b2.rx;
    b1.ry = frac1 * b1.ry + frac2 * b2.ry;
    }
  
  public function momentumExchangeReflection (b1:Body, b2_immobile:Body) : void
    {
    // Exchange momentum routine in which b2 is immobile and b1 just bounces off of it.     
    var dx:Number = b2_immobile.rx - b1.rx;
    var dy:Number = b2_immobile.ry - b1.ry;
    var d:Number = Math.sqrt(dx*dx + dy*dy);    
       
    // Compute f_hat vector (the "action" axis).    
    var fx:Number = dx / d;
    var fy:Number = dy / d;
    
    // Compute velocity projections onto f axis.
    var v1Tf:Number = b1.vx * fx + b1.vy * fy;	
    
    // Update velocity with a momentum kick.
    b1.vx = b1.vx - 2.0 * v1Tf * fx;
    b1.vy = b1.vy - 2.0 * v1Tf * fy;    
    
    // Restore tangency between the two Bodies so that they no longer collide.      
    b1.rx = b2_immobile.rx - fx*(b1.collision_radius + b2_immobile.collision_radius);
    b1.ry = b2_immobile.ry - fy*(b1.collision_radius + b2_immobile.collision_radius);        
    }
  
  public function momentumExchangeElastic (b1:Particle, b2:Particle) : Number
    {    
    // Exchange momentum routine which conserves kinetic energy. 
    var dx:Number = b2.rx - b1.rx;
    var dy:Number = b2.ry - b1.ry;
    var d:Number = Math.sqrt(dx*dx + dy*dy);    
       
    // Compute f_hat vector (the "action" axis).    
    var fx:Number = dx / d;
    var fy:Number = dy / d;
    
    // Compute velocity projections onto f axis.
    var v1Tf:Number = b1.vx * fx + b1.vy * fy;
    var v2Tf:Number = b2.vx * fx + b2.vy * fy;
    
    // Compute alpha - the exchange scalar for Body b1.
    var alpha:Number = 2.0 * (v1Tf - v2Tf);
    alpha = alpha / (1 + b1.mass / b2.mass);
    
    // Compute beta - the exchange scalar for Body b2.
    var beta:Number = b1.mass * alpha / b2.mass;
    
    // Update velocities with a momentum kick.
    b1.vx = b1.vx - alpha * fx;
    b1.vy = b1.vy - alpha * fy;
    
    b2.vx = b2.vx + beta * fx;
    b2.vy = b2.vy + beta * fy;
    
    // Restore tangency between the two Bodies so that they no longer collide.
    var excess_distance:Number = (b1.collision_radius + b2.collision_radius - d);      
    var frac1:Number = b2.mass / (b1.mass+b2.mass);
    var frac2:Number = 1-frac1;
      
    b1.rx = b1.rx - fx*excess_distance*frac1;
    b1.ry = b1.ry - fy*excess_distance*frac1;
      
    b2.rx = b2.rx + fx*excess_distance*frac2;
    b2.ry = b2.ry + fy*excess_distance*frac2;    
    
    // Return the exchanged momentum this will be used by the caller to determine whether or not an object should be destroyed.
    return b1.mass*alpha;    
    }    
    
  public function momentumExchangeAngular (b1:Body, b2:Body) : void
    // A totally fake routine to make spinning collisions look somewhat realistic.
    {
    var moment_ratio:Number = b2.moment/b1.moment;	
    b2.omega = (-b1.collision_radius * b1.omega + b1.collision_radius*b2.omega*moment_ratio) / 
               (b1.collision_radius * moment_ratio + b2.collision_radius) + Math.random()*0.1 - 0.05;
    b1.omega = -b2.omega * b2.collision_radius / b1.collision_radius;    
    }
  
  
  public function reticleSearch() : void
    {
    // Search over all four ships reticles and assign their tooltips.	    
    for (var r:Number = 0; r < 4; r++)   
      if ( ships[r].reticleLockingOn )  
        ships[r].reticle.setSticky (findBody(ships[r].reticle.rx, ships[r].reticle.ry,ships[r].reticle.radius ));      
    }
  
  public function findBeamBody(x:Number, y:Number, r:Number) : Body
    {
    var bestBody : Body = null;
    var best_d : Number = -1;  // Sentinel value - no best body selected yet.    
    
    // Search through the Arrays to find the object under this (x,y) position.	
    var foundBody : Body;
    var dx:Number;
    var dy:Number;
    var d:Number;
             
    // Search through asteroids Array.
    for (var a:Number = 0; a < asteroids.length; a++)
      {
      foundBody = asteroids[a];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }            
      }
    
    // Search through asteroids Array.
    for (var an:Number = 0; an < anchors.length; an++)
      {
      foundBody = anchors[an];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }            
      }
          
    // Search through homebases Array.
    for (var hb:Number = 0; hb < homebases.length; hb++)
      {
      foundBody = homebases[hb];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }    
      }
    
    // Search through ships Array.
    for (var sh:Number = 0; sh < ships.length; sh++)
      {
      foundBody = ships[sh];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }    
      }
    
          
    // Search through spices Array.
    var bestBodyWasSpice : Boolean = false;
    for (var s:Number = 0; s < spices.length; s++)
      {
      foundBody = spices[s];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        bestBodyWasSpice = true;
        }    
      } 
    
    if (bestBodyWasSpice)
      {
      Utility.playSound (new Assets.Buzz() );
      return null;
      }      
     
    if (bestBody == null)
      return null;
                
    if (best_d < bestBody.collision_radius+r)               
      return bestBody;      
    else    
      return null;
    
    	
    }
    
  public function findBody(x:Number, y:Number, r:Number) : Body
    {    
    var bestBody : Body = null;
    var best_d : Number = -1;  // Sentinel value - no best body selected yet.    
    
    // Search through the Arrays to find the object under this (x,y) position.	
    var foundBody : Body;
    var dx:Number;
    var dy:Number;
    var d:Number;
             
    // Search through asteroids Array.
    for (var a:Number = 0; a < asteroids.length; a++)
      {
      foundBody = asteroids[a];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }            
      }
    
    
    // Search through anchors Array.
    for (var an:Number = 0; an < anchors.length; an++)
      {
      foundBody = anchors[an];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }            
      }
    
    // Search through spices Array.
    for (var s:Number = 0; s < spices.length; s++)
      {
      foundBody = spices[s];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }    
      } 
    
    // Search through homebases Array.
    for (var hb:Number = 0; hb < homebases.length; hb++)
      {
      foundBody = homebases[hb];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }    
      }
    
    // Search through ships Array.
    for (var sh:Number = 0; sh < ships.length; sh++)
      {
      foundBody = ships[sh];	
      dx = foundBody.rx - x;
      dy = foundBody.ry - y;
      d = Math.sqrt(dx*dx + dy*dy);    	
      if (best_d == -1 || d < best_d)
        {
        bestBody = foundBody;
        best_d = d;
        }    
      }
     
    if (bestBody == null)
      return null;
                
    if (best_d < bestBody.collision_radius+r)               
      return bestBody;      
    else    
      return null;
    }
  
  
  public function initializeMap () : void
    // Generates the navigation map for cpu players. This routine rebuilds the whole map from scratch.
    {        
    var i:Number;    
    map = new NavigationMap;
    // Initialize the triangulation with the convex hull - conveniently defined by the homebases.
    map.triangles.push (new Triangle(homebases[2], homebases[1], homebases[0]) );
    map.triangles[0].computeAngles();
    map.triangles[0].ID = 0;
    map.triangles.push (new Triangle(homebases[1], homebases[2], homebases[3]) );
    map.triangles[1].computeAngles();
    map.triangles[1].ID = 1;    

    var e:Edge;
    
    e = new Edge(homebases[1], homebases[2]);
    e.Tleft = map.triangles[0];
    e.Tright = map.triangles[1];
    map.edges.push(e);
    
    e = new Edge(homebases[1],homebases[0]);
    e.Tleft = null;
    e.Tright = map.triangles[0];
    map.edges.push(e);
    
    e = new Edge(homebases[1], homebases[3]);
    e.Tleft = map.triangles[1];
    e.Tright = null;
    map.edges.push(e);
    
    e = new Edge(homebases[3],homebases[2]);
    e.Tleft = map.triangles[1];
    e.Tright = null;
    map.edges.push(e);
    
    e = new Edge(homebases[2], homebases[0]);
    e.Tleft = map.triangles[0];
    e.Tright = null; 
    map.edges.push(e);
    
    for (i=0; i < map.edges.length; i++)
      map.edges[i].ID = i;
    
    map.triangles[0].edgeAB = map.edges[0];
    map.triangles[0].edgeBC = map.edges[1];
    map.triangles[0].edgeCA = map.edges[4];    
    
    map.triangles[1].edgeAB = map.edges[0];
    map.triangles[1].edgeBC = map.edges[3];
    map.triangles[1].edgeCA = map.edges[2];        
    // Add asteroids to NavigationMap
    
    
    for (i=0; i < dummyNodes.length; i++)
      map.insert (dummyNodes[i]);
    
     
    for (i=0; i < asteroids.length; i++)
      map.insert (asteroids[i]);
    
    for (i=0; i < anchors.length; i++)
      map.insert (anchors[i]);
    
    map.computeAngles();
    map.cleanUp();           
    map.makeDualGraph();            
    }
  
      
  public function asteroidSplit (a : Asteroid, aSecondPointToGeneratePerturbationAxis : Body ) : Boolean
    // Cut this asteroid into two new asteroids. But don't split asteroids that are below a certain size cutoff
    // Boolean return value indicates whether or not new asteroids were spawned. (true = new asteroids were made)
    {
    var madeNewAsteroids:Boolean = false;
    
    if (a.mass / 2 > 5.0)
      {
      madeNewAsteroids = true;
      	
      // Create new asteroids.	
      var a1:Asteroid = new Asteroid();
      var a2:Asteroid = new Asteroid();
      
      // The mass is split randomly - a1 gets 30%-70% of the mass and a2 gets the rest.
      a1.setMass(a.mass * (Math.random()*0.4 + 0.3 ) );
      a2.setMass(a.mass - a1.mass );     
      a1.draw();
      a2.draw();
      
      // Set new asteroid positions.
      a1.rx = a.rx;  
      a1.ry = a.ry;
      
      a2.rx = a.rx;  
      a2.ry = a.ry;
      
      // Set new asteroid velocities.
      a1.vx = a.vx; 
      a1.vy = a.vy;
      
      a2.vx = a.vx; 
      a2.vy = a.vy;
      
      // Add some random perturbation to the new asteroids velocities (momenta). Make sure system momentum is conserved on breakup.      
      // Compute unit vector along perturbation axis.
      var action_nx:Number = a.rx - aSecondPointToGeneratePerturbationAxis.rx;
      var action_ny:Number = a.ry - aSecondPointToGeneratePerturbationAxis.ry;
      var action_norm:Number = Math.sqrt(action_nx*action_nx + action_ny*action_ny);
      // Perturb is ORTHOGONAL to action.
      var perturb_nx:Number = action_ny / action_norm;
      var perturb_ny:Number = -action_nx / action_norm;
      
      // Perturbation magnitude - some fraction of the splitted asteroid's velocity.
      var perturb_mag:Number = (Math.random()*0.4+0.2)*Math.sqrt(a.vx*a.vx + a.vy*a.vy);      
      
      a1.vx = a1.vx + perturb_nx * perturb_mag;
      a1.vy = a1.vy + perturb_ny * perturb_mag;
      
      a2.vx = a2.vx - perturb_nx * perturb_mag * a1.mass / a2.mass;
      a2.vy = a2.vy - perturb_ny * perturb_mag * a1.mass / a2.mass;
      
                              
      // Set the new asteroids to tangency position. Separate the asteroids along the axis defined by perturb_direction.                   
      a1.rx = a1.rx + perturb_nx*a1.collision_radius*1.01;
      a1.ry = a1.ry + perturb_ny*a1.collision_radius*1.01;
      
      a2.rx = a2.rx - perturb_nx*a2.collision_radius*1.01;
      a2.ry = a2.ry - perturb_ny*a2.collision_radius*1.01;
                      
      // Add asteroids into container.
      asteroids.push(a1);
      asteroids.push(a2);
      }        
    
    // Make an explosion here.
    var e : Explosion = new Explosion(Screen.midground);
    e.radius = a.collision_radius*3;
    e.rx = a.rx;
    e.ry = a.ry;
    animations.push(e);
    Utility.playSound (new Assets.AstExplode() );
    
    // Get rid of this split asteroid.  
    a.expire(); 
    return madeNewAsteroids;
    }
  
  
  public function findBodies (center:Ship, radius:Number) : Array
    // Find all objects with this circle. Called by CPUships to give them a neighborhood of "interactables".
    // Spice is NOT added to this list, so they will not use their gravity / repel beams on spice. They will,
    // however, tether it once they get close. CPUships do not keep global vision of spice - they pick one and
    // chase it.
    {
    var list:Array = new Array;
    var L:Number;
    // Add asteroids.
    for (var a:Number=0; a < asteroids.length; a++)    
      {
      L = (asteroids[a].rx - center.rx)*(asteroids[a].rx - center.rx) + (asteroids[a].ry - center.ry)*(asteroids[a].ry - center.ry);
      L = Math.sqrt(L);
      if (L < radius)
        list.push(asteroids[a]);
      }
    
    // Add anchors.
    for (var an:Number=0; an < anchors.length; an++)    
      {
      L = (anchors[an].rx - center.rx)*(anchors[an].rx - center.rx) + (anchors[an].ry - center.ry)*(anchors[an].ry - center.ry);
      L = Math.sqrt(L);
      if (L < radius)
        list.push(anchors[an]);
      }  
      
    // Add homebases.
    for (var hb:Number=0; hb < homebases.length; hb++)    
      {
      L = (homebases[hb].rx - center.rx)*(homebases[hb].rx - center.rx) + (homebases[hb].ry - center.ry)*(homebases[hb].ry - center.ry);
      L = Math.sqrt(L);
      if (L < radius)
        list.push(homebases[hb]);
      }    
      
    // Add ships.
    for (var sh:Number=0; sh < ships.length; sh++)    
      {
      L = (ships[sh].rx - center.rx)*(ships[sh].rx - center.rx) + (ships[sh].ry - center.ry)*(ships[sh].ry - center.ry);
      L = Math.sqrt(L);
      // Don't add ships on my team to my list - don't want to mess up their actions.
      if (L < radius &&  ships[sh].spec.teamCode != center.spec.teamCode)
        list.push(ships[sh]);
      }   
      
    return list;	
    }
  
  public function expire() : void
    // Releases EVERYTHING in the game by calling expire on all of them.
    {
    var loop:Number;
    // Asteroids.
    for (loop = 0; loop < asteroids.length; loop++)
      asteroids[loop].expire();
    // New_asteroids  
    for (loop = 0; loop < new_asteroids.length; loop++)
      new_asteroids[loop].expire();
      
    // Anchors.
    for (loop = 0; loop < anchors.length; loop++)
      anchors[loop].expire();  
      
    // Spices.  
    for (loop = 0; loop < spices.length; loop++)
      spices[loop].expire();
    // New_spices
    for (loop = 0; loop < new_spices.length; loop++)
      new_spices[loop].expire();  
      
    // Homebases.
    for (loop = 0; loop < homebases.length; loop++)
      homebases[loop].expire();
    // Animations.
    for (loop = 0; loop < animations.length; loop++)
      animations[loop].expire();      
    // Score loopers.
    for (loop = 0; loop < scoreLoopers.length; loop++)
      scoreLoopers[loop].expire();      
    // Reticles, tethers and ships.
    for (loop = 0; loop < ships.length; loop++)
      {
      ships[loop].reticle.expire();
      ships[loop].tether.expire();
      ships[loop].expire();
      }
    
    // Release controller handlers.
    controls.expire();
    
    // Hide gameclock.
    gameClock.expire();
    fpsDisplay.expire();
    
    // Clear hud and midground planes - procedural art is drawn here.
    Screen.hud.graphics.clear();    
    Screen.midground.graphics.clear();  
    
    
    // Remove background image.
    if (bg != null)
      Screen.background.removeChild(bg);

    // Update bonusDatas rawScore field with the earnings from this round.   
    for (loop = 0; loop < 4; loop++)
      bonusDatas[loop].rawScore = homebases[loop].score;         
               
    // Mark this environment as expired - this is visible from main, and will be a cue to instantiate a new garage, etc.
    isExpired = true;
    }
    
  }
  
} // end of package.