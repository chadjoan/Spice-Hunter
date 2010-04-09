
package com.pixeldroid.r_c4d3.proxies
{

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.pixeldroid.r_c4d3.proxies.KeyboardGameControlsProxy;
	import com.pixeldroid.r_c4d3.proxies.PathConstants;
	
	
	/**
	An implementation of IGameControlsProxy for the R_C4D3 system.
	<p>
	Maps keyboard events to JoyHat and JoyButton events.
	</p>
	<p>
	Keys initialize to the default R_C4D3 values, but can be customized via 
	<code>setKeys()</code> and queried via 
	<code>joystickGetHatKey()</code> and <code>joystickGetButtonKey()</code>
	</p>
	<p>
	Uses hard-coded path from PathConstants to return to menu
	</p>
	
	@see com.pixeldroid.r_c4d3.proxies.PathConstants
	*/
	public class RC4D3GameControlsProxy extends KeyboardGameControlsProxy
	{
		private const BTN_M:int = Keyboard.F12;
		
		
		
		/**
		Constructor
		*/
		public function RC4D3GameControlsProxy()
		{
			super();
			setDefaultCodes();
		}
		
		
		protected function setDefaultCodes():void
		{
			setKeys(0, 49,50,51,52,53,54,55,56);
			setKeys(1, 81,87,69,82,84,89,85,73);
			setKeys(2, 65,83,68,70,71,72,74,75);
			setKeys(3, 90,88,67,86,66,78,77,188);
		}

		
		override protected function onKeyDown(e:KeyboardEvent):void
		{
			var kc:uint = e.keyCode;
			//C.out(this, "onKeyDown - " +kc);
		
			if (kc == BTN_M)
			{
				try { navigateToURL(new URLRequest(PathConstants.RETURN_TO_MENU), "_top"); }
				catch (e:Error) { /*C.out(this, "navigation error: " +e, true);*/ }
			}
			
			else super.onKeyDown(e);
		}

	}
}
