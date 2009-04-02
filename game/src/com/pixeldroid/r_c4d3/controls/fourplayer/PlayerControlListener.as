
package com.pixeldroid.r_c4d3.controls.fourplayer {

	import flash.display.Sprite;
	import flash.display.Stage;

	import com.pixeldroid.r_c4d3.controls.ControlEvent;
	import com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl;


	/**
	* <code>PlayerControlListener</code> encapsulates the event hookups to <code>FourPlayerControl</code>,
	* to provide a convenient base class for control integration.
	*
	* Sub classes can override only the methods they wish make use of, and needn't worry about hooking up events.
	*
	* Unlike <code>FourPlayerControl</code>, <code>PlayerControl</code> makes no differentiation between
	* player numbers, expecting the user to check the playerIndex property of the event being handled.
	*
	* @example The following code shows a subclass of <code>PlayerControlListener</code>
	* overriding the right joystick press (<em>Rp</em>) event handler:
	* <listing version="3.0" >
	* package {
	*    import com.pixeldroid.r_c4d3.controls.ControlEvent;
	*    import com.pixeldroid.r_c4d3.controls.fourplayer.PlayerControlListener;
	*
	*    public class MyControlEventHandler extends PlayerControlListener {
	*       public function MyControlEventHandler() {
	*          super();
	*       }
	*       protected override function Rp(e:ControlEvent):void {
	* 	         // event handling code here
	*           // use e.playerIndex to determine which player
	*       }
	*    }
	* }
	* </listing>
	*
	* @see com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControl
	* @see com.pixeldroid.r_c4d3.controls.fourplayer.FourPlayerControlListener
	*/
	public class PlayerControlListener extends Sprite {

		private var connected:Boolean;


		/**
		* Create a new <code>FourPlayerControlListener</code>.
		*/
		public function PlayerControlListener() {
			super();
			connect();
		}

		/**
		* Connect listeners to the <code>FourPlayerControlListener</code>.
		*/
		public function connect():void {
			if (connected) { return; }

			var FPC:FourPlayerControl = FourPlayerControl.instance;
			FPC.addEventListener(ControlEvent.P1_R_PRESS,   Rp);
			FPC.addEventListener(ControlEvent.P1_R_RELEASE, Rr);
			FPC.addEventListener(ControlEvent.P1_U_PRESS,   Up);
			FPC.addEventListener(ControlEvent.P1_U_RELEASE, Ur);
			FPC.addEventListener(ControlEvent.P1_L_PRESS,   Lp);
			FPC.addEventListener(ControlEvent.P1_L_RELEASE, Lr);
			FPC.addEventListener(ControlEvent.P1_D_PRESS,   Dp);
			FPC.addEventListener(ControlEvent.P1_D_RELEASE, Dr);
			FPC.addEventListener(ControlEvent.P1_X_PRESS,   Xp);
			FPC.addEventListener(ControlEvent.P1_X_RELEASE, Xr);
			FPC.addEventListener(ControlEvent.P1_A_PRESS,   Ap);
			FPC.addEventListener(ControlEvent.P1_A_RELEASE, Ar);
			FPC.addEventListener(ControlEvent.P1_B_PRESS,   Bp);
			FPC.addEventListener(ControlEvent.P1_B_RELEASE, Br);
			FPC.addEventListener(ControlEvent.P1_C_PRESS,   Cp);
			FPC.addEventListener(ControlEvent.P1_C_RELEASE, Cr);

			FPC.addEventListener(ControlEvent.P2_R_PRESS,   Rp);
			FPC.addEventListener(ControlEvent.P2_R_RELEASE, Rr);
			FPC.addEventListener(ControlEvent.P2_U_PRESS,   Up);
			FPC.addEventListener(ControlEvent.P2_U_RELEASE, Ur);
			FPC.addEventListener(ControlEvent.P2_L_PRESS,   Lp);
			FPC.addEventListener(ControlEvent.P2_L_RELEASE, Lr);
			FPC.addEventListener(ControlEvent.P2_D_PRESS,   Dp);
			FPC.addEventListener(ControlEvent.P2_D_RELEASE, Dr);
			FPC.addEventListener(ControlEvent.P2_X_PRESS,   Xp);
			FPC.addEventListener(ControlEvent.P2_X_RELEASE, Xr);
			FPC.addEventListener(ControlEvent.P2_A_PRESS,   Ap);
			FPC.addEventListener(ControlEvent.P2_A_RELEASE, Ar);
			FPC.addEventListener(ControlEvent.P2_B_PRESS,   Bp);
			FPC.addEventListener(ControlEvent.P2_B_RELEASE, Br);
			FPC.addEventListener(ControlEvent.P2_C_PRESS,   Cp);
			FPC.addEventListener(ControlEvent.P2_C_RELEASE, Cr);

			FPC.addEventListener(ControlEvent.P3_R_PRESS,   Rp);
			FPC.addEventListener(ControlEvent.P3_R_RELEASE, Rr);
			FPC.addEventListener(ControlEvent.P3_U_PRESS,   Up);
			FPC.addEventListener(ControlEvent.P3_U_RELEASE, Ur);
			FPC.addEventListener(ControlEvent.P3_L_PRESS,   Lp);
			FPC.addEventListener(ControlEvent.P3_L_RELEASE, Lr);
			FPC.addEventListener(ControlEvent.P3_D_PRESS,   Dp);
			FPC.addEventListener(ControlEvent.P3_D_RELEASE, Dr);
			FPC.addEventListener(ControlEvent.P3_X_PRESS,   Xp);
			FPC.addEventListener(ControlEvent.P3_X_RELEASE, Xr);
			FPC.addEventListener(ControlEvent.P3_A_PRESS,   Ap);
			FPC.addEventListener(ControlEvent.P3_A_RELEASE, Ar);
			FPC.addEventListener(ControlEvent.P3_B_PRESS,   Bp);
			FPC.addEventListener(ControlEvent.P3_B_RELEASE, Br);
			FPC.addEventListener(ControlEvent.P3_C_PRESS,   Cp);
			FPC.addEventListener(ControlEvent.P3_C_RELEASE, Cr);

			FPC.addEventListener(ControlEvent.P4_R_PRESS,   Rp);
			FPC.addEventListener(ControlEvent.P4_R_RELEASE, Rr);
			FPC.addEventListener(ControlEvent.P4_U_PRESS,   Up);
			FPC.addEventListener(ControlEvent.P4_U_RELEASE, Ur);
			FPC.addEventListener(ControlEvent.P4_L_PRESS,   Lp);
			FPC.addEventListener(ControlEvent.P4_L_RELEASE, Lr);
			FPC.addEventListener(ControlEvent.P4_D_PRESS,   Dp);
			FPC.addEventListener(ControlEvent.P4_D_RELEASE, Dr);
			FPC.addEventListener(ControlEvent.P4_X_PRESS,   Xp);
			FPC.addEventListener(ControlEvent.P4_X_RELEASE, Xr);
			FPC.addEventListener(ControlEvent.P4_A_PRESS,   Ap);
			FPC.addEventListener(ControlEvent.P4_A_RELEASE, Ar);
			FPC.addEventListener(ControlEvent.P4_B_PRESS,   Bp);
			FPC.addEventListener(ControlEvent.P4_B_RELEASE, Br);
			FPC.addEventListener(ControlEvent.P4_C_PRESS,   Cp);
			FPC.addEventListener(ControlEvent.P4_C_RELEASE, Cr);

			connected = true;
		}

		/**
		* Disconnect listeners from the <code>FourPlayerControlListener</code>.
		*/
		public function disconnect():void {
			if (!connected) { return; }

			var FPC:FourPlayerControl = FourPlayerControl.instance;
			FPC.removeEventListener(ControlEvent.P1_R_PRESS,   Rp);
			FPC.removeEventListener(ControlEvent.P1_R_RELEASE, Rr);
			FPC.removeEventListener(ControlEvent.P1_U_PRESS,   Up);
			FPC.removeEventListener(ControlEvent.P1_U_RELEASE, Ur);
			FPC.removeEventListener(ControlEvent.P1_L_PRESS,   Lp);
			FPC.removeEventListener(ControlEvent.P1_L_RELEASE, Lr);
			FPC.removeEventListener(ControlEvent.P1_D_PRESS,   Dp);
			FPC.removeEventListener(ControlEvent.P1_D_RELEASE, Dr);
			FPC.removeEventListener(ControlEvent.P1_X_PRESS,   Xp);
			FPC.removeEventListener(ControlEvent.P1_X_RELEASE, Xr);
			FPC.removeEventListener(ControlEvent.P1_A_PRESS,   Ap);
			FPC.removeEventListener(ControlEvent.P1_A_RELEASE, Ar);
			FPC.removeEventListener(ControlEvent.P1_B_PRESS,   Bp);
			FPC.removeEventListener(ControlEvent.P1_B_RELEASE, Br);
			FPC.removeEventListener(ControlEvent.P1_C_PRESS,   Cp);
			FPC.removeEventListener(ControlEvent.P1_C_RELEASE, Cr);

			FPC.removeEventListener(ControlEvent.P2_R_PRESS,   Rp);
			FPC.removeEventListener(ControlEvent.P2_R_RELEASE, Rr);
			FPC.removeEventListener(ControlEvent.P2_U_PRESS,   Up);
			FPC.removeEventListener(ControlEvent.P2_U_RELEASE, Ur);
			FPC.removeEventListener(ControlEvent.P2_L_PRESS,   Lp);
			FPC.removeEventListener(ControlEvent.P2_L_RELEASE, Lr);
			FPC.removeEventListener(ControlEvent.P2_D_PRESS,   Dp);
			FPC.removeEventListener(ControlEvent.P2_D_RELEASE, Dr);
			FPC.removeEventListener(ControlEvent.P2_X_PRESS,   Xp);
			FPC.removeEventListener(ControlEvent.P2_X_RELEASE, Xr);
			FPC.removeEventListener(ControlEvent.P2_A_PRESS,   Ap);
			FPC.removeEventListener(ControlEvent.P2_A_RELEASE, Ar);
			FPC.removeEventListener(ControlEvent.P2_B_PRESS,   Bp);
			FPC.removeEventListener(ControlEvent.P2_B_RELEASE, Br);
			FPC.removeEventListener(ControlEvent.P2_C_PRESS,   Cp);
			FPC.removeEventListener(ControlEvent.P2_C_RELEASE, Cr);

			FPC.removeEventListener(ControlEvent.P3_R_PRESS,   Rp);
			FPC.removeEventListener(ControlEvent.P3_R_RELEASE, Rr);
			FPC.removeEventListener(ControlEvent.P3_U_PRESS,   Up);
			FPC.removeEventListener(ControlEvent.P3_U_RELEASE, Ur);
			FPC.removeEventListener(ControlEvent.P3_L_PRESS,   Lp);
			FPC.removeEventListener(ControlEvent.P3_L_RELEASE, Lr);
			FPC.removeEventListener(ControlEvent.P3_D_PRESS,   Dp);
			FPC.removeEventListener(ControlEvent.P3_D_RELEASE, Dr);
			FPC.removeEventListener(ControlEvent.P3_X_PRESS,   Xp);
			FPC.removeEventListener(ControlEvent.P3_X_RELEASE, Xr);
			FPC.removeEventListener(ControlEvent.P3_A_PRESS,   Ap);
			FPC.removeEventListener(ControlEvent.P3_A_RELEASE, Ar);
			FPC.removeEventListener(ControlEvent.P3_B_PRESS,   Bp);
			FPC.removeEventListener(ControlEvent.P3_B_RELEASE, Br);
			FPC.removeEventListener(ControlEvent.P3_C_PRESS,   Cp);
			FPC.removeEventListener(ControlEvent.P3_C_RELEASE, Cr);

			FPC.removeEventListener(ControlEvent.P4_R_PRESS,   Rp);
			FPC.removeEventListener(ControlEvent.P4_R_RELEASE, Rr);
			FPC.removeEventListener(ControlEvent.P4_U_PRESS,   Up);
			FPC.removeEventListener(ControlEvent.P4_U_RELEASE, Ur);
			FPC.removeEventListener(ControlEvent.P4_L_PRESS,   Lp);
			FPC.removeEventListener(ControlEvent.P4_L_RELEASE, Lr);
			FPC.removeEventListener(ControlEvent.P4_D_PRESS,   Dp);
			FPC.removeEventListener(ControlEvent.P4_D_RELEASE, Dr);
			FPC.removeEventListener(ControlEvent.P4_X_PRESS,   Xp);
			FPC.removeEventListener(ControlEvent.P4_X_RELEASE, Xr);
			FPC.removeEventListener(ControlEvent.P4_A_PRESS,   Ap);
			FPC.removeEventListener(ControlEvent.P4_A_RELEASE, Ar);
			FPC.removeEventListener(ControlEvent.P4_B_PRESS,   Bp);
			FPC.removeEventListener(ControlEvent.P4_B_RELEASE, Br);
			FPC.removeEventListener(ControlEvent.P4_C_PRESS,   Cp);
			FPC.removeEventListener(ControlEvent.P4_C_RELEASE, Cr);

			connected = false;
		}

		/**
		* Handle joystick right press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Rp(e:ControlEvent):void {  }
		/**
		* Handle joystick right release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Rr(e:ControlEvent):void {  }
		/**
		* Handle joystick up press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Up(e:ControlEvent):void {  }
		/**
		* Handle joystick up release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Ur(e:ControlEvent):void {  }
		/**
		* Handle joystick left press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Lp(e:ControlEvent):void {  }
		/**
		* Handle joystick left release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Lr(e:ControlEvent):void {  }
		/**
		* Handle joystick down press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Dp(e:ControlEvent):void {  }
		/**
		* Handle joystick down release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Dr(e:ControlEvent):void {  }
		/**
		* Handle X button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Xp(e:ControlEvent):void {  }
		/**
		* Handle X button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Xr(e:ControlEvent):void {  }
		/**
		* Handle A button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Ap(e:ControlEvent):void {  }
		/**
		* Handle A button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Ar(e:ControlEvent):void {  }
		/**
		* Handle B button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Bp(e:ControlEvent):void {  }
		/**
		* Handle B button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Br(e:ControlEvent):void {  }
		/**
		* Handle C button press.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Cp(e:ControlEvent):void {  }
		/**
		* Handle C button release.
		* @param e com.pixeldroid.r_c4d3.controls.ControlEvent
		*/
		protected function Cr(e:ControlEvent):void {  }

	}
}
