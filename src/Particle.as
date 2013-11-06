package  {
	import fl.motion.Color;
	
	public class Particle extends Animate{
		
		public function Particle(localX:int,localY:int) {
			this.x = localX;
			this.y = localY;
			
			//Make the particle a random color;
			// new ColorTransform object
			var my_color:Color = new Color();
			
			var digitList:Array = new Array(0xFFFFFF,0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0x00FFFF);
			my_color.setTint(digitList[Math.floor(Math.random()*digitList.length)], 1.0); // my_mc turns red
			this.transform.colorTransform = my_color;
		}

	}
	
}
