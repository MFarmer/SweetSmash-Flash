package  {
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	
	public class Grid {

		public var grid:Dictionary = new Dictionary();
		
		private var tempGrid:Dictionary = new Dictionary();
		private var matchBucket:Array = new Array();
		private var freeSpacesPerColumn:Array = new Array();
		
		private var myGame:SweetSmash;
		
		//Stat Counters
		private var comboFound:uint = 0;
		
		public function Grid(myGame:SweetSmash) {
			this.myGame = myGame;
		}
		
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
		
		public function processMatches():void{
			this.matchBucket = new Array();
			this.tempGrid = this.grid;
			this.findColMatches();
			this.findRowMatches();
			if(this.matchBucket.length > 0){
				this.showAllMatchedSweets();
			}else{
				//USER INPUT WILL BE RE-ENABLED BECAUSE THERE ARE NO MATCHES TO AUTO-EXPLODE.
				//this.myGame.gridInputAllowed = true;
				this.myGame.gridInputLight.setEnabled(true);
			}
		}
		
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
		
		private function keyIsInMatchBucket(key:String):Boolean{
			for(var i:uint=0; i<this.matchBucket.length; i++){
				if(this.grid[key] == this.matchBucket[i]){
					trace("Found the key in my bucket.");
					return true;
				}
			}
			return false;
		}
		
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
						this.matchBucket.push(this.tempGrid["row"+row+"col"+col]);
					}else{
						matchStreak = this.resetMatchStatus(matchStreak);
						row--;
					}
				}
				matchStreak = this.resetMatchStatus(matchStreak);
			}
			
		}
		
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
						this.matchBucket.push(this.tempGrid["row"+row+"col"+col]);
					}else{
						matchStreak = this.resetMatchStatus(matchStreak);
						col--;
					}
				}
				matchStreak = this.resetMatchStatus(matchStreak);
			}
		}
		
		//Call when a match streak ends and the results need to be processed
		private function resetMatchStatus(matchStreak):uint{
			if(matchStreak < 3){
				var lastIndex:uint = this.matchBucket.length - 1;
				for(var i:int=lastIndex; i>lastIndex-matchStreak; i--){
					this.matchBucket.splice(i,1);
				}
			}else{
				this.comboFound++;
			}
			
			return 0;
		}
		
		//http://stackoverflow.com/questions/2386781/get-size-of-actionscript-3-dictionary/2386847#2386847
		public static function countKeys(myDictionary:flash.utils.Dictionary):int 
		{
			var n:int = 0;
			for (var key:* in myDictionary) {
				n++;
			}
			return n;
		}
		
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
			for(var i:uint=0; i<this.matchBucket.length; i++){
				this.matchBucket[i].isMatched = true;
				this.matchBucket[i].startExplode(uniqueSweetCount);
			}
		}
		
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
			for(var i:uint=0; i<sweetsToMoveDown.length; i++){
				//Update the physical grid
				sweetsToMoveDown[i].moveDown(sweetsToMoveDown[i].spacesToMoveDown,64,20,"settling",sweetsToMoveDown.length);
			}
		}
		
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
					
					//Replace the empty sweet with a new sweet
					this.grid["row"+i+"col"+col] = new Sweet(newX,newY,this.myGame);
					this.myGame.addChild(this.grid["row"+i+"col"+col]);
					
					var mySweet = this.grid["row"+i+"col"+col];
					mySweet.moveToPosition(mySweet.getOriginX(),mySweet.getOriginY(),10,0,"processMatches",totalFreeSpaces);
					
					//Setup all sweets to listen for mouse up/down (Drags)
					mySweet.addEventListener(MouseEvent.MOUSE_DOWN,mySweet.wiggle);
					mySweet.addEventListener(MouseEvent.MOUSE_UP,this.myGame.performSwap);
				}
			}
			
		}
	}
	
}
