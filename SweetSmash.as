package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class SweetSmash extends MovieClip{
		
		private var topBar:TopBar = new TopBar();
		public var kitchen:Kitchen = new Kitchen();
		private var tileList:Array = new Array();
		
		//Controls whether the user can interact with the grid or not at various times
		public var gridInputLight:ToggleLight;

		private var sweetList:Array = new Array();
		
		public var sweetGrid:Grid;
		
		//Keep track of sweets to swap
		public var sweet1:Sweet;
		public var sweet2:Sweet;
		
		//#########################
		//#	Constructor
		//#########################
		public function SweetSmash() {

			//Create the Grid of Sweets
			this.sweetGrid = new Grid(this);
			
			//Add 81 background tiles and the top bar (these are always static)
			this.buildBackground();
			
			//Draw input light to tell user when input is or is not allowed
			this.gridInputLight = new ToggleLight(200,15);
			addChild(this.gridInputLight);
			
			//Place kitchen
			addChild(this.kitchen);
			
			this.buildInitialSweetGrid();
			
			//Debugging
			//this.addEventListener(MouseEvent.MOUSE_DOWN,printCursorPosition);
		}
		
		//#########################
		//#	Print Cursor Position
		//#########################
		private function printCursorPosition(event:MouseEvent):void{
			//trace("Cursor Position: ("+this.mouseX+","+this.mouseY+")");
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
			this.kitchen.openDoor(1500);
			
			var moveToDelay:uint = 20;
			
			//Place sweets
			var rowNumber = 0;
			var colNumber = 0;
			for(var i:uint=32; i<608; i+=64){
				for(var j:uint=96; j<672; j+=64){
					
					//1. Add the sweet to my dictionary
					this.sweetGrid.grid["row"+rowNumber+"col"+colNumber] = new Sweet(i,j,this);
					addChild(this.sweetGrid.grid["row"+rowNumber+"col"+colNumber]);
					
					//Get ready to animate the sweet. It will shoot out from the kitchen to its initial grid position.
					var mySweet = this.sweetGrid.grid["row"+rowNumber+"col"+colNumber];
					mySweet.moveToPosition(mySweet.getOriginX(),mySweet.getOriginY(),10,moveToDelay,"processMatches",162);
					
					//I want the sweets to shoot out one at a time at staggered intervals, so increase the delay for the next sweet.
					moveToDelay += 20;
					
					//Setup all sweets to listen for mouse up/down (Drags)
					mySweet.addEventListener(MouseEvent.MOUSE_DOWN,mySweet.wiggle);
					mySweet.addEventListener(MouseEvent.MOUSE_UP,this.performSwap);
					
					rowNumber++;
				}
				rowNumber = 0;
				colNumber++;
			}
		}
		
		//#########################
		//#	Perform Swap
		//#########################
		public function performSwap(event:MouseEvent):void{
			if(!this.gridInputLight.isEnabled()){
				trace("Ignoring swap request because input is disabled.");
				return;
			}
			
			this.sweet2 = (event.target as Sweet);
			
			if(this.sweet1 != null && this.sweet1 != this.sweet2){
				
				//Is the move even physically possible?
				if(this.sweetGrid.moveIsPhysicallyPossible(this.sweet1,this.sweet2)){

					if(this.sweetGrid.moveIsLogicallyPossible(this.sweet1,this.sweet2)){

						this.gridInputLight.setEnabled(false);
						
						trace("Swap is logically possible.");
						this.sweet1.stopWiggle();
						
						var tempX = this.sweet1.x;
						var tempY = this.sweet1.y;
						this.sweet1.moveToPosition(this.sweet2.x,this.sweet2.y,5,0,"showAllMatches",2);
						this.sweet2.moveToPosition(tempX,tempY,5,0,"showAllMatches",2);
					}else{
						trace("Swap is not logically possible.");
						//Stop wiggling the chosen sweet
						this.sweet1.stopWiggle();
					}
				}else{
					trace("Move is not physically possible. Ignoring...");
				}
			}else{
				if(this.sweet1 != null){
					//Tell me the info about this chosen sweet
					trace("Sweet Info: defaultFrame="+this.sweet1.getDefaultFrame()+", key="+this.sweet1.getKey());
					var myLocation:String = "";
					for(var col:uint=0; col<9; col++){
						for(var row:uint=0; row<9; row++){
							if(this.sweetGrid.grid["row"+row+"col"+col] == this.sweet1){
								myLocation = "row"+row+"col"+col;
								break;
							}
						}
					}
					trace("I belong at the location this.sweetGrid["+myLocation+"]");
					//Stop wiggling the chosen sweet
					this.sweet1.stopWiggle();
				}
			}
		}
	}
	
}
