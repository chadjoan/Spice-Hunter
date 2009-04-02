
package com.pixeldroid.r_c4d3.controls.fourplayer {

	import flash.display.Stage;
	import flash.display.Sprite;

	import com.pixeldroid.r_c4d3.controls.ControlEvent;
	import com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl;


	/**
	* <code>FourPlayerControlListener</code> encapsulates the event hookups to <code>FourPlayerControl</code>,
	* to provide a convenient base class for control integration.
	*
	* Sub classes can override only the methods they wish make use of, and needn't worry about hooking up events.
	*
	* @example The following code shows a subclass of <code>FourPlayerControlListener</code>
	* overriding the Player1 joystick right press (<em>P1Rp</em>) event handler:
	* <listing version="3.0" >
	* package {
	*    import com.pixeldroid.r_c4d3.controls.ControlEvent;
	*    import com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControlListener;
	*
	*    public class MyControlEventHandler extends FourPlayerControlListener {
	*       public function MyControlEventHandler() {
	*          super();
	*       }
	*       protected override function P1Rp(e:ControlEvent):void {
	* 	         // event handling code here
	*       }
	*    }
	* }
	* </listing>
	*
	* @see com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl
	*/
	public class FourPlayerControlListener extends Sprite {
		
		private var connected:Boolean;


		/**
		* Create a new <code>FourPlayerControlListener</code>.
		*/
		public function FourPlayerControlListener() {
			super();
			connect();
		}
		
		/**
		* Connect listeners to the <code>FourPlayerControlListener</code>.
		*/
		public function connect():void {
			if (connected) { return; }
			
			var FPC:FourPlayerControl = FourPlayerControl.instance;			
			FPC.addEventListener(ControlEvent.P1_R_PRESS,   P1Rp);
			FPC.addEventListener(ControlEvent.P1_R_RELEASE, P1Rr);
			FPC.addEventListener(ControlEvent.P1_U_PRESS,   P1Up);
			FPC.addEventListener(ControlEvent.P1_U_RELEASE, P1Ur);
			FPC.addEventListener(ControlEvent.P1_L_PRESS,   P1Lp);
			FPC.addEventListener(ControlEvent.P1_L_RELEASE, P1Lr);
			FPC.addEventListener(ControlEvent.P1_D_PRESS,   P1Dp);
			FPC.addEventListener(ControlEvent.P1_D_RELEASE, P1Dr);
			FPC.addEventListener(ControlEvent.P1_X_PRESS,   P1Xp);
			FPC.addEventListener(ControlEvent.P1_X_RELEASE, P1Xr);
			FPC.addEventListener(ControlEvent.P1_A_PRESS,   P1Ap);
			FPC.addEventListener(ControlEvent.P1_A_RELEASE, P1Ar);
			FPC.addEventListener(ControlEvent.P1_B_PRESS,   P1Bp);
			FPC.addEventListener(ControlEvent.P1_B_RELEASE, P1Br);
			FPC.addEventListener(ControlEvent.P1_C_PRESS,   P1Cp);
			FPC.addEventListener(ControlEvent.P1_C_RELEASE, P1Cr);

			FPC.addEventListener(ControlEvent.P2_R_PRESS,   P2Rp);
			FPC.addEventListener(ControlEvent.P2_R_RELEASE, P2Rr);
			FPC.addEventListener(ControlEvent.P2_U_PRESS,   P2Up);
			FPC.addEventListener(ControlEvent.P2_U_RELEASE, P2Ur);
			FPC.addEventListener(ControlEvent.P2_L_PRESS,   P2Lp);
			FPC.addEventListener(ControlEvent.P2_L_RELEASE, P2Lr);
			FPC.addEventListener(ControlEvent.P2_D_PRESS,   P2Dp);
			FPC.addEventListener(ControlEvent.P2_D_RELEASE, P2Dr);
			FPC.addEventListener(ControlEvent.P2_X_PRESS,   P2Xp);
			FPC.addEventListener(ControlEvent.P2_X_RELEASE, P2Xr);
			FPC.addEventListener(ControlEvent.P2_A_PRESS,   P2Ap);
			FPC.addEventListener(ControlEvent.P2_A_RELEASE, P2Ar);
			FPC.addEventListener(ControlEvent.P2_B_PRESS,   P2Bp);
			FPC.addEventListener(ControlEvent.P2_B_RELEASE, P2Br);
			FPC.addEventListener(ControlEvent.P2_C_PRESS,   P2Cp);
			FPC.addEventListener(ControlEvent.P2_C_RELEASE, P2Cr);

			FPC.addEventListener(ControlEvent.P3_R_PRESS,   P3Rp);
			FPC.addEventListener(ControlEvent.P3_R_RELEASE, P3Rr);
			FPC.addEventListener(ControlEvent.P3_U_PRESS,   P3Up);
			FPC.addEventListener(ControlEvent.P3_U_RELEASE, P3Ur);
			FPC.addEventListener(ControlEvent.P3_L_PRESS,   P3Lp);
			FPC.addEventListener(ControlEvent.P3_L_RELEASE, P3Lr);
			FPC.addEventListener(ControlEvent.P3_D_PRESS,   P3Dp);
			FPC.addEventListener(ControlEvent.P3_D_RELEASE, P3Dr);
			FPC.addEventListener(ControlEvent.P3_X_PRESS,   P3Xp);
			FPC.addEventListener(ControlEvent.P3_X_RELEASE, P3Xr);
			FPC.addEventListener(ControlEvent.P3_A_PRESS,   P3Ap);
			FPC.addEventListener(ControlEvent.P3_A_RELEASE, P3Ar);
			FPC.addEventListener(ControlEvent.P3_B_PRESS,   P3Bp);
			FPC.addEventListener(ControlEvent.P3_B_RELEASE, P3Br);
			FPC.addEventListener(ControlEvent.P3_C_PRESS,   P3Cp);
			FPC.addEventListener(ControlEvent.P3_C_RELEASE, P3Cr);

			FPC.addEventListener(ControlEvent.P4_R_PRESS,   P4Rp);
			FPC.addEventListener(ControlEvent.P4_R_RELEASE, P4Rr);
			FPC.addEventListener(ControlEvent.P4_U_PRESS,   P4Up);
			FPC.addEventListener(ControlEvent.P4_U_RELEASE, P4Ur);
			FPC.addEventListener(ControlEvent.P4_L_PRESS,   P4Lp);
			FPC.addEventListener(ControlEvent.P4_L_RELEASE, P4Lr);
			FPC.addEventListener(ControlEvent.P4_D_PRESS,   P4Dp);
			FPC.addEventListener(ControlEvent.P4_D_RELEASE, P4Dr);
			FPC.addEventListener(ControlEvent.P4_X_PRESS,   P4Xp);
			FPC.addEventListener(ControlEvent.P4_X_RELEASE, P4Xr);
			FPC.addEventListener(ControlEvent.P4_A_PRESS,   P4Ap);
			FPC.addEventListener(ControlEvent.P4_A_RELEASE, P4Ar);
			FPC.addEventListener(ControlEvent.P4_B_PRESS,   P4Bp);
			FPC.addEventListener(ControlEvent.P4_B_RELEASE, P4Br);
			FPC.addEventListener(ControlEvent.P4_C_PRESS,   P4Cp);
			FPC.addEventListener(ControlEvent.P4_C_RELEASE, P4Cr);
			
			connected = true;
		}
		
		/**
		* Disconnect listeners from the <code>FourPlayerControlListener</code>.
		*/
		public function disconnect():void {
			if (!connected) { return; }
			
			var FPC:FourPlayerControl = FourPlayerControl.instance;			
			FPC.removeEventListener(ControlEvent.P1_R_PRESS,   P1Rp);
			FPC.removeEventListener(ControlEvent.P1_R_RELEASE, P1Rr);
			FPC.removeEventListener(ControlEvent.P1_U_PRESS,   P1Up);
			FPC.removeEventListener(ControlEvent.P1_U_RELEASE, P1Ur);
			FPC.removeEventListener(ControlEvent.P1_L_PRESS,   P1Lp);
			FPC.removeEventListener(ControlEvent.P1_L_RELEASE, P1Lr);
			FPC.removeEventListener(ControlEvent.P1_D_PRESS,   P1Dp);
			FPC.removeEventListener(ControlEvent.P1_D_RELEASE, P1Dr);
			FPC.removeEventListener(ControlEvent.P1_X_PRESS,   P1Xp);
			FPC.removeEventListener(ControlEvent.P1_X_RELEASE, P1Xr);
			FPC.removeEventListener(ControlEvent.P1_A_PRESS,   P1Ap);
			FPC.removeEventListener(ControlEvent.P1_A_RELEASE, P1Ar);
			FPC.removeEventListener(ControlEvent.P1_B_PRESS,   P1Bp);
			FPC.removeEventListener(ControlEvent.P1_B_RELEASE, P1Br);
			FPC.removeEventListener(ControlEvent.P1_C_PRESS,   P1Cp);
			FPC.removeEventListener(ControlEvent.P1_C_RELEASE, P1Cr);

			FPC.removeEventListener(ControlEvent.P2_R_PRESS,   P2Rp);
			FPC.removeEventListener(ControlEvent.P2_R_RELEASE, P2Rr);
			FPC.removeEventListener(ControlEvent.P2_U_PRESS,   P2Up);
			FPC.removeEventListener(ControlEvent.P2_U_RELEASE, P2Ur);
			FPC.removeEventListener(ControlEvent.P2_L_PRESS,   P2Lp);
			FPC.removeEventListener(ControlEvent.P2_L_RELEASE, P2Lr);
			FPC.removeEventListener(ControlEvent.P2_D_PRESS,   P2Dp);
			FPC.removeEventListener(ControlEvent.P2_D_RELEASE, P2Dr);
			FPC.removeEventListener(ControlEvent.P2_X_PRESS,   P2Xp);
			FPC.removeEventListener(ControlEvent.P2_X_RELEASE, P2Xr);
			FPC.removeEventListener(ControlEvent.P2_A_PRESS,   P2Ap);
			FPC.removeEventListener(ControlEvent.P2_A_RELEASE, P2Ar);
			FPC.removeEventListener(ControlEvent.P2_B_PRESS,   P2Bp);
			FPC.removeEventListener(ControlEvent.P2_B_RELEASE, P2Br);
			FPC.removeEventListener(ControlEvent.P2_C_PRESS,   P2Cp);
			FPC.removeEventListener(ControlEvent.P2_C_RELEASE, P2Cr);

			FPC.removeEventListener(ControlEvent.P3_R_PRESS,   P3Rp);
			FPC.removeEventListener(ControlEvent.P3_R_RELEASE, P3Rr);
			FPC.removeEventListener(ControlEvent.P3_U_PRESS,   P3Up);
			FPC.removeEventListener(ControlEvent.P3_U_RELEASE, P3Ur);
			FPC.removeEventListener(ControlEvent.P3_L_PRESS,   P3Lp);
			FPC.removeEventListener(ControlEvent.P3_L_RELEASE, P3Lr);
			FPC.removeEventListener(ControlEvent.P3_D_PRESS,   P3Dp);
			FPC.removeEventListener(ControlEvent.P3_D_RELEASE, P3Dr);
			FPC.removeEventListener(ControlEvent.P3_X_PRESS,   P3Xp);
			FPC.removeEventListener(ControlEvent.P3_X_RELEASE, P3Xr);
			FPC.removeEventListener(ControlEvent.P3_A_PRESS,   P3Ap);
			FPC.removeEventListener(ControlEvent.P3_A_RELEASE, P3Ar);
			FPC.removeEventListener(ControlEvent.P3_B_PRESS,   P3Bp);
			FPC.removeEventListener(ControlEvent.P3_B_RELEASE, P3Br);
			FPC.removeEventListener(ControlEvent.P3_C_PRESS,   P3Cp);
			FPC.removeEventListener(ControlEvent.P3_C_RELEASE, P3Cr);

			FPC.removeEventListener(ControlEvent.P4_R_PRESS,   P4Rp);
			FPC.removeEventListener(ControlEvent.P4_R_RELEASE, P4Rr);
			FPC.removeEventListener(ControlEvent.P4_U_PRESS,   P4Up);
			FPC.removeEventListener(ControlEvent.P4_U_RELEASE, P4Ur);
			FPC.removeEventListener(ControlEvent.P4_L_PRESS,   P4Lp);
			FPC.removeEventListener(ControlEvent.P4_L_RELEASE, P4Lr);
			FPC.removeEventListener(ControlEvent.P4_D_PRESS,   P4Dp);
			FPC.removeEventListener(ControlEvent.P4_D_RELEASE, P4Dr);
			FPC.removeEventListener(ControlEvent.P4_X_PRESS,   P4Xp);
			FPC.removeEventListener(ControlEvent.P4_X_RELEASE, P4Xr);
			FPC.removeEventListener(ControlEvent.P4_A_PRESS,   P4Ap);
			FPC.removeEventListener(ControlEvent.P4_A_RELEASE, P4Ar);
			FPC.removeEventListener(ControlEvent.P4_B_PRESS,   P4Bp);
			FPC.removeEventListener(ControlEvent.P4_B_RELEASE, P4Br);
			FPC.removeEventListener(ControlEvent.P4_C_PRESS,   P4Cp);
			FPC.removeEventListener(ControlEvent.P4_C_RELEASE, P4Cr);
			
			connected = false;
		}

		/**
		* Handle player 1 joystick right press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Rp(e:ControlEvent):void {  }
		/**
		* Handle player 1 joystick right release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Rr(e:ControlEvent):void {  }
		/**
		* Handle player 1 joystick up press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Up(e:ControlEvent):void {  }
		/**
		* Handle player 1 joystick up release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Ur(e:ControlEvent):void {  }
		/**
		* Handle player 1 joystick left press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Lp(e:ControlEvent):void {  }
		/**
		* Handle player 1 joystick left release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Lr(e:ControlEvent):void {  }
		/**
		* Handle player 1 joystick down press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Dp(e:ControlEvent):void {  }
		/**
		* Handle player 1 joystick down release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Dr(e:ControlEvent):void {  }
		/**
		* Handle player 1 X button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Xp(e:ControlEvent):void {  }
		/**
		* Handle player 1 X button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Xr(e:ControlEvent):void {  }
		/**
		* Handle player 1 A button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Ap(e:ControlEvent):void {  }
		/**
		* Handle player 1 A button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Ar(e:ControlEvent):void {  }
		/**
		* Handle player 1 B button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Bp(e:ControlEvent):void {  }
		/**
		* Handle player 1 B button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Br(e:ControlEvent):void {  }
		/**
		* Handle player 1 C button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Cp(e:ControlEvent):void {  }
		/**
		* Handle player 1 C button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P1Cr(e:ControlEvent):void {  }


		/**
		* Handle player 2 joystick right press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Rp(e:ControlEvent):void {  }
		/**
		* Handle player 2 joystick right release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Rr(e:ControlEvent):void {  }
		/**
		* Handle player 2 joystick up press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Up(e:ControlEvent):void {  }
		/**
		* Handle player 2 joystick up release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Ur(e:ControlEvent):void {  }
		/**
		* Handle player 2 joystick left press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Lp(e:ControlEvent):void {  }
		/**
		* Handle player 2 joystick left release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Lr(e:ControlEvent):void {  }
		/**
		* Handle player 2 joystick down press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Dp(e:ControlEvent):void {  }
		/**
		* Handle player 2 joystick down release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Dr(e:ControlEvent):void {  }
		/**
		* Handle player 2 X button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Xp(e:ControlEvent):void {  }
		/**
		* Handle player 2 X button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Xr(e:ControlEvent):void {  }
		/**
		* Handle player 2 A button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Ap(e:ControlEvent):void {  }
		/**
		* Handle player 2 A button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Ar(e:ControlEvent):void {  }
		/**
		* Handle player 2 B button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Bp(e:ControlEvent):void {  }
		/**
		* Handle player 2 B button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Br(e:ControlEvent):void {  }
		/**
		* Handle player 2 C button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Cp(e:ControlEvent):void {  }
		/**
		* Handle player 2 C button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P2Cr(e:ControlEvent):void {  }


		/**
		* Handle player 3 joystick right press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Rp(e:ControlEvent):void {  }
		/**
		* Handle player 3 joystick right release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Rr(e:ControlEvent):void {  }
		/**
		* Handle player 3 joystick up press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Up(e:ControlEvent):void {  }
		/**
		* Handle player 3 joystick up release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Ur(e:ControlEvent):void {  }
		/**
		* Handle player 3 joystick left press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Lp(e:ControlEvent):void {  }
		/**
		* Handle player 3 joystick left release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Lr(e:ControlEvent):void {  }
		/**
		* Handle player 3 joystick down press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Dp(e:ControlEvent):void {  }
		/**
		* Handle player 3 joystick down release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Dr(e:ControlEvent):void {  }
		/**
		* Handle player 3 X button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Xp(e:ControlEvent):void {  }
		/**
		* Handle player 3 X button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Xr(e:ControlEvent):void {  }
		/**
		* Handle player 3 A button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Ap(e:ControlEvent):void {  }
		/**
		* Handle player 3 A button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Ar(e:ControlEvent):void {  }
		/**
		* Handle player 3 B button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Bp(e:ControlEvent):void {  }
		/**
		* Handle player 3 B button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Br(e:ControlEvent):void {  }
		/**
		* Handle player 3 C button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Cp(e:ControlEvent):void {  }
		/**
		* Handle player 3 C button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P3Cr(e:ControlEvent):void {  }


		/**
		* Handle player 4 joystick right press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Rp(e:ControlEvent):void {  }
		/**
		* Handle player 4 joystick right release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Rr(e:ControlEvent):void {  }
		/**
		* Handle player 4 joystick up press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Up(e:ControlEvent):void {  }
		/**
		* Handle player 4 joystick up release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Ur(e:ControlEvent):void {  }
		/**
		* Handle player 4 joystick left press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Lp(e:ControlEvent):void {  }
		/**
		* Handle player 4 joystick left release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Lr(e:ControlEvent):void {  }
		/**
		* Handle player 4 joystick down press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Dp(e:ControlEvent):void {  }
		/**
		* Handle player 4 joystick down release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Dr(e:ControlEvent):void {  }
		/**
		* Handle player 4 X button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Xp(e:ControlEvent):void {  }
		/**
		* Handle player 4 X button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Xr(e:ControlEvent):void {  }
		/**
		* Handle player 4 A button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Ap(e:ControlEvent):void {  }
		/**
		* Handle player 4 A button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Ar(e:ControlEvent):void {  }
		/**
		* Handle player 4 B button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Bp(e:ControlEvent):void {  }
		/**
		* Handle player 4 B button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Br(e:ControlEvent):void {  }
		/**
		* Handle player 4 C button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Cp(e:ControlEvent):void {  }
		/**
		* Handle player 4 C button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function P4Cr(e:ControlEvent):void {  }

	}
}
