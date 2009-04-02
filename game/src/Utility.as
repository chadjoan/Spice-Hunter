package
{

  import flash.display.Bitmap;
  import flash.media.Sound;

  public class Utility
    {
    
    public static function center( bmp : Bitmap ) : void
      {
        bmp.x = -(bmp.width / 2);
        bmp.y = -(bmp.height / 2);
      }
    
    public static function playSound( snd : Sound ) : void
      {
        snd.play();
      }


    public static function oneDigit (argument:Number) : Number	
      {
      return Math.round (argument*10)/10;	
      }
    
    }

}