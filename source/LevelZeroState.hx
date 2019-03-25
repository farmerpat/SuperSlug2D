package;

import flash.system.System;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.util.FlxColor;
import openfl.Assets;
import flixel.input.gamepad.FlxGamepad;

import flixel.FlxState;

class LevelZeroState extends FlxState {
    public var levelMap:FlxTilemap;
    public var backgroundMap:FlxTilemap;
    private var _hero:Hero;

	override public function create():Void {
        //FlxObject.SEPARATE_BIAS = 0;
        levelMap = new FlxTilemap();
        levelMap.allowCollisions = FlxObject.ANY;

        //var ret = add(levelMap.loadMapFromCSV("assets/levels/ss_level0.csv", "assets/images/ss_earth_tileset-export.png", 16, 16, null -1));
        //add(levelMap.loadMapFromCSV("assets/levels/ss_level0_take_four.csv", "assets/images/ss_earth_tileset-export.png", 16, 16, null, 1, 1));
        //add(levelMap.loadMapFromCSV("assets/levels/ss_level0_take_four.csv", "assets/images/ss_earth_tileset-export.png", 16, 16));
        //var ret = levelMap.loadMapFromCSV("assets/levels/ss_level0_take_four.csv", "assets/images/ss_earth_tileset-export.png", 16, 16, null);
        //var ret = levelMap.loadMapFromCSV("assets/levels/ss_level0_take_four.csv", "assets/images/ss_earth_tileset-export.png", 16, 16, null);


        // so this works, but had to use a silly column of garbage tiles to avoid 0 index.
        //var ret = levelMap.loadMapFromCSV("assets/levels/fyf.csv", "assets/images/fyf.png", 16, 16, null);
        //var ret = levelMap.loadMapFromCSV("assets/levels/ss_level_0.csv", "assets/images/ss_earth_tileset.png", 16, 16, null, 0, 0);
        //var ret = levelMap.loadMapFromCSV("assets/levels/ss_level_0.csv", "assets/images/ss_earth_tileset.png", 16, 16, null, 1, 0);
        //var ret = levelMap.loadMapFromCSV("assets/levels/ss_level_0.csv", "assets/images/ss_earth_tileset.png", 16, 16, FlxTilemapAutoTiling.OFF, 0, 0);
        //var ret = levelMap.loadMapFromCSV("assets/levels/ss_level_0.csv", "assets/images/ss_earth_tileset.png", 16, 16);
        //var ret = levelMap.loadMapFromCSV("assets/levels/ss_level_0.csv", "assets/images/ss_earth_tileset.png", 16, 16, FlxTilemapAutoTiling.OFF);
        //add(ret);

        var map = new TiledMap("assets/levels/ss_level_0.tmx");
        //levelMap.loadMapFromArray(cast(map.getLayer("Tile Layer 1"), TiledTileLayer))
        levelMap.loadMapFromArray(
            cast(map.getLayer("Tile Layer 1"), TiledTileLayer).tileArray,
            map.width, map.height,
            "assets/images/ss_earth_tileset.png",
            map.tileWidth,
            map.tileHeight,FlxTilemapAutoTiling.OFF,
            1,
            1,
            1);

        //levelMap.screenCenter(flixel.util.FlxAxes.X);
        // why do I even have to do this?
        // e.g. why is it not actually at x=0 to begin w?
        // e.g. map x=0 is not screen x=0
        //levelMap.setPosition(-127, 0);
        levelMap.setPosition(-20, 0);
        levelMap.follow();
        //levelMap.setTileProperties(0, FlxObject.NONE);

        /*
        levelMap.setTileProperties(1, FlxObject.ANY);
        levelMap.setTileProperties(2, FlxObject.ANY);
        levelMap.setTileProperties(3, FlxObject.ANY);
        levelMap.setTileProperties(4, FlxObject.ANY);
        levelMap.setTileProperties(7, FlxObject.ANY);
        levelMap.setTileProperties(8, FlxObject.ANY);
        levelMap.setTileProperties(9, FlxObject.ANY);
        levelMap.setTileProperties(10, FlxObject.ANY);
        levelMap.setTileProperties(11, FlxObject.ANY);
        levelMap.setTileProperties(12, FlxObject.ANY);
        levelMap.setTileProperties(13, FlxObject.ANY);
        levelMap.setTileProperties(14, FlxObject.ANY);
        levelMap.setTileProperties(15, FlxObject.ANY);
        levelMap.setTileProperties(16, FlxObject.ANY);
        */

        add(levelMap);
        //add(map);

        //levelMap.

        FlxG.camera.setScrollBoundsRect(0, 0, levelMap.width, levelMap.height);
        //FlxG.worldBounds.set(-127, 0, levelMap.width, levelMap.height);
        FlxG.worldBounds.set(-20, 0, levelMap.width, levelMap.height);

        _hero = new Hero(10, 50, this);
        add(_hero);

        //FlxG.camera.follow(hero, LOCKON, 1);

        //FlxG.debugger.visible = true;
        //FlxG.debugger.drawDebug = true;

		super.create();
	}

	override public function update(elapsed:Float):Void {
        var gamepad:FlxGamepad = FlxG.gamepads.firstActive;

        if ( FlxG.keys.justPressed.ESCAPE || (gamepad != null && gamepad.justPressed.BACK)) {
#if desktop
            System.exit(0);
#end
        }

        // try calling from Hero
        //FlxG.collide(levelMap, _hero);
        //FlxG.collide(_hero, levelMap);

		super.update(elapsed);
	}
}
