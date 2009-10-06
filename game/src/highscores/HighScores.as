package highscores
{

import com.pixeldroid.r_c4d3.data.DataEvent;
import com.pixeldroid.r_c4d3.scores.ScoreEvent;
import com.pixeldroid.r_c4d3.scores.RemoteHighScores;

import flash.text.*;
import flash.display.*;
import flash.events.Event;

import Firework;
import Screen;
import Drawable;
import IDrawable;
import BitmapDrawable;
import highscores.ScoreListing;

public class HighScores implements IDrawable
  {
  public static const numScoresStored : uint = 10;
  private static const scoreServerURL : String = "http://accad.osu.edu/arcade/scores/";
  
  private static const titleY : uint = 20;
  private static const teamTypeY : uint = 60;
  private static const column1X : uint = 250; // ranking column
  private static const column2X : uint = 325; // player initials column
  private static const column3X : uint = 500; // score column
  private static const columnsY : uint = 110; // How far down on the screen the columns start.  
                                              //   this includes column titles.  
  private static const initialsSize : uint = 110; // approximately how many pixels each initial/name entry may take
                                                  // This is only a fraction of what a comma-delimited team entry will be.  
  private static const columnYSpacing : uint = 40;
  
  private static const duration : Number = 5; // Time, in seconds, each of the 4 high scores screens gets shown.  
  
  private static const defaultScoresInitials : Array =
    [
    "----------",
    "---------",
    "--------",
    "-------",
    "------",
    
    "-----",
    "----",
    "---",
    "--",
    "-"
    ];
  
  private static const defaultScoresValues : Array = 
    [
    0,
    0,
    0,
    0,
    0,
    
    0,
    0,
    0,
    0,
    0
    ];
  
  // array for holding all of the different types of scores
  // scoreArrayArray[0] = 1 player high scores
  // scoreArrayArray[1] = 2 player high scores
  // scoreArrayArray[2] = 3 player high scores
  // scoreArrayArray[3] = 4 player high scores
  public static var scoreArrayArray : Array; 
  
  // Array of RemoteHighScores objects.
  public static var RMH : Array;
  
  // this array should be sorted by scores.
  // sessionScores[0] should be the highest score, and sessionScores[max] should be the lowest score
  // If a score is not entered, it shall be inserted as a -1.  
  //   -1 is considered to be less than a score of 0.  
  public var scores : Array; // array of ScoreListings
  
  public var expired : Boolean;
  private var startTime : Number; // Time, in millisecs, when this highscores started.
  private var teamType : uint; // 1, 2, 3, or 4.  Specifies how many players were involved 
                               //  in the teams on the scores currently being shown.  
  
  private var background : BitmapDrawable;
  private var textLayer : Sprite;
  
  private var fireworks : Array;
  private var fireworkCooldown : Number;
  private var fpsDisplay:FPSDisplay;
  
  private static function getGameID( index : uint ) : String
    {
    switch( index )
      {
      case 0: return "au2007SpiceHunter1";
      case 1: return "au2007SpiceHunter2";
      case 2: return "au2007SpiceHunter3";
      case 3: return "au2007SpiceHunter4";
      }
    
    return "";
    }
  
  // call this when the game starts
  public static function init() : void
    {
    scoreArrayArray = new Array(4);
    RMH = new Array(4);
    var i : int;
    for ( i = 0; i < 4; i++ )
      initScoreArray(i);
    }
  
  // this will probably end up with another arg or two, to tell pdroid which scores to load
  private static function initScoreArray(index:int) : void
    {
    generateStartingScores(index+1);
    trace( "Initializing Score Array "+index );
    RMH[index] = new RemoteHighScores(getGameID(index), numScoresStored, scoreServerURL);
    RMH[index].addEventListener(ScoreEvent.LOAD,getLoadListener(index));
    RMH[index].addEventListener(DataEvent.ERROR,onDataError);
    RMH[index].load();
    }
  
  private static function getLoadListener( index : uint ) : Function
    {
    switch( index )
      {
      case 0: return onLoad1;
      case 1: return onLoad2;
      case 2: return onLoad3;
      case 3: return onLoad4;
      }
    trace("no load listener matching index " +index);
    return null;
    }
  
  private static function onLoad1(e:ScoreEvent) : void { trace("onLoad1"); onLoad(e,0); }
  private static function onLoad2(e:ScoreEvent) : void { trace("onLoad2"); onLoad(e,1); }
  private static function onLoad3(e:ScoreEvent) : void { trace("onLoad3"); onLoad(e,2); }
  private static function onLoad4(e:ScoreEvent) : void { trace("onLoad4"); onLoad(e,3); }
  
  private static function onLoad(e:ScoreEvent,index:uint) : void
    {
    var i : int;
    
    if ( e.success )
      {
      var m_RMH : RemoteHighScores = RMH[index];
      //m_RMH.reset();
      
      if ( m_RMH.length == numScoresStored )
        {
        
        // check for erranious null initials
        for ( i = 0; i < numScoresStored; i++ )
          {
        trace( "m_RMH.getInitials(i) = "+m_RMH.getInitials(i) );
          if ( m_RMH.getInitials(i) == null )
            return;
          }
        
        // it was successful, so load em up
        var array : Array = new Array(numScoresStored);
        
        for ( i = 0; i < numScoresStored; i++ )
          {
          array[i] = new ScoreListing();
          array[i].score = m_RMH.getScore(i);
          array[i].initials = m_RMH.getInitials(i);
          scoreArrayArray[index] = array;
          }
        }
      }
    
    }
  
  private static function onDataError(e:DataEvent) : void
    {
    trace( e.message );
    }
  
  private static function generateStartingScores(teamSize:uint) : void
    {
    var i : int;
    var j : int;
    var array : Array = new Array(numScoresStored);
    
    // generate stuff for this session, and let HighScoresEntry handle the writing later.  
    /*for ( i = 0; i < numScoresStored; i++ )
      {
      var integer : uint = Math.random() * 1000;
      array[i] = new ScoreListing();
      array[i].score = integer + 1000;
      array[i].initials = generateRobotName();
      for ( j = 1; j < teamSize; j++ )
        array[i].initials += ", "+generateRobotName();
      }
    
    sortScores( array );*/
    
    for ( i = 0; i < numScoresStored; i++ )
      {
      array[i] = new ScoreListing();
      array[i].score = defaultScoresValues[i];
      array[i].initials = defaultScoresInitials[i];
      }
    
    scoreArrayArray[teamSize-1] = array;
    }
  
  public static function sortScores( scores : Array ) : void
    {
    if ( scores.length < 2 )
      return;
    
    // simple bubble sort algo
    var i : int;
    var sorted : Boolean = false;
    var lastListing : ScoreListing;
    var currentListing : ScoreListing;
    
    while ( !sorted )
      {
      sorted = true;
      lastListing = scores[0];
      
      for ( i = 1; i < scores.length; i++ )
        {
        currentListing = scores[i];
        if ( lastListing.score < currentListing.score )
          {
          sorted = false;
          
          scores[i] = lastListing;
          scores[i-1] = currentListing;
          }
        lastListing = currentListing;
        }
      }
    }
  
  // returns true if the contents of the arrays are the same
  // false if they are not
  public static function cmpScoreArrays( scores1 : Array, scores2 : Array ) : Boolean
    {
    var i : int;
    
    if ( scores1.length != scores2.length )
      return false;
    
    for ( i = 0; i < scores1.length; i++ )
      if ( scores1[i] != scores2[i] )
        return false;
    
    return true;
    }
  
  public function HighScores()
    {
    teamType = 1;
    scores = scoreArrayArray[teamType-1];
    
    var date : Date = new Date();
    startTime = date.getTime();
    expired = false;
    
    fireworks = new Array;
    fireworkCooldown = 0;
    fpsDisplay = new FPSDisplay();
    
    textLayer = new Sprite();
    
    var tmp : Bitmap = new Assets.Background;
    background = new BitmapDrawable( Drawable.background );
    background.bitmapData = tmp.bitmapData;
    
    Screen.queueDraw(this);
    Screen.queueDraw(background);
    
    showScores();
    }
  
  // IDrawable implementation
  public function isVisible() : Boolean { return !expired; }
  public function getLayer() : uint { return Drawable.foreground; }
  public function draw( backbuffer : BitmapData ) : void
    {
    backbuffer.draw(textLayer,
                    textLayer.transform.matrix,
                    textLayer.transform.colorTransform,
                    null,null,true);
    }
  
  public function update() : void
    {
    fpsDisplay.update();
    var deltaT : Number = 25.0 / fpsDisplay.FPS;
    
    fireworkCooldown -= deltaT;
    if (fireworkCooldown < 0)
      // Spawn a new firework.
      {
      var f:Firework = new Firework();
      f.rx = Math.random()*800;
      f.ry = Math.random()*600;      	
      f.radius = Math.random()*300 + 100;
      fireworks.push(f);      
      fireworkCooldown = Math.random()*15 + 5;      
      Utility.playSound (Assets.AstExplode );
      }
    // Update fireworks.
    var loop1 : Number;
    for (loop1 = 0; loop1 < fireworks.length; loop1++)
      fireworks[loop1].update(deltaT);
    
    // Remove expired fireworks.
    loop1 = 0;
    while (loop1 < fireworks.length)
      if (fireworks[loop1].isExpired)
        {
        fireworks[loop1] = fireworks[fireworks.length-1];
        fireworks.pop();
        }
      else
        loop1++;
    
    // check to see if we are done.
    var date : Date = new Date();
    if ( startTime + (duration * 4000) < date.getTime() )
      expire();
    else if ( startTime + (duration * 3000) < date.getTime() )
      {
      teamType = 4;
      showScores();
      }
    else if ( startTime + (duration * 2000) < date.getTime() )
      {
      teamType = 3;
      showScores();
      }
    else if ( startTime + (duration * 1000) < date.getTime() )
      {
      teamType = 2;
      showScores();
      }
    }
  
  public function showScores() : void
    {
    // first, some cleanup and initialization
    var i : int;
    var j : int;
    
    while ( textLayer.numChildren > 0 )
      textLayer.removeChildAt(0);
    
    scores = scoreArrayArray[teamType-1];
    
    //Text Fields
    var x1 : int = column1X - initialsSize * (teamType-1) / 2;
    var x2 : int = column2X - initialsSize * (teamType-1) / 2;
    var x3 : int = column3X + initialsSize * (teamType-1) / 2;
    
    var tformat : TextFormat = new TextFormat();
    tformat.font = "title";
    tformat.size = 32;
    tformat.color = 0xffffff;
    tformat.bold = true;
    tformat.align = "center";
    
    placeText( 0, titleY, "High Scores", tformat, 800 );
    
    tformat.size = 24;
    
    if ( teamType < 2 )
      placeText( 0, teamTypeY, teamType+" Player Scores", tformat, 800 );
    else
      placeText( 0, teamTypeY, teamType+" Player Team Scores", tformat, 800 );
      
    tformat.font = "text";
    tformat.size = 18;
    tformat.align = "left";
    
    placeText( x1, columnsY, "Rank", tformat );
    placeText( x2, columnsY, "Initials", tformat );
    placeText( x3, columnsY, "Score", tformat );
    
    //var halfScores : int = numScoresStored / 2;
    var y : int;
    
    for ( i = 0; i < numScoresStored; i++ )
      {
      y = columnsY + (i+1) * columnYSpacing;
      
      placeText( x1, y, ""+(i+1), tformat ); // rank
      placeText( x2, y, scores[i].initials, tformat, initialsSize * teamType + 10 );
      placeText( x3, y, ""+scores[i].score, tformat );
      }
    
    /*
    placeText( column1X+rightColumnsX, columnsY, "Rank", tformat );
    placeText( column2X+rightColumnsX, columnsY, "Initials", tformat );
    placeText( column3X+rightColumnsX, columnsY, "Score", tformat );
    
    for ( j = halfScores; j < numScoresStored; j++ )
      {
      i = j - halfScores;
      y = columnsY + (i+1) * columnYSpacing;
      
      placeText( column1X+rightColumnsX, y, ""+(j+1), tformat ); // rank
      placeText( column2X+rightColumnsX, y, scores[j].initials, tformat );
      placeText( column3X+rightColumnsX, y, ""+scores[j].score, tformat );
      }
    */
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
      sprite = textLayer;
    sprite.addChild( tf );
    return tf;
    }
  
  public function expire() : void
    {
    trace( "Expiring at team "+teamType );
    
    var i : int;
    
    fpsDisplay.expire();
    
    for ( i = 0; i < fireworks.length; i++ )
      fireworks[i].expire();
    
    expired = true;
    
    while ( textLayer.numChildren > 0 )
      textLayer.removeChildAt(0);
    
    Screen.queueRemove(this);
    Screen.queueRemove(background);
    
    Screen.reset();
    }
  }

}