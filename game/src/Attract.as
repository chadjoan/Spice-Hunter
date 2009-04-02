package{

import Assets;
import Screen;
import highscores.HighScores;

import com.pixeldroid.r_c4d3.controls.ControlEvent;
import com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl;

import flash.events.*;
import flash.display.*;
import flash.media.Sound;
import flash.media.SoundChannel;

public class Attract
  {
  // desired FPS for movies to play at.  Also influences the highscores screen.  
  private static const desiredFPS : Number = 50.0;
  
  public var expired : Boolean;
  
  private var highScores : HighScores;
  
  [Embed(source="..\\..\\swfs\\title.swf", symbol="titleScreen")]
  private var Title:Class;
  
  [Embed(source="..\\..\\swfs\\howTo.swf", symbol="howToScreen")]
  private var HowToPlay:Class;
  
  private var title : MovieClip;
  private var howToPlay : *;
  
  private var titlePlaying : Boolean;
  private var howToPlayPlaying : Boolean;
  
  private var music:Sound = new Assets.Music_Title;
  private var musicChannel:SoundChannel = new SoundChannel;
  
  private var previousFPS : Number;
  
  private var state : uint;
  public static const STATE_HIGHSCORES : uint = 0;
  public static const STATE_TITLE : uint = 1;
  public static const STATE_HOWTOPLAY : uint = 2;
  
  public function Attract( currentState : uint = STATE_HIGHSCORES )
    {
    FourPlayerControl.instance.addEventListener(ControlEvent.ANY_PRESS, onKeyUp);
    
    expired = false;
    titlePlaying = false;
    howToPlayPlaying = false;
    state = currentState;
    
    title = new Title();
    howToPlay = new HowToPlay();
    
    musicChannel = music.play();
    
    previousFPS = Screen.root.stage.frameRate;
    Screen.root.stage.frameRate = desiredFPS;
    }
  
  public function update() : void
    {
    switch ( state )
      {
      case STATE_HIGHSCORES:
        if ( highScores == null )
          highScores = new HighScores();
        highScores.update();
        if ( highScores.expired )
          {
          state = STATE_TITLE;
          highScores = null;
          }
        break;
      case STATE_TITLE:
        if ( !titlePlaying )
          {
          Screen.midground.addChild( title );
          titlePlaying = true;
          title.gotoAndPlay(0);
          }
        else if ( title.currentFrame == title.totalFrames )
          {
          title.stop();
          state = STATE_HOWTOPLAY;
          titlePlaying = false;
          Screen.midground.removeChild( title );
          }
        break;
      case STATE_HOWTOPLAY:
        if ( !howToPlayPlaying )
          {
          Screen.midground.addChild( howToPlay );
          howToPlayPlaying = true;
          howToPlay.gotoAndPlay(0);
          }
        else if ( howToPlay.currentFrame == howToPlay.totalFrames )
          {
          howToPlay.stop();
          state = STATE_HIGHSCORES;
          howToPlayPlaying = false;
          Screen.midground.removeChild( howToPlay );
          }
        break;
      }
    }
  
  // we are done as soon as someone does something
  public function onKeyUp(event:ControlEvent) : void
    {
    trace( "onKeyUp" );
    if ( highScores != null )
      {
      trace( "highScores != null" );
      highScores.expire();
      }
    Screen.reset();
    musicChannel.stop();
    expired = true;
    Screen.root.stage.frameRate = previousFPS;
    FourPlayerControl.instance.removeEventListener(ControlEvent.ANY_PRESS, onKeyUp);
    }
  
  /*public function cleanup() : void
    {
    Screen.root.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
    }
  */
  }

}