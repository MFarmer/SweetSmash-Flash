package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.filters.BlurFilter;
	
	public class SweetSmash extends MovieClip{
		
		public var topBar:TopBar = new TopBar();
		public var kitchen:Kitchen = new Kitchen();
		//private var tileList:Array = new Array();
		
		//Controls whether the user can interact with the grid or not at various times
		public var gridInputLight:ToggleLight;
		
		//Scoreboard
		public var scoreBoard:HUDInfoText = new HUDInfoText(0,"SCORE",32,15,16);
		public var movesRemaining:HUDInfoText = new HUDInfoText(10,"MOVES LEFT",32,690,16);
		public var timeElapsed:HUDInfoText = new HUDInfoText(0,"ELAPSED TIME",32,275,16);
		
		//End of Game UI
		public var recapBoard:Recap;
		public var mainMenu:MainMenu;
		
		private var sweetList:Array = new Array();
		
		public var sweetGrid:Grid;
		
		public var tileGrid:Array;
		
		//Keep track of sweets to swap
		public var sweet1:Sweet;
		public var sweet2:Sweet;
		
		//#########################
		//#	Constructor
		//#########################
		public function SweetSmash() {

			//Create the Grid of Sweets.
			this.sweetGrid = new Grid(this);
			this.recapBoard = new Recap(this);
			this.mainMenu = new MainMenu(this);
			
			//Add 81 background tiles and the top bar (these are always static)
			this.buildBackground();
			
			//Draw the Score
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,timerTriggered);
			addChild(this.scoreBoard);
			addChild(this.movesRemaining);
			addChild(this.timeElapsed);
			timer.start();
			
			//Place kitchen
			addChild(this.kitchen);
			
			//Draw input light to tell user when input is or is not allowed
			this.gridInputLight = new ToggleLight(600,600);
			addChild(this.gridInputLight);
			
			//this.buildInitialSweetGrid();
			this.showMainMenu();
			
			//Debugging
			//this.addEventListener(MouseEvent.MOUSE_DOWN,printCursorPosition);
		}
		
		private function timerTriggered(event:TimerEvent):void{
			if(this.movesRemaining.getValue() > 0 && this.gridInputLight.isEnabled()){
				this.timeElapsed.updateText(1);
			}
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
			this.tileGrid = new Array();
			for(var i:uint=0; i<576; i+=64){
				for(var j:uint=64; j<640; j+=64){
					this.tileGrid.push(new Tile(i,j));
					addChild(this.tileGrid[this.tileGrid.length-1]);
				}
			}
		}
		//#########################
		//# Show Main Menu
		//#########################
		public function showMainMenu():void{
			//this.addChild(this.mainMenu());
			this.buildInitialSweetGrid("");
			this.sweetGrid.blurGame(new Array(new BlurFilter(10,10,1)));
			this.mainMenu.addEventListener(MouseEvent.MOUSE_DOWN,this.startGame);
			this.addChild(this.mainMenu);
		}
		
		private function startGame(event:MouseEvent):void{
			this.sweetGrid.blurGame(new Array());
			this.scoreBoard.applyShadowFilter();
			this.movesRemaining.applyShadowFilter();
			this.timeElapsed.applyShadowFilter();
			this.mainMenu.removeEventListener(MouseEvent.MOUSE_DOWN,this.startGame);
			this.removeChild(this.mainMenu);
			this.buildInitialSweetGrid("processMatches");
		}
		
		//#########################
		//#	Build Initial Sweet Grid
		//#########################
		public function buildInitialSweetGrid(followupFunctionName:String):void{
			
			if(this.sweetGrid.grid["row0col0"]){
				this.movesRemaining.resetValue(10);
				this.timeElapsed.resetValue(0);
				this.scoreBoard.resetValue(0);
				//this.removeChild(this.recapBoard);
				this.recapBoard = null;
				this.recapBoard = new Recap(this);
				this.sweetGrid.blurGame(new Array());
				this.scoreBoard.applyShadowFilter();
				this.movesRemaining.applyShadowFilter();
				this.timeElapsed.applyShadowFilter();
				this.sweetGrid.cleanGrid();
			}
			
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
					mySweet.moveToPosition(mySweet.getOriginX(),mySweet.getOriginY(),10,moveToDelay,followupFunctionName,81);
					
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
						
						this.movesRemaining.updateText(-1);
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
