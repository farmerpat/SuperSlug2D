package;

import flixel.input.keyboard.FlxKey;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;

class Hero extends FlxSprite {
    //public static inline var GRAVITY:Int = 250;
    public static inline var GRAVITY:Int = 420;
    public static inline var RUN_SPEED:Int = 100;
    //public static inline var JUMP_FORCE:Int = 350;
    public static inline var JUMP_FORCE:Int = 150;
    private var _parent:LevelZeroState;
    private var _jumpPossible:Bool = false;
    private var _leftWallGrabPossible:Bool = false;
    private var _rightWallGrabPossible:Bool = false;
    private var _groundGrabPossible:Bool = false;
    private var _ceilGrabPossible:Bool = false;
    private var _gravityDirection:GravityDirection = DOWN;

    // extend FlxState w/ our own class to so that we know levelMap is a member of it
    public function new (x:Int, y:Int, parent:LevelZeroState) {
        super(x, y);

        loadGraphic("assets/images/slug_right.png", true, 32, 32);
        //width = 32;
        //height = 32;

        drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
        maxVelocity.x = RUN_SPEED;
        maxVelocity.y = JUMP_FORCE;
        _parent = parent;
        FlxG.watch.add(this, "_gravityDirection", "grav dir");
        animation.add("idle", [0]);
        animation.add("walking", [0, 1], 6, true);
    }

