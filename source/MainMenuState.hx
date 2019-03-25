package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;

enum Selection {
    PLAY;
    QUIT;
}

class MainMenuState extends FlxState {
    var _titleText:FlxText;
    var _playText:FlxText;
    var _quitText:FlxText;
    var _textUnderline:FlxText;
    var _menuTextColor = 0xFF000000;
    var _textUnderLineOffset = 7;

    var _selectedMenuOption:Selection;

    override public function create():Void {
        FlxG.stage.window.height = FlxG.stage.window.height * 2;
        FlxG.stage.window.width = FlxG.stage.window.width * 2;
        FlxG.stage.window.x = 200;
        FlxG.stage.window.y = 50;
        FlxG.mouse.visible = false;
        FlxG.state.bgColor = 0xFFB3CCCC;

        _titleText = new FlxText(0, 0, FlxG.width, "Super Slug 2D", 30);
        _titleText.setFormat(null, 30, _menuTextColor, FlxTextAlign.CENTER);
        _titleText.antialiasing = true;

        add(_titleText);

        _playText = new FlxText(0, FlxG.height / 3, FlxG.width, "Play", 18);
        _playText.setFormat(null, 18, _menuTextColor, FlxTextAlign.CENTER);
        _playText.antialiasing = true;
        _selectedMenuOption = PLAY;

        add(_playText);

        _quitText = new FlxText(0, FlxG.height / 2.5, FlxG.width, "Quit", 18);
        _quitText.setFormat(null, 18, _menuTextColor, FlxTextAlign.CENTER);
        _quitText.antialiasing = true;

        add(_quitText);

        _textUnderline = new FlxText(0, _playText.y + _textUnderLineOffset, FlxG.width, "____", 18);
        _textUnderline.setFormat(null, 18, _menuTextColor, FlxTextAlign.CENTER);
        _textUnderline.antialiasing = true;

        add(_textUnderline);

        super.create();
    }

    override public function update(elapsed:Float):Void {
        var gamepad:FlxGamepad = FlxG.gamepads.firstActive;

        if ( FlxG.keys.justPressed.ESCAPE || (gamepad != null && gamepad.justPressed.BACK)) {
#if desktop
            System.exit(0);
#end
        }

        if ( FlxG.keys.justPressed.UP || (gamepad != null && gamepad.justPressed.DPAD_UP) ) {
            toggleSelection();
        }

        if ( FlxG.keys.justPressed.DOWN || (gamepad != null && gamepad.justPressed.DPAD_DOWN) ) {
            toggleSelection();
        }

        if ( FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER || (gamepad != null && (gamepad.justPressed.A || gamepad.justPressed.START) )) {
            triggerSelectedOption();
        }

        // if start, or a or space is pressed, do the thing that is selected!

        super.update(elapsed);
    }

    private function triggerSelectedOption():Void {
        if ( _selectedMenuOption == PLAY ) {
            FlxG.switchState(new LevelZeroState());

        } else {
#if desktop
            System.exit(0);
#end

        }
    }

    private function toggleSelection():Void {
        if ( _selectedMenuOption == PLAY ) {
            _selectedMenuOption = QUIT;
            _textUnderline.setPosition(0, _quitText.y + _textUnderLineOffset);

        } else {
            _selectedMenuOption = PLAY;
            _textUnderline.setPosition(0, _playText.y + _textUnderLineOffset);
        }

    }
}