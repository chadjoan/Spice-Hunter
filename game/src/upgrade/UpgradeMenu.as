package upgrade
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import Assets;
	import Debouncer;

  import upgrade.Upgrade;

	//shield = bomb
	
	public class UpgradeMenu extends Sprite
	{

    [Embed(source="../../swfs/AssetLibrary.swf", symbol="Highlight")]
    private var MenuMov:Class;
    private var Menu:MovieClip = new MenuMov;

    [Embed(source="../../swfs/AssetLibrary.swf", symbol="ColorBG")]
    private var ColorMov:Class;
    private var Team:MovieClip = new ColorMov;

    [Embed(source="../../swfs/AssetLibrary.swf", symbol="done")]
    private var DoneMov:Class;
    private var Done:MovieClip = new DoneMov;

    [Embed(source="../../swfs/AssetLibrary.swf", symbol="text")]
    private var LabelImg:Class;
    private var Label:MovieClip = new LabelImg;

    [Embed(source="../../swfs/AssetLibrary.swf", symbol="arrowGra")]
		private var ArrowMov:Class;
		private var LeftArrow:MovieClip = new ArrowMov;
		private var RightArrow:MovieClip = new ArrowMov;
		public var LArrowFlash:MovieClip = new ArrowMov;
		public var RArrowFlash:MovieClip = new ArrowMov;
		
		public var Border:Bitmap = new Assets.selectionBorder;
		
		private var LeaveAmtTxt:TextField = new TextField;
		private var WordFormat:TextFormat;
		private var NumberFormat:TextFormat;

		private var Attract:Upgrade;
		private var Repel:Upgrade;
		private var Reticle:Upgrade;
		private var Tether:Upgrade;
		private var Shield:Upgrade;

		private var items:Array;

		public var attractPrice:Array;
		public var repelPrice:Array;
		public var reticlePrice:Array;
		public var tetherPrice:Array;
		public var shieldPrice:Array;

		public var selection:Number;
		private var enterAmt:Number;
		private var amtDue:Number;
		public var leaveAmt:Number;
		
		private var teamNo:Number;
		private var specs:ShipSpec;
        public var isDone:Boolean;
        private var gs:GlamourShot;
 
		private var leftArrow:Boolean;
		
		private var debouncer:Debouncer;
		
		public function UpgradeMenu(xOffset:Number, yOffset:Number, _specs:ShipSpec)
		{
			specs = _specs;
			x = xOffset;
			y = yOffset;
			leftArrow = true;
			isDone = false;
			
			debouncer = new Debouncer;
			
			WordFormat = new TextFormat(null, 18, 0xEEEEEE, true);
			WordFormat.font = null;
			NumberFormat = new TextFormat(null, 18, 0xEEEEEE, true, null, null, null, null, "center");
			NumberFormat.font = "number";
			
			attractPrice = [-1, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, -1];
			repelPrice = [-1, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, -1];
			reticlePrice = [-1, 80, 160, 240, 320, 400, 480, 560, 640, 720, 800, -1];
			tetherPrice = [-1, 80, 160, 240, 320, 400, 480, 560, 640, 720, 800, -1];
			shieldPrice = [-1, 100, 300, 300, 300, 300, 500, 500, 500, 500, 500, -1];

			// don't know why the x and y coordinates need to be half of what they should be
			Attract = new Upgrade("Attract", attractPrice, 5, 120, specs.gravityLevel);
			Repel = new Upgrade("Repel", repelPrice, 5, 145, specs.repelLevel);
			Reticle = new Upgrade("Reticle", reticlePrice, 5, 170, specs.reticleLevel);
			Tether = new Upgrade("Tether", tetherPrice, 5, 195, specs.tetherLevel);
			Shield = new Upgrade("Shield", shieldPrice, 5, 220, specs.shieldLevel);
			items = [Attract, Repel, Reticle, Tether, Shield];

			selection = 0;
			enterAmt = specs.accountBalance;
			amtDue = 0;
			leaveAmt = specs.accountBalance;			
			
			teamNo = specs.teamCode;
			gs = new GlamourShot(specs,1.0);
			gs.x = 100;
			gs.y = 65;
			addChild(gs);
			
			setupMenu();
			
			Border.alpha = 0.3;
			addChild(Border);
			
			Label.x = 50;
			Label.y = 230;
			addChild(Label);
		}

		private function setupMenu() : void
		{
			switch(teamNo)
			{
				case 0: Team.gotoAndStop("red"); break;
				case 1: Team.gotoAndStop("blue"); break;
				case 2: Team.gotoAndStop("yellow"); break;
				case 3: Team.gotoAndStop("green"); break;
				default: break;
			}
			addChild(Team);
			
			Menu.gotoAndStop("attract");
			Menu.y = 230;
			addChild(Menu);
			
			addChild(Attract);
			addChild(Repel);
			addChild(Reticle);
			addChild(Tether);
			addChild(Shield);
			
			items[selection].lightArrows();
			
			LeaveAmtTxt.text = String(leaveAmt);
			LeaveAmtTxt.x = 50;
			LeaveAmtTxt.y = 507;
			LeaveAmtTxt.embedFonts = true;
			LeaveAmtTxt.setTextFormat(NumberFormat);
			LeaveAmtTxt.selectable = false;
			addChild(LeaveAmtTxt);
			
			Done.gotoAndStop("notDone");
			Done.x = 50;
			Done.y = 538;
			addChild(Done);
			
			LeftArrow.gotoAndStop("inactive");
			LeftArrow.rotation = 180;
			LeftArrow.scaleX = 1.5;
			LeftArrow.scaleY = 1.5;
			LeftArrow.x = 45;
			LeftArrow.y = 561;
			
			RightArrow.gotoAndStop("inactive");
			RightArrow.scaleX = 1.5;
			RightArrow.scaleY = 1.5;
			RightArrow.x = 155;
			RightArrow.y = 541;

			LArrowFlash.gotoAndStop("highlight");
			LArrowFlash.rotation = 180;
			LArrowFlash.scaleX = 1.5;
			LArrowFlash.scaleY = 1.5;
			LArrowFlash.x = 45;
			LArrowFlash.y = 561;
			LArrowFlash.alpha = 0.1;
			
			RArrowFlash.gotoAndStop("highlight");
			RArrowFlash.scaleX = 1.5;
			RArrowFlash.scaleY = 1.5;
			RArrowFlash.x = 155;
			RArrowFlash.y = 541;
			RArrowFlash.alpha = 0.1;
			
			addChild(LeftArrow);
			addChild(RightArrow);
			addChild(LArrowFlash);
			addChild(RArrowFlash);
		}

		private function updateText() : void
		{
			amtDue = 0;
			leaveAmt = enterAmt;

			for(var i:Number = 0; i < items.length; i++)
			{
				amtDue = amtDue + items[i].currentCost;	
			}

			leaveAmt = leaveAmt - amtDue;
			specs.accountBalance = leaveAmt;
			LeaveAmtTxt.text = String(leaveAmt);
			LeaveAmtTxt.setTextFormat(NumberFormat);
		}

		public function navigateUp() : void
		{
		  if(!debouncer.debounced())
		    return;
		  else
		    debouncer.setLastEventTime();
		  
			if(!isDone)
			{
				// dull the upgrade arrow pair and stop flashing before moving on
				if(selection != 5)
					items[selection].dullArrows();
				
				switch(selection)
				{
					case 0: Menu.gotoAndStop("done"); selection = 5; break;
					case 1: Menu.gotoAndStop("attract"); selection = 0; break;
					case 2: Menu.gotoAndStop("repel"); selection = 1; break;
					case 3: Menu.gotoAndStop("reticle"); selection = 2; break;
					case 4: Menu.gotoAndStop("tether"); selection = 3; break;
					case 5: Menu.gotoAndStop("shield"); selection = 4; break;
					default: break;
				}
			
				// brighten the new upgrade arrow pair and start flashing
				if(selection != 5)
					items[selection].lightArrows();
				
				Utility.playSound(Assets.menuScroll);
			}
		}
		
		public function navigateDown() : void
		{
		  if(!debouncer.debounced())
		    return;
		  else
		    debouncer.setLastEventTime();
		  
			if(!isDone)
			{
				// dull the upgrade arrow pair and stop flashing before moving on
				if(selection != 5)
					items[selection].dullArrows();
				
				switch(selection)
				{
					case 0: Menu.gotoAndStop("repel"); selection = 1; break;
					case 1: Menu.gotoAndStop("reticle"); selection = 2; break;
					case 2: Menu.gotoAndStop("tether"); selection = 3; break;
					case 3: Menu.gotoAndStop("shield"); selection = 4; break;
					case 4: Menu.gotoAndStop("done"); selection = 5; break;
					case 5: Menu.gotoAndStop("attract"); selection = 0; break;
					default: break;
				}

				// brighten the new upgrade arrow pair and start flashing
				if(selection != 5)
					items[selection].lightArrows();
					
				Utility.playSound(Assets.menuScroll);
			}
		}	
	
		public function upgrade() : void
		{
		  if(!debouncer.debounced())
		    return;
		  else
		    debouncer.setLastEventTime();
		  
			if(selection == 5)
			{
				RArrowFlash.alpha = 1.0;
				
				if(isDone == true)
				{
					Done.gotoAndStop("notDone");
					isDone = false;
				}
				else if(isDone == false)
				{
					Done.gotoAndStop("done");
					isDone = true;
				}
			}
			else
			{
				Border.alpha = 1.0;
				items[selection].RArrowFlash.alpha = 1.0;

				if(items[selection].level != 10)
				{
					items[selection].lightArrows();
					
					// Can we afford this upgrade? 
					var canBeAfforded:Boolean;
					switch(selection)
					  {
					  case 0: canBeAfforded = (leaveAmt >= attractPrice[items[selection].level+1]) ; break;	
					  case 1: canBeAfforded = (leaveAmt >= repelPrice[items[selection].level+1]) ; break;
					  case 2: canBeAfforded = (leaveAmt >= reticlePrice[items[selection].level+1]) ; break;
					  case 3: canBeAfforded = (leaveAmt >= tetherPrice[items[selection].level+1]) ; break;
					  case 4: canBeAfforded = (leaveAmt >= shieldPrice[items[selection].level+1]) ; break;	
					  }
					if (!canBeAfforded)
					  {
					  Utility.playSound (Assets.Buzz );
					  return;
					  }
					Utility.playSound (Assets.menuRight );
					
					items[selection].update(items[selection].level + 1);
					switch (selection)
					  {
					  case 0: specs.gravityLevel += 1; break;	
					  case 1: specs.repelLevel += 1; break;
					  case 2: specs.reticleLevel += 1; break;
					  case 3: specs.tetherLevel += 1; break;
					  case 4: specs.shieldLevel += 1; break;	
					  }
					updateText();
					gs.refresh(specs,1.0);
				}
			}
		}

		public function downgrade() : void
		{
		  if(!debouncer.debounced())
		    return;
		  else
		    debouncer.setLastEventTime();
		  
			if(selection == 5)
			{
				LArrowFlash.alpha = 1.0;
				
				if(isDone == true)
				{
					Done.gotoAndStop("notDone");
					isDone = false;
				}
				else if(isDone == false)
				{
					Done.gotoAndStop("done");
					isDone = true;
				}
			}
			else
			{
				Border.alpha = 1.0;
				items[selection].LArrowFlash.alpha = 1.0;
				
				if(items[selection].level != 1)
				{
					items[selection].lightArrows();
					
					Utility.playSound (Assets.menuLeft );
					items[selection].update(items[selection].level - 1);
					switch (selection)
					  {
					  case 0: specs.gravityLevel -= 1; break;	
					  case 1: specs.repelLevel -= 1; break;
					  case 2: specs.reticleLevel -= 1; break;
					  case 3: specs.tetherLevel -= 1; break;
					  case 4: specs.shieldLevel -= 1; break;	
					  }					
					updateText();
					gs.refresh(specs,1.0);
				}
			}
		}
		
		public function upgradeFlash(dt:Number) : void
		{
			if(Border.alpha < 0.3)
				Border.alpha = 0.3;
			else
				Border.alpha-=0.05;
			
			if(selection == 5)
			{
				if(LArrowFlash.alpha < 0.1)
					LArrowFlash.alpha = 0.1;
				else
					LArrowFlash.alpha-=0.05;
					
				if(RArrowFlash.alpha < 0.1)
					RArrowFlash.alpha = 0.1;
				else
					RArrowFlash.alpha-=0.05;
			}
			else
			{
				if(items[selection].LArrowFlash.alpha < 0.1)
					items[selection].LArrowFlash.alpha = 0.1;
				else
					items[selection].LArrowFlash.alpha-=0.05;
				
				if(items[selection].RArrowFlash.alpha < 0.1)
					items[selection].RArrowFlash.alpha = 0.1;
				else
					items[selection].RArrowFlash.alpha-=0.05;
			}
		}
	
	}
}