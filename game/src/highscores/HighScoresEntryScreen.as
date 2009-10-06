package highscores
{

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import legacy.ControlEvent;
import legacy.PlayerControlListener;

import com.pixeldroid.r_c4d3.scores.RemoteHighScores;

import highscores.HighScores;
import highscores.HighScoresPanel;
import highscores.HighScoresAI;
import highscores.HighScoresMovementTimer;

import FPSDisplay;
import Drawable;
import IDrawable;
import GameClock;
import Debouncer;

import Assets;

public class HighScoresEntryScreen extends PlayerControlListener // which extends Sprite
                                   implements IDrawable
  {
  public var expired : Boolean;
  
  private var graphicsLayer : Sprite;
  private var reticleSprites : Array;
  //private var controls : HighScoresControls;
  
  private var panels : Array;
  private var initialsFields : Array;
  
  private var xCoords : Array;
  private var yCoords : Array;
  private var xTimers : Array;
  private var yTimers : Array;
  
  private var fpsDisplay : FPSDisplay;
  private var gameClock : GameClock;
  
  private const poolX : uint = 75;
  private const poolY : uint = 225;
  private const xSpacing : uint = 68;
  private const ySpacing : uint = 68;
  private const reticleRadius : uint = 26;
  
  private static const keypad : Array = 
  [ ["A","B","C","D","E","F","G","H","I"],
    ["J","K","L","M","N","O","P","Q","R"],
    ["S","T","U","V","W","X","Y","Z","0"],
    ["1","2","3","4","5","6","7","8","9"],
    [".","$","?","!","%","SPC","DEL","CLR","DONE"]
  ];
  
  private static var letters : Array; // Array of arrays of TextFields
  public var winningScores : Array; // Array of ScoreLisings
  private var lastTime : Number;
  private var debouncer : Debouncer;
  
  public function HighScoresEntryScreen(shipSpecs:Array)
    {
    var i : int;
    var j : int;
    
    fpsDisplay = new FPSDisplay();
    gameClock = new GameClock(120,400,5,0.61,0.61);
    debouncer = new Debouncer();
    
    graphicsLayer = new Sprite();
    reticleSprites = new Array(4);
    for ( i = 0; i < 4; i++ )
      reticleSprites[i] = new Sprite();
    
    var date : Date = new Date();
    lastTime = date.getTime();
    
    /*
    // use this code if starting in the high score entry state (for debug purposes)
    for ( i = 0; i < 4; i++ )
      shipSpecs[i].careerEarnings = (3-i) * 1001;
    
    shipSpecs[1].teamCode = ShipSpec.YELLOW_TEAM;
    shipSpecs[1].isCPUControlled = true;
    
    shipSpecs[0].isCPUControlled = false;
    shipSpecs[2].isCPUControlled = false;
    shipSpecs[3].isCPUControlled = false;
    // end bootstrap code
    */
    
    var teamScores : Array = new Array(4);  // how much money did this team make, combined?    
    var scoreListing : ScoreListing;
    
    // Sum ship earnings into team earnings.
    for (i = 0; i < 4; i++)
      {
      for ( j = 0; j < i; j++ )
        if ( shipSpecs[i].teamCode == shipSpecs[j].teamCode )
          {
          // make sure the scoreListings are identical.
          scoreListing = teamScores[j];
          scoreListing.teamSize++;
          }
      
      if ( scoreListing == null )
        {
        scoreListing = new ScoreListing;
        scoreListing.playerIDs = new Array(0);
        scoreListing.score = 0;
        scoreListing.teamSize = 1;
        }
      
      scoreListing.playerIDs.push( i );
      scoreListing.score += shipSpecs[i].careerEarnings;
      teamScores[i] = scoreListing;
      //trace( "scoreListing.initials = "+scoreListing.initials );
      scoreListing = null;
      }
    
    var sortedScores : Array = new Array(0);
    winningScores = new Array(0);
    var winners : Array = new Array(4);
    for ( i = 0; i < 4; i++ )
      winners[i] = false;
    
    for ( i = 0; i < 4; i++ )
      {
      // skip over duplicates... the elements of sortedScores are unique
      var cont : Boolean = false;
      for ( j = 0; j < i; j++ )
        if ( teamScores[i] == teamScores[j] )
          cont = true;
      if ( cont )
        continue;
      
      // check for validity, and if valid add it to the sortedScores list
      // Only potential candidates for high score'edness are permitted in sortedScores.  
      if ( teamScores[i].score > -1 && teamScores[i].teamSize > 0 )
        sortedScores.push( teamScores[i] );
      }
    
    HighScores.sortScores(sortedScores);
    
    // Now sortedScores[0] is the highest score, [1] the second highest, and so on.
    // Start with the highest score, see if it makes it into the high scores.  
    // If it does, leave it there and try the next.
    // Otherwise, leave the original array alone and try the next.  
    // This handles the case where there are multiple high scoring people
    //   and the lower scoring person gets checked first and makes it,
    //   even though they shouldn't when the higher scores are taken into
    //   consideration.  
    for ( i = 0; i < sortedScores.length; i++ )
      {
      scoreListing = sortedScores[i];
      var originalScores : Array = HighScores.scoreArrayArray[scoreListing.teamSize-1];
      var potentialScores : Array = new Array(originalScores.length);
      
      for ( j = 0; j < originalScores.length; j++ )
        potentialScores[j] = originalScores[j];
      
      potentialScores.push( scoreListing );
      HighScores.sortScores(potentialScores);
      potentialScores.length--;
      if ( HighScores.cmpScoreArrays( potentialScores, originalScores ) )
        continue;
      
      //trace("ScoreArrayArray before: ");
      //traceScores(HighScores.scoreArrayArray[scoreListing.teamSize-1]);
      HighScores.scoreArrayArray[scoreListing.teamSize-1] = potentialScores;
      //trace("ScoreArrayArray after: ");
      //traceScores(HighScores.scoreArrayArray[scoreListing.teamSize-1]);
      
      for ( j = 0; j < scoreListing.playerIDs.length; j++ )
        {
        winners[scoreListing.playerIDs[j]] = true;
        winningScores.push(scoreListing);
        }
      }
    
    //trace("The winning scores are: ");
    //trace(traceScores(winningScores));
    
    // storing scores is done, now for panels
    panels = new Array(4);
    for ( i = 0; i < 4; i++ )
      panels[i] = new HighScoresPanel( shipSpecs[i], teamScores[i], winners[i] );
    
    xCoords = new Array(4);
    yCoords = new Array(4);
    
    // far left
    panels[2].x = 0;
    
    // left
    panels[0].x = 200;
    
    // right
    panels[1].x = 400;
    
    // far right
    panels[3].x = 600;
    
    // lower left
    xCoords[0] = 0;
    yCoords[0] = keypad.length - 1;
    
    // lower right
    xCoords[1] = keypad[keypad.length - 1].length - 1;
    yCoords[1] = keypad.length - 1;
    
    // upper left
    xCoords[2] = 0;
    yCoords[2] = 0;
    
    // upper right
    xCoords[3] = keypad[0].length - 1;
    yCoords[3] = 0;
    
    xTimers = new Array(4);
    yTimers = new Array(4);
    for ( i = 0; i < 4; i++ )
      {
      xTimers[i] = new HighScoresMovementTimer();
      yTimers[i] = new HighScoresMovementTimer();
      }
    
    //addEventListener(Event.ENTER_FRAME, onEnterFrame);
    
    // Let's make some robot names.  
    var aiNames : Array = new Array(4);
    for ( i = 0; i < 4; i++ )
      {
      var foundUnique : Boolean = false;
      
      while ( !foundUnique )
        {
        aiNames[i] = generateRobotName();
        
        if ( i > 0 )
          {
          for ( j = 0; j < i; j++ )
            {
            trace( "My name is "+aiNames[i] );
            trace( "His name is "+aiNames[j] );
            if ( aiNames[i] != aiNames[j] )
              {
              foundUnique = true;
              break;
              }
            }
          }
        else
          foundUnique = true;
        
        } // while ( !foundUnique )
      }
    
    // Now that we have some playthrough-unique AI names, have the AI enter them.  
    for ( i = 0; i < 4; i++ )
      {
      if ( panels[i].shipSpec.isCPUControlled )
        {
        if ( panels[i].highScore )
          var ai : HighScoresAI = new HighScoresAI( aiNames[i], i, xCoords[i], yCoords[i],
                                                  keypad, panels[i], xPress, yPress );
        else
          panels[i].enterSelection("DONE");
        }
      }
    
    drawOnce();
    Screen.queueDraw(this);
    }
  
  // This assumes 8 character names
  public static function generateRobotName() : String
    {
    var char1 : String;
    var char2 : String;
    var char3 : String;
    var char4 : String;
    
    const max : int = 6;
    var random : int = Math.random() * max;
    if ( random == max )
      random = 0;
    
    switch( random )
      {
      case 0:
        char1 = "R";
        char2 = "A";
        char3 = "C";
        char4 = randomDigit();
        break;
      case 1:
        char1 = "C";
        char2 = randomDigit();
        char3 = "J";
        char4 = randomDigit();
        break;
      case 2:
        char1 = "D";
        char2 = randomDigit();
        char3 = "G";
        char4 = randomDigit();
        break;
      case 3:
        char1 = "H";
        char2 = randomDigit();
        char3 = "C";
        char4 = randomDigit();
        break;
      case 4:
        char1 = "J";
        char2 = randomDigit();
        char3 = "P";
        char4 = randomDigit();
        break;
      case 5:
        char1 = "J";
        char2 = randomDigit();
        char3 = "L";
        char4 = randomDigit();
        break;
      }
    
    return "CPU "+char1+char2+char3+char4;
    }
  
  private static function randomDigit() : String
    {
    var integer : int = Math.random() * 10;
    if ( integer == 10 ) // extremely small edge case
      integer = 0;
    return ""+integer;
    }
  
  private static var phi : Number = 0;
  
  public function update() : void
    {
    var i : int;
    var j : int;
    
    fpsDisplay.update();    
    var deltaT : Number = 25.0 / fpsDisplay.FPS;
    gameClock.update(deltaT);
    
    if ( gameClock.clockIsZero() )
      for ( i = 0; i < 4; i++ )
        panels[i].done = true; // force everyone to be done
    
    var graphics : Graphics = graphicsLayer.graphics;
    graphics.clear();
    
    var date : Date = new Date();
    var time : Number = date.getTime();
    var timeDelta : Number = time - lastTime;
    lastTime = time;
    
    // update any changes that may have happened in the panels
    for ( i = 0; i < 4; i++ )
      panels[i].update();
    
    // draw selectors
    for ( i = 0; i < 4; i++ )
      {
      // if he/she/it is a loser, don't draw the reticle
      if ( !panels[i].highScore )
        continue;
      //
      
      var spec : ShipSpec = panels[i].shipSpec;
      
      reticleSprites[i].x = gridToScreenX(xCoords[i])+35;
      reticleSprites[i].y = gridToScreenY(yCoords[i])+13;
      
      var omega : Number = 0.05 + 0.05 * (spec.reticleLevel/10);
      
      // Spin
      phi += Math.PI*timeDelta/2400;
      
      ReticleGraphics.draw (panels[i].shipSpec, reticleSprites[i], phi, reticleRadius, 0, false);
      }
    
    // check to see if everyone is a loser, if that's the case then everyone has to press done to get by.  
    // This is done to make sure everyone gets to see that they are, indeed, losers.  
    var allLosers : Boolean = true;
    for ( i = 0; i < 4; i++ )
      if ( panels[i].highScore )
        allLosers = false;
    
    // check to see if we are done
    var done : Boolean = true;
    if ( allLosers )
      {
      for ( i = 0; i < 4; i++ )
        if ( !panels[i].done )
          done = false;
      }
    else
      {
      for ( i = 0; i < 4; i++ )
        // the && highScore makes it so people who didn't win don't have to press done
        if ( !panels[i].done && panels[i].highScore ) 
          done = false;
      }
    
    expired = done;
    
    
    if ( expired )
      expire();
    }
  
  public function drawOnce() : void
    {
    // first let's draw the top 4 boxes.  This code should reduce when some artwork comes in.
    initialsFields = new Array(4);
    
    // background
    addChild( new Assets.HighScoresBackground );
    
    var i : int;
    
    // midground
    for ( i = 0; i < 4; i++ )
      addChild( panels[i] );
    
    // now draw the field of letters
    var x : int;
    var y : int;
    var format : TextFormat = new TextFormat();
    format.font = "text";
    format.align = "center";
    format.bold = true;
    format.color = 0xffffff;
    format.size = 24;
    var specialFormat : TextFormat = new TextFormat();
    specialFormat.font = "text";
    specialFormat.align = "center";
    specialFormat.bold = true;
    specialFormat.color = 0xffffff;
    specialFormat.size = 17;
    letters = new Array(keypad.length);
    for ( y = 0; y < keypad.length; y++ )
      {
      letters[y] = new Array(keypad[y].length);
      for ( x = 0; x < keypad[y].length; x++ )
        {
        var tf : TextField = new TextField();
        tf.text = keypad[y][x];
        tf.embedFonts = true;
        tf.x = poolX + x * xSpacing;
        tf.y = poolY + y * ySpacing;
        tf.width = xSpacing;
        tf.height = ySpacing;
        if ( tf.text == "DONE" || tf.text == "SPC" || tf.text == "DEL" || tf.text == "CLR" )
          {
          tf.y += 4;
          tf.setTextFormat(specialFormat);
          }
        else
          tf.setTextFormat(format);
        addChild(tf);
        letters[y][x] = tf;
        }
      }
    
    // foreground
    addChild( graphicsLayer );
    
    // hud
    for ( i = 0; i < 4; i++ )
      addChild( reticleSprites[i] );
    
    } // function drawOnce()
    
  // IDrawable implementation
  public function isVisible() : Boolean { return true; }
  public function getLayer() : uint { return Drawable.background; }
  public function draw( backbuffer : BitmapData ) : void
    {
    backbuffer.draw(this,this.transform.matrix,this.transform.colorTransform,
                    null,null,true);
    }
  // End IDrawable implementation.
  
  private function gridToScreenX( input : int ) : int
    {
    return poolX + input * xSpacing;
    }
  
  private function gridToScreenY( input : int ) : int
    {
    return poolY + input * ySpacing;
    }
  
  // use the below two lines to make the attract loop go faster.
  //private var pindex : int = 0;
  //protected override function Xr(e:ControlEvent) : void { panels[pindex % 4].donePress(); pindex++; }
  protected override function Xr(e:ControlEvent) : void { panels[e.playerIndex].donePress(); }
  protected override function Br(e:ControlEvent) : void { panels[e.playerIndex].deletePress(); }
  protected override function Cr(e:ControlEvent) : void { panels[e.playerIndex].deletePress(); }
  protected override function Ar(e:ControlEvent) : void { enterSelection( e.playerIndex ); }
  
  protected override function Rp(e:ControlEvent):void { xPlayerPress(  1, e.playerIndex ); }
  protected override function Rr(e:ControlEvent):void { xRelease    (  1, e.playerIndex ); }
  protected override function Up(e:ControlEvent):void { yPlayerPress( -1, e.playerIndex ); }
  protected override function Ur(e:ControlEvent):void { yRelease    ( -1, e.playerIndex ); }
  protected override function Lp(e:ControlEvent):void { xPlayerPress( -1, e.playerIndex ); }
  protected override function Lr(e:ControlEvent):void { xRelease    ( -1, e.playerIndex ); }
  protected override function Dp(e:ControlEvent):void { yPlayerPress(  1, e.playerIndex ); }
  protected override function Dr(e:ControlEvent):void { yRelease    (  1, e.playerIndex ); }
  
  private function enterSelection( player : uint ) : void
    {
    panels[player].enterSelection(keypad[yCoords[player]][xCoords[player]]);
    }
  
  private function xPlayerPress( direction : int, player : uint ) : void
    {
    if(!debouncer.debounced())
      return;
    else
      debouncer.setLastEventTime();
    
    if ( !panels[player].shipSpec.isCPUControlled )
      xPress( direction, player );
    }
  
  // returns the resultant x position
  private function xPress( direction : int, player : uint ) : int
    {
    if ( direction > 0 )
      incrementXCoord(player);
    else
      decrementXCoord(player);
    
    if ( !panels[player].shipSpec.isCPUControlled )
      {
      if ( direction > 0 )
        xTimers[player].callback = incrementXCoord;
      else
        xTimers[player].callback = decrementXCoord;
        
      xTimers[player].player = player;
      xTimers[player].start();
      }
    
    panels[player].onSelectionChange(keypad[yCoords[player]][xCoords[player]]);
    
    return xCoords[player];
    }
  
  private function yPlayerPress( direction : int, player : uint ) : void
    {
    if(!debouncer.debounced())
      return;
    else
      debouncer.setLastEventTime();
    
    if ( !panels[player].shipSpec.isCPUControlled )
      yPress( direction, player );
    }
  
  // returns the resultant y position
  private function yPress( direction : int, player : uint ) : int
    {
    if ( direction > 0 )
      incrementYCoord(player);
    else
      decrementYCoord(player);
    
    if ( !panels[player].shipSpec.isCPUControlled )
      {
      if ( direction > 0 )
        yTimers[player].callback = incrementYCoord;
      else
        yTimers[player].callback = decrementYCoord;
      
      yTimers[player].player = player;
      yTimers[player].start();
      }
    
    panels[player].onSelectionChange(keypad[yCoords[player]][xCoords[player]]);
    
    return yCoords[player];
    }
  
  private function xRelease( direction : int, player : uint ) : void
    {
    if ( !panels[player].shipSpec.isCPUControlled )
      xTimers[player].stop();
    }
  
  private function yRelease( direction : int, player : uint ) : void
    {
    if ( !panels[player].shipSpec.isCPUControlled )
      yTimers[player].stop();
    }
  
  private function incrementXCoord( player : uint ) : void
    {
    xCoords[player]++;
    
    if ( xCoords[player] >= keypad[yCoords[player]].length )
      xCoords[player] = 0;
    }
  
  private function decrementXCoord( player : uint ) : void
    {
    xCoords[player]--;
    
    if ( xCoords[player] < 0 )
      xCoords[player] = keypad[yCoords[player]].length - 1;
    }
  
  private function incrementYCoord( player : uint ) : void
    {
    yCoords[player]++;
    
    if ( yCoords[player] >= keypad.length )
      yCoords[player] = 0;
    }
  
  private function decrementYCoord( player : uint ) : void
    {
    yCoords[player]--;
    
    if ( yCoords[player] < 0 )
      yCoords[player] = keypad.length - 1;
    }
  
  public function expire() : void
    {
    var i : int;
    var j : int;
    
    expired = true;
    
    // Make sure the initials get entered correctly.  
    for ( i = 0; i < winningScores.length; i++ )
      {
      var hsp : HighScoresPanel = panels[ winningScores[i].playerIDs[0] ];
      winningScores[i].initials = hsp.initials.slice( 0, hsp.initials.length - 1 );
      for ( j = 1; j < winningScores[i].playerIDs.length; j++ )
        {
        hsp = panels[ winningScores[i].playerIDs[j] ];
        winningScores[i].initials += ", "+hsp.initials.slice( 0, hsp.initials.length - 1 );
        }
      }
    
  
    // Now modify the remote server's data.  
    for ( i = 0; i < 4; i++ )
      {
      var arr : Array = HighScores.scoreArrayArray[i];
      
      //trace("final ScoreArrayArray: ");
      //traceScores(arr);
      
      for ( j = 0; j < HighScores.numScoresStored; j++ )
        HighScores.RMH[i].insert( arr[j].score, arr[j].initials );
      
      HighScores.RMH[i].store();
      }
    
    // release the input control
    disconnect();
    
    // free screen resources  
    gameClock.expire();
    Screen.queueRemove(this);
    Screen.reset();
    }
  
  private function traceScores(scores : Array) : void
    {
    var i : int;
    var j : int;
    
    trace( "[" );
    for ( i = 0; i < scores.length; i++ )
      {
      var listing : ScoreListing = scores[i];
      trace("  {"+listing.teamSize+", "+listing.score+", "+listing.initials+"},");
      }
    trace( "]" );
    }
  } // class HighScores

}