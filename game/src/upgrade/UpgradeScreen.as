package upgrade
{
  import Screen;
  import Drawable;
  import IDrawable;
  
  import upgrade.UpgradeAI;
  import upgrade.UpgradeMenu;
  
  import flash.display.Sprite;
  import flash.display.BitmapData;
  import flash.media.Sound;
  import flash.media.SoundChannel;

  import legacy.ControlEvent;
  import legacy.PlayerControlListener;

  public class UpgradeScreen extends PlayerControlListener // which extends Sprite
                             implements IDrawable
  {
    [Embed(source="../../swfs/AssetLibrary.swf", symbol="Background")]
    private var Background:Class;
    
    public var upgradeMenus : Array = new Array(4); // of UpgradeMenu
    
    private var TipScroller:Tip;

    private var Music:Sound = Assets.Music_Upgrade;
    private var MusicChannel:SoundChannel = new SoundChannel;
    
    public var isExpired:Boolean; 
    private var specs:Array;
    private var upgradeAIs : Array;
    
    private var FPSDisp:FPSDisplay = new FPSDisplay;
    private var Clock:GameClock;
    
    public function UpgradeScreen(_specs:Array) : void
      {
      Clock = new GameClock(90);
      
      specs = _specs;
      
      isExpired = false;
      
      upgradeMenus[0] = new UpgradeMenu(200, 0, specs[0]);
      upgradeMenus[1] = new UpgradeMenu(400, 0, specs[1]);
      upgradeMenus[2] = new UpgradeMenu(  0, 0, specs[2]);
      upgradeMenus[3] = new UpgradeMenu(600, 0, specs[3]);

      TipScroller = new Tip("UpgradeScreen");
      
      addChild(new Background);
      addChild(upgradeMenus[0]);
      addChild(upgradeMenus[1]);
      addChild(upgradeMenus[2]);
      addChild(upgradeMenus[3]);
      addChild(TipScroller);
      
      MusicChannel = Music.play();
      
      // Create & attach upgradeAI's as needed.
      upgradeAIs = new Array;
      for ( var i : int = 0; i < 4; i++ )
        if (specs[i].isCPUControlled)
          upgradeAIs.push (new UpgradeAI(specs[i], upgradeMenus[i]) );
      
      Screen.queueDraw(this);
      }

    // IDrawable implementation
    public function isVisible() : Boolean { return !isExpired; }
    public function getLayer() : uint { return Drawable.background; }
    public function draw ( backbuffer : BitmapData ) :void
      {
      backbuffer.draw(this,this.transform.matrix,this.transform.colorTransform,
                      null,null,true);
      }
    // End IDrawable implementation
  
    public function onEnterFrame () : void
      {
      var i : int;
      
      //frame per second display
      FPSDisp.update();
      
      isExpired = true; 
      var deltaT:Number = 25.0 / FPSDisp.FPS;
      Clock.update(deltaT);
      
      TipScroller.scrollTip(deltaT);
      
      for (i = 0; i < upgradeAIs.length; i++)
        upgradeAIs[i].update(deltaT);
      
      for (i = 0; i < 4; i++ )
        {
        if ( !upgradeMenus[i].isDone )
          isExpired = false;
        
        upgradeMenus[i].upgradeFlash(deltaT);
        }

      if(Clock.clockIsZero())
        isExpired = true;
      
      if(isExpired)
        {
        disconnect(); // Stop listening for keypresses.  
        MusicChannel.stop();
        Clock.expire();
        Screen.queueRemove(this);
        }
      }
    
    protected override function Rp(e:ControlEvent):void { upgradeMenus[e.playerIndex].upgrade(); }
    protected override function Up(e:ControlEvent):void { upgradeMenus[e.playerIndex].navigateUp(); }
    protected override function Lp(e:ControlEvent):void { upgradeMenus[e.playerIndex].downgrade(); }
    protected override function Dp(e:ControlEvent):void { upgradeMenus[e.playerIndex].navigateDown(); }
  }
}