    public override function update(elapsed:Float):Void {
        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
        var useGamePad:Bool = false;
        _jumpPossible = false;
        _groundGrabPossible = false;
        _ceilGrabPossible = false;
        _rightWallGrabPossible = false;
        _leftWallGrabPossible = false;

        if (gamepad != null) {
            useGamePad = true;
        }

        FlxG.collide(_parent, this);

        if (_gravityDirection == DOWN) {
            acceleration.y = GRAVITY;
            acceleration.x = 0;
            if (isTouching(FlxObject.FLOOR)) {
                // this gave us a bad time
                //acceleration.y = 0;
                _jumpPossible = true;
            }
        } else if (_gravityDirection == UP) {
            acceleration.y = -GRAVITY;
            acceleration.x = 0;

            if (isTouching(FlxObject.CEILING)) {
                _jumpPossible = true;
            }
        } else if (_gravityDirection == RIGHT) {
            acceleration.y = 0;
            acceleration.x = GRAVITY;

            if (isTouching(FlxObject.RIGHT)) {
                _jumpPossible = true;
            }
        } else if (_gravityDirection == LEFT) {
            acceleration.y = 0;
            acceleration.x = -GRAVITY;

            if (isTouching(FlxObject.LEFT)) {
                _jumpPossible = true;
            }
        }

        if (isTouching(FlxObject.RIGHT)) {
            _rightWallGrabPossible = true;
        }

        if (isTouching(FlxObject.LEFT)) {
            _leftWallGrabPossible = true;
        }

        if (isTouching(FlxObject.FLOOR)) {
            _groundGrabPossible = true;
        }

        if (isTouching(FlxObject.CEILING)) {
            _ceilGrabPossible = true;
        }

        if (_gravityDirection == DOWN) {
            if (FlxG.keys.anyPressed([LEFT, A]) || (useGamePad && gamepad.pressed.DPAD_LEFT)) {
                acceleration.x = -drag.x;
                flipX = true;

            } else if (FlxG.keys.anyPressed([RIGHT, D]) || (useGamePad && gamepad.pressed.DPAD_RIGHT)) {
                acceleration.x = drag.x;
                flipX = false;

            } else {
                acceleration.x = 0;
            }

            if (_jumpPossible && (FlxG.keys.anyJustPressed([W, SPACE]) || (useGamePad && gamepad.justPressed.A))) {
                // TODO:
                // velocity or acceleration?
                // investigate and choose
                //acceleration.y = -JUMP_FORCE;
                velocity.y = -JUMP_FORCE;
            } else if (_rightWallGrabPossible && (useGamePad && gamepad.pressed.DPAD_RIGHT && gamepad.pressed.X)) {
                // grab the wall we can based on dpad (if there is no d-pad input, don't grab.
                _gravityDirection = RIGHT;
            } else if (_leftWallGrabPossible && (useGamePad && gamepad.pressed.DPAD_LEFT && gamepad.pressed.X)) {
                _gravityDirection = LEFT;
            } else if (_ceilGrabPossible && (useGamePad && gamepad.pressed.DPAD_UP && gamepad.pressed.X)) {
                _gravityDirection = UP;
            }

        } else if (_gravityDirection == UP) {
            if (useGamePad && gamepad.pressed.DPAD_LEFT) {
                acceleration.x = -drag.x;
                flipX = true;

            } else if (useGamePad && gamepad.pressed.DPAD_RIGHT) {
                acceleration.x = drag.x;
                flipX = true;

            } else {
                acceleration.x = 0;
            }

            if (_jumpPossible && (useGamePad && gamepad.justPressed.A)) {
                velocity.y = JUMP_FORCE;
            } else if (_rightWallGrabPossible && (useGamePad && gamepad.pressed.DPAD_RIGHT && gamepad.pressed.X)) {
                _gravityDirection = RIGHT;
            } else if (_leftWallGrabPossible && (useGamePad && gamepad.pressed.DPAD_LEFT && gamepad.pressed.X)) {
                _gravityDirection = LEFT;
            } else if (_groundGrabPossible && (useGamePad && gamepad.pressed.DPAD_DOWN && gamepad.pressed.X)) {
                _gravityDirection = DOWN;
            }

        } else if (_gravityDirection == RIGHT) {
            if (useGamePad && gamepad.pressed.DPAD_UP) {
                // should i also change drag on gravity change? probably.
                acceleration.y = -drag.x;
                flipX = false;
            } else if (useGamePad && gamepad.pressed.DPAD_DOWN) {
                acceleration.y = drag.x;
                flipX = true;
            } else {
                acceleration.y = 0;
            }

            if (_jumpPossible && (useGamePad && gamepad.justPressed.A)) {
                velocity.x = -JUMP_FORCE;
            } else if (_groundGrabPossible && (useGamePad && gamepad.pressed.DPAD_DOWN && gamepad.pressed.X)) {
                _gravityDirection = DOWN;
            } else if (_leftWallGrabPossible && (useGamePad && gamepad.pressed.DPAD_LEFT && gamepad.pressed.X)) {
                _gravityDirection = LEFT;
            } else if (_ceilGrabPossible && (useGamePad && gamepad.pressed.DPAD_UP && gamepad.pressed.X)) {
                _gravityDirection = UP;
            }

        } else if (_gravityDirection == LEFT) {
            if (useGamePad && gamepad.pressed.DPAD_UP) {
                acceleration.y = -drag.x;
                flipX = true;
            } else if (useGamePad && gamepad.pressed.DPAD_DOWN) {
                acceleration.y = drag.x;
                flipX = false;
            } else {
                acceleration.y = 0;
            }

            if (_jumpPossible && (useGamePad && gamepad.justPressed.A)) {
                velocity.x = JUMP_FORCE;
            } else if (_groundGrabPossible && (useGamePad && gamepad.pressed.DPAD_DOWN && gamepad.pressed.X)) {
                _gravityDirection = DOWN;
            } else if (_rightWallGrabPossible && (useGamePad && gamepad.pressed.DPAD_RIGHT && gamepad.pressed.X)) {
                _gravityDirection = RIGHT;
            } else if (_ceilGrabPossible && (useGamePad && gamepad.pressed.DPAD_UP && gamepad.pressed.X)) {
                _gravityDirection = UP;
            }
        }

        if (_gravityDirection == DOWN) {
            angle = 0;
            if (isTouching(FlxObject.FLOOR)) {
                if (velocity.x == 0) {
                    animation.play("idle");
                } else {
                    animation.play("walking");
                }
            } else {
                // later, we'll add a jump animation
                // and will have to make sure that it finished before 
                // playing idle anim when airborne
                animation.play("idle");
            }
        } else if (_gravityDirection == UP) {
            angle = 180;
            if (isTouching(FlxObject.CEILING)) {
                if (velocity.x == 0) {
                    animation.play("idle");
                } else {
                    animation.play("walking");
                }
            } else {
                animation.play("idle");
            }
        } else if (_gravityDirection == LEFT) {
            angle = 90;
            if (isTouching(FlxObject.LEFT)) {
                if (velocity.y == 0) {
                    animation.play("idle");
                } else {
                    animation.play("walking");
                }
            } else {
                animation.play("idle");
            }
        } else if (_gravityDirection == RIGHT) {
            angle = 270;
            if (isTouching(FlxObject.RIGHT)) {
                if (velocity.y == 0) {
                    animation.play("idle");
                } else {
                    animation.play("walking");
                }
            } else {
                animation.play("idle");
            }
        }

        // why?
        // because when the map doesn't take up the whole stage size, hf tries
        // to center it or something
        if (x <= -20) {
			x = -20;
		}

		if ((x + width) > (_parent.levelMap.width + 20)) {
			x = (_parent.levelMap.width + 20) - width;
		}

        super.update(elapsed);
    }
}

enum GravityDirection {
    UP;
    DOWN;
    LEFT;
    RIGHT;
}