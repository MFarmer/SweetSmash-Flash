package  {
	
	public class Grid {

		private var sweetList:Array = new Array();

		//Dictionary for key-value pairs
		private var logicalGrid:Object = new Object();
		
		private var myGame:SweetSmash;
		
		private var rowCount:uint = 9;
		private var colCount:uint = 9;
		
		public function Grid(myGame:SweetSmash) {
			this.myGame = myGame;
		}
		
		public function addSweet(newSweet:Sweet):void{
			this.sweetList.push(newSweet);
		}

		public function getLastSweet():Sweet{
			return this.sweetList[this.sweetList.length-1];
		}

		public function getSweetAtIndex(index:uint):Sweet{
			return this.sweetList[index];
		}
		
		public function getSweetAtPosition(row:uint,col:uint):Sweet{
			if(row < rowCount && col < this.colCount && row >= 0 && col >= 0){
				return this.sweetList[row * this.rowCount + col];
			}else{
				trace("Error: getSweet request denied because the row and/or col was out of bounds.(row="+row+",col="+col+")");
				return null;
			}
		}
		
		public function findMyIndex(x:Sweet):int{
			for(var i:uint; i<this.sweetList.length; i++){
				if(this.sweetList[i] == x){
					return i;
				}
			}
			return -1;
		}
		
		public function swapLogicalSweet(index1:uint,index2:uint):void{
			
		}
	}
	
}
