package {

import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.media.Sound;
import flash.text.Font;

    public class Assets
    {
        public static var root : Sprite;
    
        [Embed(source="../fonts/text.ttf", fontName="text")]
        public static var text_dummy:Class;
        [Embed(source="../fonts/title.ttf", fontName="title")]
        public static var title_dummy:Class;
        [Embed(source="../fonts/number.ttf", fontName="number")]
        public static var number_dummy:Class;
        [Embed(source="../src/com/pixeldroid/tools/osd/VeraMono.ttf", fontName="VeraMono")]
        public static var VeraMono_dummy:Class;
        [Embed(source="../src/com/pixeldroid/tools/framerate/PixelHugger.ttf", fontName="PixelHugger")]
        public static var PixelHugger_dummy:Class;
        [Embed(source="../images/LeftArmPowerup4.png")]
        public static var LeftArmPowerup4:Class;
        [Embed(source="../images/selectionScreen/barRed.png")]
        public static var barRed:Class;
        [Embed(source="../images/selectionScreen/blink.png")]
        public static var blink:Class;
        [Embed(source="../images/selectionScreen/staticText.png")]
        public static var staticText:Class;
        [Embed(source="../images/selectionScreen/boxGreen.png")]
        public static var boxGreen:Class;
        [Embed(source="../images/selectionScreen/barYellow.png")]
        public static var barYellow:Class;
        [Embed(source="../images/selectionScreen/readyNOT.png")]
        public static var readyNOT:Class;
        [Embed(source="../images/selectionScreen/ready.png")]
        public static var ready:Class;
        [Embed(source="../images/selectionScreen/bg.png")]
        public static var bg:Class;
        [Embed(source="../images/selectionScreen/boxBlue.png")]
        public static var boxBlue:Class;
        [Embed(source="../images/selectionScreen/highlight1.png")]
        public static var highlight1:Class;
        [Embed(source="../images/selectionScreen/barBlue.png")]
        public static var barBlue:Class;
        [Embed(source="../images/selectionScreen/barRobot.png")]
        public static var barRobot:Class;
        [Embed(source="../images/selectionScreen/highlight3.png")]
        public static var highlight3:Class;
        [Embed(source="../images/selectionScreen/highlight2.png")]
        public static var highlight2:Class;
        [Embed(source="../images/selectionScreen/barGreen.png")]
        public static var barGreen:Class;
        [Embed(source="../images/selectionScreen/boxYellow.png")]
        public static var boxYellow:Class;
        [Embed(source="../images/selectionScreen/barHuman.png")]
        public static var barHuman:Class;
        [Embed(source="../images/selectionScreen/boxRed.png")]
        public static var boxRed:Class;
        [Embed(source="../images/player2reticule03.png")]
        public static var player2reticule03:Class;
        [Embed(source="../images/ShipArm10.png")]
        public static var ShipArm10:Class;
        [Embed(source="../images/RightArmPowerup2.png")]
        public static var RightArmPowerup2:Class;
        [Embed(source="../images/explode05.png")]
        public static var explode05:Class;
        [Embed(source="../images/LeftArmPowerup1.png")]
        public static var LeftArmPowerup1:Class;
        [Embed(source="../images/level7Gradient.png")]
        public static var level7Gradient:Class;
        [Embed(source="../images/score5.png")]
        public static var score5:Class;
        [Embed(source="../images/ShipArm9.png")]
        public static var ShipArm9:Class;
        [Embed(source="../images/score3.png")]
        public static var score3:Class;
        [Embed(source="../images/Gemini.png")]
        public static var Gemini:Class;
        [Embed(source="../images/LeftArmPowerup9.png")]
        public static var LeftArmPowerup9:Class;
        [Embed(source="../images/Tether8.png")]
        public static var Tether8:Class;
        [Embed(source="../images/player1reticule08.png")]
        public static var player1reticule08:Class;
        [Embed(source="../images/firework21.png")]
        public static var firework21:Class;
        [Embed(source="../images/LeftArmPowerup5.png")]
        public static var LeftArmPowerup5:Class;
        [Embed(source="../images/firework18.png")]
        public static var firework18:Class;
        [Embed(source="../images/BlueTriangle.png")]
        public static var BlueTriangle:Class;
        [Embed(source="../images/explode09.png")]
        public static var explode09:Class;
        [Embed(source="../images/bombCount8.png")]
        public static var bombCount8:Class;
        [Embed(source="../images/bonusMotherlode.png")]
        public static var bonusMotherlode:Class;
        [Embed(source="../images/bombCount6.png")]
        public static var bombCount6:Class;
        [Embed(source="../images/ShipBack.png")]
        public static var ShipBack:Class;
        [Embed(source="../images/RightArmPowerup10.png")]
        public static var RightArmPowerup10:Class;
        [Embed(source="../images/Background_6.png")]
        public static var Background_6:Class;
        [Embed(source="../images/player1reticule07.png")]
        public static var player1reticule07:Class;
        [Embed(source="../images/player1reticule05.png")]
        public static var player1reticule05:Class;
        [Embed(source="../images/bombCount9.png")]
        public static var bombCount9:Class;
        [Embed(source="../images/player4reticule05.png")]
        public static var player4reticule05:Class;
        [Embed(source="../images/GreenCircle.png")]
        public static var GreenCircle:Class;
        [Embed(source="../images/firework6.png")]
        public static var firework6:Class;
        [Embed(source="../images/GreenTriangle.png")]
        public static var GreenTriangle:Class;
        [Embed(source="../images/firework29.png")]
        public static var firework29:Class;
        [Embed(source="../images/player2reticule04.png")]
        public static var player2reticule04:Class;
        [Embed(source="../images/firework12.png")]
        public static var firework12:Class;
        [Embed(source="../images/ShipBody1.png")]
        public static var ShipBody1:Class;
        [Embed(source="../images/RightArmPowerup7.png")]
        public static var RightArmPowerup7:Class;
        [Embed(source="../images/BlueSpiral.png")]
        public static var BlueSpiral:Class;
        [Embed(source="../images/firework7.png")]
        public static var firework7:Class;
        [Embed(source="../images/player4reticule04.png")]
        public static var player4reticule04:Class;
        [Embed(source="../images/player1reticule06.png")]
        public static var player1reticule06:Class;
        [Embed(source="../images/ShipArm3.png")]
        public static var ShipArm3:Class;
        [Embed(source="../images/score0.png")]
        public static var score0:Class;
        [Embed(source="../images/player3reticule02.png")]
        public static var player3reticule02:Class;
        [Embed(source="../images/firework5.png")]
        public static var firework5:Class;
        [Embed(source="../images/Background_2.png")]
        public static var Background_2:Class;
        [Embed(source="../images/Tether4.png")]
        public static var Tether4:Class;
        [Embed(source="../images/score9.png")]
        public static var score9:Class;
        [Embed(source="../images/player2reticule05.png")]
        public static var player2reticule05:Class;
        [Embed(source="../images/BlueCircle.png")]
        public static var BlueCircle:Class;
        [Embed(source="../images/RightArmPowerup6.png")]
        public static var RightArmPowerup6:Class;
        [Embed(source="../images/bomb5.png")]
        public static var bomb5:Class;
        [Embed(source="../images/firework19.png")]
        public static var firework19:Class;
        [Embed(source="../images/DonutYellow.png")]
        public static var DonutYellow:Class;
        [Embed(source="../images/ShipArm5.png")]
        public static var ShipArm5:Class;
        [Embed(source="../images/bomb3.png")]
        public static var bomb3:Class;
        [Embed(source="../images/firework4.png")]
        public static var firework4:Class;
        [Embed(source="../images/player1reticule03.png")]
        public static var player1reticule03:Class;
        [Embed(source="../images/player1reticule02.png")]
        public static var player1reticule02:Class;
        [Embed(source="../images/RightArmPowerup3.png")]
        public static var RightArmPowerup3:Class;
        [Embed(source="../images/firework26.png")]
        public static var firework26:Class;
        [Embed(source="../images/Tether9.png")]
        public static var Tether9:Class;
        [Embed(source="../images/firework20.png")]
        public static var firework20:Class;
        [Embed(source="../images/player4reticule08.png")]
        public static var player4reticule08:Class;
        [Embed(source="../images/player3reticule09.png")]
        public static var player3reticule09:Class;
        [Embed(source="../images/ShipArm1.png")]
        public static var ShipArm1:Class;
        [Embed(source="../images/DonutRed.png")]
        public static var DonutRed:Class;
        [Embed(source="../images/Base.png")]
        public static var Base:Class;
        [Embed(source="../images/SpaceSpiceCollision2.png")]
        public static var SpaceSpiceCollision2:Class;
        [Embed(source="../images/firework16.png")]
        public static var firework16:Class;
        [Embed(source="../images/player3reticule01.png")]
        public static var player3reticule01:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel7.png")]
        public static var ReticuleLevel7:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel6.png")]
        public static var ReticuleLevel6:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel1.png")]
        public static var ReticuleLevel1:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel9.png")]
        public static var ReticuleLevel9:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel8.png")]
        public static var ReticuleLevel8:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel2.png")]
        public static var ReticuleLevel2:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel3.png")]
        public static var ReticuleLevel3:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel4.png")]
        public static var ReticuleLevel4:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel10.png")]
        public static var ReticuleLevel10:Class;
        [Embed(source="../images/finalRenders/ReticuleLevel5.png")]
        public static var ReticuleLevel5:Class;
        [Embed(source="../images/RightArmPowerup4.png")]
        public static var RightArmPowerup4:Class;
        [Embed(source="../images/player2reticule09.png")]
        public static var player2reticule09:Class;
        [Embed(source="../images/SpaceSpiceCollision4.png")]
        public static var SpaceSpiceCollision4:Class;
        [Embed(source="../images/bomb1.png")]
        public static var bomb1:Class;
        [Embed(source="../images/Background_0.png")]
        public static var Background_0:Class;
        [Embed(source="../images/SpaceSpiceCollision5.png")]
        public static var SpaceSpiceCollision5:Class;
        [Embed(source="../images/firework17.png")]
        public static var firework17:Class;
        [Embed(source="../images/ShipBody2.png")]
        public static var ShipBody2:Class;
        [Embed(source="../images/player2reticule06.png")]
        public static var player2reticule06:Class;
        [Embed(source="../images/blackhole.png")]
        public static var blackhole:Class;
        [Embed(source="../images/player2reticule08.png")]
        public static var player2reticule08:Class;
        [Embed(source="../images/RightArmPowerup5.png")]
        public static var RightArmPowerup5:Class;
        [Embed(source="../images/firework2.png")]
        public static var firework2:Class;
        [Embed(source="../images/Asteroid8.png")]
        public static var Asteroid8:Class;
        [Embed(source="../images/blank.png")]
        public static var blank:Class;
        [Embed(source="../images/bomb9.png")]
        public static var bomb9:Class;
        [Embed(source="../images/player2reticule10.png")]
        public static var player2reticule10:Class;
        [Embed(source="../images/score8.png")]
        public static var score8:Class;
        [Embed(source="../images/DonutGreen.png")]
        public static var DonutGreen:Class;
        [Embed(source="../images/explode08.png")]
        public static var explode08:Class;
        [Embed(source="../images/explode01.png")]
        public static var explode01:Class;
        [Embed(source="../images/explode04.png")]
        public static var explode04:Class;
        [Embed(source="../images/bonusNiceShot.png")]
        public static var bonusNiceShot:Class;
        [Embed(source="../images/SpaceSpiceCollision7.png")]
        public static var SpaceSpiceCollision7:Class;
        [Embed(source="../images/SpaceSpiceCollision3.png")]
        public static var SpaceSpiceCollision3:Class;
        [Embed(source="../images/colon.png")]
        public static var colon:Class;
        [Embed(source="../images/Background_7b.png")]
        public static var Background_7b:Class;
        [Embed(source="../images/LeftArmPowerup10.png")]
        public static var LeftArmPowerup10:Class;
        [Embed(source="../images/score7.png")]
        public static var score7:Class;
        [Embed(source="../images/RedSpiral.png")]
        public static var RedSpiral:Class;
        [Embed(source="../images/SpaceSpiceCollision10.png")]
        public static var SpaceSpiceCollision10:Class;
        [Embed(source="../images/plus.png")]
        public static var plus:Class;
        [Embed(source="../images/firework9.png")]
        public static var firework9:Class;
        [Embed(source="../images/player3reticule08.png")]
        public static var player3reticule08:Class;
        [Embed(source="../images/LeftArmPowerup3.png")]
        public static var LeftArmPowerup3:Class;
        [Embed(source="../images/Asteroid.png")]
        public static var Asteroid:Class;
        [Embed(source="../images/Background_3.png")]
        public static var Background_3:Class;
        [Embed(source="../images/firework22.png")]
        public static var firework22:Class;
        [Embed(source="../images/Asteroid7.png")]
        public static var Asteroid7:Class;
        [Embed(source="../images/player2reticule02.png")]
        public static var player2reticule02:Class;
        [Embed(source="../images/player1reticule01.png")]
        public static var player1reticule01:Class;
        [Embed(source="../images/explode07.png")]
        public static var explode07:Class;
        [Embed(source="../images/Background_4.png")]
        public static var Background_4:Class;
        [Embed(source="../images/YellowTriangle.png")]
        public static var YellowTriangle:Class;
        [Embed(source="../images/ShipArm2.png")]
        public static var ShipArm2:Class;
        [Embed(source="../images/player4reticule10.png")]
        public static var player4reticule10:Class;
        [Embed(source="../images/Tether5.png")]
        public static var Tether5:Class;
        [Embed(source="../images/score4.png")]
        public static var score4:Class;
        [Embed(source="../images/bombCount4.png")]
        public static var bombCount4:Class;
        [Embed(source="../images/ShipArm4.png")]
        public static var ShipArm4:Class;
        [Embed(source="../images/anchor.png")]
        public static var anchor:Class;
        [Embed(source="../images/player3reticule04.png")]
        public static var player3reticule04:Class;
        [Embed(source="../images/firework10.png")]
        public static var firework10:Class;
        [Embed(source="../images/Tether2.png")]
        public static var Tether2:Class;
        [Embed(source="../images/bomb6.png")]
        public static var bomb6:Class;
        [Embed(source="../images/explode03.png")]
        public static var explode03:Class;
        [Embed(source="../images/player2reticule07.png")]
        public static var player2reticule07:Class;
        [Embed(source="../images/player3reticule03.png")]
        public static var player3reticule03:Class;
        [Embed(source="../images/firework27.png")]
        public static var firework27:Class;
        [Embed(source="../images/explode10.png")]
        public static var explode10:Class;
        [Embed(source="../images/ShipArm7.png")]
        public static var ShipArm7:Class;
        [Embed(source="../images/splash.png")]
        public static var splash:Class;
        [Embed(source="../images/Background_5.png")]
        public static var Background_5:Class;
        [Embed(source="../images/firework25.png")]
        public static var firework25:Class;
        [Embed(source="../images/player4reticule09.png")]
        public static var player4reticule09:Class;
        [Embed(source="../images/LeftArmPowerup7.png")]
        public static var LeftArmPowerup7:Class;
        [Embed(source="../images/LeftArmPowerup6.png")]
        public static var LeftArmPowerup6:Class;
        [Embed(source="../images/player4reticule02.png")]
        public static var player4reticule02:Class;
        [Embed(source="../images/Tether10.png")]
        public static var Tether10:Class;
        [Embed(source="../images/firework14.png")]
        public static var firework14:Class;
        [Embed(source="../images/player1reticule04.png")]
        public static var player1reticule04:Class;
        [Embed(source="../images/score1.png")]
        public static var score1:Class;
        [Embed(source="../images/EpicFail.png")]
        public static var EpicFail:Class;
        [Embed(source="../images/highScores/topBoxRed.png")]
        public static var topBoxRed:Class;
        [Embed(source="../images/highScores/topBoxGreen.png")]
        public static var topBoxGreen:Class;
        [Embed(source="../images/highScores/topBoxBlue.png")]
        public static var topBoxBlue:Class;
        [Embed(source="../images/highScores/HighScoresBackground.png")]
        public static var HighScoresBackground:Class;
        [Embed(source="../images/highScores/topBoxYellow.png")]
        public static var topBoxYellow:Class;
        [Embed(source="../images/Background_1.png")]
        public static var Background_1:Class;
        [Embed(source="../images/bombCount1.png")]
        public static var bombCount1:Class;
        [Embed(source="../images/ShipArm6.png")]
        public static var ShipArm6:Class;
        [Embed(source="../images/RightArmPowerup8.png")]
        public static var RightArmPowerup8:Class;
        [Embed(source="../images/Background_8.png")]
        public static var Background_8:Class;
        [Embed(source="../images/player3reticule07.png")]
        public static var player3reticule07:Class;
        [Embed(source="../images/bomb7.png")]
        public static var bomb7:Class;
        [Embed(source="../images/firework24.png")]
        public static var firework24:Class;
        [Embed(source="../images/firework11.png")]
        public static var firework11:Class;
        [Embed(source="../images/LeftArmPowerup2.png")]
        public static var LeftArmPowerup2:Class;
        [Embed(source="../images/LeftArmPowerup8.png")]
        public static var LeftArmPowerup8:Class;
        [Embed(source="../images/explode06.png")]
        public static var explode06:Class;
        [Embed(source="../images/player4reticule06.png")]
        public static var player4reticule06:Class;
        [Embed(source="../images/firework23.png")]
        public static var firework23:Class;
        [Embed(source="../images/YellowCircle.png")]
        public static var YellowCircle:Class;
        [Embed(source="../images/bonusOhSnap.png")]
        public static var bonusOhSnap:Class;
        [Embed(source="../images/player4reticule03.png")]
        public static var player4reticule03:Class;
        [Embed(source="../images/Tether6.png")]
        public static var Tether6:Class;
        [Embed(source="../images/ShipBody3.png")]
        public static var ShipBody3:Class;
        [Embed(source="../images/firework13.png")]
        public static var firework13:Class;
        [Embed(source="../images/explode02.png")]
        public static var explode02:Class;
        [Embed(source="../images/selectionBorder.png")]
        public static var selectionBorder:Class;
        [Embed(source="../images/player4reticule07.png")]
        public static var player4reticule07:Class;
        [Embed(source="../images/RedTriangle.png")]
        public static var RedTriangle:Class;
        [Embed(source="../images/player3reticule05.png")]
        public static var player3reticule05:Class;
        [Embed(source="../images/firework8.png")]
        public static var firework8:Class;
        [Embed(source="../images/Tether7.png")]
        public static var Tether7:Class;
        [Embed(source="../images/bombCount7.png")]
        public static var bombCount7:Class;
        [Embed(source="../images/RightArmPowerup1.png")]
        public static var RightArmPowerup1:Class;
        [Embed(source="../images/player1reticule09.png")]
        public static var player1reticule09:Class;
        [Embed(source="../images/SpaceSpiceCollision8.png")]
        public static var SpaceSpiceCollision8:Class;
        [Embed(source="../images/firework28.png")]
        public static var firework28:Class;
        [Embed(source="../images/RightArmPowerup9.png")]
        public static var RightArmPowerup9:Class;
        [Embed(source="../images/bomb8.png")]
        public static var bomb8:Class;
        [Embed(source="../images/bombCount2.png")]
        public static var bombCount2:Class;
        [Embed(source="../images/bomb0.png")]
        public static var bomb0:Class;
        [Embed(source="../images/FallMiddle.png")]
        public static var FallMiddle:Class;
        [Embed(source="../images/player4reticule01.png")]
        public static var player4reticule01:Class;
        [Embed(source="../images/score2.png")]
        public static var score2:Class;
        [Embed(source="../images/bombCount0.png")]
        public static var bombCount0:Class;
        [Embed(source="../images/Tether3.png")]
        public static var Tether3:Class;
        [Embed(source="../images/Background.png")]
        public static var Background:Class;
        [Embed(source="../images/RedCircle.png")]
        public static var RedCircle:Class;
        [Embed(source="../images/firework1.png")]
        public static var firework1:Class;
        [Embed(source="../images/go.png")]
        public static var go:Class;
        [Embed(source="../images/DonutBlue.png")]
        public static var DonutBlue:Class;
        [Embed(source="../images/SpaceSpiceCollision9.png")]
        public static var SpaceSpiceCollision9:Class;
        [Embed(source="../images/SpaceSpiceCollision1.png")]
        public static var SpaceSpiceCollision1:Class;
        [Embed(source="../images/Background_9.png")]
        public static var Background_9:Class;
        [Embed(source="../images/ShipBody4.png")]
        public static var ShipBody4:Class;
        [Embed(source="../images/player2reticule01.png")]
        public static var player2reticule01:Class;
        [Embed(source="../images/firework3.png")]
        public static var firework3:Class;
        [Embed(source="../images/GreenSpiral.png")]
        public static var GreenSpiral:Class;
        [Embed(source="../images/bonusSpiceCombo.png")]
        public static var bonusSpiceCombo:Class;
        [Embed(source="../images/bombCount3.png")]
        public static var bombCount3:Class;
        [Embed(source="../images/SpaceSpice.png")]
        public static var SpaceSpice:Class;
        [Embed(source="../images/score6.png")]
        public static var score6:Class;
        [Embed(source="../images/bombCount5.png")]
        public static var bombCount5:Class;
        [Embed(source="../images/ShipArm8.png")]
        public static var ShipArm8:Class;
        [Embed(source="../images/SpaceSpiceCollision6.png")]
        public static var SpaceSpiceCollision6:Class;
        [Embed(source="../images/player3reticule10.png")]
        public static var player3reticule10:Class;
        [Embed(source="../images/Asteroid6.png")]
        public static var Asteroid6:Class;
        [Embed(source="../images/YellowSpiral.png")]
        public static var YellowSpiral:Class;
        [Embed(source="../images/player3reticule06.png")]
        public static var player3reticule06:Class;
        [Embed(source="../images/bomb2.png")]
        public static var bomb2:Class;
        [Embed(source="../images/bomb4.png")]
        public static var bomb4:Class;
        [Embed(source="../images/player1reticule10.png")]
        public static var player1reticule10:Class;
        [Embed(source="../images/firework15.png")]
        public static var firework15:Class;
        [Embed(source="../images/Tether1.png")]
        public static var Tether1:Class;
        [Embed(source="../sounds/BeamRepel.mp3")]
        public static var BeamRepel_Class:Class;
        public static const BeamRepel:Sound = new BeamRepel_Class();
        [Embed(source="../sounds/Snap.mp3")]
        public static var Snap_Class:Class;
        public static const Snap:Sound = new Snap_Class();
        [Embed(source="../sounds/AstAstCollide.mp3")]
        public static var AstAstCollide_Class:Class;
        public static const AstAstCollide:Sound = new AstAstCollide_Class();
        [Embed(source="../sounds/BeamAttract.mp3")]
        public static var BeamAttract_Class:Class;
        public static const BeamAttract:Sound = new BeamAttract_Class();
        [Embed(source="../sounds/menuScroll.mp3")]
        public static var menuScroll_Class:Class;
        public static const menuScroll:Sound = new menuScroll_Class();
        [Embed(source="../sounds/Tether.mp3")]
        public static var Tether_Class:Class;
        public static const Tether:Sound = new Tether_Class();
        [Embed(source="../sounds/menuRight.mp3")]
        public static var menuRight_Class:Class;
        public static const menuRight:Sound = new menuRight_Class();
        [Embed(source="../sounds/count2.mp3")]
        public static var count2_Class:Class;
        public static const count2:Sound = new count2_Class();
        [Embed(source="../sounds/count3.mp3")]
        public static var count3_Class:Class;
        public static const count3:Sound = new count3_Class();
        [Embed(source="../sounds/SpiceSpiceCollide.mp3")]
        public static var SpiceSpiceCollide_Class:Class;
        public static const SpiceSpiceCollide:Sound = new SpiceSpiceCollide_Class();
        [Embed(source="../sounds/countgo.mp3")]
        public static var countgo_Class:Class;
        public static const countgo:Sound = new countgo_Class();
        [Embed(source="../sounds/Score.mp3")]
        public static var Score_Class:Class;
        public static const Score:Sound = new Score_Class();
        [Embed(source="../sounds/bigspicebonus.mp3")]
        public static var bigspicebonus_Class:Class;
        public static const bigspicebonus:Sound = new bigspicebonus_Class();
        [Embed(source="../sounds/nice_shot.mp3")]
        public static var nice_shot_Class:Class;
        public static const nice_shot:Sound = new nice_shot_Class();
        [Embed(source="../sounds/oh_snap.mp3")]
        public static var oh_snap_Class:Class;
        public static const oh_snap:Sound = new oh_snap_Class();
        [Embed(source="../sounds/Buzz.mp3")]
        public static var Buzz_Class:Class;
        public static const Buzz:Sound = new Buzz_Class();
        [Embed(source="../sounds/combosound.mp3")]
        public static var combosound_Class:Class;
        public static const combosound:Sound = new combosound_Class();
        [Embed(source="../sounds/joinupLeftRight.mp3")]
        public static var joinupLeftRight_Class:Class;
        public static const joinupLeftRight:Sound = new joinupLeftRight_Class();
        [Embed(source="../sounds/AstSpiceCollide.mp3")]
        public static var AstSpiceCollide_Class:Class;
        public static const AstSpiceCollide:Sound = new AstSpiceCollide_Class();
        [Embed(source="../sounds/joinupUpDown.mp3")]
        public static var joinupUpDown_Class:Class;
        public static const joinupUpDown:Sound = new joinupUpDown_Class();
        [Embed(source="../sounds/count1.mp3")]
        public static var count1_Class:Class;
        public static const count1:Sound = new count1_Class();
        [Embed(source="../sounds/menuLeft.mp3")]
        public static var menuLeft_Class:Class;
        public static const menuLeft:Sound = new menuLeft_Class();
        [Embed(source="../sounds/AstExplode.mp3")]
        public static var AstExplode_Class:Class;
        public static const AstExplode:Sound = new AstExplode_Class();
        [Embed(source="../sounds/countdown.mp3")]
        public static var countdown_Class:Class;
        public static const countdown:Sound = new countdown_Class();
        [Embed(source="../sounds/GravBombSound.mp3")]
        public static var GravBombSound_Class:Class;
        public static const GravBombSound:Sound = new GravBombSound_Class();
        [Embed(source="../sounds/addmoney.mp3")]
        public static var addmoney_Class:Class;
        public static const addmoney:Sound = new addmoney_Class();
        [Embed(source="../music/m03.mp3")]
        public static var m03_Class:Class;
        public static const m03:Sound = new m03_Class();
        [Embed(source="../music/m09.mp3")]
        public static var m09_Class:Class;
        public static const m09:Sound = new m09_Class();
        [Embed(source="../music/Music_Upgrade.mp3")]
        public static var Music_Upgrade_Class:Class;
        public static const Music_Upgrade:Sound = new Music_Upgrade_Class();
        [Embed(source="../music/m08.mp3")]
        public static var m08_Class:Class;
        public static const m08:Sound = new m08_Class();
        [Embed(source="../music/m05.mp3")]
        public static var m05_Class:Class;
        public static const m05:Sound = new m05_Class();
        [Embed(source="../music/Music_joinup.mp3")]
        public static var Music_joinup_Class:Class;
        public static const Music_joinup:Sound = new Music_joinup_Class();
        [Embed(source="../music/m02.mp3")]
        public static var m02_Class:Class;
        public static const m02:Sound = new m02_Class();
        [Embed(source="../music/m07.mp3")]
        public static var m07_Class:Class;
        public static const m07:Sound = new m07_Class();
        [Embed(source="../music/m01.mp3")]
        public static var m01_Class:Class;
        public static const m01:Sound = new m01_Class();
        [Embed(source="../music/m04.mp3")]
        public static var m04_Class:Class;
        public static const m04:Sound = new m04_Class();
        [Embed(source="../music/Music_Title.mp3")]
        public static var Music_Title_Class:Class;
        public static const Music_Title:Sound = new Music_Title_Class();
        [Embed(source="../music/m06.mp3")]
        public static var m06_Class:Class;
        public static const m06:Sound = new m06_Class();
        [Embed(source="../music/m0.mp3")]
        public static var m0_Class:Class;
        public static const m0:Sound = new m0_Class();


        public static function init(_root:Sprite) : void
        {
            root = _root;
        }
    }

}