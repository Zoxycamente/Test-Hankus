package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
   i hate code fnf stages i hate i fuckin hate that shit so much holyshitloisi'mcumming
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			if (PlayState.SONG.curStage == null) {
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'apotheosis':
				    curStage = 'apotheosis';
				case 'purple-alert':
				    curStage = 'purple-alert';
				case 'sussy-legacy':
					curStage = 'sussy-legacy';
				default:
					curStage = 'stage';
			}} else {
				curStage = PlayState.SONG.curStage;
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'apotheosis':
				PlayState.defaultCamZoom = 0.8;
				curStage = 'apotheosis';

                var bg:FNFSprite = new FNFSprite(-184, -274).loadGraphic(Paths.image('backgrounds/' + curStage + '/fundo'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var caixas:FNFSprite = new FNFSprite(418, 60).loadGraphic(Paths.image('backgrounds/' + curStage + '/somsonador'));
				caixas.antialiasing = true;
				caixas.scrollFactor.set(0.9, 0.9);
				caixas.active = false;
				add(caixas);

				var zumbis:FNFSprite = new FNFSprite(820, 868).loadGraphic(Paths.image('backgrounds/' + curStage + '/zumbis'));
				zumbis.antialiasing = true;
				zumbis.scrollFactor.set(0.9, 0.9);
                zumbis.active = false;
				add(zumbis);

				var zumbi:FNFSprite = new FNFSprite(-24, 812).loadGraphic(Paths.image('backgrounds/' + curStage + '/zumbi'));
				zumbi.antialiasing = true;
				zumbi.scrollFactor.set(0.9, 0.9);
                zumbis.active = false;
				add(zumbi);

				var lampada:FNFSprite = new FNFSprite(80, -700).loadGraphic(Paths.image('backgrounds/' + curStage + '/lampada'));
				lampada.antialiasing = true;
				lampada.scrollFactor.set(0.9, 0.9);
				lampada.active = true;
				foreground.add(lampada);
			case 'purple-alert':
				PlayState.defaultCamZoom = 0.6;
				curStage = 'purple-alert';

                var bg:FNFSprite = new FNFSprite(-550, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/fundo'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.1, 0.1);
				bg.active = false;
				add(bg);

				var corpo:FNFSprite = new FNFSprite(-550, -150).loadGraphic(Paths.image('backgrounds/' + curStage + '/a'));
				corpo.antialiasing = true;
				corpo.scrollFactor.set(0.9, 0.9);
				corpo.active = true;
				add(corpo);
			case 'sussy-legacy':
					PlayState.defaultCamZoom = 0.8;
					curStage = 'sussy-legacy';
	
					var bg:FNFSprite = new FNFSprite(-550, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/bg'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);
	
					var frente:FNFSprite = new FNFSprite(-400, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/frente'));
					frente.antialiasing = true;
					frente.scrollFactor.set(0.9, 0.9);
					frente.active = false;
					add(frente);

					/* deixa o jogo tudo lagado toma no cu
					var neve:FNFSprite = new FNFSprite(-400, -200);
				    neve.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/neve');
				    neve.animation.addByPrefix('neve', "snow anim", 24);
				    neve.animation.play('neve');
				    neve.scrollFactor.set(0.4, 0.4);
				    foreground.add(neve);
					*/
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';
		if (PlayState.SONG.curStage == null) {
		switch (curStage)
		{
			case 'apotheosis' | 'dead-memories' | 'sussy-legacy' | 'purple-alert':
				gfVersion = 'nothinglol';
		}}
		else
		gfVersion = PlayState.SONG.gfVersion;

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray)
		{
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
					/*
						if (isStoryMode)
						{
							camPos.x += 600;
							tweenCamIn();
					}*/
					/*
						case 'spirit':
							var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
							evilTrail.changeValuesEnabled(false, false, false, false);
							add(evilTrail);
					 */
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'apotheosis':
				boyfriend.x += 350;
				boyfriend.y += 100;
				dad.x -= -350;
				dad.y += 70;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	public function dispatchEvent(myEvent:String)
	{

	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}