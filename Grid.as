package  {
	import flash.utils.Dictionary;
	
	public class Grid {

		public var grid:Dictionary = new Dictionary();
		private var tempGrid:Dictionary = new Dictionary();
		private var matchBucket:Array;
		
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
		
		public function moveIsLogicallyPossible(s1:Sweet,s2:Sweet):Boolean{
			
			var key1 = s1.getKey();
			var key2 = s2.getKey();
			
			//Re-initialize a new, empty matchBucket
			this.matchBucket = new Array();
			
			//Copy over the current grid to the tempGrid
			this.tempGrid = this.grid;
			
			this.printGrid(this.tempGrid);
			
			//Make the logical swap in the tempGrid			
			var sweet1 = this.tempGrid[key1];
			var sweet2 = this.tempGrid[key2];
			
			delete this.tempGrid[key1];
			delete this.tempGrid[key2];
			
			this.tempGrid[key1] = sweet2;
			this.tempGrid[key2] = sweet1;
			
			this.printGrid(this.tempGrid);
			
			//I need to find all matches in my grid
			this.findColMatches();
			this.findRowMatches();

			//** The Match Bucket is now filled with all sweets which are involved in a match **
			//The aforementioned functions placed match keys into the matchBucket. If key1 and/or key2 are in the matchBucket, the move is logically possible.
			if(this.keyIsInMatchBucket(key1) || this.keyIsInMatchBucket(key2)){
				//move is logically sound. Allow it!
				this.grid = this.tempGrid;
				
				return true;
			}else{
				return false;
			}
		}
		
		private function printGrid(x:Dictionary):void{
			var rowFrames:String;
			trace("-------------------------------------");
			for(var row:uint=0; row<9; row++){
				for(var col:uint=0; col<9; col++){
					rowFrames += x["row"+row+"col"+col].getDefaultFrame();
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
						//trace("row"+row+"col"+col+": Setting "+frame+" as the current frame to look for.");
					}
					
					if(this.tempGrid["row"+row+"col"+col].getDefaultFrame() == frame){
						matchStreak++;
						this.matchBucket.push(this.tempGrid["row"+row+"col"+col]);
						//trace("row"+row+"col"+col+": Match with current frame! Match streak is now "+matchStreak+", and Match Bucket length is now "+this.matchBucket.length+".");
					}else{
						//trace("row"+row+"col"+col+": Match not found, streak ended at "+matchStreak+".");
						matchStreak = this.resetMatchStatus(matchStreak);
						row--;
						//trace("");
					}
				}
				
				matchStreak = this.resetMatchStatus(matchStreak);
			}
			
			//trace("Done with findColMatches()");
			//trace("--------------------------");
			//trace("There were "+this.comboFound+" combos found!");
		}
		
		private function findRowMatches():void{
			var frame:uint;
			var matchStreak:uint = 0;
			
			for(var row:uint=0; row<9; row++){
				
				for(var col:uint=0; col<9; col++){
					
					if(matchStreak == 0){
						frame = this.tempGrid["row"+row+"col"+col].getDefaultFrame();
						//trace("row"+row+"col"+col+": Setting "+frame+" as the current frame to look for.");
					}
					
					if(this.tempGrid["row"+row+"col"+col].getDefaultFrame()== frame){
						matchStreak++;
						this.matchBucket.push(this.tempGrid["row"+row+"col"+col]);
						//trace("row"+row+"col"+col+": Match with current frame! Match streak is now "+matchStreak+", and Match Bucket length is now "+this.matchBucket.length+".");
					}else{
						//trace("row"+row+"col"+col+": Match not found, streak ended at "+matchStreak+".");
						matchStreak = this.resetMatchStatus(matchStreak);
						col--;
						//trace("");
					}
				}
				
				matchStreak = this.resetMatchStatus(matchStreak);
			}
			
			//trace("Done with findRowMatches()");
			//trace("--------------------------");
			//trace("There were "+this.comboFound+" combos found!");
		}
		
		//Call when a match streak ends and the results need to be processed
		private function resetMatchStatus(matchStreak):uint{
			if(matchStreak < 3){
				var lastIndex:uint = this.matchBucket.length - 1;
				for(var i:int=lastIndex; i>lastIndex-matchStreak; i--){
					this.matchBucket.splice(i,1);
				}
			}else{
				//trace("		[Combo was found!]");
				this.comboFound++;
			}
			
			return 0;
		}
		
		public function showAllMatchedSweets():void{
			for(var i:uint=0; i<this.matchBucket.length; i++){
				this.matchBucket[i].startBlink(5,20);
			}
			this.matchBucket = new Array();
		}
	}
	
}
