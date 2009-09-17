package upgrade
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import Assets;
	
	public class Upgrade extends Sprite
	{
    [Embed(source="../../swfs/AssetLibrary.swf", symbol="Bar_mc")]
    private var BarMov:Class;
    private var Bar:MovieClip = new BarMov;

    [Embed(source="../../swfs/AssetLibrary.swf", symbol="arrowGra")]
		private var ArrowMov:Class;
		private var LeftArrow:MovieClip = new ArrowMov;
		private var RightArrow:MovieClip = new ArrowMov;
		public var LArrowFlash:MovieClip = new ArrowMov;
		public var RArrowFlash:MovieClip = new ArrowMov;

		private var BuyPrice:TextField = new TextField;
		private var SellPrice:TextField = new TextField;
		private var RightJustify:TextFormat;
		private var LeftJustify:TextFormat;
		
		private var barPosition:String;
		private var total:Number;
		private var originalLvl:Number;
		private var lvl:Number;
		private var c:Array;
		
		public function Upgrade(name:String, prices:Array, xPos:Number, yPos:Number, currentLevel:Number)
		{
			x = xPos;
			y = yPos;
			total = 0;
			if(currentLevel == 0)
				currentLevel = 1;
			originalLvl = currentLevel;
			lvl = currentLevel;
			c = prices;
			barPosition = "a" + String(lvl);

			RightJustify = new TextFormat(null, 14, 0xEEEEEE, true, null, null, null, null, "right");
			RightJustify.font = "number";
			LeftJustify = new TextFormat(null, 14, 0xEEEEEE, true, null, null, null, null, "left");
			LeftJustify.font = "number";
			
			if(c[lvl] == -1)
				SellPrice.text = "N/A";
			else
				SellPrice.text = String(c[lvl]);
			SellPrice.x = x - 4;
			SellPrice.y = y - 3;
			SellPrice.embedFonts = true;
			SellPrice.selectable = false;
			SellPrice.setTextFormat(LeftJustify);
			
			if(c[lvl+1] == -1)
				BuyPrice.text = "N/A";
			else
				BuyPrice.text = String(c[lvl+1]);
			BuyPrice.x = x + 84;
			BuyPrice.y = y - 3;
			BuyPrice.embedFonts = true;
			BuyPrice.selectable = false;
			BuyPrice.setTextFormat(RightJustify);

			Bar.gotoAndStop(barPosition);
			Bar.scaleX = .30;
			Bar.scaleY = .35;
			Bar.x = x + 13;
			Bar.y = y + 17;
		
			LeftArrow.gotoAndStop("inactive");
			LeftArrow.rotation = 180;
			LeftArrow.x = x + 10;
			LeftArrow.y = y + 32;
			
			RightArrow.gotoAndStop("inactive");
			RightArrow.x = x + 169;
			RightArrow.y = y + 19;

			LArrowFlash.gotoAndStop("highlight");
			LArrowFlash.rotation = 180;
			LArrowFlash.x = x + 10;
			LArrowFlash.y = y + 32;
			LArrowFlash.alpha = 0.1;
			
			RArrowFlash.gotoAndStop("highlight");
			RArrowFlash.x = x + 169;
			RArrowFlash.y = y + 19;
			RArrowFlash.alpha = 0.1;
			
			addChild(SellPrice);
			addChild(BuyPrice);
			addChild(Bar);
			addChild(LeftArrow);
			addChild(LArrowFlash);
			addChild(RightArrow);
			addChild(RArrowFlash);
		}

		public function get currentCost() : Number
		{
			return total;
		}

		public function get level() : Number
		{
			return lvl;
		}

		public function dullArrows() : void
		{
			LeftArrow.gotoAndStop("inactive");
			RightArrow.gotoAndStop("inactive");
		}

		//public function flashArrows(dt:Number) : void
		//{		}
		
		public function lightArrows() : void
		{
			LeftArrow.gotoAndStop("active");
			RightArrow.gotoAndStop("active");
		}
		
		public function update(level:Number) : void
		{
			if(level == originalLvl)
			{
				total = 0;
			}
			else
			{
				if(level < lvl)
				{
					// this upgrade was decreased
					total = total - c[lvl];
				}
				else // this upgrade was increased
				{
					total = total + c[level];
				}
			}
			
			lvl = level;

			SellPrice.text = String(c[lvl]);
			if(c[lvl] == -1)
				SellPrice.text = "N/A";
			SellPrice.setTextFormat(LeftJustify);
			
			BuyPrice.text = String(c[lvl+1]);
			if(c[lvl+1] == -1)
				BuyPrice.text = "N/A";
			BuyPrice.setTextFormat(RightJustify);
		
			barPosition = "a" + String(lvl);
			Bar.gotoAndStop(barPosition);
		}
	}
}