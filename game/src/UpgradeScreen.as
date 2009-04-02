package
{
	import Screen;
	
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import com.pixeldroid.r_c4d3.controls.ControlEvent;
	import com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl;

	public class UpgradeScreen extends Sprite
	{
		[Embed(source="..\\..\\swfs\\AssetLibrary.swf", symbol="Background")]
		private var Background:Class;

		public var Garage1:GarageMenu;
		public var Garage2:GarageMenu;
		public var Garage3:GarageMenu;
		public var Garage4:GarageMenu;
		public var garageList:Array;
		
		private var TipScroller:Tip;
		
		private var FPC:FourPlayerControl;

		private var Music:Sound = new Assets.Music_Upgrade;
		private var MusicChannel:SoundChannel = new SoundChannel;
		
		public var isExpired:Boolean; 
		private var specs:Array;
		private var upgradeAIs : Array;
		
		private var FPSDisp:FPSDisplay = new FPSDisplay;
		private var Clock:GameClock;
		
		public function UpgradeScreen(_specs:Array) : void
		{
			Clock = new GameClock(90);
			
			specs = _specs;
			
			isExpired = false;
			
			Garage1 = new GarageMenu(200, 0, specs[0]);
			Garage2 = new GarageMenu(400, 0, specs[1]);
			Garage3 = new GarageMenu(0, 0, specs[2]);
			Garage4 = new GarageMenu(600, 0, specs[3]);
			garageList = [Garage1, Garage2, Garage3, Garage4];
			
			FPC = Screen.FPC;

			TipScroller = new Tip("UpgradeScreen");
			
			addChild(new Background);
			addChild(Garage1);
			addChild(Garage2);
			addChild(Garage3);
			addChild(Garage4);
			addChild(TipScroller);

			registerListeners();
			
			MusicChannel = Music.play();
			
			// Create & attach upgradeAI's as needed.
			upgradeAIs = new Array;
		    if (specs[0].isCPUControlled)
	          upgradeAIs.push (new UpgradeAI(specs[0], Garage1) );			
	        if (specs[1].isCPUControlled)
	          upgradeAIs.push (new UpgradeAI(specs[1], Garage2) );
	        if (specs[2].isCPUControlled)			
			  upgradeAIs.push (new UpgradeAI(specs[2], Garage3) );			
			if (specs[3].isCPUControlled)			
			  upgradeAIs.push (new UpgradeAI(specs[3], Garage4) );
		}

        public function onEnterFrame () : void
        {
			//frame per second display
			FPSDisp.update();
			
			isExpired = true;	
			var deltaT:Number = 25.0 / FPSDisp.FPS;
			Clock.update(deltaT);
			
			TipScroller.scrollTip(deltaT);
			
			for (var i: Number = 0; i < upgradeAIs.length; i++)
			  upgradeAIs[i].update(deltaT);
			
			if(!Garage1.isDone)
				isExpired = false;
			if(!Garage2.isDone)
				isExpired = false;
			if(!Garage3.isDone)
				isExpired = false;
			if(!Garage4.isDone)
				isExpired = false;
				
			Garage1.upgradeFlash(deltaT);
			Garage2.upgradeFlash(deltaT);
			Garage3.upgradeFlash(deltaT);
			Garage4.upgradeFlash(deltaT);

			if(Clock.clockIsZero())
				isExpired = true;
			
			if(isExpired)
			{
				unregisterListeners();
				MusicChannel.stop();
				Clock.expire();
			}
        }

		private function registerListeners() : void
		{
			if(!specs[0].isCPUControlled)
			{
			FPC.addEventListener(ControlEvent.P1_R_PRESS,   Garage1.upgrade);
			FPC.addEventListener(ControlEvent.P1_R_RELEASE, P1Rr);
			FPC.addEventListener(ControlEvent.P1_U_PRESS,   Garage1.navigateUp);
			FPC.addEventListener(ControlEvent.P1_U_RELEASE, P1Ur);
			FPC.addEventListener(ControlEvent.P1_L_PRESS,   Garage1.downgrade);
			FPC.addEventListener(ControlEvent.P1_L_RELEASE, P1Lr);
			FPC.addEventListener(ControlEvent.P1_D_PRESS,   Garage1.navigateDown);
			FPC.addEventListener(ControlEvent.P1_D_RELEASE, P1Dr);
			FPC.addEventListener(ControlEvent.P1_X_PRESS,   P1Xp);
			FPC.addEventListener(ControlEvent.P1_X_RELEASE, P1Xr);
			FPC.addEventListener(ControlEvent.P1_A_PRESS,   P1Ap);
			FPC.addEventListener(ControlEvent.P1_A_RELEASE, P1Ar);
			FPC.addEventListener(ControlEvent.P1_B_PRESS,   P1Bp);
			FPC.addEventListener(ControlEvent.P1_B_RELEASE, P1Br);
			FPC.addEventListener(ControlEvent.P1_C_PRESS,   P1Cp);
			FPC.addEventListener(ControlEvent.P1_C_RELEASE, P1Cr);
		}
			if(!specs[1].isCPUControlled)
			{
			FPC.addEventListener(ControlEvent.P2_R_PRESS,   Garage2.upgrade);
			FPC.addEventListener(ControlEvent.P2_R_RELEASE, P2Rr);
			FPC.addEventListener(ControlEvent.P2_U_PRESS,   Garage2.navigateUp);
			FPC.addEventListener(ControlEvent.P2_U_RELEASE, P2Ur);
			FPC.addEventListener(ControlEvent.P2_L_PRESS,   Garage2.downgrade);
			FPC.addEventListener(ControlEvent.P2_L_RELEASE, P2Lr);
			FPC.addEventListener(ControlEvent.P2_D_PRESS,   Garage2.navigateDown);
			FPC.addEventListener(ControlEvent.P2_D_RELEASE, P2Dr);
			FPC.addEventListener(ControlEvent.P2_X_PRESS,   P2Xp);
			FPC.addEventListener(ControlEvent.P2_X_RELEASE, P2Xr);
			FPC.addEventListener(ControlEvent.P2_A_PRESS,   P2Ap);
			FPC.addEventListener(ControlEvent.P2_A_RELEASE, P2Ar);
			FPC.addEventListener(ControlEvent.P2_B_PRESS,   P2Bp);
			FPC.addEventListener(ControlEvent.P2_B_RELEASE, P2Br);
			FPC.addEventListener(ControlEvent.P2_C_PRESS,   P2Cp);
			FPC.addEventListener(ControlEvent.P2_C_RELEASE, P2Cr);
		}
		if(!specs[2].isCPUControlled)
		{
			FPC.addEventListener(ControlEvent.P3_R_PRESS,   Garage3.upgrade);
			FPC.addEventListener(ControlEvent.P3_R_RELEASE, P3Rr);
			FPC.addEventListener(ControlEvent.P3_U_PRESS,   Garage3.navigateUp);
			FPC.addEventListener(ControlEvent.P3_U_RELEASE, P3Ur);
			FPC.addEventListener(ControlEvent.P3_L_PRESS,   Garage3.downgrade);
			FPC.addEventListener(ControlEvent.P3_L_RELEASE, P3Lr);
			FPC.addEventListener(ControlEvent.P3_D_PRESS,   Garage3.navigateDown);
			FPC.addEventListener(ControlEvent.P3_D_RELEASE, P3Dr);
			FPC.addEventListener(ControlEvent.P3_X_PRESS,   P3Xp);
			FPC.addEventListener(ControlEvent.P3_X_RELEASE, P3Xr);
			FPC.addEventListener(ControlEvent.P3_A_PRESS,   P3Ap);
			FPC.addEventListener(ControlEvent.P3_A_RELEASE, P3Ar);
			FPC.addEventListener(ControlEvent.P3_B_PRESS,   P3Bp);
			FPC.addEventListener(ControlEvent.P3_B_RELEASE, P3Br);
			FPC.addEventListener(ControlEvent.P3_C_PRESS,   P3Cp);
			FPC.addEventListener(ControlEvent.P3_C_RELEASE, P3Cr);
		}
		if(!specs[3].isCPUControlled)
		{
			FPC.addEventListener(ControlEvent.P4_R_PRESS,   Garage4.upgrade);
			FPC.addEventListener(ControlEvent.P4_R_RELEASE, P4Rr);
			FPC.addEventListener(ControlEvent.P4_U_PRESS,   Garage4.navigateUp);
			FPC.addEventListener(ControlEvent.P4_U_RELEASE, P4Ur);
			FPC.addEventListener(ControlEvent.P4_L_PRESS,   Garage4.downgrade);
			FPC.addEventListener(ControlEvent.P4_L_RELEASE, P4Lr);
			FPC.addEventListener(ControlEvent.P4_D_PRESS,   Garage4.navigateDown);
			FPC.addEventListener(ControlEvent.P4_D_RELEASE, P4Dr);
			FPC.addEventListener(ControlEvent.P4_X_PRESS,   P4Xp);
			FPC.addEventListener(ControlEvent.P4_X_RELEASE, P4Xr);
			FPC.addEventListener(ControlEvent.P4_A_PRESS,   P4Ap);
			FPC.addEventListener(ControlEvent.P4_A_RELEASE, P4Ar);
			FPC.addEventListener(ControlEvent.P4_B_PRESS,   P4Bp);
			FPC.addEventListener(ControlEvent.P4_B_RELEASE, P4Br);
			FPC.addEventListener(ControlEvent.P4_C_PRESS,   P4Cp);
			FPC.addEventListener(ControlEvent.P4_C_RELEASE, P4Cr);
		}
		}
		
		private function unregisterListeners() : void
		{
			if(!specs[0].isCPUControlled)
			{
			FPC.removeEventListener(ControlEvent.P1_R_PRESS,   Garage1.upgrade);
			FPC.removeEventListener(ControlEvent.P1_R_RELEASE, P1Rr);
			FPC.removeEventListener(ControlEvent.P1_U_PRESS,   Garage1.navigateUp);
			FPC.removeEventListener(ControlEvent.P1_U_RELEASE, P1Ur);
			FPC.removeEventListener(ControlEvent.P1_L_PRESS,   Garage1.downgrade);
			FPC.removeEventListener(ControlEvent.P1_L_RELEASE, P1Lr);
			FPC.removeEventListener(ControlEvent.P1_D_PRESS,   Garage1.navigateDown);
			FPC.removeEventListener(ControlEvent.P1_D_RELEASE, P1Dr);
			FPC.removeEventListener(ControlEvent.P1_X_PRESS,   P1Xp);
			FPC.removeEventListener(ControlEvent.P1_X_RELEASE, P1Xr);
			FPC.removeEventListener(ControlEvent.P1_A_PRESS,   P1Ap);
			FPC.removeEventListener(ControlEvent.P1_A_RELEASE, P1Ar);
			FPC.removeEventListener(ControlEvent.P1_B_PRESS,   P1Bp);
			FPC.removeEventListener(ControlEvent.P1_B_RELEASE, P1Br);
			FPC.removeEventListener(ControlEvent.P1_C_PRESS,   P1Cp);
			FPC.removeEventListener(ControlEvent.P1_C_RELEASE, P1Cr);
			}
		if(!specs[1].isCPUControlled)
		{
			FPC.removeEventListener(ControlEvent.P2_R_PRESS,   Garage2.upgrade);
			FPC.removeEventListener(ControlEvent.P2_R_RELEASE, P2Rr);
			FPC.removeEventListener(ControlEvent.P2_U_PRESS,   Garage2.navigateUp);
			FPC.removeEventListener(ControlEvent.P2_U_RELEASE, P2Ur);
			FPC.removeEventListener(ControlEvent.P2_L_PRESS,   Garage2.downgrade);
			FPC.removeEventListener(ControlEvent.P2_L_RELEASE, P2Lr);
			FPC.removeEventListener(ControlEvent.P2_D_PRESS,   Garage2.navigateDown);
			FPC.removeEventListener(ControlEvent.P2_D_RELEASE, P2Dr);
			FPC.removeEventListener(ControlEvent.P2_X_PRESS,   P2Xp);
			FPC.removeEventListener(ControlEvent.P2_X_RELEASE, P2Xr);
			FPC.removeEventListener(ControlEvent.P2_A_PRESS,   P2Ap);
			FPC.removeEventListener(ControlEvent.P2_A_RELEASE, P2Ar);
			FPC.removeEventListener(ControlEvent.P2_B_PRESS,   P2Bp);
			FPC.removeEventListener(ControlEvent.P2_B_RELEASE, P2Br);
			FPC.removeEventListener(ControlEvent.P2_C_PRESS,   P2Cp);
			FPC.removeEventListener(ControlEvent.P2_C_RELEASE, P2Cr);
		}
		if(!specs[2].isCPUControlled)
		{
			FPC.removeEventListener(ControlEvent.P3_R_PRESS,   Garage3.upgrade);
			FPC.removeEventListener(ControlEvent.P3_R_RELEASE, P3Rr);
			FPC.removeEventListener(ControlEvent.P3_U_PRESS,   Garage3.navigateUp);
			FPC.removeEventListener(ControlEvent.P3_U_RELEASE, P3Ur);
			FPC.removeEventListener(ControlEvent.P3_L_PRESS,   Garage3.downgrade);
			FPC.removeEventListener(ControlEvent.P3_L_RELEASE, P3Lr);
			FPC.removeEventListener(ControlEvent.P3_D_PRESS,   Garage3.navigateDown);
			FPC.removeEventListener(ControlEvent.P3_D_RELEASE, P3Dr);
			FPC.removeEventListener(ControlEvent.P3_X_PRESS,   P3Xp);
			FPC.removeEventListener(ControlEvent.P3_X_RELEASE, P3Xr);
			FPC.removeEventListener(ControlEvent.P3_A_PRESS,   P3Ap);
			FPC.removeEventListener(ControlEvent.P3_A_RELEASE, P3Ar);
			FPC.removeEventListener(ControlEvent.P3_B_PRESS,   P3Bp);
			FPC.removeEventListener(ControlEvent.P3_B_RELEASE, P3Br);
			FPC.removeEventListener(ControlEvent.P3_C_PRESS,   P3Cp);
			FPC.removeEventListener(ControlEvent.P3_C_RELEASE, P3Cr);
		}
		if(!specs[3].isCPUControlled)
		{
			FPC.removeEventListener(ControlEvent.P4_R_PRESS,   Garage4.upgrade);
			FPC.removeEventListener(ControlEvent.P4_R_RELEASE, P4Rr);
			FPC.removeEventListener(ControlEvent.P4_U_PRESS,   Garage4.navigateUp);
			FPC.removeEventListener(ControlEvent.P4_U_RELEASE, P4Ur);
			FPC.removeEventListener(ControlEvent.P4_L_PRESS,   Garage4.downgrade);
			FPC.removeEventListener(ControlEvent.P4_L_RELEASE, P4Lr);
			FPC.removeEventListener(ControlEvent.P4_D_PRESS,   Garage4.navigateDown);
			FPC.removeEventListener(ControlEvent.P4_D_RELEASE, P4Dr);
			FPC.removeEventListener(ControlEvent.P4_X_PRESS,   P4Xp);
			FPC.removeEventListener(ControlEvent.P4_X_RELEASE, P4Xr);
			FPC.removeEventListener(ControlEvent.P4_A_PRESS,   P4Ap);
			FPC.removeEventListener(ControlEvent.P4_A_RELEASE, P4Ar);
			FPC.removeEventListener(ControlEvent.P4_B_PRESS,   P4Bp);
			FPC.removeEventListener(ControlEvent.P4_B_RELEASE, P4Br);
			FPC.removeEventListener(ControlEvent.P4_C_PRESS,   P4Cp);
			FPC.removeEventListener(ControlEvent.P4_C_RELEASE, P4Cr);
		}
		}
		
		private function P1Rp(e:ControlEvent):void {  }
		private function P1Rr(e:ControlEvent):void {  }
		private function P1Up(e:ControlEvent):void {  }
		private function P1Ur(e:ControlEvent):void {  }
		private function P1Lp(e:ControlEvent):void {  }
		private function P1Lr(e:ControlEvent):void {  }
		private function P1Dp(e:ControlEvent):void {  }
		private function P1Dr(e:ControlEvent):void {  }
		private function P1Xp(e:ControlEvent):void {  }
		private function P1Xr(e:ControlEvent):void {  }
		private function P1Ap(e:ControlEvent):void {  }
		private function P1Ar(e:ControlEvent):void {  }
		private function P1Bp(e:ControlEvent):void {  }
		private function P1Br(e:ControlEvent):void {  }
		private function P1Cp(e:ControlEvent):void {  }
		private function P1Cr(e:ControlEvent):void {  }

		private function P2Rp(e:ControlEvent):void {  }
		private function P2Rr(e:ControlEvent):void {  }
		private function P2Up(e:ControlEvent):void {  }
		private function P2Ur(e:ControlEvent):void {  }
		private function P2Lp(e:ControlEvent):void {  }
		private function P2Lr(e:ControlEvent):void {  }
		private function P2Dp(e:ControlEvent):void {  }
		private function P2Dr(e:ControlEvent):void {  }
		private function P2Xp(e:ControlEvent):void {  }
		private function P2Xr(e:ControlEvent):void {  }
		private function P2Ap(e:ControlEvent):void {  }
		private function P2Ar(e:ControlEvent):void {  }
		private function P2Bp(e:ControlEvent):void {  }
		private function P2Br(e:ControlEvent):void {  }
		private function P2Cp(e:ControlEvent):void {  }
		private function P2Cr(e:ControlEvent):void {  }

		private function P3Rp(e:ControlEvent):void {  }
		private function P3Rr(e:ControlEvent):void {  }
		private function P3Up(e:ControlEvent):void {  }
		private function P3Ur(e:ControlEvent):void {  }
		private function P3Lp(e:ControlEvent):void {  }
		private function P3Lr(e:ControlEvent):void {  }
		private function P3Dp(e:ControlEvent):void {  }
		private function P3Dr(e:ControlEvent):void {  }
		private function P3Xp(e:ControlEvent):void {  }
		private function P3Xr(e:ControlEvent):void {  }
		private function P3Ap(e:ControlEvent):void {  }
		private function P3Ar(e:ControlEvent):void {  }
		private function P3Bp(e:ControlEvent):void {  }
		private function P3Br(e:ControlEvent):void {  }
		private function P3Cp(e:ControlEvent):void {  }
		private function P3Cr(e:ControlEvent):void {  }

		private function P4Rp(e:ControlEvent):void {  }
		private function P4Rr(e:ControlEvent):void {  }
		private function P4Up(e:ControlEvent):void {  }
		private function P4Ur(e:ControlEvent):void {  }
		private function P4Lp(e:ControlEvent):void {  }
		private function P4Lr(e:ControlEvent):void {  }
		private function P4Dp(e:ControlEvent):void {  }
		private function P4Dr(e:ControlEvent):void {  }
		private function P4Xp(e:ControlEvent):void {  }
		private function P4Xr(e:ControlEvent):void {  }
		private function P4Ap(e:ControlEvent):void {  }
		private function P4Ar(e:ControlEvent):void {  }
		private function P4Bp(e:ControlEvent):void {  }
		private function P4Br(e:ControlEvent):void {  }
		private function P4Cp(e:ControlEvent):void {  }
		private function P4Cr(e:ControlEvent):void {  }
	}
}