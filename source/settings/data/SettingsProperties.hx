package settings.data;

import substates.RatingPosition;
import states.TitleState;
import flixel.FlxSubState;
import flixel.FlxState;
import flixel.FlxG;

class SettingsType
{
	public static var BOOL:Int = 0; // ENTER
	public static var INT:Int = 1; // LEFT RIGHT
	public static var FLOAT:Int = 2; // LEFT RIGHT
	public static var FUNCTION:Int = 3; // ENTER
	public static var MIXED:Int = 4; // SELF DEFINED
}

// Modable settings wip
class SettingsProperties
{
	public static var currentClass:SettingsSubState = null;
	public static var CURRENT_SETTINGS:Array<SettingsCategory> = [];
	public static var holdTime:Float = 0;
	public static var ON_PAUSE:Bool = false;

	public static function setCurrentClass(curClass:Dynamic)
	{
		currentClass = cast curClass;
	}

	public static function reset():Void
	{
		currentClass = null;
		CURRENT_SETTINGS = [];
		holdTime = 0;
	}

	public static function load_default():Void
	{
		// CONTROLS//
		create_category("Controls", [],function()
		{
			//currentClass.openSubState(new keybinds.RebindControls(false));
		});

		// GAMEPLAY//
		create_category("Gameplay", [
			new BaseSettings("Scroll Direction", ["Up", "Down"], "Set the notes Scroll Direction.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}, false),
			new BaseSettings("Middlescroll", ["Disabled", "Enabled"], "Whether to position your Note Strums in center of your screen.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}, false),
			new BaseSettings("Ghost Tapping", ["Disabled", "Enabled"], "If enabled, you won't get any misses when there's no notes hit.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Note Hit Timing", ["Hide", "Show"], "Whether to show your note timing in miliseconds.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Stacking Rating Sprite", ["Disabled", "Enabled"], "Whether to show or hide the \"Sick!!\" sprite stacking each other.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Hit Sound", ["Disabled", "Enabled"], "If enabled, it'll play a clicking sound when you press your note keybinds.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Reset Button", ["Disabled", "Enabled"], "If disabled, you won't get instant killed if you press the \"R\" key.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Botplay", ["OFF", "ON"], "If enabled, a bot will play the game for you.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Health Percentage", ["Hide", "Show"], "Whether to show or hide the Health percentage in Score Text.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("FPS Cap", ["", ""], "Choose how many frames per second that this game should run at.", SettingsType.MIXED, function(elapsed:Float, bs:BaseSettings){
				var daValueToAdd:Int = FlxG.keys.pressed.RIGHT ? 1 : -1;
				if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
					holdTime += elapsed;
				else
					holdTime = 0;
		
				var e = [FlxG.keys.pressed.LEFT, FlxG.keys.pressed.RIGHT];
				if (holdTime <= 0 && e.contains(true))
					FlxG.sound.play(Paths.sound('scrollMenu'));
	
				if (holdTime > 0.5 || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
				{
					CDevConfig.setData("FPS Cap", CDevConfig.getData("FPS Cap")+daValueToAdd);
		
					if (CDevConfig.getData("FPS Cap") <= 50)
						CDevConfig.setData("FPS Cap", 50);

					if (CDevConfig.getData("FPS Cap") > 300)
						CDevConfig.setData("FPS Cap", 300);

					CDevConfig.setFPS(CDevConfig.getData("FPS Cap"));
				}
				bs.value_name[0] = CDevConfig.getData("FPS Cap") + " FPS";
			}, function(){}),	
			new BaseSettings("Note Hit Effect", ["Hide", "Show"], "Whether to show or hide the hit effect when you hit a note.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),	
			new BaseSettings("Time Bar", ["Hide", "Show"], "If enabled, it will show current playing song time as a bar.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Flashing Lights", ["Disabled", "Enabled"], "Enable / Disable Flashing Lights.\n(Disable this if you're sensitive to flashing lights!)", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),	
			new BaseSettings("Camera Beat Zoom", ["OFF", "ON"], "If enabled, the camera will zoom on every 4th beat.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Camera Movement", ["OFF", "ON"], "If disabled, the camera won't move based on the current character sing animation", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Note Offset", ["", ""], "If you think that your audio was late / early, try to change this setting!", SettingsType.MIXED, function(elapsed:Float, bs:BaseSettings){
				if (FlxG.keys.justPressed.ENTER)
				{
					FlxG.switchState(new states.OffsetTest());
				}

				var daValueToAdd:Int = FlxG.keys.pressed.RIGHT ? 1 : -1;
				if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
					holdTime += elapsed;
				else
					holdTime = 0;
	
				var e = [FlxG.keys.pressed.LEFT, FlxG.keys.pressed.RIGHT];
				if (holdTime <= 0 && e.contains(true))
					FlxG.sound.play(Paths.sound('scrollMenu'));
	
				if (holdTime > 0.5 || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
				{
					CDevConfig.setData("Note Offset", CDevConfig.getData("Note Offset")+daValueToAdd);
	
					if (CDevConfig.getData("Note Offset") <= -90000) // like who tf does have a 90000 ms audio delay
						CDevConfig.setData("Note Offset",-90000);

					if (CDevConfig.getData("Note Offset") > 90000) // pfft
						CDevConfig.setData("Note Offset",90000);
				}
				bs.value_name[0] = CDevConfig.getData("Note Offset") + "ms";
			}, function(){}, false),
			new BaseSettings("Detailed Score Text", ["OFF", "ON"], "If enabled, the game will show your misses and accuracy in the score text.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Auto Pause", ["Disabled", "Enabled"], "If disabled, the game will no longer pauses whenever the game window is unfocused.", SettingsType.MIXED, function(elapsed:Float, bs:BaseSettings){
				if (FlxG.keys.justPressed.ENTER){
					FlxG.sound.play(Paths.sound('confirmMenu'));
					CDevConfig.saveData.autoPause = !CDevConfig.saveData.autoPause;
					FlxG.autoPause = CDevConfig.saveData.autoPause;
				}
			}, function(){})
		], null);

		// GAMEPLAY//
		create_category("Appearance", [
			//new BaseSettings("Resources Info", ["Hide", "Show"], "Whether to show currently used resources info as a text.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Engine Watermark", ["Hide", "Show"], "Whether to show CDEV Engine's watermark in the game.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),	
			new BaseSettings("Opponent Notes in Midscroll", ["Hide", "Show"], "If enabled, opponent notes will be slightly visible.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			new BaseSettings("Strum Lane", ["Hide", "Show"], "If enabled, your strum notes playfield will have a black background.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}),
			#if desktop new BaseSettings("Discord Rich Presence", ["", ""], "If enabled, your current game information will be shared to Discord RPC.\n(Changing this option will restart the game!)", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){
				if (FlxG.keys.justPressed.ENTER){
					CDevConfig.saveData.discordRpc = !CDevConfig.saveData.discordRpc;
					Main.discordRPC = CDevConfig.saveData.discordRpc;
					@:privateAccess{
						TitleState.initialized = false;
						TitleState.closedState = false;
					}
					reset();
					FlxG.resetGame();
				}
				bs.value_name[0] = (CDevConfig.saveData.discordRpc ? "ON":"OFF");
			}, function(){}, false),#end
			new BaseSettings("Antialiasing", ["OFF", "ON"], "If disabled, your game will run as smooth but at cost of graphics.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}, false),
			new BaseSettings("Hit Effect Style", ["Splash", "Ripple"], "Choose your preferred Hit Effect Style.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}, false),
			new BaseSettings("Set Rating Sprite Position", ["Press ENTER",""], "Set your preferred Rating sprite position.", SettingsType.MIXED, function(elapsed:Float, bs:BaseSettings){
				if (FlxG.keys.justPressed.ENTER){
					currentClass.hideAllOptions();
					var newState:RatingPosition = new RatingPosition(ON_PAUSE);
					currentClass.openSubState(newState);

					if (newState.leftState){
						currentClass.changeSelection();
						newState.leftState = false;
					}
				}
			}, function(){}),
		], null);

		create_category("Misc", [
			new BaseSettings("Resources Info Mode", ["", ""], "Choose your preferred Resources Text Info Mode.", SettingsType.MIXED, function(elapsed:Float, bs:BaseSettings){
				if (FlxG.keys.justPressed.ENTER)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					var things:Array<String> = ["fps", "fps-mem", "mem", "hide"];
					var curIndex:Int = 0;

					trace("before: " + CDevConfig.saveData.performTxt);
					for (i in things){
						trace("data: " + i);
						if (CDevConfig.saveData.performTxt == i){
							curIndex = things.indexOf(i);
							trace("it similiar: " + i);
							break;
						}
					}

					curIndex += 1;
					if (curIndex >= things.length)
						curIndex = 0;
					CDevConfig.saveData.performTxt = things[curIndex];
					trace("after: " + CDevConfig.saveData.performTxt);
					Main.fps_mem.visible = (CDevConfig.saveData.performTxt=="hide" ? false : true);
				}

				bs.value_name[0] = CDevConfig.saveData.performTxt;
			}, function(){}),
			new BaseSettings("Trace Log Window", ["", ""], "Whether to show / hide Trace Log Window.", SettingsType.MIXED, function(elapsed:Float, bs:BaseSettings){
				if (FlxG.keys.justPressed.ENTER){
					FlxG.sound.play(Paths.sound('confirmMenu'));
					CDevConfig.saveData.showTraceLogAt += 1;
					if (CDevConfig.saveData.showTraceLogAt < 0)
						CDevConfig.saveData.showTraceLogAt = 2;
					if (CDevConfig.saveData.showTraceLogAt >= 2)
						CDevConfig.saveData.showTraceLogAt = 0;
				}
				if (CDevConfig.saveData.showTraceLogAt==0)
					bs.value_name[0] = "Hide";
				else if (CDevConfig.saveData.showTraceLogAt==1)
					bs.value_name[0] = "Show";
				else
					bs.value_name[0] = "Undefined";
			}, function(){}, false),
			new BaseSettings("Trace Log Main Message", ["Hide", "Show"], "Whether to show the tips text in the Trace Log Window.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}, false),	
			new BaseSettings("Check For Updates", ["Disable", "Enabled"], "If enabled, the game will check for updates.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){}, function(){}, false),
			/*new BaseSettings("Autosave Chart File", ["Disable", "Enabled"], "If enabled, the game will autosave the chart as a file. (Press SHIFT for more options)", SettingsType.MIXED, function(elapsed:Float, bs:BaseSettings){
				if (FlxG.keys.justPressed.ENTER){
					FlxG.sound.play(Paths.sound('confirmMenu'));
					CDevConfig.saveData.autosaveChart = !CDevConfig.saveData.autosaveChart;
				}
				if (FlxG.keys.justPressed.SHIFT){
					currentClass.openSubState(new settings.misc.AutosaveSettings());
				}
				
			}, function(){}, false),*/
			new BaseSettings("Clear Game Cache", ["", ""], "Press ENTER to clear memory cache.", SettingsType.BOOL, function(elapsed:Float, bs:BaseSettings){
				if (FlxG.keys.justPressed.ENTER){
					FlxG.sound.play(Paths.sound('confirmMenu'));
					openfl.utils.Assets.cache.clear();
					Paths.destroyLoadedImages();
				}
			}, function(){}, false),
		], null);
	}

	public static function create_category(name:String, child:Array<BaseSettings>, ?onPress:Dynamic):Void
	{
		for (cat in CURRENT_SETTINGS)
		{
			if (cat.name == name)
			{
				trace("Settings category \"" + name + "\" already exists.");
				return;
			}
		}
		CURRENT_SETTINGS.push(new SettingsCategory(name, child, onPress));
	}

	public static function add_setting(catName:String, setName:String, setType:Int):Void
	{
		// Case-sensitive
		for (cat in CURRENT_SETTINGS)
		{
			if (cat.name == catName)
			{
				//var newSet:BaseSettings = new BaseSettings(setName, setType);
				//cat.settings.push(newSet);
				return;
			}
		}

		trace("Can't find settings category \"" + catName + "\".");
	}
}

class SettingsCategory
{
	public var settings:Array<BaseSettings> = [];
	public var name:String = "";
	public var onPress:Dynamic = null;

	public function new(name:String, sets:Array<BaseSettings>, ?onPress:Dynamic=null)
	{
		this.name = name;
		this.settings = sets;
		this.onPress = onPress;
	}
}

class BaseSettings
{
	public var name:String = "New Setting";
	public var value_name:Array<String> = ["Disabled", "Enabled"]; // false, true values.
	public var description:String = "No description was set.";
	public var type:Int = -1;

	public var selectedSetting:Bool = false;
	public var pausable:Bool = false;
	public var onUpdate:(Float, BaseSettings)->Void;
	public var updateDisplay:Void->Void;

	public function new(n:String, v:Array<String>, d:String, t:Int, oc:(Float, BaseSettings)->Void, ud:Void->Void, ?canPause:Bool=true)
	{
		name = n;
		value_name = v;
		description = d;
		type = t;

		pausable = canPause;

		onUpdate = oc;
		updateDisplay = ud;
	}

	public function onUpdateHit(updateElapsed){
		onUpdate(updateElapsed,this);
	}

	public function updateThisDisplay(){
		updateDisplay();
	}
}