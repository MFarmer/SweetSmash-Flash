package  {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	
	public class HUDInfoText extends TextField{

		private var scoreValue:int;
		private var prefixString:String;
		
		public function HUDInfoText(value:int,prefixString:String,xPos:int,yPos:int) {
			// constructor code
			this.x = xPos;
			this.y = yPos;
			this.scoreValue = value;
			this.autoSize = "left";
			this.prefixString = prefixString
			this.defaultTextFormat = new TextFormat('Verdana',32,0xFFFFFF);

			var shadowEffect:DropShadowFilter = new DropShadowFilter();
			shadowEffect.angle = 45;
			shadowEffect.distance = 3;
			this.filters = [shadowEffect];
			
			this.refreshScore();
		}
		public function updateScore(x:int):void{
			this.scoreValue += x;
			this.refreshScore();
		}
		public function refreshScore():void{
			this.text = this.prefixString+" "+this.scoreValue;
		}

	}
	
}
