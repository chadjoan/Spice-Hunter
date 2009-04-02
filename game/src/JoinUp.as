
//cd Documents and Settings\chen730\Desktop\Space_F\AAA_chn\classes\peteNewClass\game
//cd Space_F\AAA_chn\classes\peteNewClass\game
package {


import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.media.Sound;
import flash.media.SoundChannel;

public class JoinUp
  {  
  private var renderPlane : Sprite;
  public var shipspecs : Array;  // Public so controls can see it.
  public var cursors : Array; //cursors is probably which item is highlighted
  public var IAmReady : Array; //the buttons at the bottom
  
  private var alpha : Number;
  
  private var chevrons : Array;
  private var blinks : Array;
  
  private var tip:Tip;
	
  private var fpsDisplay:FPSDisplay;
  
  private var gameClock:GameClock;
  private var controls : JoinUpControls;
  public var isExpired : Boolean;
  
  private var Music:Sound = new Assets.Music_joinup;
  private var MusicChannel:SoundChannel = new SoundChannel;
	
  
  public function JoinUp (_shipspecs : Array)
    {    
    shipspecs = _shipspecs;
    renderPlane = new Sprite();
    Screen.foreground.addChild(renderPlane);
    fpsDisplay = new FPSDisplay();
    gameClock = new GameClock(20);
    controls = new JoinUpControls(this);
    
    isExpired = false;
    
    cursors = new Array;
    cursors[0] = 0;
    cursors[1] = 0;
    cursors[2] = 0;
    cursors[3] = 0;
    
	IAmReady = new Array;
	IAmReady[0]=false;
	IAmReady[1]=false;
	IAmReady[2]=false;
	IAmReady[3]=false;
		
    chevrons = new Array;
    blinks = new Array;	
    
	tip = new Tip("JoinUp");	
	
    //Utility.playSound (new Assets.joinup_theme);
	
    alpha = 0.5;
		
    writeChevron();
	writeBlink();
	
	render();   
	
	MusicChannel = Music.play();
	
    }
	
	
	
  /////////////////////////////////////////////////////////////////////////render starts
  public function render () : void
    {
    removeChevron();	
	removeBlink();
	
    Screen.foreground.removeChild(renderPlane);
    
    renderPlane = new Sprite();
    var i:Number;
    var positions : Array;
    
	
	//////////////////////////////background
    renderPlane.addChild(new Assets.bg);  
    
	
    /////////////////////////// Place glamour shots.    
    positions = [300, 500, 100, 700];        
    for (i = 0; i < 4; i++)
      {
      var gs : GlamourShot = new GlamourShot (shipspecs[i],1.0);
      gs.x = positions[i];
      gs.y = 60;
      renderPlane.addChild(gs);
      }
    
    /////////////////////////////// Place color windows.
    positions = [200, 400, 0, 600];
    for (i = 0; i < 4; i++)
      {
		var joinpane:Bitmap;
		switch (shipspecs[i].teamCode){
			case 0:
			joinpane = new Assets.boxRed; break;
			case 1:
			joinpane = new Assets.boxBlue; break;
			case 2:
			joinpane = new Assets.boxYellow; break;
			case 3:
			joinpane = new Assets.boxGreen; break;		
		}	  
      
      joinpane.x = positions[i];
      joinpane.y = 0;
      renderPlane.addChild(joinpane);
      }
        
	  
	//////////////////////////////////////////bars for teams
	positions = [200, 400, 0, 600];
    for (i = 0; i < 4; i++)
      {
		var barTeam:Bitmap;
		switch (shipspecs[i].teamCode){
			case 0: barTeam = new Assets.barRed; break;
			case 1: barTeam = new Assets.barBlue; break;
			case 2: barTeam = new Assets.barYellow; break;
			case 3: barTeam = new Assets.barGreen; break;		
		}      
      barTeam.x = positions[i];
      barTeam.y = 0;
	  renderPlane.addChild(barTeam);
      }
	
	
	///////////////////////////////////////bars for controls:
	positions = [200, 400, 0, 600];
	for (i = 0; i < 4; i++)
      {
		var barControl:Bitmap;
		switch (shipspecs[i].isCPUControlled){
			case false: barControl = new Assets.barHuman; break;
			case true: barControl = new Assets.barRobot; break;
		}      
      barControl.x = positions[i];
      barControl.y = 0;
	  renderPlane.addChild(barControl);
      }
	  
	  
	/////////////////////////////////////////ready or not ready:
	positions = [200, 400, 0, 600];
	for (i = 0; i < 4; i++)
      {
		var readyControl:Bitmap;
		switch (IAmReady[i]){
			case false: readyControl = new Assets.readyNOT; break;
			case true: readyControl = new Assets.ready; break;
		}
      readyControl.x = positions[i];
      readyControl.y = 515;
	  renderPlane.addChild(readyControl);
      }	  
	
	  
	////////////////////////////////////static text
	renderPlane.addChild(new Assets.staticText);  		
		
	renderPlane.addChild(tip);
		
    Screen.foreground.addChild(renderPlane);
    writeChevron();
	writeBlink();	  
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////end of render
  
  
/**/
 	public function writeBlink () : void
    {		
		blinks = new Array;
		var positions : Array;
		positions = [200, 400, 0, 600];  
		for (var k:Number = 0; k < 4; k++){			
			var blinkBmp:Bitmap;
			blinkBmp = new Assets.blink;
			blinks.push(blinkBmp);
			Utility.center (blinkBmp);
			blinkBmp.x = positions[k];
			switch (cursors[k]){
				case 0: blinkBmp.y=294; break;
				case 1: blinkBmp.y=419; break;
				case 2: blinkBmp.y=526; break;
				case 3: blinkBmp.y=900; break;
			}
			blinkBmp.alpha=alpha;
			renderPlane.addChild (blinkBmp);
		}
    }	
	
	
   
  public function writeChevron () : void //writeChevron is now used for highlight
  {
    chevrons = new Array;
    var positions : Array;
    positions = [200, 400, 0, 600]; 
	
    for (var i : Number = 0; i < 4; i++)
	{		
		var chevronBmp : Bitmap;
		switch (cursors[i]){
			case 0:
			chevronBmp = new Assets.highlight1; break;
			case 1:
			chevronBmp = new Assets.highlight2; break;
			case 2:
			chevronBmp = new Assets.highlight3; break;
		}	
		chevrons.push(chevronBmp);
		Utility.center (chevronBmp);
		chevronBmp.x = positions[i];
		chevronBmp.y = 0;
		renderPlane.addChild (chevronBmp);
	}
  }
  
  
  
   public function removeChevron () : void
    {
    for (var i : Number = 0; i < 4; i++)
      renderPlane.removeChild (chevrons[i]);
    }
	
	
   public function removeBlink () : void
    {
  	for (var j : Number = 0; j < 4; j++)
      renderPlane.removeChild (blinks[j]);	
	}
	
	
	
  // Used to implement "button mash style" skipping
  public function fakeTick () : void
    {
    fpsDisplay.update();        
    gameClock.update(25);
    }
  
  
  
  public function update () : void
    {
    fpsDisplay.update();    
    var deltaT : Number = 25.0 / fpsDisplay.FPS;
    gameClock.update(deltaT);
  
    // Update chevron alpha parameter.
    /**/alpha = alpha + deltaT / 25.0;
    if (alpha > 1)
      alpha = 0.4;
  
	tip.scrollTip(deltaT);
	
    removeChevron ();
    writeChevron();
		
	removeBlink();
    writeBlink();
	
    // Compute expiration status.
    // If everyone is ready, expire.
    // If the countdown is complete, expire.
    if (gameClock.clockIsZero() )
      {
      expire ();
      return;
      }
	  
    if (IAmReady[0])
      if (IAmReady[1])
        if (IAmReady[2])
          if (IAmReady[3])
            {
            expire();
            return;	
            }  
    }
	
	
	
	
  
  public function expire () : void
    {
    Screen.foreground.removeChild(renderPlane);	
    isExpired = true;	
    controls.expire();    
    gameClock.expire();
    fpsDisplay.expire();
	MusicChannel.stop();
    }
  	
  }
}