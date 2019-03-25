package;
// from cli:
// $ lime test windows
// figure out how to add as a build task to vscode

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		//addChild(new FlxGame(1024, 768, MainMenuState, 1, 60, 60, true));
		addChild(new FlxGame(640, 480, MainMenuState, 1, 60, 60, true));

	}
}
