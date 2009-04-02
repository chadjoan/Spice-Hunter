package {


import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


public class Congratulations
  {  
  private var fireworks : Array;
  private var fireworkCooldown : Number;
  private var fpsDisplay:FPSDisplay; 
  private var glamourshots : Array;
  
  private var congratsText : TextField;
  private var earningsText : TextField;  
  
  public function Congratulations (shipspecs : Array)
    {    
    fireworks = new Array;	
    fireworkCooldown = 0;
    fpsDisplay = new FPSDisplay();   
        
    Screen.background.addChild(new Assets.Background);          
    
    
    // Figure out the winning team.    
    var teamEarnings : Array = new Array;  // how much money did this team make, combined?    
    var i:Number;
    // Sum ship earnings into team earnings.
    teamEarnings[ShipSpec.RED_TEAM] = 0;
    teamEarnings[ShipSpec.YELLOW_TEAM] = 0;
    teamEarnings[ShipSpec.GREEN_TEAM] = 0;
    teamEarnings[ShipSpec.BLUE_TEAM] = 0;    
    
    for (i = 0; i < 4; i++)      
      teamEarnings[ shipspecs[i].teamCode ] += shipspecs[i].careerEarnings;     
      
    var bestTeam : Number = 0;    
    for (i = 1; i < 4; i++)
      if (teamEarnings[i] > teamEarnings[bestTeam])
        bestTeam = i;
    
    // Make a list of the members on the winning team.
    var winningTeam:Array = new Array;
    for (i = 0; i < 4; i++)
      if (shipspecs[i].teamCode == bestTeam)
        winningTeam.push(i);
      	          
    // Post up team glamour shots.
    var gs : GlamourShot;
    glamourshots = new Array;
    switch (winningTeam.length)
      {
      case 1:
      	// Place 1 glamourshot.
     	gs = new GlamourShot (shipspecs[winningTeam[0]],2);
        gs.x = 400;
        gs.y = 300;
        Screen.foreground.addChild(gs);      	
      	glamourshots.push(gs);
      break;	
      
      case 2:
      	// Place 2 glamourshots.
      	gs = new GlamourShot (shipspecs[winningTeam[0]],1.5);
      	gs.x = 250;
      	gs.y = 300;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);
      	
      	gs = new GlamourShot (shipspecs[winningTeam[1]],1.5);      	
      	gs.x = 550;
      	gs.y = 300;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);      	
      break;
      
      case 3:
      	// Place 3 glamourshots.
        gs = new GlamourShot (shipspecs[winningTeam[0]],1);
      	gs.x = 400;
      	gs.y = 200;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);
      	
      	gs = new GlamourShot (shipspecs[winningTeam[1]],1);      	
      	gs.x = 300;
      	gs.y = 400;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);    
      	
      	gs = new GlamourShot (shipspecs[winningTeam[2]],1);      	
      	gs.x = 500;
      	gs.y = 400;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);
      	
      break;
      
      case 4:
      	// Place 4 glamourshots.      	
        gs = new GlamourShot (shipspecs[winningTeam[0]],1);
      	gs.x = 300;
      	gs.y = 200;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);
      	
      	gs = new GlamourShot (shipspecs[winningTeam[1]],1);      	
      	gs.x = 300;
      	gs.y = 400;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);    
      	
      	gs = new GlamourShot (shipspecs[winningTeam[2]],1);      	
      	gs.x = 500;
      	gs.y = 400;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);
      	
      	gs = new GlamourShot (shipspecs[winningTeam[3]],1);
      	gs.x = 500;
      	gs.y = 200;
      	Screen.foreground.addChild(gs);
      	glamourshots.push(gs);
      	
      break; 	
      }    
    
    // Put up congrats message.      
    var format:TextFormat = new TextFormat();
    format.font = "title";	 
	format.color = Screen.getColor( bestTeam );
	format.size = 32;			         
	format.align = "center";
	  
    congratsText = new TextField();
    congratsText.embedFonts = true;    
    congratsText.width = 800;      
    switch ( bestTeam )
      {
      case ShipSpec.RED_TEAM:	        
        congratsText.text = "Congratulations\nRed";
      break;  
      case ShipSpec.YELLOW_TEAM:	
        congratsText.text = "Congratulations\nYellow";
      break;  
      case ShipSpec.BLUE_TEAM:	
        congratsText.text = "Congratulations\nBlue";
      break;  
      case ShipSpec.GREEN_TEAM:	
        congratsText.text = "Congratulations\nGreen";
      break;        
      }    
    if (winningTeam.length == 1)      
      congratsText.appendText(" Player!");	
    else
      congratsText.appendText (" Team!");
                
    congratsText.x = 0;
    congratsText.y = 15;      
    congratsText.setTextFormat(format);            
    Screen.hud.addChild (congratsText);            
    
    // Put up spice earning message.
    earningsText = new TextField ();
    earningsText.embedFonts = true;    
    earningsText.width = 800;  
    if (winningTeam.length == 1)
      earningsText.text = "Career earnings: " + teamEarnings[bestTeam];
    else
      earningsText.text = "Team career earnings: " + teamEarnings[bestTeam];               
    //earningsText.text = "R" + teamEarnings[0] + " B" + teamEarnings[1] + " Y" + teamEarnings[2] + " G" + teamEarnings[3];
      
    earningsText.x = 0;
    earningsText.y = 545;      
    earningsText.setTextFormat(format);            
    Screen.hud.addChild (earningsText); 
    }
  
  public function update () : void
    {
    fpsDisplay.update();    
    var deltaT : Number = 25.0 / fpsDisplay.FPS;	
    
    fireworkCooldown -= deltaT;
    if (fireworkCooldown < 0)
      // Spawn a new firework.    
      {
      var f:Firework = new Firework (Screen.midground);
      f.rx = Math.random()*800;
      f.ry = Math.random()*600;      	
      f.radius = Math.random()*300 + 100;
      fireworks.push(f);      
      fireworkCooldown = Math.random()*15 + 5;      
      Utility.playSound (new Assets.AstExplode() );
      }
    // Update fireworks.
    var loop1 : Number;
    for (loop1 = 0; loop1 < fireworks.length; loop1++)
      fireworks[loop1].update(deltaT);
    
    // Remove expired fireworks.
    loop1 = 0;
    while (loop1 < fireworks.length)
      if (fireworks[loop1].isExpired)
        {
        fireworks[loop1] = fireworks[fireworks.length-1];
        fireworks.pop();	
        }
      else
        loop1++;
    	
    }
  	
  }
}