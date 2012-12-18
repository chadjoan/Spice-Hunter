package play
{

import play.Ship;

// A helper class for detecting long range shots of spice.
public class SpiceReleaseFingerprint
  {
  // Where was I released?
  public var release_x : Number;
  public var release_y : Number;
  // Who released me?
  public var releaser : Ship;

  public function SpiceReleaseFingerprint (rx : Number, ry : Number, whodunit : Ship)
    {
    release_x = rx;
    release_y = ry;
    releaser = whodunit;
    }
  }
}