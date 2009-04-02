package{

public class Debouncer
  {
  private var lastEvent: Number;
  private var delay:Number;
  
  public function Debouncer( _delay:Number=100 )
    {
    lastEvent = 0;
    delay = _delay;
    }
  
  public function debounced() : Boolean
    {
    
    var date : Date = new Date();
    var currentTime : Number = date.getTime();
    var timeDelta : Number = currentTime - lastEvent;
    
    if ( timeDelta < delay )
      return false;
    
    return true;
    }
  
  public function setLastEventTime() : void
    {
    var date : Date = new Date();
    lastEvent = date.getTime();
    }
  }

}