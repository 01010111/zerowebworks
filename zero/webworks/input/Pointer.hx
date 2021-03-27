package webworks.input;

import webworks.util.EventBus;
import webworks.math.Vec2;
import webworks.core.Game;
import js.Browser.document as document;

class Pointer {

	public static var POINTER_EVENTS:EventBus<PointerEventData> = new EventBus();

	public static var touches:Array<TouchPoint> = [];
	static var last_position:Vec2 = Vec2.get();

	public static var x(get, never):Float;
	static function get_x() return last_position.x;

	public static var y(get, never):Float;
	static function get_y() return last_position.y;

	public static var touched(get, never):Bool;
	static function get_touched() {
		for (p in touches) if (p != null) return true;
		return false;
	}

	public static var just_touched(get, never):Bool;
	static function get_just_touched() {
		for (p in touches) if (p != null && p.just_touched) return true;
		return false;
	}
	
	public static function init() {
		document.addEventListener('pointermove', (e) -> move(e.clientX, e.clientY, e.pointerId));
		document.addEventListener('pointerdown', (e) -> down(e.clientX, e.clientY, e.pointerId));
		document.addEventListener('pointerup', (e) -> up(e.clientX, e.clientY, e.pointerId));
		document.addEventListener('pointerout', (e) -> out(e.pointerId));
		Game.GAME_EVENTS.listen(GameEvents.POST_UPDATE, (e) -> post_update());
	}

	static function move(x:Float, y:Float, id:Int) {
		POINTER_EVENTS.dispatch(PointerEvents.POINTER_MOVE, { id: id, x: x, y: y, type: PointerEvents.POINTER_MOVE });
		if (touches[id] != null) touches[id].set_position(x, y);
		last_position.set(x, y);
	}

	static function down(x:Float, y:Float, id:Int) {
		POINTER_EVENTS.dispatch(PointerEvents.POINTER_DOWN, { id: id, x: x, y: y, type: PointerEvents.POINTER_DOWN });
		touches[id] = TouchPoint.get(id, x, y);
		touches[id].just_touched = true;
		last_position.set(x, y);
	}

	static function up(x:Float, y:Float, id:Int) {
		POINTER_EVENTS.dispatch(PointerEvents.POINTER_UP, { id: id, x: x, y: y, type: PointerEvents.POINTER_UP });
		if (touches[id] == null) return;
		touches[id].put();
		touches[id] = null;
	}
	
	static function out(id:Int) {
		POINTER_EVENTS.dispatch(PointerEvents.POINTER_OUT, { id: id, x: x, y: y, type: PointerEvents.POINTER_OUT });
		if (touches[id] == null) return;
		touches[id].put();
		touches[id] = null;
	}

	static function post_update() for (touch in touches) {
		if (touch == null) continue;
		touch.just_touched = false;
		touch.last_position.copy_from(touch.position);
	}

}

class TouchPoint {

	static var pool:Array<TouchPoint> = [];
	public static function get(id:Int, x:Float, y:Float) return pool.length > 0 ? pool.shift().set(id, x, y) : new TouchPoint(id, x, y);
	
	public var id:Int;
	public var position:Vec2 = Vec2.get();
	public var last_position:Vec2 = Vec2.get();
	public var just_touched:Bool;
	
	private function new(id:Int, x:Float, y:Float) set(id, x, y);
	public function put() pool.push(this);

	function set(id:Int, x:Float, y:Float) {
		this.id = id;
		position.set(x, y);
		return this;
	}

	public function set_position(x:Float, y:Float) {
		last_position.set(position.x, position.y);
		position.set(x, y);
	}

}

class PointerEvents {
	public static var POINTER_DOWN(default, never) = 'POINTER_DOWN';
	public static var POINTER_MOVE(default, never) = 'POINTER_MOVE';
	public static var POINTER_UP(default, never) = 'POINTER_UP';
	public static var POINTER_OUT(default, never) = 'POINTER_OUT';
}

typedef PointerEventData = {
	id:Int,
	type:String,
	x:Float,
	y:Float,
}