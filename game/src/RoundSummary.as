package {


import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


public class RoundSummary
  {    
  public var isExpired : Boolean;
  
  private var fpsDisplay:FPSDisplay;       
  private var bottomBlurb : TextField;  
  private var pressAnyKey : TextField;
  private var roundSummaryPanes : Array;
  private var bg : Bitmap;
  
  private var formatBottom:TextFormat;
  
  private var state : Number;
    
  private static const STATE_WRITING:int = 0;
  private static const STATE_WAITING:int = 1;
  private var delayCounter : Number;  
  private var controls : RoundSummaryControls;
  
  public function RoundSummary (shipspecs : Array, bonusDatas:Array)
    {            
    isExpired = false;
    state = STATE_WRITING;
    delayCounter = 15;  // Delay, in seconds.
    delayCounter *= 25; // Scale to frames.
    
    fpsDisplay = new FPSDisplay();    
    bg = new Assets.Background;  
    Screen.background.addChild(bg);
    
    controls = new RoundSummaryControls (this);
    
    var positions : Array = [300, 500, 100, 700];
    roundSummaryPanes = new Array;
    var i:Number;
    for (i = 0; i < 4; i++)
      roundSummaryPanes[i] = new RoundSummaryPane(shipspecs[i], positions[i]);    
      
    
    // Text format for "Round Summary" text box.
    formatBottom = new TextFormat();
    formatBottom.font = "title";	 
	formatBottom.color = 0xFFFFFF;
	formatBottom.size = 24;			         
	formatBottom.align = "center";  
    
    // TextField for "Round Summary"
    bottomBlurb = new TextField();
    bottomBlurb.embedFonts = true;    
    bottomBlurb.width = 800;     
    bottomBlurb.text = "Round Summary";   
    bottomBlurb.x = 0;
    bottomBlurb.y = 555;      
    bottomBlurb.setTextFormat(formatBottom);  
    
    Screen.midground.addChild(bottomBlurb);  
    
    for (i = 0; i < 4; i++)
      roundSummaryPanes[i].appendBonus ("Spice Mined",bonusDatas[i].rawScore);                    
    
    
    
    // Round leader award.
    var bestScore : Number = 0;
    var bestScoreID : Number = -1;
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].rawScore > bestScore)
        {
        bestScore = bonusDatas[i].rawScore;
        bestScoreID = i;	
        }    
    if (bestScoreID != -1)
      roundSummaryPanes[bestScoreID].appendBonus ("Round Leader", 50);
            
    // Also ran award.
    var worstScore : Number = 1000000;
    var worstScoreID : Number = -1;
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].rawScore < worstScore && bonusDatas[i].rawScore != 0)
        {
        worstScore= bonusDatas[i].rawScore;
        worstScoreID = i;	
        }
    if (worstScoreID != -1 && worstScoreID != bestScoreID)    
      roundSummaryPanes[worstScoreID].appendBonus ("Also Ran", 25);
    
    // Zero award.
    for (i = 0; i < 4; i++) 
      if (bonusDatas[i].rawScore == 0)
        roundSummaryPanes[i].appendBonus ("Zero?",1);
    
    // Y10K Bug award.
    for (i = 0; i < 4; i++)
       if (bonusDatas[i].rawScore >= 10000)
         roundSummaryPanes[i].appendBonus ("Y10K Bug",1);    
  
    // Buzzer beater awards.  
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].timeOfLastScore < 11)
        roundSummaryPanes[i].appendBonus ("Buzzer Beater", 75 );
    
    // Tether wins awards.
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].tetherWins > 0)
        roundSummaryPanes[i].appendBonus ("Tug of War (" + bonusDatas[i].tetherWins + ")",  bonusDatas[i].tetherWins*50);
    
    // Demolition Derby award.
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].shipCollisions >= 5)
        roundSummaryPanes[i].appendBonus ("Demolition Derby", 50);
    
    // Motherlode award.
    for (i = 0; i < 4; i++)   
      if (bonusDatas[i].bigSpiceHauls > 0)
        roundSummaryPanes[i].appendBonus ("Motherlode (" + bonusDatas[i].bigSpiceHauls + ")", bonusDatas[i].bigSpiceHauls*50);
        
    // Safe driver award.
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].numberCollisions < 10)
        roundSummaryPanes[i].appendBonus ("Safe Driver", 50);  
        
    // Number of long shots.
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].numberLongShots > 0)
        roundSummaryPanes[i].appendBonus ("Long Shots (" + bonusDatas[i].numberLongShots + ")",  bonusDatas[i].numberLongShots*50);
    
    // Number of combos.
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].combos > 0)
        roundSummaryPanes[i].appendBonus ("Combos (" + bonusDatas[i].combos + ")",  bonusDatas[i].combos*50);
    
    // Related bonus, the 3-Point-Shooter award.
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].numberLongShots >= 3)
        roundSummaryPanes[i].appendBonus ("3-Point-Shooter", 150);
    
    var j : Number;    
    // Blanket Finish award - harder to get, so more valuable.
    var blanketCounters : Array = [0, 0, 0, 0];    
    for (j = 0; j < 4; j++)
      for (i = j+1; i < 4; i++)
        if (shipspecs[i].teamCode == shipspecs[j].teamCode)
          if (Math.abs (bonusDatas[i].rawScore - bonusDatas[j].rawScore) < 75 )
            {
            blanketCounters[i]++;
            blanketCounters[j]++;
            }
    for (i = 0; i < 4; i++)
      if (blanketCounters[i] != 0)
        roundSummaryPanes[i].appendBonus ("Blanket Finish",blanketCounters[i]*200);
    
    // Team exacta award.
    // We've already found the top player (it's in bestScoreID)
    // Find the SECOND best player - if 1st and 2nd are allied, give them both bonus points for their "Team Exacta"
    var secondBestScore : Number= 0;
    var secondBestScoreID : Number = -1;
    for (i = 0; i < 4; i++)
      if (bonusDatas[i].rawScore > secondBestScore && i != bestScoreID)
        {
        secondBestScore = bonusDatas[i].rawScore;
        secondBestScoreID = i;
        }
    if ( bestScoreID != -1 && secondBestScoreID != -1)
      if (shipspecs[bestScoreID].teamCode == shipspecs[secondBestScoreID].teamCode)
        {
        roundSummaryPanes[bestScoreID].appendBonus ("Team Exacta", 500);
        roundSummaryPanes[secondBestScoreID].appendBonus("Team Exacta", 500);
        }
          
    // "Underdog Rally" - given to any player that significantly outscores a significantly wealthier (careerwise) opponent.      
    var underdogCounters : Array = [0, 0, 0, 0];
    for (i = 0; i < 4; i++)
      for (j = i+1; j < 4; j++)
        if ( bonusDatas[i].rawScore - bonusDatas[j].rawScore > 300 )
          if (shipspecs[j].careerEarnings - shipspecs[i].careerEarnings > 1000)
            underdogCounters[i]++;  
    for (i = 0; i < 4; i++)
      if (underdogCounters[i] != 0)
        roundSummaryPanes[i].appendBonus("Underdog Rally",200 * underdogCounters[i]);
    }  
  
  public function update () : void
    {
    fpsDisplay.update();    
    var deltaT : Number = 25.0 / fpsDisplay.FPS;
    
    var i:Number;
    for (i = 0; i < 4; i++)	    
      roundSummaryPanes[i].update(deltaT);
    
    // Are all roundSummaryPanes finished?
    if (state == STATE_WRITING)
      if (roundSummaryPanes[0].isDone)
        if (roundSummaryPanes[1].isDone)
          if (roundSummaryPanes[2].isDone)
            if (roundSummaryPanes[3].isDone)
              {
              state = STATE_WAITING;
            
              // Add another text blurb that says press any button to continue.
              // TextField for "Press any button"
              pressAnyKey = new TextField();
              pressAnyKey.embedFonts = true;    
              pressAnyKey.width = 800;                 
              pressAnyKey.x = 0;
              pressAnyKey.y = 575;                 
              Screen.midground.addChild(pressAnyKey);                     
              }
    
    if (state == STATE_WAITING)
      {      
      delayCounter -= deltaT;
      pressAnyKey.text = "Returning to base in " + Math.max (0, Math.round (delayCounter/25.0) );   
      pressAnyKey.setTextFormat(formatBottom);
      }
    
    if (delayCounter < 0)
      expire();    
    }
  
  public function skipOut () : void
    {
    if (state == STATE_WAITING)
      delayCounter -= 25;	
    }
  
  public function expire () : void
    {
    isExpired = true;
    fpsDisplay.expire();
    for (var i:Number = 0; i < 4; i++)
      roundSummaryPanes[i].expire();
    Screen.midground.removeChild(bottomBlurb);        	
    Screen.midground.removeChild(pressAnyKey);
    Screen.background.removeChild(bg);
    }
  	
  }
}