
package com.pixeldroid.r_c4d3.romloader
{


	/**
		ConfigDataProxy is a simple data structure front end to the romloader xml configuration.
		
		@example Sample <code>romloader-config.xml</code>:
		<listing version="3.0">
		&lt;configuration&gt;
			&lt;!-- trace logging on when true --&gt;
			&lt;logging enabled="true" /&gt;

			&lt;!-- rom to load --&gt;
			&lt;rom file="../controls/ControlTestGameRom.swf" /&gt;

			&lt;!-- key mappings, player numbers start at 1 --&gt;
			&lt;keymappings&gt;
				&lt;joystick playerNumber="1"&gt;
					&lt;hatUp    keyCode="38" /&gt;
					&lt;hatRight keyCode="39" /&gt;
					&lt;hatLeft  keyCode="37" /&gt;
					&lt;hatDown  keyCode="40" /&gt;
					&lt;buttonY  keyCode="17" /&gt;
					&lt;buttonR  keyCode="46" /&gt;
					&lt;buttonG  keyCode="35" /&gt;
					&lt;buttonB  keyCode="34" /&gt;
				&lt;/joystick&gt;
			&lt;/keymappings&gt;
		&lt;/configuration&gt;
		</listing>
	*/
	public class ConfigDataProxy
	{

		private var xmlData:XML;
		private var _xmlString:String;
		private var _loggingEnabled:Boolean;
		private var _romUrl:String;



		/**
			Constructor
		*/
		public function ConfigDataProxy(sourceXml:String)
		{
			xmlString = sourceXml;
			xmlData = new XML(xmlString);
			C.enabled = loggingEnabled;
			C.out(this, toString());
		}


		/** Is trace logging requested? */
        public function get loggingEnabled():Boolean
        {
			if (!_loggingEnabled) _loggingEnabled = Boolean(xmlData..logging.@enabled.toString());
			return _loggingEnabled;
        }

		/** IGameRom swf to load */
        public function get romUrl():String
        {
			if (!_romUrl) _romUrl = xmlData..rom.@file.toString();
			return _romUrl;
        }

		/** Were key codes defined for player 1? */    public function get p1HasKeys():Boolean { return (xmlData..keymappings.joystick.(@playerNumber==1).length() > 0); }
		/** Key code for player 1 Up */                public function get p1U():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==1).hatUp.@keyCode.toString()) as uint; }
		/** Key code for player 1 Right */             public function get p1R():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==1).hatRight.@keyCode.toString()) as uint; }
		/** Key code for player 1 Down */              public function get p1D():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==1).hatDown.@keyCode.toString()) as uint; }
		/** Key code for player 1 Left */              public function get p1L():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==1).hatLeft.@keyCode.toString()) as uint; }
		/** Key code for player 1 Button X (yellow) */ public function get p1X():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==1).buttonX.@keyCode.toString()) as uint; }
		/** Key code for player 1 Button A (red) */    public function get p1A():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==1).buttonA.@keyCode.toString()) as uint; }
		/** Key code for player 1 Button B (blue) */   public function get p1B():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==1).buttonB.@keyCode.toString()) as uint; }
		/** Key code for player 1 Button C (green) */  public function get p1C():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==1).buttonC.@keyCode.toString()) as uint; }

		/** Were key codes defined for player 2? */    public function get p2HasKeys():Boolean { return (xmlData..keymappings.joystick.(@playerNumber==2).length() > 0); }
		/** Key code for player 2 Up */                public function get p2U():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==2).hatUp.@keyCode.toString()) as uint; }
		/** Key code for player 2 Right */             public function get p2R():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==2).hatRight.@keyCode.toString()) as uint; }
		/** Key code for player 2 Down */              public function get p2D():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==2).hatDown.@keyCode.toString()) as uint; }
		/** Key code for player 2 Left */              public function get p2L():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==2).hatLeft.@keyCode.toString()) as uint; }
		/** Key code for player 2 Button X (yellow) */ public function get p2X():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==2).buttonX.@keyCode.toString()) as uint; }
		/** Key code for player 2 Button A (red) */    public function get p2A():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==2).buttonA.@keyCode.toString()) as uint; }
		/** Key code for player 2 Button B (blue) */   public function get p2B():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==2).buttonB.@keyCode.toString()) as uint; }
		/** Key code for player 2 Button C (green) */  public function get p2C():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==2).buttonC.@keyCode.toString()) as uint; }

		/** Were key codes defined for player 3? */    public function get p3HasKeys():Boolean { return (xmlData..keymappings.joystick.(@playerNumber==3).length() > 0); }
		/** Key code for player 3 Up */                public function get p3U():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==3).hatUp.@keyCode.toString()) as uint; }
		/** Key code for player 3 Right */             public function get p3R():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==3).hatRight.@keyCode.toString()) as uint; }
		/** Key code for player 3 Down */              public function get p3D():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==3).hatDown.@keyCode.toString()) as uint; }
		/** Key code for player 3 Left */              public function get p3L():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==3).hatLeft.@keyCode.toString()) as uint; }
		/** Key code for player 3 Button X (yellow) */ public function get p3X():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==3).buttonX.@keyCode.toString()) as uint; }
		/** Key code for player 3 Button A (red) */    public function get p3A():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==3).buttonA.@keyCode.toString()) as uint; }
		/** Key code for player 3 Button B (blue) */   public function get p3B():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==3).buttonB.@keyCode.toString()) as uint; }
		/** Key code for player 3 Button C (green) */  public function get p3C():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==3).buttonC.@keyCode.toString()) as uint; }

		/** Were key codes defined for player 4? */    public function get p4HasKeys():Boolean { return (xmlData..keymappings.joystick.(@playerNumber==4).length() > 0); }
		/** Key code for player 4 Up */                public function get p4U():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==4).hatUp.@keyCode.toString()) as uint; }
		/** Key code for player 4 Right */             public function get p4R():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==4).hatRight.@keyCode.toString()) as uint; }
		/** Key code for player 4 Down */              public function get p4D():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==4).hatDown.@keyCode.toString()) as uint; }
		/** Key code for player 4 Left */              public function get p4L():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==4).hatLeft.@keyCode.toString()) as uint; }
		/** Key code for player 4 Button X (yellow) */ public function get p4X():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==4).buttonX.@keyCode.toString()) as uint; }
		/** Key code for player 4 Button A (red) */    public function get p4A():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==4).buttonA.@keyCode.toString()) as uint; }
		/** Key code for player 4 Button B (blue) */   public function get p4B():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==4).buttonB.@keyCode.toString()) as uint; }
		/** Key code for player 4 Button C (green) */  public function get p4C():uint { return parseInt(xmlData..keymappings.joystick.(@playerNumber==4).buttonC.@keyCode.toString()) as uint; }

		/**
			Source of loaded xml
			@param value - xml source string
		*/
		public function set xmlString(value:String):void { _xmlString = value; }
		public function get xmlString():String { return _xmlString; }

		/**
			Xml string as XML
		*/
		public function get xml():XML
		{
			return new XML(_xmlString);
		}

		/**
			String print of current data
		*/
		public function toString():String
		{
			var s:String = "\nrom configuration";
			s += "\n  loggingEnabled ? " +loggingEnabled;
			s += "\n  romUrl: " +romUrl;
			s += "\n  xmlString - - - - -\n";
			s += xmlString;
			s += "\n  - - - - - - - - - -\n\n";
			return s;
		}
	}
}
