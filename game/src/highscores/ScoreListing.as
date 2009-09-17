package highscores
{

public class ScoreListing
  {
  public var score : int;
  public var teamSize : int; // values 1-4.  0 is invalid (a zero person team).
  public var initials : String; // comma delimited if multiple people
  public var playerIDs : Array; // an array of player IDs, each ID being a player on the team
                                //   this is not persistant, it is only used in HighScoresEntryScreen
  
  public function ScoreListing()
    {
    score = -1;
    initials = "";
    teamSize = 0;
    playerIDs = null;
    }
  }

}