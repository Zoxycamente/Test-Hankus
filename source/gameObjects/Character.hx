package gameObjects;

/**
   the fnf hankus characters omg
**/
import flixel.FlxG;
import flixel.addons.util.FlxSimplex;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;
import gameObjects.userInterface.HealthIcon;
import meta.*;
import meta.data.*;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

typedef CharacterData =
{
	var offsetX:Float;
	var offsetY:Float;
	var camOffsetX:Float;
	var camOffsetY:Float;
	var quickDancer:Bool;
}

class Character extends FNFSprite
{
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var barColor:Int;
	
	public var holdTimer:Float = 0;

	public var characterData:CharacterData;
	public var adjustPos:Bool = true;

	public function new(?isPlayer:Bool = false)
	{
		super(x, y);
		this.isPlayer = isPlayer;
		barColor = isPlayer ? 0xFF66FF33 : 0xFFFF0000;
	}

	public function setCharacter(x:Float, y:Float, character:String):Character
	{
		curCharacter = character;
		var tex:FlxAtlasFrames;
		antialiasing = true;

		characterData = {
			offsetY: 0,
			offsetX: 0,
			camOffsetY: 0,
			camOffsetX: 0,
			quickDancer: false
		};

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/sprites/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				playAnim('danceRight');
				barColor = 0xFFA5004D;
			case 'nothinglol':
				tex = Paths.getSparrowAtlas('characters/sprites/nothinglol');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				
				playAnim('danceRight');
			case 'hankus':
				frames = Paths.getSparrowAtlas('characters/sprites/hankus');

				animation.addByPrefix('idle', 'hankus idle dance', 24, false);
				animation.addByPrefix('singUP', 'hankus sing up', 24, false);
				animation.addByPrefix('singLEFT', 'hankus sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'hankus sing right', 24, false);
				animation.addByPrefix('singDOWN', 'hankus sing down', 24, false);
		
		        characterData.offsetY = 70;
				characterData.offsetX = -60;
	        	setGraphicSize(Std.int(width * 1.3));
				updateHitbox();
				playAnim('idle');

				if (!Init.trueSettings.get('Classic Health Bar'))
				barColor = 0xFFFC0036;
			case 'hankus_memories':
				frames = Paths.getSparrowAtlas('characters/sprites/hankus_memories');

				animation.addByPrefix('idle', 'hankus idle dance', 24, false);
				animation.addByPrefix('singUP', 'hankus sing up', 24, false);
				animation.addByPrefix('singLEFT', 'hankus sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'hankus sing right', 24, false);
				animation.addByPrefix('singDOWN', 'hankus sing down', 24, false);
		
	        	setGraphicSize(Std.int(width * 1.2));
				updateHitbox();
				playAnim('idle');

				if (!Init.trueSettings.get('Classic Health Bar'))
				barColor = 0xFF8A6262;
			case 'corrupted':
					frames = Paths.getSparrowAtlas('characters/sprites/corrupted_hankus');
	
					animation.addByPrefix('idle', 'hankus idle dance', 24, true);
					animation.addByPrefix('singUP', 'hankus sing up', 24, false);
					animation.addByPrefix('singLEFT', 'hankus sing left', 24, false);
					animation.addByPrefix('singRIGHT', 'hankus sing right', 24, false);
					animation.addByPrefix('singDOWN', 'hankus sing down', 24, false);
		
					characterData.offsetY = 100;
					setGraphicSize(Std.int(width * 1.3));
					updateHitbox();
					playAnim('idle');

					if (!Init.trueSettings.get('Classic Health Bar'))
					barColor = 0xFFB11B3C;
			case 'legacy':
				frames = Paths.getSparrowAtlas('characters/sprites/legacy_hankus');

				animation.addByPrefix('idle', 'legacy idle dance', 24, false);
				animation.addByPrefix('singUP', 'legacy sing up', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'legacy playing left', 24, false);
				    animation.addByPrefix('singRIGHT', 'legacy playing right', 24, false);
				}
				else
				{
					animation.addByPrefix('singLEFT', 'legacy sing left', 24, false);
				    animation.addByPrefix('singRIGHT', 'legacy sing right', 24, false); //fuck you rafaelcranio, why did you do the right visor being red and the left visor being purple in 2021????
				}
				animation.addByPrefix('singUP', 'legacy sing up', 24, false);
				animation.addByPrefix('singDOWN', 'legacy sing down', 24, false);
		
		        characterData.camOffsetY = 140;
		        characterData.offsetY = -140;
		        setGraphicSize(Std.int(width * 1.3));
				updateHitbox();
				playAnim('idle');
			case 'hankusPoligonal':
				frames = Paths.getSparrowAtlas('characters/sprites/hankus_3D');

				animation.addByPrefix('idle', 'hankus 3D idle', 24, false);
				animation.addByPrefix('singUP', 'hankus 3D up', 24, false);
				animation.addByPrefix('singLEFT', 'hankus 3D left', 24, false);
				animation.addByPrefix('singRIGHT', 'hankus 3D right', 24, false);
				animation.addByPrefix('singDOWN', 'hankus 3D down', 24, false);
		
		        characterData.camOffsetY = -100;
		        characterData.offsetY = 100;
		        setGraphicSize(Std.int(width * 2.0));
				updateHitbox();
				playAnim('idle');

				if (!Init.trueSettings.get('Classic Health Bar'))
				barColor = 0xFF65063A;
				case 'rencus':
					frames = Paths.getSparrowAtlas('characters/sprites/rencus');
	
					animation.addByPrefix('idle', 'rencus idle dance', 24, true);
					animation.addByPrefix('singUP', 'rencus sing up', 24, false);
					animation.addByPrefix('singLEFT', 'rencus sing left', 24, false);
					animation.addByPrefix('singRIGHT', 'rencus sing right', 24, false);
					animation.addByPrefix('singDOWN', 'rencus sing down', 24, false);
			
					setGraphicSize(Std.int(width * 1.6));
					updateHitbox();
					playAnim('idle');
	
					if (!Init.trueSettings.get('Classic Health Bar'))
					barColor = 0xFF632885;
			case 'renkwuz':
				frames = Paths.getSparrowAtlas('characters/sprites/renk wus');

				animation.addByPrefix('idle', 'H idle', 24, true);
				animation.addByPrefix('singUP', 'H up', 24, false);
				animation.addByPrefix('singLEFT', 'H ieft', 24, false);
				animation.addByPrefix('singRIGHT', 'H right', 24, false);
				animation.addByPrefix('singDOWN', 'H down', 24, false);

                characterData.offsetY = 100;
				characterData.offsetX = -60;
               	playAnim('idle');

				if (!Init.trueSettings.get('Classic Health Bar'))
				barColor = 0xFF5C3F5A;
			case 'bfwuz':
				frames = Paths.getSparrowAtlas('characters/sprites/bfwus');

				animation.addByPrefix('idle', 'B idle', 24, true);
				animation.addByPrefix('singUP', 'B up', 24, false);
				animation.addByPrefix('singLEFT', 'B left', 24, false);
				animation.addByPrefix('singRIGHT', 'B right', 24, false);
				animation.addByPrefix('singDOWN', 'B down', 24, false);
				animation.addByPrefix('singDOWNmiss', 'B dont sing', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'B dont sing', 24, false);
				animation.addByPrefix('singUPmiss', 'B dont sing', 24, false);
				animation.addByPrefix('singLEFTmiss', 'B dont sing', 24, false);

                characterData.offsetY = 100;
				characterData.offsetX = -70;
				playAnim('idle');
				flipX = true;

				if (!Init.trueSettings.get('Classic Health Bar'))
				barColor = 0xFF7998FF;
			case 'bf':
				frames = Paths.getSparrowAtlas('characters/sprites/bf_canon');

				animation.addByPrefix('idle', 'bf idle dance', 24, false);
				animation.addByPrefix('singUP', 'bf sing up', 24, false);
				animation.addByPrefix('singLEFT', 'bf sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'bf sing right', 24, false);
				animation.addByPrefix('singDOWN', 'bf sing down', 24, false);
				animation.addByPrefix('singUPmiss', 'bf dont sing up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'bf dont sing left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'bf dont sing right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'bf dont sing down', 24, false);

                characterData.offsetY = 120;
				characterData.offsetX = 100;
				playAnim('idle');
				flipX = true;

				if (!Init.trueSettings.get('Classic Health Bar'))
				barColor = 0xFFF5DB5A;
			case 'bf-shadering':
				frames = Paths.getSparrowAtlas('characters/sprites/bf_shadering');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				playAnim('idle');
				flipX = true;
				case 'bf_og':
					frames = Paths.getSparrowAtlas('characters/sprites/bf_og');
	
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
					animation.addByPrefix('scared', 'BF idle shaking', 24);
	
					playAnim('idle');
					
					if (!Init.trueSettings.get('Classic Health Bar'))
					barColor = 0xFF31B0D1;
					flipX = true;
			case 'bf-dead':
				frames = Paths.getSparrowAtlas('characters/sprites/BF_DEATH');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				playAnim('firstDeath');
				flipX = true;
			default:
				// set up animations if they aren't already

				// fyi if you're reading this this isn't meant to be well made, it's kind of an afterthought I wanted to mess with and
				// I'm probably not gonna clean it up and make it an actual feature of the engine I just wanted to play other people's mods but not add their files to
				// the engine because that'd be stealing assets
				var fileNew = curCharacter + 'Anims';
				if (OpenFlAssets.exists(Paths.offsetTxt(fileNew)))
				{
					var characterAnims:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(fileNew));
					var characterName:String = characterAnims[0].trim();
					frames = Paths.getSparrowAtlas('characters/sprites/$characterName');
					for (i in 1...characterAnims.length)
					{
						var getterArray:Array<Array<String>> = CoolUtil.getAnimsFromTxt(Paths.offsetTxt(fileNew));
						animation.addByPrefix(getterArray[i][0], getterArray[i][1].trim(), 24, false);
					}
				}
				else
					return setCharacter(x, y, 'bf');
		}

		// set up offsets cus why not
		if (OpenFlAssets.exists(Paths.offsetTxt('offsets/' + curCharacter + 'Offsets')))
		{
			var characterOffsets:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt('offsets/' + curCharacter + 'Offsets'));
			for (i in 0...characterOffsets.length)
			{
				var getterArray:Array<Array<String>> = CoolUtil.getOffsetsFromTxt(Paths.offsetTxt('offsets/' + curCharacter + 'Offsets'));
				addOffset(getterArray[i][0], Std.parseInt(getterArray[i][1]), Std.parseInt(getterArray[i][2]));
			}
		}

		dance();

		if (isPlayer) // fuck you ninjamuffin lmao
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
				flipLeftRight();
			//
		}
		else if (curCharacter.startsWith('bf'))
			flipLeftRight();

