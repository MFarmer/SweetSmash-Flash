package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class SweetSmash extends MovieClip{

		private var topBar:TopBar = new TopBar();
		private var kitchen:Kitchen = new Kitchen();
		private var tileList:Array = new Array();

		private var sweetList:Array = new Array();
		
		//Keep track of whether input is allowed at the moment or not
		public var gridInputAllowed:Boolean;
		
		//Keep track of sweets to swap
		public var sweet1:Sweet;
		public var sweet2:Sweet;
		
		//#########################
		//#	Constructor
		//#########################
		public function SweetSmash() {
			
			//Don't allow input initially
			this.gridInputAllowed = false;
			
			this.buildBackground();
			
			//Place kitchen
			addChild(this.kitchen);
			
			this.buildInitialSweetGrid();
			
			//Debugging
			this.addEventListener(MouseEvent.MOUSE_DOWN,printCursorPosition);
		}
		
		//#########################
		//#	Print Cursor Position
		//#########################
		private function printCursorPosition(event:MouseEvent):void{
			trace("Cursor Position: ("+this.mouseX+","+this.mouseY+")");
		}
		
		//#########################
		//#	Build Background
		//#########################
		private function buildBackground():void{
			//Place TopBar
			addChild(topBar);
			
			//Place tiles
			for(var i:uint=0; i<576; i+=64){
				for(var j:uint=64; j<640; j+=64){
					addChild(new Tile(i,j));
				}
			}
		}
		
		//#########################
		//#	Build Initial Sweet Grid
		//#########################
		private function buildInitialSweetGrid():void{
			//Open the kitchen door
			this.kitchen.openDoor(500);
			
			//Place sweets
			for(var i:uint=32; i<608; i+=64){
				for(var j:uint=96; j<672; j+=64){
					this.sweetList.push(new Sweet(i,j,this));
					addChild(this.sweetList[this.sweetList.length-1]);
					var mySweet = this.sweetList[this.sweetList.length-1];
					
					//Move the Sweet from the Kitchen to its Initial Position
					mySweet.moveToPosition(mySweet.getOriginX(),mySweet.getOriginY(),20);
					
					//Setup all sweets to listen for mouse up/down (Drags)
					mySweet.addEventListener(MouseEvent.MOUSE_DOWN,mySweet.wiggle);
					mySweet.addEventListener(MouseEvent.MOUSE_UP,this.performSwap);
				}
			}
		}
		
		//#########################
		//#	Perform Swap
		//#########################
		private function performSwap(event:MouseEvent):void{
			if(this.sweet1 != null){
				this.sweet2 = (event.target as Sweet);
				
				var tempX = this.sweet1.x;
				var tempY = this.sweet1.y;
				
				//Animate the swap
				this.sweet1.moveToPosition(this.sweet2.x,this.sweet2.y,5);
				this.sweet2.moveToPosition(tempX,tempY,5);
				
				//Update the logical grid
				//TODO
				
				//Stop wiggling the chosen sweet
				this.sweet1.stopWiggle();
				
				this.sweet1 = null;
				this.sweet2 = null;
			}
		}

	}
	
}
