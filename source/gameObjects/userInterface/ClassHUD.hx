package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.Timings;
import meta.state.PlayState;
import gameObjects.Character;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class ClassHUD extends FlxTypedGroup<FlxBasic>
{
	// set up variables and stuff here
	public static var scoreBar:FlxText;
	var scoreLast:Float = -1;

	// fnf mods
	var scoreDisplay:String = 'beep bop sskepoedd bebep bobeba pe';

	var cornerMark:FlxText; // engine mark at the upper right corner
	public static var centerMark:FlxText; // song display name and difficulty at the center

	private var SONG = PlayState.SONG;

	private var stupidHealth:Float = 0;

	private var timingsMap:Map<String, FlxText> = [];

	var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song);
	var diffDisplay:String = File.getContent('assets/songs/' + PlayState.SONG.song.toLowerCase() + '/canonTxt.txt');
	var engineDisplay:String = "Forever Engine v0.3.1";
	var hankusDisplay:String = "Vs Hankus V1";

	var composerDisplay:String;

	public static var composerTxt:FlxText;

	// eep
	public function new()
	{
		// call the initializations and stuffs
		super();

		// le healthbar setup
		var barY = FlxG.height * 0.875;
		if (Init.trueSettings.get('Downscroll'))
			barY = 64;

		scoreBar = new FlxText(FlxG.width / 2, Math.floor(barY + 40), 0, scoreDisplay);
		if (PlayState.curSong == "sussy-legacy") {
		scoreBar.setFormat(Paths.font(PlayState.choosenfont), 18, FlxColor.WHITE);
		scoreBar.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		updateScoreText();
	    } else {
		scoreBar.setFormat(Paths.font(PlayState.choosenfont), 18, PlayState.dadOpponent.barColor);
		scoreBar.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		updateScoreText();
	    }
		// scoreBar.scrollFactor.set();
		scoreBar.antialiasing = !PlayState.curStage.startsWith("school");
		add(scoreBar);

		cornerMark = new FlxText(0, 0, 0, engineDisplay);
		cornerMark.setFormat(Paths.font(PlayState.choosenfont), 18, FlxColor.WHITE);
		cornerMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(cornerMark);
		cornerMark.alpha = 0.85;
		cornerMark.setPosition(FlxG.width - (cornerMark.width + 5), 5);
		cornerMark.antialiasing = !PlayState.curStage.startsWith("school");

		if (PlayState.curSong == "sabotage-error") {
			centerMark = new FlxText(0, 0, 0, "- S4b0t4ge &rr0r" + (Init.trueSettings.get('Show Canon text') ? " [" + diffDisplay + "]" : "") + " -");
		} else {
			centerMark = new FlxText(0, 0, 0, "- " + infoDisplay + (Init.trueSettings.get('Show Canon text') ? " [" + diffDisplay + "]" : "") + " -");
		}
		centerMark.setFormat(Paths.font(PlayState.choosenfont), 24, FlxColor.WHITE);
		centerMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(centerMark);
		centerMark.screenCenter(X);
		centerMark.antialiasing = !PlayState.curStage.startsWith("school");
		if (Init.trueSettings.get('Downscroll'))
			centerMark.y = (FlxG.height - centerMark.height / 2) - 30;
		else {
			centerMark.y = (FlxG.height / 24) - 10;
		}
		
		composerTxt = new FlxText(500);
		composerTxt.scrollFactor.set();
		composerTxt.setFormat(Paths.font(PlayState.choosenfont), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (!FileSystem.exists(Paths.txt('songs/${PlayState.SONG.song.toLowerCase()}/composerTxt'))) // incase no composer text file
		composerDisplay = '';
		else composerDisplay = '' + CoolUtil.coolTextFile(Paths.txt('songs/${PlayState.SONG.song.toLowerCase()}/composerTxt'));
		// Remove the fuckin [] from the text.
		composerDisplay.substring(composerDisplay.length - 500);
		composerDisplay.substring(composerDisplay.length - 500);
		composerTxt.text = '$composerDisplay';
		composerTxt.y = 500;
		composerTxt.screenCenter(X);
		add(composerTxt);

		// counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			var judgementNameArray:Array<String> = [];
			for (i in Timings.judgementsMap.keys())
				judgementNameArray.insert(Timings.judgementsMap.get(i)[0], i);
			judgementNameArray.sort(sortByShit);
			for (i in 0...judgementNameArray.length)
			{
				var textAsset:FlxText = new FlxText(5
					+ (!left ? (FlxG.width - 10) : 0),
					(FlxG.height / 2)
					- (counterTextSize * (judgementNameArray.length / 2))
					+ (i * counterTextSize), 0, '', counterTextSize);
				if (!left)
					textAsset.x -= textAsset.text.length * counterTextSize;
				textAsset.scrollFactor.set();
				textAsset.setFormat(Paths.font(PlayState.choosenfont), 18, PlayState.boyfriend.barColor);
		        textAsset.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
				timingsMap.set(judgementNameArray[i], textAsset);
				add(textAsset);
			}
		}
		updateScoreText();
	}

	var counterTextSize:Int = 18;

	function sortByShit(Obj1:String, Obj2:String):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Timings.judgementsMap.get(Obj1)[0], Timings.judgementsMap.get(Obj2)[0]);

	var left = (Init.trueSettings.get('Counter') == 'Left');

	override public function update(elapsed:Float)
	{
		if (PlayState.cpuControlled)
			scoreBar.text = 'hi, im a stupid, cringe, paia, dnb fan, brony, i see GF fnf rule 34, i want did pico fuck me, i want dicks in my ass.';
		updateScoreText();
	}

	private final divider:String = " • ";

	public function updateScoreText()
	{
		var importSongScore = PlayState.songScore;
		var importPlayStateCombo = PlayState.combo;
		var importMisses = PlayState.misses;
		if (!PlayState.cpuControlled) {
		scoreBar.text = 'Score: $importSongScore';
		// testing purposes
		var displayAccuracy:Bool = Init.trueSettings.get('Display Accuracy');
		if (displayAccuracy)
		{
			scoreBar.text += divider + 'Misses: ' + Std.string(PlayState.misses);
			scoreBar.text += divider + 'Accuracy: ' + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%' + Timings.comboDisplay;
			if (PlayState.practiceMode) scoreBar.text += divider + 'Noob Mode';
		}
		}
		scoreBar.text += '\n';
		scoreBar.x = Math.floor((FlxG.width / 2) - (scoreBar.width / 2));

		// update counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			for (i in timingsMap.keys())
			{
				timingsMap[i].text = '${(i.charAt(0).toUpperCase() + i.substring(1, i.length))}: ${Timings.gottenJudgements.get(i)}';
				timingsMap[i].x = (5 + (!left ? (FlxG.width - 10) : 0) - (!left ? (6 * counterTextSize) : 0));
			}
		}

		// update playstate
		PlayState.detailsSub = scoreBar.text;
		PlayState.updateRPC(false);
	}

	public static function startDaSong() {
		FlxTween.tween(composerTxt, {y: FlxG.height - 500}, 0, {ease: FlxEase.cubeOut});
	}

	public static function fadeOutSongText()
	{
		FlxTween.cancelTweensOf(composerTxt);
		FlxTween.tween(centerMark, {alpha: 0.7}, 4, {ease: FlxEase.linear});
		FlxTween.tween(composerTxt, {y: composerTxt.y + 500}, 1, {ease: FlxEase.cubeOut});
	}

	public static function bopScore() {
		if (!PlayState.cpuControlled) {
		FlxTween.cancelTweensOf(scoreBar);
		scoreBar.scale.set(1.075, 1.075);
		FlxTween.tween(scoreBar, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.cubeOut});
		}
	}
}
