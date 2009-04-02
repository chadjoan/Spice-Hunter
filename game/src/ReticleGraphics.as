/*
cd Documents and Settings\chen730\Desktop\Space_F\AAA_chn\classes\peteNewClass\reticle
mxmlc TestReticle.as -default-size 600 450 -default-frame-rate 30 -sp C:\GameHanning\AS3

cd reticle
mxmlc TestReticle.as -default-size 600 450 -default-frame-rate 30 -sp Z:\AS3
*/
package 
{

	import flash.display.Sprite;
	import flash.display.JointStyle;
	import ShipSpec;


	public class ReticleGraphics
	{
		//radius -  20-40
		//phi - rotation offset for different players reticles
			//0*15 - player 0
			//1*15 - player 1
			//2*15 - player 2
			//3*15 - player 3
		//lengthCounter - 0-10, to draw stickyFlag		
		
		private static const an:Number = Math.PI*2/3; //120 degree, angle between groups of dots
		private static const an_t:Number = Math.PI/12; //angle between each dots
		
		
		public static function draw(spec:ShipSpec, screen:Sprite, phi:Number, radius:Number, lengthCounter:Number, stickyFlag:Boolean):void
		{
			screen.graphics.clear();
			
			var color:uint = Screen.getColor(spec.teamCode);
			var dot:Number = radius/4; //radius of dot
			var linewidth:Number = 2 + (spec.reticleLevel / 10);	
			
			// This line makes it easier to see 2 reticles on top of each other by shifting the 
			// rotation by a small amount.  This is only tested to work on the high scores entry screen.
			phi += spec.playerID * Math.PI * 1 / 6;
			
			switch (spec.playerID)
			{
				case 0: drawTriangle(color, screen, phi, radius, lengthCounter, stickyFlag, dot, linewidth); break;
				case 1: drawCircle  (color, screen, phi, radius, lengthCounter, stickyFlag, dot, linewidth); break;
				case 2: drawSpiral  (color, screen, phi, radius, lengthCounter, stickyFlag, dot, linewidth); break;
				case 3: drawDonut   (color, screen, phi, radius, lengthCounter, stickyFlag, dot, linewidth); break;
			}
		}		
		
		//00000000000000000000000000000000000000000000000
		private static function drawTriangle(color:uint, screen:Sprite, phi:Number, radius:Number, lengthCounter:Number, stickyFlag:Boolean, dot:Number, linewidth:Number):void {
			var anTri:Number = Math.PI/20; //the angle between corners of a triangle
			
			screen.graphics.lineStyle(undefined); //no line
			
			for (var i:uint=0; i<3; i++){				
				for (var j:int=-2; j<3; j++){
					var k:Number = Math.abs(j%2)*2-1; //direction of triangle: -1,1, -1,1, -1,1, ...
					var dot_j:Number = dot/2/(1+Math.abs(j)/2); //triangle size varies by j
					var an_j:Number = an*i+an_t*j+phi; //triangle rotate around center
					var anTri_j:Number = anTri/(1+Math.abs(j)*2); //triangle shrink
					screen.graphics.moveTo((radius+k*dot_j)*Math.cos(an_j), 				(radius+k*dot_j)*Math.sin(an_j));
					screen.graphics.beginFill(color);
					screen.graphics.lineTo((radius-k*dot_j)*Math.cos(an_j+anTri_j),	(radius-k*dot_j)*Math.sin(an_j+anTri_j));
					screen.graphics.lineTo((radius-k*dot_j)*Math.cos(an_j-anTri_j),	(radius-k*dot_j)*Math.sin(an_j-anTri_j));
					screen.graphics.endFill();
				}
			}
			
			screen.graphics.lineStyle(1, color);
			if (stickyFlag)	{
				for (var m:uint=0; m<3; m++){
					var an_n:Number = an*m+phi;
					for (var n:uint=0; n<lengthCounter/(80/radius); n++){
						var rad:Number=radius*.7-n*4;
						screen.graphics.moveTo (   rad*Math.cos(an_n-an_t/2),    rad*Math.sin(an_n-an_t/2)  );
						screen.graphics.curveTo (  (rad+radius/(j+1)/10)*Math.cos(an_n), (rad+radius/10)*Math.sin(an_n),
												   rad*Math.cos(an_n+an_t/2),    rad*Math.sin(an_n+an_t/2)  );
					}	
				}
			}	
		}
		
		//1111111111111111111111111111111111111111111111111
		private static function drawCircle(color:uint, screen:Sprite, phi:Number, radius:Number, lengthCounter:Number, stickyFlag:Boolean, dot:Number, linewidth:Number):void {
			
			screen.graphics.lineStyle(undefined);
			
			for (var i:uint=0; i<3; i++){
				for (var j:int=-2; j<3; j++){
					var an_j:Number = an*i+an_t*j+phi;
					screen.graphics.beginFill(color);
					screen.graphics.drawCircle(radius*Math.cos(an_j), radius*Math.sin(an_j), dot/2/(1+Math.abs(j)));
					screen.graphics.endFill();				
				}
			}
			
			screen.graphics.lineStyle(1, color);
			if (stickyFlag)	{
				for (var m:uint=0; m<3; m++){
					var an_n:Number = an*m+phi;
					for (var n:uint=0; n<lengthCounter/(80/radius); n++){
						var rad:Number=radius*.7-n*4;
						screen.graphics.moveTo (   rad*Math.cos(an_n-an_t/2),    rad*Math.sin(an_n-an_t/2)  );
						screen.graphics.curveTo (  (rad+radius/(j+1)/10)*Math.cos(an_n), (rad+radius/10)*Math.sin(an_n),
												   rad*Math.cos(an_n+an_t/2),    rad*Math.sin(an_n+an_t/2)  );
					}	
				}
			}	
		}
		
		//2222222222222222222222222222222222222222222222222222222222
		private static function drawSpiral(color:uint, screen:Sprite, phi:Number, radius:Number, lengthCounter:Number, stickyFlag:Boolean, dot:Number, linewidth:Number):void {

			for (var i:uint=0; i<3; i++){
				for (var j:int=-2; j<3; j++){	
					screen.graphics.lineStyle(linewidth/(1+Math.abs(j)), color);					
					var dot_t:Number = dot/(1+Math.abs(j)/2);
					var an_j:Number = an*i+an_t*j+phi;
					screen.graphics.moveTo ((radius-dot/4)*Math.cos(an_j-an_t*.5), (radius-dot/4)*Math.sin(an_j-an_t*.5));
					screen.graphics.curveTo((radius+dot_t)*Math.cos(an_j),         (radius+dot_t)*Math.sin(an_j),  
											(radius-dot/4)*Math.cos(an_j+an_t*.5), (radius-dot/4)*Math.sin(an_j+an_t*.5));
				}
			}
			
			screen.graphics.lineStyle(1, color);
			if (stickyFlag)	{
				for (var m:uint=0; m<3; m++){
					var an_n:Number = an*m+phi;
					for (var n:uint=0; n<lengthCounter/(80/radius); n++){
						var rad:Number=radius*.7-n*4;
						screen.graphics.moveTo (   rad*Math.cos(an_n-an_t/2),    rad*Math.sin(an_n-an_t/2)  );
						screen.graphics.curveTo (  (rad+radius/(j+1)/10)*Math.cos(an_n), (rad+radius/10)*Math.sin(an_n),
												   rad*Math.cos(an_n+an_t/2),    rad*Math.sin(an_n+an_t/2)  );
					}	
				}
			}	
		}

		//333333333333333333333333333333333333333333333333333
		private static function drawDonut(color:uint, screen:Sprite, phi:Number, radius:Number, lengthCounter:Number, stickyFlag:Boolean, dot:Number, linewidth:Number):void {

			for (var i:uint=0; i<3; i++){	
				for (var j:int=-2; j<3; j++){
					var dot_t:Number = dot/2/(1+Math.abs(j));
					var an_j:Number = an*i+an_t*j+phi;
					screen.graphics.lineStyle(linewidth/(1+Math.abs(j))+1, color);
					screen.graphics.moveTo((radius-dot_t)*Math.cos(an_j), (radius-dot_t)*Math.sin(an_j));
					screen.graphics.lineTo((radius+dot_t)*Math.cos(an_j), (radius+dot_t)*Math.sin(an_j));
				}
			}
			
			screen.graphics.lineStyle(1, color);
			if (stickyFlag)	{
				for (var m:uint=0; m<3; m++){
					var an_n:Number = an*m+phi;
					for (var n:uint=0; n<lengthCounter/(80/radius); n++){
						var rad:Number=radius*.7-n*4;
						screen.graphics.moveTo (   rad*Math.cos(an_n-an_t/2),    rad*Math.sin(an_n-an_t/2)  );
						screen.graphics.curveTo (  (rad+radius/(j+1)/10)*Math.cos(an_n), (rad+radius/10)*Math.sin(an_n),
												   rad*Math.cos(an_n+an_t/2),    rad*Math.sin(an_n+an_t/2)  );
					}	
				}
			}
		}
		
		
	}
}