package{

import Assets;
import Screen;
import highscores.HighScores;

import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;
import com.pixeldroid.r_c4d3.controls.JoyButtonEvent;
import legacy.ControlEvent;

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

  [Embed(source="../swfs/title.swf", symbol="titleScreen")]
  private var Title:Class;

  [Embed(source="../swfs/howTo.swf", symbol="howToScreen")]
  private var HowToPlay:Class;
  
  private var title : MovieClip;
  private var howToPlay : *;
  
  private var titlePlaying : Boolean;
  private var howToPlayPlaying : Boolean;
  
  private var music:Sound = Assets.m03;
  private var musicChannel:SoundChannel = new SoundChannel;
  
  private var previousFPS : Number;
  
  private var state : uint;
  public static const STATE_HIGHSCORES : uint = 0;
  public static const STATE_TITLE : uint = 1;
  public static const STATE_HOWTOPLAY : uint = 2;

  public var controlsProxy : IGameControlsProxy;
  
  public function Attract( controls : IGameControlsProxy, currentState : uint = STATE_HIGHSCORES )
    {
    // Code that uses old R-C4D3 library and won't work anymore.
    //FourPlayerControl.instance.addEventListener(ControlEvent.ANY_PRESS, onKeyUp);

    controlsProxy = controls;
    controlsProxy.addEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onKeyUp);
    
    expired = false;
    titlePlaying = false;
    howToPlayPlaying = false;
    state = currentState;
    
    title = new Title();
    howToPlay = new HowToPlay();
    
    musicChannel = music.play();

    // HACK: When loaded by RomLoader.swf, these won't work anymore because root.stage is null.
    //previousFPS = Screen.root.stage.frameRate;
    //Screen.root.stage.frameRate = desiredFPS;
    }
  
  public function update() : void
    {
    switch ( state )
      {
      case STATE_HIGHSCORES:
        
        // temp hack until high scores is fixed
        //state = STATE_TITLE;
        //break;
        // end temp hack
        
        if ( highScores == null )
          highScores = new HighScores();
        highScores.update();
        Screen.draw(); // causes highScores to get drawn.
        if ( highScores.expired )
          {
          state = STATE_TITLE;
          highScores = null;
          }
        break;
      case STATE_TITLE:
        if ( !titlePlaying )
          {
          Screen.swfs.addChild( title );
          titlePlaying = true;
          title.gotoAndPlay(0);
          }
        else if ( title.currentFrame == title.totalFrames )
          {
          title.stop();
          state = STATE_HOWTOPLAY;
          titlePlaying = false;
          Screen.swfs.removeChild( title );
          }
        break;
      case STATE_HOWTOPLAY:
        if ( !howToPlayPlaying )
          {
          Screen.swfs.addChild( howToPlay );
          howToPlayPlaying = true;
          howToPlay.gotoAndPlay(0);
          }
        else if ( howToPlay.currentFrame == howToPlay.totalFrames )
          {
          howToPlay.stop();
          state = STATE_HIGHSCORES;
          howToPlayPlaying = false;
          Screen.swfs.removeChild( howToPlay );
          }
        break;
      }
    }
  
  // we are done as soon as someone does something
  public function onKeyUp(event:JoyButtonEvent) : void
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

    // HACK: When loaded by RomLoader.swf, this won't work anymore because root.stage is null.
    //Screen.root.stage.frameRate = previousFPS;

    // Code that uses old R-C4D3 library and won't work anymore.
    //FourPlayerControl.instance.removeEventListener(ControlEvent.ANY_PRESS, onKeyUp);

    controlsProxy.removeEventListener(JoyButtonEvent.JOY_BUTTON_MOTION, onKeyUp);
    }

  }

}
