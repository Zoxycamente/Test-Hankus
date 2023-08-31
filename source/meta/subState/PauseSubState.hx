package meta.subState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.font.Alphabet;
import sys.io.File;
import meta.state.*;
import meta.state.menus.*;

class PauseSubState extends MusicBeatSubState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart', 'Options', 'Practice', 'Menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var extraInfo:FlxText;

	public function new(x:Float, y:Float)
	{
		super();
		#if debug
		// trace('pause call');
		#end

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		#if debug
		// trace('pause background');
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/base/menuDesat'));
		bg.alpha = 0.7;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += CoolUtil.dashToSpace(PlayState.SONG.song);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		#if debug
		// trace('pause info');
		#end

		var composer:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		composer.text = File.getContent('assets/songs/' + PlayState.SONG.song.toLowerCase() + '/composerTxt.txt');
		composer.scrollFactor.set();
		composer.setFormat(Paths.font('vcr.ttf'), 32);
		composer.updateHitbox();
		add(composer);

		var levelDeaths:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		levelDeaths.text += "Blue balled: " + PlayState.deaths;
		levelDeaths.scrollFactor.set();
		levelDeaths.setFormat(Paths.font('vcr.ttf'), 32);
		levelDeaths.updateHitbox();
		add(levelDeaths);

		extraInfo = new FlxText(20, 15 + 250, 0, "", 32);
		extraInfo.scrollFactor.set();
		extraInfo.setFormat(Paths.font('vcr.ttf'), 32);
		extraInfo.updateHitbox();
		add(extraInfo);

		composer.alpha = 0;
		levelInfo.alpha = 0;
		levelDeaths.alpha = 0;
		extraInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		composer.x = FlxG.width - (composer.width + 20);
		levelDeaths.x = FlxG.width - (levelDeaths.width + 20);
		extraInfo.x = FlxG.width - (levelDeaths.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(composer, {alpha: 1, y: composer.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(levelDeaths, {alpha: 1, y: levelDeaths.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(extraInfo, {alpha: 1, y: extraInfo.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.middleX = true;
			songText.targetY = i;
			grpMenuShit.add(songText);

			songText.x = ((FlxG.width / 2) - (songText.width / 2));
		}

		#if debug
		// trace('change selection');
		#end

		changeSelection();

		#if debug
		// trace('cameras');
		#end

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		#if debug
		// trace('cameras done');
		#end
	}

	override function update(elapsed:Float)
	{
		#if debug
		// trace('call event');
		#end

		super.update(elapsed);

		#if debug
		// trace('updated event');
		#end

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		extraInfo.text = '';
		if (PlayState.cpuControlled) extraInfo.text += '\nBOTPLAY';
		if (PlayState.practiceMode) extraInfo.text += '\nPRACTICE MODE';

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart":
					Main.switchState(this, new PlayState());
				case 'Options':
					OptionsMenuState.fromPlayState = true;
				    Main.switchState(this, new OptionsMenuState());
				case 'Practice':
					PlayState.practiceMode = !PlayState.practiceMode;
				case "Menu":
					PlayState.resetMusic();
					PlayState.deaths = 0;

					if (PlayState.isStoryMode)
						Main.switchState(this, new StoryMenuState());
					else
						Main.switchState(this, new FreeplayState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}

		#if debug
		// trace('music volume increased');
		#end

		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		#if debug
		// trace('mid selection');
		#end

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		#if debug
		// trace('finished selection');
		#end
		//
	}
}
