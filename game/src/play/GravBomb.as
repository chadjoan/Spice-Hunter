package play
{

public class GravBomb
  {
  private static var STATE_READY : Number;
  private static var STATE_DETONATE : Number;
  private static var STATE_COOLDOWN : Number;
  private static var DETONATION_LENGTH : Number;
  private static var COOLDOWN_LENGTH : Number;

  private var env : Environment;

  public var state : Number;
  public var elapsed_time : Number;

  private var rx : Number;
  private var ry : Number;
  public var count : Number;


  public function GravBomb (_env:Environment, _count : Number)
    {
    env = _env;

    STATE_READY = 0;
    STATE_DETONATE = 1;
    STATE_COOLDOWN = 2;

    DETONATION_LENGTH = 12.5;
    COOLDOWN_LENGTH = 25.0;

    state = STATE_READY;
    count = _count;
    }

  public function isReady () : Boolean
    {
    return (state == STATE_READY && count > 0);
    }

  public function detonate(_rx : Number, _ry:Number) : void
    {
    if (isReady() )
      {
      count--;
      state = STATE_DETONATE;
      elapsed_time = DETONATION_LENGTH;
      rx = _rx;
      ry = _ry;

      var gb:GravBombAnim = new GravBombAnim();
      gb.rx = rx;
      gb.ry = ry;
      gb.radius = 100;
      env.animations.push (gb);
      Utility.playSound (Assets.GravBombSound);
      }

    }

  public function applyTo (b : Body, deltaT : Number) : void
    {
    var tau : Number = 50;
    var strength: Number = 0.2;
    var scale : Number;
    var dx: Number;
    var dy: Number;
    var dl: Number;


    // Apply force to b.
    dx = rx - b.rx;
    dy = ry - b.ry;
    dl = Math.sqrt (dx*dx + dy*dy);
    dx /= dl;
    dy /= dl;

    // Add some longitudinal velocity...
    scale = Math.exp (-(dl-tau)*(dl-tau)/tau/tau) * dl / tau;

    // Damp transverse velocity...
    // 1. get current velocity.
    var new_vx : Number = b.vx;
    var new_vy : Number = b.vy;
    // 2. subtract the component along b-r
    var dot : Number = new_vx*dx + new_vy*dy;
    new_vx -= dot * dx;
    new_vy -= dot * dy;
    // 3. damp this component.
    new_vx = new_vx * (1-0.15*deltaT*scale);
    new_vy = new_vy * (1-0.15*deltaT*scale);
    // 4. add back in the projection.
    new_vx += dot * dx;
    new_vy += dot * dy;


    //scale = scale * (DETONATION_LENGTH - elapsed_time) / (DETONATION_LENGTH);
    b.vx = new_vx + strength * scale * dx * deltaT; // / b.mass;
    b.vy = new_vy + strength * scale * dy * deltaT; // / b.mass;
    }


  public function update (deltaT : Number) : void
    {
    if (state == STATE_DETONATE)
      {
      var loop1 : Number;
      for (loop1 = 0; loop1 < env.asteroids.length; loop1++)
        applyTo (env.asteroids[loop1],deltaT);

      for (loop1 = 0; loop1 < env.spices.length; loop1++)
        applyTo (env.spices[loop1],deltaT);

      elapsed_time -= deltaT;
      if (elapsed_time < 0.0)
        {
        state = STATE_COOLDOWN;
        elapsed_time = COOLDOWN_LENGTH;
        }
      }

    if (state == STATE_COOLDOWN)
      {
      if (elapsed_time > 0.0)
        elapsed_time -= deltaT;
      else
        state = STATE_READY;
      }

    }

  }

}