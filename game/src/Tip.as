package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import Assets
	
	public class Tip extends Sprite
	{
		private var LiveTipTxt:TextField = new TextField;
		private var Format:TextFormat;

		private var liveTip:String;

		private var tip:Array;
		private var speed:Number;
		
		private var ScrollArea:Rectangle;
		
		public function Tip(tipSet:String) : void
		{
			if(tipSet == "UpgradeScreen")
			{
				tip = ["Downgrading a part returns money equal to the original purchase price.",
					"Your attract and repel beams can be at different strengths.",
					"Make sure your tether is strong enough to resist being snapped by your opponents!",
					"Remember to keep the next stage in mind when you're choosing upgrades.",
					"You get a bonus for merging spice while it's on your tether.",
					"Slinging spice into your base from a distance nets you a bonus.",
					"Gravity bombs can be used to herd spice together quickly.",
					"There are more bonuses than just those listed here.  Discover them all!",
					"Rock-like entities!!",
					"Though you may be on a team, your share of the bounty is higher when spice enters your own base...",
					"You can earn additional bonus points for winning the round.",
					"The gravity bomb upgrade gives you more bombs but does not make them more powerful."];
			}
			else if(tipSet == "JoinUp")
			{
				tip = ["Choose you team by selecting a color.",
					"Up to four players can be on the same team.",
					"Choose a player type by selecting 'Robot' or 'Human'.",
					"Robot players are computer controlled.",
					"Human players are user controlled.                                   (Imagine that.)"];
			}
			
			liveTip = randomTip();

			speed = 5;
			
			Format = new TextFormat(null, 20, 0x000000, true);
			Format.indent = 800;
			Format.font = "title";
			
			ScrollArea = new Rectangle(0, 0, 800, 50);
			
			LiveTipTxt.text = liveTip;
			LiveTipTxt.x = 0;
			LiveTipTxt.y = 573;
			LiveTipTxt.scrollRect = ScrollArea;
			LiveTipTxt.embedFonts = true;
			LiveTipTxt.setTextFormat(Format);
			LiveTipTxt.width = 1500;
			addChild(LiveTipTxt);
		}

		public function randomTip() : String
		{
			// Get a level.
			var i : Number = Math.round ( Math.random() * tip.length );
			if(i == tip.length) 
				i = 0;                        
			return tip[i];
		}

		// Scrolls Tip text by:
		// -formatting with an indent of 800 pixels, decrease until 0
		// -when it's 0, increase scroll rectangle position until text has passed
		// -choose another random tip and reset
		public function scrollTip(dt:Number) : void
		{
			if(Format.indent <= 0)
			{
				if(ScrollArea.x <= LiveTipTxt.textWidth)
				{
					ScrollArea.x = ScrollArea.x + speed * dt;
					LiveTipTxt.scrollRect = ScrollArea;
				}
				else
				{
					Format.indent = 800;
					ScrollArea.x = 0;
					LiveTipTxt.scrollRect = ScrollArea;
					LiveTipTxt.text = randomTip();
					LiveTipTxt.setTextFormat(Format);
				}
			}
			else
			{
				Format.indent = Number(Format.indent) - 8 * dt;
				LiveTipTxt.setTextFormat(Format);
			}
		}
	}
}