package webworks.util;

import webworks.math.Vec2;
import webworks.input.Pointer;
import webworks.core.Game;
import webworks.core.Game.GameEvents;
import webworks.display.Drawable;

using webworks.math.Poly.PolyUtils;

class Interactions {
	
	static var stack:Array<Drawable> = [];
	static function empty() while (stack.length > 0) stack.pop();
	public static function add(d:Drawable) stack.unshift(d);

	static var events:Array<PointerEventData> = [];

	public static function init() {
		Pointer.POINTER_EVENTS.listen(PointerEvents.POINTER_DOWN, (e) -> events.push(e));
		Pointer.POINTER_EVENTS.listen(PointerEvents.POINTER_UP, (e) -> events.push(e));
		Pointer.POINTER_EVENTS.listen(PointerEvents.POINTER_MOVE, (e) -> events.push(e));
		Game.GAME_EVENTS.listen(GameEvents.UPDATE, (e) -> update());
		Game.GAME_EVENTS.listen(GameEvents.POST_UPDATE, (e) -> empty());
	}

	static function update() {
		while (events.length > 0) {
			var event = events.shift();
			switch event.type {
				case PointerEvents.POINTER_DOWN: on_down(event);
				case PointerEvents.POINTER_UP: on_up(event);
				case PointerEvents.POINTER_MOVE: on_move(event);
				default: continue;
			}
		}
	}

	static function on_down(e:PointerEventData) for (d in stack) {
		if (!pointer_over_drawable(d, e)) continue;
		return d.on_pointer_down(e);
	}

	static function on_up(e:PointerEventData) for (d in stack) {
		if (!pointer_over_drawable(d, e)) continue;
		return d.on_pointer_up(e);
	}

	static function on_move(e:PointerEventData) for (d in stack) {
		if (!pointer_over_drawable(d, e)) continue;
		return d.on_pointer_move(e);
	}

	static function pointer_over_drawable(d:Drawable, e:PointerEventData) {
		var rect = d.rect;
		var poly = rect.to_poly();
		var point = Vec2.get(e.x, e.y);
		var transform = d.get_global_transform();
		poly.apply_transform(transform);
		var out = poly.contains_point(point);
		rect.put();
		point.put();
		poly.put();
		transform.put();
		return out;
	}

}