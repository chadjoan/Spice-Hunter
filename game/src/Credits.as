package
  {
  import Drawable;
  import IDrawable;

  //import flash.display.Sprite;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFormatAlign;
  import flash.geom.Point;

  public class Credits implements IDrawable
    {
    private var names : Array;
    private var tasks : Array;

    private var nameFields : Array;
    private var taskFields : Array;
    private var topBlurb : TextField;

    private var taskformat:TextFormat;
    private var nameformat:TextFormat;
    private var blurbformat:TextFormat;

    private static var TEXT_Y_INCREMENT:Number = 75;
    private static var bg : Bitmap = new Assets.Background;
    private static var bgPoint : Point = new Point(0,0);
    private var fpsDisplay : FPSDisplay;
    public var expired : Boolean;

    private var state : int;
    private var next_to_write : int;
    private var cooldownTimer : Number;

    private static const STATE_WRITING : int = 0;
    private static const STATE_WAITING : int = 1;

    private static const SCROLLON_TIME : Number = 12.5;
    private static const WAIT_TIME : Number = 100.0;

    public function Credits ()
      {
      names = new Array;
      tasks = new Array;
      nameFields = new Array;
      taskFields = new Array;

      fpsDisplay = new FPSDisplay();

      Screen.queueDraw(this);
      //Screen.background.addChild(bg);


      names[0] = "Hanning Chen";
      tasks[0] = "2D Artwork and Layout";

      names[1] = "Ryan Chilton";
      tasks[1] = "Physics and AI";

      names[2] = "Danny Guinn";
      tasks[2] = "3D Artwork and Level Design";

      names[3] = "Chad Joan";
      tasks[3] = "Platform Programming and Dynamic Art";

      names[4] = "Jimmy Lei";
      tasks[4] = "Upgrade Interface";

      names[5] = "James Pae";
      tasks[5] = "Music and Sound"

      names[6] = "Thank you";
      tasks[6] = "for playing!";


      // Allocate nameFields.
      var i : Number;

      // Text format for name text boxes.
      nameformat = new TextFormat();
      nameformat.font = "title";
      nameformat.color = 0xFFFFFF;
      nameformat.size = 24;
      nameformat.align = "center";

      for (i = 0; i < names.length; i++)
        {
        nameFields[i] = new TextField ();
        nameFields[i].embedFonts = true;
        nameFields[i].width = 800;
        nameFields[i].text = names[i];
        nameFields[i].x = -800;
        nameFields[i].y = i*TEXT_Y_INCREMENT + 90;
        nameFields[i].setTextFormat (nameformat);
        //Screen.midground.addChild (nameFields[i]);
        }

      // Allocate taskFields.

      // Text format for task text
      taskformat = new TextFormat();
      taskformat.font = "title";
      taskformat.color = 0xC0C0C0;
      taskformat.size = 24;
      taskformat.align = "center";

      for (i = 0; i < tasks.length; i++)
        {
        taskFields[i] = new TextField ();
        taskFields[i].embedFonts = true;
        taskFields[i].width = 800;
        taskFields[i].text = tasks[i];
        taskFields[i].x = 800;
        taskFields[i].y = i*TEXT_Y_INCREMENT + 90 + 24;
        taskFields[i].setTextFormat (taskformat);
        //Screen.midground.addChild (taskFields[i]);
        }

      // Text format for topBlurb boxes.
      blurbformat = new TextFormat();
      blurbformat.font = "title";
      blurbformat.color = 0xFFFFFF;
      blurbformat.size = 32;
      blurbformat.align = "center";

      topBlurb = new TextField();
      topBlurb.embedFonts = true;
      topBlurb.width = 800;
      topBlurb.text = "AUTHOR CREDITS";
      topBlurb.x = 0;
      topBlurb.y = 15;
      topBlurb.setTextFormat (blurbformat);
      //Screen.midground.addChild (topBlurb);


      expired = false;
      next_to_write = 0;
      state = STATE_WRITING;
      cooldownTimer = SCROLLON_TIME;
      }

    // IDrawable implementation
    public function isVisible() : Boolean { return !expired; }
    public function getLayer() : uint { return Drawable.background; }
    public function draw ( backbuffer : BitmapData ) :void
      {
      var i : int;

      // background
      var bdata : BitmapData = bg.bitmapData;
      backbuffer.copyPixels(bdata, bdata.rect, bgPoint);

      for ( i = 0; i < nameFields.length; i++ )
        backbuffer.draw(nameFields[i],
                        nameFields[i].transform.matrix,
                        nameFields[i].transform.colorTransform,
                        null,null,true);

      for ( i = 0; i < taskFields.length; i++ )
        backbuffer.draw(taskFields[i],
                        taskFields[i].transform.matrix,
                        taskFields[i].transform.colorTransform,
                        null,null,true);

      backbuffer.draw(topBlurb,
                      topBlurb.transform.matrix,
                      topBlurb.transform.colorTransform,
                      null,null,true);
      }
    // End IDrawable implementation

    public function update () : void
      {
      fpsDisplay.update();
      var deltaT : Number = 25.0 / fpsDisplay.FPS;

      if (state == STATE_WRITING)
        {
        cooldownTimer -= deltaT;
        if (cooldownTimer < 0.0)
          cooldownTimer = 0.0;
        // Place the text fields at the progress spot.
        var progress : Number = (SCROLLON_TIME - cooldownTimer) / SCROLLON_TIME;
        nameFields[next_to_write].x = -800.0 + progress*800.0;
        taskFields[next_to_write].x =  800.0 - progress*800.0;
        if (cooldownTimer == 0.0)
          {
          Utility.playSound (Assets.joinupLeftRight );
          next_to_write++;
          cooldownTimer = SCROLLON_TIME;
          if (next_to_write == nameFields.length)
            {
            state = STATE_WAITING;
            cooldownTimer = WAIT_TIME;
            }
          }
        }

      if (state == STATE_WAITING)
        {
        cooldownTimer -= deltaT;
        if (cooldownTimer < 0.0)
          expire();
        }

      }

    public function expire () : void
      {
      /*
      // Removes all text boxes from the screen.
      var i : Number;
      for (i = 0; i < taskFields.length; i++)
        Screen.midground.removeChild (taskFields[i]);
      for (i = 0; i < nameFields.length; i++)
        Screen.midground.removeChild (nameFields[i]);

      // Remove the background.
      Screen.background.removeChild(bg);

      // Remove topBlurb.
      Screen.midground.removeChild (topBlurb);
      */
      Screen.queueRemove(this);

      expired = true;
      }


    }




  }
