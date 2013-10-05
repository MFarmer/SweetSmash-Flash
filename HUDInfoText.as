package  {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	
	public class HUDInfoText extends TextField{

		private var scoreValue:int;
		private var prefixString:String;
		
		public function HUDInfoText(value:int,prefixString:String,fontSize:uint,xPos:int,yPos:int) {
			// constructor code
			this.x = xPos;
			this.y = yPos;
			this.scoreValue = value;
			this.prefixString = prefixString;
			this.autoSize = "left";
			this.defaultTextFormat = new TextFormat('Hobo Std',fontSize,0xFFFFFF);

			this.applyShadowFilter();
			
			this.refreshText();
		}
		public function updateText(x:int):void{
			this.scoreValue += x;
			this.refreshText();
		}
		public function refreshText():void{
			this.text = this.prefixString+" "+this.scoreValue;
		}
		public function getValue():int{
			return this.scoreValue;
		}
		public function updatePrefix(x:String):void{
			this.prefixString = x;
		}
		public function resetValue(x:int):void{
			this.scoreValue = x;
			this.refreshText();
		}
		
		public function applyShadowFilter():void{
			var shadowEffect:DropShadowFilter = new DropShadowFilter();
			shadowEffect.angle = 45;
			shadowEffect.distance = 3;
			this.filters = [shadowEffect];
		}

	}
	
}
