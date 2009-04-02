package highscores
{

import ShipSpec;
import Utility;
import GlamourShot;
import Assets;
import Screen;

import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.events.Event;

public class HighScoresPanel extends Sprite
  {
  private static const scoreDescriptY : int = 25;
  private static const scoreAmountY : int = 29;
  private static const scoreCenter : int = 140;
  private static const pleaseEnterY : int = 80;
  private static const initialsY : int = 110;
  private static const initialsX : int = 55;
  private static const initialsWidth : int = 110;
  private static const infoY : int = 160;
  
  public var shipSpec : ShipSpec;
  public var scoreListing : ScoreListing;
  public var done : Boolean;
  public var highScore : Boolean;
  
  public function get initials() : String { return initialsText.text; }
  public function set initials(value:String) : void
    {
    initialsText.text = value;
    initialsText.setTextFormat(initialsFormat);
    }
  
  public function get infoText() : String { return infoTextField.text; }
  public function set infoText(value:String) : void
    {
    infoTextField.text = value;
    infoTextField.setTextFormat(infoTextFormat);
    }
  
  private var infoTextField : TextField; // displays whether you win/lose/are done
  private var pleaseEnterText : TextField; // displays the "Please enter your name:" text
  private var scoreDescriptText : TextField;
  private var scoreAmountText : TextField;
  private var initialsText : TextField;
  //private var letterFields : Array;
  private var startTime : Number;
  private var infoTextFormat : TextFormat; // displays whether you win/lose/are done
  private var pleaseEnterFormat : TextFormat; // displays the "Please enter your name:" text
  private var scoreDescriptFormat : TextFormat; // Career Earnings: \n Team Total:
  private var initialsFormat : TextFormat;
  private var numberFormat : TextFormat; // ends up to the right of Career Earnings: \n Team Total:
  private var cursor : String = " ";
  private var cursorPositive : String = "_";
  
  private static const winText : String = "Congratulations!\nYou have a high score!";
  private static const loseText : String = "Your score did not make it\n into the high scores board.";
  private static const doneText : String = "Done!";
  
  public function HighScoresPanel( _shipSpec : ShipSpec, _scoreListing : ScoreListing, _highScore : Boolean )
    {
    var i : int;
    
    pleaseEnterFormat = new TextFormat();
    pleaseEnterFormat.font = "text";
    pleaseEnterFormat.align = "center";
    pleaseEnterFormat.size = 14;
    pleaseEnterFormat.color = 0xffffff;
    pleaseEnterFormat.bold = false;
    
    scoreDescriptFormat = new TextFormat();
    scoreDescriptFormat.font = "text";
    scoreDescriptFormat.align = "right";
    scoreDescriptFormat.size = 16;
    scoreDescriptFormat.color = 0xffffff;
    scoreDescriptFormat.bold = false;
    
    infoTextFormat = new TextFormat();
    infoTextFormat.font = "text";
    infoTextFormat.align = "center";
    infoTextFormat.size = 14;
    infoTextFormat.color = 0xffffff;
    infoTextFormat.bold = true;
    
    initialsFormat = new TextFormat();
    initialsFormat.font = "text";
    initialsFormat.align = "left";
    initialsFormat.size = 14;
    initialsFormat.color = 0xffffff;
    initialsFormat.bold = true;
    
    numberFormat = new TextFormat();
    numberFormat.font = "number";
    numberFormat.align = "left";
    numberFormat.size = 14;
    numberFormat.color = 0xffffff;
    numberFormat.bold = true;
    numberFormat.leading = 4;
    
    initialsText = new TextField();
    initialsText.x = initialsX;
    initialsText.y = initialsY;
    initialsText.width = initialsWidth;
    
    var date : Date = new Date();
    //var tf : TextField;
    startTime = date.getTime();
    initials = "";
    shipSpec = _shipSpec;
    scoreListing = _scoreListing;
    highScore = _highScore;
    
    initialsText.setTextFormat(initialsFormat);
    
    // this is a bit of extra complication -- 
    //  If the glamourshot is used directly with an alpha value that isn't 1,
    //  it will have all of it's parts set to that value and THEN rendered.
    //  That's bad, it means you can see parts of the ship through other parts
    //  of the ship.  
    //  The workaround is to first render the thing opaque, and draw it to a bitmap.  
    //  Then, the bitmap is drawn to the screen with an alpha value.  
    //  This causes the ship as a whole to be rendered with alpha, not just it's parts.  
    var gs : GlamourShot = new GlamourShot( shipSpec, 1 );
    gs.x = gs.width / 2;
    gs.y = gs.height / 2 - 10;
    var sprite : Sprite = new Sprite();
    sprite.addChild( gs );
    var bmpd : BitmapData = new BitmapData(gs.width,gs.height,true,0);
    bmpd.draw( sprite );
    var bmp : Bitmap = new Bitmap( bmpd );
    bmp.alpha = 0.5;
    addChild( bmp );
    
    // The colored box for this panel.
    switch (shipSpec.teamCode)
      {
      case ShipSpec.RED_TEAM:    bmp = new Assets.topBoxRed;    break;
      case ShipSpec.BLUE_TEAM:   bmp = new Assets.topBoxBlue;   break;
      case ShipSpec.GREEN_TEAM:  bmp = new Assets.topBoxGreen;  break;
      case ShipSpec.YELLOW_TEAM: bmp = new Assets.topBoxYellow; break;
      }
    addChild( bmp );
    
    // Handle text.  
    var textToShow : String;
    if ( highScore )
      textToShow = winText;
    else
      textToShow = loseText;
    
    scoreDescriptText = placeText(0,scoreDescriptY,"Career Earnings: \nTeam Score: ",
                                  scoreDescriptFormat,scoreCenter,this);
    scoreAmountText = placeText(scoreCenter,scoreAmountY,""+shipSpec.careerEarnings+"\n"+scoreListing.score,
                                numberFormat,200-scoreCenter,this);
    
    // This works, but the code makes no sense.
    // How does the getter/setter above play into this? -> I've not a clue.  
    if ( highScore )
      {
      initialsText = placeText(initialsX,initialsY,initials,initialsFormat,initialsWidth,this);
      pleaseEnterText = placeText(0,pleaseEnterY,"Please enter your name:",pleaseEnterFormat,200,this);
      }
    
    infoTextField = placeText(0,infoY,textToShow,infoTextFormat,200,this);
    }
  
  private function placeText( x : int, y : int, text : String, 
                              format : TextFormat = null, width : int = -1, 
                              sprite : Sprite = null ) : TextField
    {
    var tf : TextField = new TextField();
    tf.embedFonts = true;
    tf.x = x;
    tf.y = y;
    if ( width >= 0 )
      tf.width = width;
    tf.text = text;
    if ( format != null )
      tf.setTextFormat( format );
    if ( sprite == null )
      sprite = Screen.foreground;
    sprite.addChild( tf );
    return tf;
    }
  
  public function enterSelection( selection : String ) : void
    {
    switch( selection )
      {
      case "DONE": m_donePress(); return;
      case "CLR": initials = cursor; return;
      case "DEL": deletePress(); return;
      case "SPC": if ( !done ) selection = " "; break;
      default: break;
      }
      
    if ( done )
      return;
    
    if ( initials.length < 9 )
      initials = initials.slice( 0, initials.length - 1 ) + selection + cursor;
    }
  
  public function onSelectionChange( newSelection : String ) : void
    {
    // don't do anything.  This function was left incase it becomes useful - the hooks will still be here.
    /*if ( done )
      {
      cursorPositive = " ";
      return;
      }
    
    switch( newSelection )
      {
      case "DONE":
      case "CLR":
      case "DEL": 
      case "SPC":
        cursorPositive = "a";
        return;
      default: break;
      }
    
    cursorPositive = newSelection.toLowerCase();
    */
    }
  
  // This function traps any players trying to change the CPU's name.  
  public function donePress() : void
    {
    if ( !shipSpec.isCPUControlled )
      m_donePress();
    }
  
  // The REAL done press function.  
  private function m_donePress() : void
    {
    if ( done )
      {
      done = false;
      if ( highScore )
        infoText = winText;
      else
        infoText = loseText;
      }
    else
      {
      done = true;
      infoText = doneText;
      }
    
    // still need to change the graphics
    }
  
  public function deletePress() : void
    {
    if ( shipSpec.isCPUControlled )
      return; // Robots never make mistakes.  
    
    if ( done )
      return;
    
    initials = initials.slice( 0, initials.length - 2 ) + cursor;
    }
  
  // this should be called from HighScores.as
  public function update() : void
    {
    var i : int;
    
    // update the cursor
    var date : Date = new Date();
    var time : Number = date.getTime();
    var timeDelta : Number = time - startTime;
    var lastCursor : String = cursor;
    cursor = " ";
    if ( timeDelta % 1000 < 500 )
      cursor = cursorPositive;
    
    if ( cursor != lastCursor )
      initials = initials.slice( 0, initials.length - 1 ) + cursor;
    } // onEnterFrame
  }

}