package  {
	import flash.display.MovieClip;
	
	public class SweetSmash extends MovieClip{

		private var topBar:TopBar = new TopBar();
		private var kitchen:Kitchen = new Kitchen();
		private var tileList:Array = new Array();

		private var sweetList:Array = new Array();
		
		public function SweetSmash() {
			//Place TopBar
			addChild(topBar);
			
			//Place kitchen
			addChild(this.kitchen);
			
			//Place tiles
			for(var i:uint=0; i<576; i+=64){
				for(var j:uint=64; j<640; j+=64){
					addChild(new Tile(i,j));
				}
			}
			
			//Place sweets
			for(i=32; i<608; i+=64){
				for(j=96; j<672; j+=64){
					this.sweetList.push(new Sweet(i,j,Math.floor(Math.random() * 5+1)));
					addChild(this.sweetList[this.sweetList.length-1]);
					var mySweet = this.sweetList[this.sweetList.length-1];
					mySweet.explodeOn(mySweet,this);
				}
			}
			
		}

	}
	
}
