package webworks.input;

import webworks.core.Game;
import js.Browser.document as document;

class Keys {

	static var keys:Map<String, Bool> = [];
	static var last:Map<String, Bool> = [];

	public static var last_key:String;

	public static function init() {
		document.addEventListener('keydown', (e) -> set_key(e.key, true));
		document.addEventListener('keyup', (e) -> set_key(e.key, false));
		Game.GAME_EVENTS.listen(GameEvents.POST_UPDATE, (e) -> for (key => value in keys) last.set(key, value));
	}

	static function set_key(key:String, down:Bool) {
		keys.set(key, down);
		if (down) last_key = key;
	}

	public static function pressed(key:String):Bool {
		if (!keys.exists(key)) return false;
		return keys[key];
	}

	public static function just_pressed(key:String):Bool {
		if (!keys.exists(key)) return false;
		if (!keys[key]) return false;
		if (last[key]) return false;
		last.set(key, true);
		return true;
	}

	public static function just_released(key:String):Bool {
		if (!keys.exists(key)) return false;
		if (keys[key]) return false;
		if (!last[key]) return false;
		last.set(key, false);
		return true;
	}

}