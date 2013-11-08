package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	public class MainMenu{
		
		//Main Menu Components
		private var menuBG:MenuBG = new MenuBG();
		private var instructionBG:MenuBG = new MenuBG();
		private var newGameButton:MenuButton;
		private var howToPlayButton:MenuButton;
		private var nextPageButton:MenuButton;
		private var prevPageButton:MenuButton;
		private var letsGoButton:MenuButton;
		
		private var myGame:SweetSmash;
		
		public function MainMenu(myGame:SweetSmash){
			this.myGame = myGame;
			
			this.menuBG.x = 960/2 - this.menuBG.width/2;
			this.menuBG.y = 320 - this.menuBG.height/2;
			this.menuBG.gotoAndStop(1);
			
			trace("Building buttons");
			this.newGameButton = new MenuButton(2,480,320);
			this.howToPlayButton = new MenuButton(1,480,420);
			this.nextPageButton = new MenuButton(3,750,125);
			this.prevPageButton = new MenuButton(4,750,125);
			this.letsGoButton = new MenuButton(5,480,570);
			trace("Finished building buttons");
			
			this.newGameButton.addEventListener(MouseEvent.MOUSE_DOWN,this.startNewGame);
			this.letsGoButton.addEventListener(MouseEvent.MOUSE_DOWN,this.clearHowToPlay);
			this.nextPageButton.addEventListener(MouseEvent.MOUSE_DOWN,this.nextPage);
			this.prevPageButton.addEventListener(MouseEvent.MOUSE_DOWN,this.prevPage);
			this.howToPlayButton.addEventListener(MouseEvent.MOUSE_DOWN,this.showHowToPlay);
			
			this.myGame.addChild(this.menuBG);
			this.myGame.addChild(this.newGameButton);
			this.myGame.addChild(this.howToPlayButton);
		}
		
		private function startNewGame(event:MouseEvent):void{
			this.newGameButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.startNewGame);
			this.howToPlayButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.showHowToPlay);
			this.myGame.startGame();
		}
		
		private function showHowToPlay(event:MouseEvent):void{
			//How to Play was clicked on
			trace("How to Play was clicked...");
			this.cleanup();
			this.buildInstructionMenu();
		}
		
		public function remindHowToPlay(event:MouseEvent):void{
			this.myGame.sweetGrid.blurGame(new Array(new BlurFilter(10,10,1)));
			this.buildInstructionMenu();
		}
		
		public function cleanup():void{
			this.myGame.removeChild(this.menuBG);
			this.newGameButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.startNewGame);
			this.myGame.removeChild(this.newGameButton);
			this.howToPlayButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.showHowToPlay);
			this.myGame.removeChild(this.howToPlayButton);
		}
		
		private function prevPage(event:MouseEvent):void{
			this.myGame.removeChild(this.prevPageButton);
			this.myGame.removeChild(this.letsGoButton);
			this.instructionBG.gotoAndStop(2);
			this.myGame.addChild(this.nextPageButton);
		}
		
		private function nextPage(event:MouseEvent):void{
			this.myGame.removeChild(this.nextPageButton);
			this.instructionBG.gotoAndStop(3);
			this.myGame.addChild(this.prevPageButton);
			this.myGame.addChild(this.letsGoButton);
		}
		
		public function clearHowToPlay(event:MouseEvent):void{
			this.myGame.removeChild(this.instructionBG);
			this.myGame.removeChild(this.prevPageButton);
			this.myGame.removeChild(this.letsGoButton);
			this.myGame.letsGo();
		}
		
		public function buildInstructionMenu():void{
			this.instructionBG.x = 960/2 - this.instructionBG.width/2;
			this.instructionBG.y = 320 - this.instructionBG.height/2;
			this.instructionBG.gotoAndStop(2);
			
			this.myGame.addChild(this.instructionBG);
			this.myGame.addChild(this.nextPageButton);
		}
	}
	
}
