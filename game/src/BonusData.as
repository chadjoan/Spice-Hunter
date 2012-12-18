package {

// Representation of bonus data - lots of different attributes here.
public class BonusData
  {
  // Data member for awarding "Buzzer Beater" title.
  // Stores the timestamp of the most recent score (in gameClock seconds).
  // When the round ends, if the last score occured with 10 seconds or fewer
  // on the clock, the player is awarded the title.
  public var timeOfLastScore : Number;
  // This award is handled by environment (when spice collides with homebase)

  // Data member for awarding the "Tug of War" title.
  // If a player wins a tug of war battle, this number is incremented.
  // If they win 3 or more times, they get the title.
  public var tetherWins : Number;
  // This award is very klunky to implement. It is handled by Ship.triggerReset()

  // Data member for the "Demolition Derby" title.
  // Every time 2 non-allied ships collide, both get this number incremented.
  // If a ship undergoes 5 or more collisions with enemy ships in a single round,
  // they are award the title.
  public var shipCollisions : Number;
  // This award is handled by environment (when ships & ships collide).

  // Data member for the "Motherlode" title.
  // Keeps track of how many large spices have been collected by a player. If it's sufficiently
  // large (>5.0 mass) they get the Motherlode" award.
  public var bigSpiceHauls : Number;
  // This award is handled by environment (when spice collides with homebase).

  // Data member for accumulating "combos".
  // When a player drags a tethered spice across another, they're awarded a combo. (this is a pretty deliberate move)
  // When a fingerprinted spice globs with another spice, the fingerprints releaser is awarded a combo.
  public var combos : Number;

  // Data member for the "Good Driver" title.
  // Keeps track of the number of collisions that a player is involved in.
  // (With anchors and asteroids). If its less than 5, they get
  // the award.
  public var numberCollisions : Number;
  // This award is handled by environment (ship/asteroid and ship/anchor collisions)

  // Data member for the "3-Point Shooter" title.
  // Keeps track of the number of long shots a player completes.
  // If it's greater than 3, they get the title.
  public var numberLongShots : Number;
  // This is klunky to implement. It is handled by tether.setTarget and environment (when spice collides with homebase).

  public var rawScore : Number;
  // Stores the rawScore for this round.

  // Additional awards that don't require storage.
  // "Round Leader" - given to the player with the largest raw score.
  // "Also Ran" - given to the player with the lowest raw score.
  // "Team Exacta" - given to 2 allied players when they finish #1 and #2 in raw score. A bonus for good team coordination.
  // "Blanket Finish" - given to 2 allied players when they have very close raw scores. A bonus for team coordination.
  // "Underdog Rally" - given to any player that significantly outscores a significantly wealthier (careerwise) opponent.
  public function BonusData ()
    {
    numberLongShots = 0;
    tetherWins = 0;
    shipCollisions = 0;
    numberCollisions = 0;
    timeOfLastScore = 100;  // Initialized to some large time value that won't trigger the "Buzzer Beater" award.
    bigSpiceHauls = 0;
    rawScore = 0;
    combos = 0;
    }

  }


} // end package