package  {
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality; 
	import flash.filters.BlurFilter; 
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.media.Sound;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
	
	public class Grid {

		public var grid:Dictionary = new Dictionary();
		
		private var tempGrid:Dictionary = new Dictionary();
		private var matchBucket:Array = new Array();
		private var freeSpacesPerColumn:Array = new Array();
		private var specialBucket:Array = new Array();
		private var superSpecialBucket:Array = new Array();
		private var sawSuperSpecialInActiveMatch:Boolean;
		private var myGame:SweetSmash;
		
		//Sound effects
		private var explode1Sound:Sound;
		private var explode11Sound:Sound;
		private var explode2Sound:Sound;
		private var explode3Sound:Sound;
		
		//Stat Counters
		private var comboFound:uint = 0;
		private var currentComboStreak:uint = 0;
		public var longestComboStreak:uint = 0;
		
		//############################################################
		//# Constructor
		//############################################################
		public function Grid(myGame:SweetSmash) {
			//Setup sound effects
			this.explode1Sound = new Sound(new URLRequest("sound/explode1.mp3"));
			this.explode11Sound = new Sound(new URLRequest("sound/explode1-1.mp3"));
			this.explode2Sound = new Sound(new URLRequest("sound/explode4.mp3"));
			this.explode3Sound = new Sound(new URLRequest("sound/explode3.mp3"));
			this.myGame = myGame;
			this.sawSuperSpecialInActiveMatch = false;
		}
		
		//############################################################
		//# Clean Grid
		//############################################################
		public function cleanGrid():void{
			for(var row:uint=0; row<9; row++){
				for(var col:uint=0; col<9; col++){
					this.grid["row"+row+"col"+col].removeEventListener(MouseEvent.MOUSE_DOWN,this.grid["row"+row+"col"+col].wiggle);
					this.grid["row"+row+"col"+col].removeEventListener(MouseEvent.MOUSE_UP,this.myGame.performSwap);
					this.myGame.removeChild(this.grid["row"+row+"col"+col]);
					delete this.grid["row"+row+"col"+col];
				}
			}
			this.grid = null;
			this.tempGrid = null;
			this.matchBucket = null;
			this.freeSpacesPerColumn = null;
			this.specialBucket = null;
			this.superSpecialBucket = null;
			this.comboFound = 0;
			this.currentComboStreak = 0;
			this.longestComboStreak = 0;
			
			this.grid = new Dictionary();
			this.tempGrid = new Dictionary();
			this.matchBucket = new Array();
			this.freeSpacesPerColumn = new Array();
			this.specialBucket = new Array();
			this.superSpecialBucket = new Array();
			this.sawSuperSpecialInActiveMatch = false;
		}
		
		//############################################################
		//# Move is Physically Possible
		//############################################################
		public function moveIsPhysicallyPossible(s1:Sweet,s2:Sweet):Boolean{
			var key1 = s1.getKey();
			var key2 = s2.getKey();
			
			var result:Boolean = false;
			
			var temp1:String = key1.split("row")[1];
			var temp2:String = key2.split("row")[1];
			
			var row1:int = int(temp1.split("col")[0]);
			var col1:int = int(temp1.split("col")[1]);
			
			var row2:int = int(temp2.split("col")[0]);
			var col2:int = int(temp2.split("col")[1]);
			
			//If move is legal (directly left, right, up, or down.
			if((Math.abs(row1 - row2) == 1 && Math.abs(col1 - col2) == 0) || (Math.abs(col1 - col2) == 1 && Math.abs(row1 - row2) == 0)){
				trace("The move is legal. Do it.");
				result = true;
			}
			
			return result;
		}
		
		//############################################################
		//# Move is Logically Possible
		//############################################################
		public function moveIsLogicallyPossible(s1:Sweet,s2:Sweet):Boolean{
			
			var key1 = s1.getKey();
			var key2 = s2.getKey();
			
			//Re-initialize a new, empty matchBucket
			this.matchBucket = new Array();
			this.specialBucket = new Array();
			this.superSpecialBucket = new Array();
			
			//Copy over the current grid to the tempGrid
			this.tempGrid = this.grid;
			
			//Make the logical swap in the tempGrid			
			var sweet1 = this.tempGrid[key1];
			var sweet2 = this.tempGrid[key2];
			
			delete this.tempGrid[key1];
			delete this.tempGrid[key2];
			
			this.tempGrid[key1] = sweet2;
			this.tempGrid[key2] = sweet1;
			
			//I need to find all matches in my grid
			this.findColMatches();
			this.findRowMatches();

			//** The Match Bucket is now filled with all sweets which are involved in a match **
			//The aforementioned functions placed match keys into the matchBucket. If key1 and/or key2 are in the matchBucket, the move is logically possible.
			if(this.keyIsInMatchBucket(key1) || this.keyIsInMatchBucket(key2)){
				
				this.grid = this.tempGrid;
				this.currentComboStreak++;
				return true;
			}else{
				sweet1 = this.tempGrid[key1];
				sweet2 = this.tempGrid[key2];
			
				delete this.tempGrid[key1];
				delete this.tempGrid[key2];
			
				this.tempGrid[key1] = sweet2;
				this.tempGrid[key2] = sweet1;
				
				return false;
			}
		}
		
		//############################################################
		//# Process Matches
		//############################################################
		public function processMatches():void{
			this.matchBucket = new Array();
			this.specialBucket = new Array();
			this.superSpecialBucket = new Array();
			this.tempGrid = this.grid;
			
			this.findColMatches();
			this.findRowMatches();
			
			if(this.matchBucket.length > 0){
				this.currentComboStreak++;
				this.showAllMatchedSweets();
			}else{
				//USER INPUT WILL BE RE-ENABLED BECAUSE THERE ARE NO MATCHES TO AUTO-EXPLODE.
				if(this.currentComboStreak > this.longestComboStreak){
					this.longestComboStreak = this.currentComboStreak;
				}
				this.currentComboStreak = 0;
				
				if(this.myGame.movesRemaining.getValue() > 0){
					this.myGame.gridInputLight.setEnabled(true);
					this.myGame.helpButton.visible = true;
				}else{
					trace("Game Over!");
					this.myGame.addChild(this.myGame.recapBoard);
					this.myGame.recapBoard.startFade(20,false);
					this.myGame.recapBoard.beginRecap();
					
					//Blur all symbols on board
					this.blurGame(new Array(new BlurFilter(10,10,1)));
				}
			}
		}
		
		//############################################################
		//# Blur Game (To un-blur game, send it an empty array
		//############################################################
		public function blurGame(blurEffect:Array):void{

			//Blur the sweets and tiles
			for(var row:uint=0; row<9; row++){
				for(var col:uint=0; col<9; col++){
					this.grid["row"+row+"col"+col].filters = blurEffect;
				}
			}
			//Blur the tiles
			for(var i:uint=0; i<this.myGame.tileGrid.length; i++){
				this.myGame.tileGrid[i].filters = blurEffect;
			}
			//Blur the kitchen
			this.myGame.kitchen.filters = blurEffect;
			//Blur the topbar
			this.myGame.topBar.filters = blurEffect;
			//Blur the grid input light
			this.myGame.gridInputLight.filters = blurEffect;
			//Blur the hud textfields
			this.myGame.scoreBoard.filters = blurEffect;
			this.myGame.timeElapsed.filters = blurEffect;
			this.myGame.movesRemaining.filters = blurEffect;
		}
		
		//############################################################
		//# Print Grid
		//############################################################
		private function printGrid(x:Dictionary):void{
			var rowFrames:String;
			trace("-------------------------------------");
			for(var row:uint=0; row<9; row++){
				for(var col:uint=0; col<9; col++){
					if(x["row"+row+"col"+col]){
						rowFrames += x["row"+row+"col"+col].getDefaultFrame();
					}else{
						rowFrames += " ";
					}
					rowFrames += " ";
				}
				trace(rowFrames);
				rowFrames = "";
			}
			trace("-------------------------------------");
		}

		//############################################################
		//# Key is in Match Bucket
		//############################################################
		private function keyIsInMatchBucket(key:String):Boolean{
			for(var i:uint=0; i<this.matchBucket.length; i++){
				if(this.grid[key] == this.matchBucket[i]){
					trace("Found the key in my bucket.");
					return true;
				}
			}
			return false;
		}
		
		//############################################################
		//# Find Column Matches
		//############################################################
		private function findColMatches():void{
			var frame:uint;
			var matchStreak:uint = 0;
			
			for(var col:uint=0; col<9; col++){
				
				for(var row:uint=0; row<9; row++){
					
					if(matchStreak == 0){
						frame = this.tempGrid["row"+row+"col"+col].getDefaultFrame();
					}
					
					if(this.tempGrid["row"+row+"col"+col].getDefaultFrame() == frame){
						matchStreak++;
						if(this.tempGrid["row"+row+"col"+col].isSuperSpecial){
							this.sawSuperSpecialInActiveMatch = true;
						}
						this.matchBucket.push(this.tempGrid["row"+row+"col"+col]);
					}else{
						matchStreak = this.resetMatchStatus(matchStreak);
						row--;
					}
				}
				matchStreak = this.resetMatchStatus(matchStreak);
			}
			
		}
		
		//############################################################
		//# Find Row Matches
		//############################################################
		private function findRowMatches():void{
			var frame:uint;
			var matchStreak:uint = 0;
			
			for(var row:uint=0; row<9; row++){
				
				for(var col:uint=0; col<9; col++){
					
					if(matchStreak == 0){
						frame = this.tempGrid["row"+row+"col"+col].getDefaultFrame();
					}
					
					if(this.tempGrid["row"+row+"col"+col].getDefaultFrame() == frame){
						matchStreak++;
						if(this.tempGrid["row"+row+"col"+col].isSuperSpecial){
							this.sawSuperSpecialInActiveMatch = true;
						}
						this.matchBucket.push(this.tempGrid["row"+row+"col"+col]);
					}else{
						matchStreak = this.resetMatchStatus(matchStreak);
						col--;
					}
				}
				matchStreak = this.resetMatchStatus(matchStreak);
			}
		}
		
		//############################################################
		//# Reset Match Status
		//############################################################
		//Call when a match streak ends and the results need to be processed
		private function resetMatchStatus(matchStreak):uint{
			if(matchStreak < 3){
				var lastIndex:uint = this.matchBucket.length - 1;
				for(var i:int=lastIndex; i>lastIndex-matchStreak; i--){
					this.matchBucket.splice(i,1);
				}
			}else{
				this.comboFound++;
				//Find opportunities for special sweets
				if(matchStreak >= 4){
					//Mark the sweet in the middle of this 4-5 combo as a special jelly bean.
					if(this.myGame.sweet1 && this.myGame.sweet2){
						if(this.keyIsInMatchBucket(this.myGame.sweet1.getKey())){
							//Sweet1 succeeded in a match
							this.specialBucket.push(this.myGame.sweet1.getKey());
						}else{
							this.specialBucket.push(this.myGame.sweet2.getKey());
						}
					}
				}
				if(this.sawSuperSpecialInActiveMatch){
					//Wow! Blow up the entire board.
					for(var l:uint=0; l<9; l++){
						for(var m:uint=0; m<9; m++){
							//Reset all super special sweets since they are about to be blown up
							if(this.tempGrid["row"+l+"col"+m].isSuperSpecial){
								this.tempGrid["row"+l+"col"+m].isSuperSpecial = false;
							}
							this.matchBucket.push(this.tempGrid["row"+l+"col"+m]);
						}
					}
				}else if(this.matchBucket[this.matchBucket.length-1].getDefaultFrame() == 7){
					this.superSpecialBucket.push(this.matchBucket[this.matchBucket.length-2].getKey());
					this.specialBucket.push(this.matchBucket[this.matchBucket.length-2].getKey());
					
					var colNumber:uint = this.matchBucket[this.matchBucket.length-1].getCol();
					if(this.matchBucket[this.matchBucket.length-1].getCol() == this.matchBucket[this.matchBucket.length-2].getCol()){
						//Put the entire column into the  matchbucket
						for(var j:uint=0; j<9; j++){
							this.matchBucket.push(this.tempGrid["row"+j+"col"+colNumber]);
						}
					}else{
						//Put the entire row into the matchbucket
						var rowNumber:uint = this.matchBucket[this.matchBucket.length-1].getRow();
						for(var k:uint=0; k<9; k++){
							this.matchBucket.push(this.tempGrid["row"+rowNumber+"col"+k]);
						}
					}
				}
			}
			this.sawSuperSpecialInActiveMatch = false;
			return 0;
		}
		
		//############################################################
		//# Count Keys
		//############################################################
		//http://stackoverflow.com/questions/2386781/get-size-of-actionscript-3-dictionary/2386847#2386847
		public static function countKeys(myDictionary:flash.utils.Dictionary):int 
		{
			var n:int = 0;
			for (var key:* in myDictionary) {
				n++;
			}
			return n;
		}
		
		//############################################################
		//# Show All Matched Sweets
		//############################################################
		public function showAllMatchedSweets():void{
			//Figure out how many unique sweets in the match bucket there are
			var uniqueSweet:Dictionary = new Dictionary();
			trace("ShowAllMatchedSweets:");
			trace("~~~~~~~~~~~~~~~~~~~~~");
			for(var i:uint=0; i<this.matchBucket.length; i++){
				if(!uniqueSweet[this.matchBucket[i].getKey()]){
					trace(this.matchBucket[i].getKey()+": Unique. I will explode this sweet.");
					uniqueSweet[this.matchBucket[i].getKey()] = this.matchBucket[i];
					trace(this.matchBucket[i].getKey()+": ALREADY ACCOUNTED FOR, I will not explode it again.");
				}else{
					trace(this.matchBucket[i].getKey()+": ALREADY ACCOUNTED FOR, I will not explode it again.");
				}
			}
			trace("~~~~~~~~~~~~~~~~~~~~~");
			
			var uniqueSweetCount = countKeys(uniqueSweet);
			//Begin the explosions. When the explosions end, sweets will settle.
			for(i=0; i<this.matchBucket.length; i++){
				this.matchBucket[i].isMatched = true;
				//this.matchBucket[i].startExplode(uniqueSweetCount);
				this.matchBucket[i].gotoAndStop(6);//switch to the package icon
			}
			
			//Play explosion sound effect
			if(this.matchBucket.length < 5){
				this.explode1Sound.play();
			}else if(this.matchBucket.length < 10){
				this.explode1Sound.play();
				this.explode2Sound.play();
			}else{
				this.explode1Sound.play();
				this.explode2Sound.play();
				this.explode3Sound.play();
				this.explode11Sound.play();
			}
			
			//For each match, add 25 pts to the scoreboard
			this.myGame.scoreBoard.updateText(25*this.matchBucket.length);
			
			//Wait some time before processing the matches
			var myTimer:Timer = new Timer(375, 1);
            myTimer.addEventListener("timer", timerHandler);
            myTimer.start();
		}
		
		public function timerHandler(event:TimerEvent):void {
            trace("Settle sweets");
			for(var i:uint=0; i<this.matchBucket.length; i++){
				//Safely remove the sweet from the board.
				if(this.matchBucket[i].parent){
					try{
						this.matchBucket[i].parent.removeChild(this.matchBucket[i]);
					}catch(err:Error){
						trace("particle list not removing");
					}
				}
			}
			this.settleSweets();
        }
		
		//############################################################
		//# Place Special Sweets
		//############################################################	
		public function placeSpecialSweets():void{
			trace("Placing special sweets... (if any)");
			for(var i:uint=0; i<this.specialBucket.length; i++){
				this.grid[this.specialBucket[i]].isMatched = false;
				this.grid[this.specialBucket[i]].setDefaultFrame(7);
				//this.grid[this.specialBucket[i]].startPulse(0.8,1.2,0.1);
			}
			for(i=0; i<this.superSpecialBucket.length; i++){
				this.grid[this.superSpecialBucket[i]].isSuperSpecial = true;
				this.grid[this.superSpecialBucket[i]].startPulse(0.8,1.2,0.1);
			}
		}
		
		//############################################################
		//# Settle Sweets
		//############################################################
		public function settleSweets():void{
			trace("Settling muh sweets...");
			
			var emptySpaces:uint = 0;
			var moveDownCount:uint = 0;
			var sweetsToMoveDown:Array = new Array();
			
			this.freeSpacesPerColumn = new Array();
			
			//Plan on which sweets to move down and how far
			for(var col:uint=0; col<9; col++){
				for(var row:int=8; row>=0; row--){
					if(this.grid["row"+row+"col"+col].isMatched){
						emptySpaces++;
					}else{
						this.grid["row"+row+"col"+col].spacesToMoveDown = emptySpaces;
						sweetsToMoveDown.push(this.grid["row"+row+"col"+col]);
					}
				}
				this.freeSpacesPerColumn.push(emptySpaces);
				emptySpaces = 0;
			}
			
			//Actually move the sweets down
			if(sweetsToMoveDown.length > 0){
				for(var i:uint=0; i<sweetsToMoveDown.length; i++){
					//Update the physical grid
					sweetsToMoveDown[i].moveDown(sweetsToMoveDown[i].spacesToMoveDown,64,20,"settling",sweetsToMoveDown.length);
				}
			}else{
				//In the event the entire board was cleared, there will be no sweets to move down, so go ahead and just place new sweets.
				this.placeNewSweets();
			}
		}
		
		//############################################################
		//# Place New Sweets
		//############################################################
		public function placeNewSweets():void{
			trace("Placing new sweets!");
			
			//Refresh grid
			var resetGrid:Dictionary = new Dictionary();
			
			for(var col:uint=0; col<9; col++){
				for(var row:uint=0; row<9; row++){
					if(!this.grid["row"+row+"col"+col].isMatched){
						resetGrid[this.grid["row"+row+"col"+col].getKey()] = this.grid["row"+row+"col"+col];
					}else{
						this.grid["row"+row+"col"+col].removeEventListener(MouseEvent.MOUSE_DOWN,this.grid["row"+row+"col"+col].wiggle);
						this.grid["row"+row+"col"+col].removeEventListener(MouseEvent.MOUSE_UP,this.myGame.performSwap);
						trace("not including row"+row+"col"+col+"in the new resetGrid because this sweet was matched");
					}
				}
			}
			this.printGrid(resetGrid);
			
			//Erase the old grid
			this.grid = null;
			this.grid = new Dictionary();
			//Copy the contents of the new grid into the official grid
			this.grid = resetGrid;
			resetGrid = null;
			
			//Figure out where the empty spots are now
			var totalFreeSpaces:uint = 0;
			for(var j:uint=0; j<this.freeSpacesPerColumn.length; j++){
				totalFreeSpaces += this.freeSpacesPerColumn[j];
			}
			
			trace("There are "+totalFreeSpaces+" free spaces!");
			this.myGame.kitchen.openDoor(500);//door will close when this function ends regardless I believe, so better to set too long than too short
			
			for(col=0; col<9; col++){
				for(var i:uint=0; i<this.freeSpacesPerColumn[col]; i++){
					//Record the location of this empty sweet
					var newY:uint = (i*64)+96;
					var newX:uint = (col*64)+32;
					
					//Replace the empty sweet with a new sweet. Also check to see if this sweet should be special
					this.grid["row"+i+"col"+col] = new Sweet(newX,newY,this.myGame);					
					this.myGame.addChild(this.grid["row"+i+"col"+col]);
					
					var mySweet = this.grid["row"+i+"col"+col];
					mySweet.moveToPosition(mySweet.getOriginX(),mySweet.getOriginY(),5,0,"processMatches",totalFreeSpaces);
					
					//Setup all sweets to listen for mouse up/down (Drags)
					mySweet.addEventListener(MouseEvent.MOUSE_DOWN,mySweet.wiggle);
					mySweet.addEventListener(MouseEvent.MOUSE_UP,this.myGame.performSwap);
				}
			}
			
			//Show the special sweets
			this.placeSpecialSweets();
		}
	}
	
}
