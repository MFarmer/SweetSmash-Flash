package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MainMenu{
		
		//Main Menu Components
		private var menuBG:MenuBG = new MenuBG();
		private var newGameButton:MenuButton;
		private var howToPlayButton:MenuButton;
		
		private var myGame:SweetSmash;
		
		public function MainMenu(myGame:SweetSmash){
			this.myGame = myGame;
			
			this.menuBG.x = 960/2 - this.menuBG.width/2;
			this.menuBG.y = 320 - this.menuBG.height/2;
			this.menuBG.gotoAndStop(1);
			trace("Building buttons");
			this.newGameButton = new MenuButton(2);
			this.howToPlayButton = new MenuButton(1);
			this.howToPlayButton.y += 100;
			trace("Finished building buttons");
			this.newGameButton.addEventListener(MouseEvent.MOUSE_DOWN,this.startNewGame);
			this.howToPlayButton.addEventListener(MouseEvent.MOUSE_DOWN,this.showHowToPlay);
			
			this.myGame.addChild(this.menuBG);
			this.myGame.addChild(this.newGameButton);
			this.myGame.addChild(this.howToPlayButton);
		}
		
		private function startNewGame(event:MouseEvent):void{
			this.newGameButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.startNewGame);
			this.myGame.startGame();
		}
		
		private function showHowToPlay(event:MouseEvent):void{
			
		}
		
		public function cleanup():void{
			this.myGame.removeChild(this.menuBG);
			this.myGame.removeChild(this.newGameButton);
			this.myGame.removeChild(this.howToPlayButton);
		}
	}
	
}
