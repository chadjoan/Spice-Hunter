package {

import flash.display.Sprite;
import flash.display.Bitmap;

public class GlamourShot extends Sprite
  {
  private var tetherLayer : Bitmap;
  private var rightArmLayer : Bitmap;
  private var bodyLayer : Bitmap;
  private var leftArmLayer : Bitmap;  
  private var reticleLayer : Bitmap;
  private var gBombLayer : Bitmap;
  	
  public function GlamourShot (owner:ShipSpec, scale : Number)
    {    
    build(owner,scale);	
    }
  
  private function unbuild () : void
    {
    removeChild (tetherLayer);	
    removeChild (rightArmLayer);
    removeChild (bodyLayer);
    removeChild (leftArmLayer);
    removeChild (reticleLayer);
    }
  
  private function build(owner:ShipSpec, scale : Number) : void
    {
    // Insert tether layer.	    
    switch (owner.tetherLevel)
      {   
      case 0:   
      case 1: tetherLayer = new Assets.Tether1; break;
      case 2: tetherLayer = new Assets.Tether2; break;
      case 3: tetherLayer = new Assets.Tether3; break;
      case 4: tetherLayer = new Assets.Tether4; break;
      case 5: tetherLayer = new Assets.Tether5; break;
      case 6: tetherLayer = new Assets.Tether6; break;
      case 7: tetherLayer = new Assets.Tether7; break;
      case 8: tetherLayer = new Assets.Tether8; break;
      case 9: tetherLayer = new Assets.Tether9; break;
      case 10: tetherLayer = new Assets.Tether10; break;
      }    
    
    tetherLayer.scaleX = scale;
    tetherLayer.scaleY = scale;
    Utility.center (tetherLayer);       
    addChild(tetherLayer);      
    
    // Insert right arm layer.
    switch (owner.gravityLevel)
      {
      case 0:   
      case 1: rightArmLayer = new Assets.RightArmPowerup1; break;
      case 2: rightArmLayer = new Assets.RightArmPowerup2; break;
      case 3: rightArmLayer = new Assets.RightArmPowerup3; break;
      case 4: rightArmLayer = new Assets.RightArmPowerup4; break;
      case 5: rightArmLayer = new Assets.RightArmPowerup5; break;
      case 6: rightArmLayer = new Assets.RightArmPowerup6; break;
      case 7: rightArmLayer = new Assets.RightArmPowerup7; break;
      case 8: rightArmLayer = new Assets.RightArmPowerup8; break;
      case 9: rightArmLayer = new Assets.RightArmPowerup9; break;
      case 10: rightArmLayer = new Assets.RightArmPowerup10; break;	
      }
      
    rightArmLayer.scaleX = scale;
    rightArmLayer.scaleY = scale;
    Utility.center (rightArmLayer);   
    addChild (rightArmLayer);
        
    // Insert body layer - 16 possibilites (4 shapes by 4 colors)
    switch (owner.teamCode)
      {
      case ShipSpec.RED_TEAM:
      	switch (owner.playerID)
      	  {
      	  case 0: bodyLayer = new Assets.RedTriangle; break;
      	  case 1: bodyLayer = new Assets.RedCircle; break;
      	  case 2: bodyLayer = new Assets.RedSpiral; break;
      	  case 3: bodyLayer = new Assets.DonutRed; break;
      	  }
      break; 	
      case ShipSpec.BLUE_TEAM:
      	switch (owner.playerID)
      	  {
      	  case 0: bodyLayer = new Assets.BlueTriangle; break;
      	  case 1: bodyLayer = new Assets.BlueCircle; break;
      	  case 2: bodyLayer = new Assets.BlueSpiral; break;
      	  case 3: bodyLayer = new Assets.DonutBlue; break;
      	  }
      break; 
      case ShipSpec.GREEN_TEAM:
      	switch (owner.playerID)
      	  {
      	  case 0: bodyLayer = new Assets.GreenTriangle; break;
      	  case 1: bodyLayer = new Assets.GreenCircle; break;
      	  case 2: bodyLayer = new Assets.GreenSpiral; break;
      	  case 3: bodyLayer = new Assets.DonutGreen; break;
      	  }
      break; 	
      case ShipSpec.YELLOW_TEAM:
      	switch (owner.playerID)
      	  {
      	  case 0: bodyLayer = new Assets.YellowTriangle; break;
      	  case 1: bodyLayer = new Assets.YellowCircle; break;
      	  case 2: bodyLayer = new Assets.YellowSpiral; break;
      	  case 3: bodyLayer = new Assets.DonutYellow; break;
      	  }
      break; 
      }
    bodyLayer.scaleX = scale;
    bodyLayer.scaleY = scale;
    Utility.center (bodyLayer);    
    addChild (bodyLayer);
    
    // Insert left arm layer.
    switch (owner.repelLevel)
      {
      case 0:   
      case 1: leftArmLayer = new Assets.LeftArmPowerup1; break;
      case 2: leftArmLayer = new Assets.LeftArmPowerup2; break;
      case 3: leftArmLayer = new Assets.LeftArmPowerup3; break;
      case 4: leftArmLayer = new Assets.LeftArmPowerup4; break;
      case 5: leftArmLayer = new Assets.LeftArmPowerup5; break;
      case 6: leftArmLayer = new Assets.LeftArmPowerup6; break;
      case 7: leftArmLayer = new Assets.LeftArmPowerup7; break;
      case 8: leftArmLayer = new Assets.LeftArmPowerup8; break;
      case 9: leftArmLayer = new Assets.LeftArmPowerup9; break;
      case 10: leftArmLayer = new Assets.LeftArmPowerup10; break;	
      }
      
    leftArmLayer.scaleX = scale;
    leftArmLayer.scaleY = scale;
    Utility.center (leftArmLayer);    
    addChild (leftArmLayer);
    
    // Insert reticle layer.
    
    /*switch (owner.reticleLevel)
      {
      case 0:	
      case 1: reticleLayer = new Assets.ReticuleLevel1; break;
      case 2: reticleLayer = new Assets.ReticuleLevel2; break;
      case 3: reticleLayer = new Assets.ReticuleLevel3; break;
      case 4: reticleLayer = new Assets.ReticuleLevel4; break;
      case 5: reticleLayer = new Assets.ReticuleLevel5; break;
      case 6: reticleLayer = new Assets.ReticuleLevel6; break;
      case 7: reticleLayer = new Assets.ReticuleLevel7; break;
      case 8: reticleLayer = new Assets.ReticuleLevel8; break;
      case 9: reticleLayer = new Assets.ReticuleLevel9; break;
      case 10: reticleLayer = new Assets.ReticuleLevel10; break;	
      }*/
    
    switch (owner.playerID)
     	{
     	case 0:
     	  switch (owner.reticleLevel)
     	    {
          case 0:	
          case 1: reticleLayer = new Assets.player1reticule01; break;
          case 2: reticleLayer = new Assets.player1reticule02; break;
          case 3: reticleLayer = new Assets.player1reticule03; break;
          case 4: reticleLayer = new Assets.player1reticule04; break;
          case 5: reticleLayer = new Assets.player1reticule05; break;
          case 6: reticleLayer = new Assets.player1reticule06; break;
          case 7: reticleLayer = new Assets.player1reticule07; break;
          case 8: reticleLayer = new Assets.player1reticule08; break;
          case 9: reticleLayer = new Assets.player1reticule09; break;
          case 10: reticleLayer = new Assets.player1reticule10; break;
     	    }
     	  break;
     	case 1:
     	  switch (owner.reticleLevel)
     	    {
          case 0:	
          case 1: reticleLayer = new Assets.player2reticule01; break;
          case 2: reticleLayer = new Assets.player2reticule02; break;
          case 3: reticleLayer = new Assets.player2reticule03; break;
          case 4: reticleLayer = new Assets.player2reticule04; break;
          case 5: reticleLayer = new Assets.player2reticule05; break;
          case 6: reticleLayer = new Assets.player2reticule06; break;
          case 7: reticleLayer = new Assets.player2reticule07; break;
          case 8: reticleLayer = new Assets.player2reticule08; break;
          case 9: reticleLayer = new Assets.player2reticule09; break;
          case 10: reticleLayer = new Assets.player2reticule10; break;
     	    }
     	  break;
     	case 2:
     	  switch (owner.reticleLevel)
     	    {
          case 0:	
          case 1: reticleLayer = new Assets.player3reticule01; break;
          case 2: reticleLayer = new Assets.player3reticule02; break;
          case 3: reticleLayer = new Assets.player3reticule03; break;
          case 4: reticleLayer = new Assets.player3reticule04; break;
          case 5: reticleLayer = new Assets.player3reticule05; break;
          case 6: reticleLayer = new Assets.player3reticule06; break;
          case 7: reticleLayer = new Assets.player3reticule07; break;
          case 8: reticleLayer = new Assets.player3reticule08; break;
          case 9: reticleLayer = new Assets.player3reticule09; break;
          case 10: reticleLayer = new Assets.player3reticule10; break;
     	    }
     	  break;
     	case 3:
     	  switch (owner.reticleLevel)
     	    {
          case 0:	
          case 1: reticleLayer = new Assets.player4reticule01; break;
          case 2: reticleLayer = new Assets.player4reticule02; break;
          case 3: reticleLayer = new Assets.player4reticule03; break;
          case 4: reticleLayer = new Assets.player4reticule04; break;
          case 5: reticleLayer = new Assets.player4reticule05; break;
          case 6: reticleLayer = new Assets.player4reticule06; break;
          case 7: reticleLayer = new Assets.player4reticule07; break;
          case 8: reticleLayer = new Assets.player4reticule08; break;
          case 9: reticleLayer = new Assets.player4reticule09; break;
          case 10: reticleLayer = new Assets.player4reticule10; break;
     	    }
     	  break;
     	}
    
    Utility.center (reticleLayer);    
    // Apply color tint.
    reticleLayer.bitmapData.colorTransform(reticleLayer.bitmapData.rect, Screen.getColorTransform (owner.teamCode))    
    addChild (reticleLayer);
    
    
    // Gravity bomb layer.  
    switch(owner.shieldLevel)
      {
      case 0:
      case 1: gBombLayer = new Assets.bomb0; break;
      case 2: gBombLayer = new Assets.bomb1; break;
      case 3: gBombLayer = new Assets.bomb2; break;
      case 4: gBombLayer = new Assets.bomb3; break;
      case 5: gBombLayer = new Assets.bomb4; break;
      case 6: gBombLayer = new Assets.bomb5; break;
      case 7: gBombLayer = new Assets.bomb6; break;
      case 8: gBombLayer = new Assets.bomb7; break;
      case 9: gBombLayer = new Assets.bomb8; break;
      case 10: gBombLayer = new Assets.bomb9; break;
      }
    
    gBombLayer.scaleX = scale;
    gBombLayer.scaleY = scale;
    Utility.center (gBombLayer);    
    // Apply color tint.
    gBombLayer.bitmapData.colorTransform(gBombLayer.bitmapData.rect, Screen.getColorTransform (owner.teamCode))    
    addChild (gBombLayer);
    
    }
  
  public function refresh(owner:ShipSpec, scale:Number) : void
    // Regenerates a glamour shot with new art. Call this after the owner shipspec has changed.
    {
    unbuild();
    build(owner, scale);	
    }
  
  }

}