		if (adjustPos)
		{
			x += characterData.offsetX;
			trace('character ${curCharacter} scale ${scale.y}');
			y += (characterData.offsetY - (frameHeight * scale.y));
		}

		this.x = x;
		this.y = y;

		return this;
	}

	function flipLeftRight():Void
	{
		// get the old right sprite
		var oldRight = animation.getByName('singRIGHT').frames;

		// set the right to the left
		animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;

		// set the left to the old right
		animation.getByName('singLEFT').frames = oldRight;

		// insert ninjamuffin screaming I think idk I'm lazy as hell

		if (animation.getByName('singRIGHTmiss') != null)
		{
			var oldMiss = animation.getByName('singRIGHTmiss').frames;
			animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			animation.getByName('singLEFTmiss').frames = oldMiss;
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		var curCharSimplified:String = simplifyCharacter();
		switch (curCharSimplified)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
				if ((animation.curAnim.name.startsWith('sad')) && (animation.curAnim.finished))
					playAnim('danceLeft');
		}

		// Post idle animation (think Week 4 and how the player and mom's hair continues to sway after their idle animations are done!)
		if (animation.curAnim.finished && animation.curAnim.name == 'idle')
		{
			// We look for an animation called 'idlePost' to switch to
			if (animation.getByName('idlePost') != null)
				// (( WE DON'T USE 'PLAYANIM' BECAUSE WE WANT TO FEED OFF OF THE IDLE OFFSETS! ))
				animation.play('idlePost', true, false, 0);
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?forced:Bool = false)
	{
		if (!debugMode)
		{
			var curCharSimplified:String = simplifyCharacter();
			switch (curCharSimplified)
			{
				case 'gf':
					if ((!animation.curAnim.name.startsWith('hair')) && (!animation.curAnim.name.startsWith('sad')))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
				default:
					// Left/right dancing, think Skid & Pump
					if (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null)
					{
						danced = !danced;
						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
					else
						playAnim('idle', forced);
			}
		}
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) != null)
			super.playAnim(AnimName, Force, Reversed, Frame);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
				danced = true;
			else if (AnimName == 'singRIGHT')
				danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}
	}

	public function simplifyCharacter():String
	{
		var base = curCharacter;

		if (base.contains('-'))
			base = base.substring(0, base.indexOf('-'));
		return base;
	}
}
