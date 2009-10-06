package legacy {

import com.pixeldroid.r_c4d3.interfaces.IGameControlsProxy;

// This class used to be much more, but now it is a stub that wraps a global
//   instance of IGameControlsProxy.
public final class FourPlayerControl
  {

  // HACK: We (indirectly) provide a global instance of an IGameControlsProxy
  //   to replace the global instance of FourPlayerControl in the old r-c4d3
  //   library.
  // Put another way, this is only here so that Spice Hunter doesn't have to be
  //   refactored in any significant way.
  private static var FPCinstance:FourPlayerControl = new FourPlayerControl();
  public var gameControlsProxy : IGameControlsProxy;

  public function FourPlayerControl()
    {
    }

  public function connect(proxy : IGameControlsProxy):void
    {
    gameControlsProxy = proxy;
    }

  public function disconnect():void
    {
    gameControlsProxy = null;
    }

  /**
  * Retrieve the FourPlayerControl instance.
  */
  public static function get instance():FourPlayerControl
    {
    return FPCinstance;
    }

  }
}