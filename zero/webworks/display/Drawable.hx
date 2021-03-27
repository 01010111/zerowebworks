package webworks.display;

import webworks.math.Matrix;
import webworks.math.Rect;
import webworks.core.Game;
import webworks.input.Pointer;
import webworks.util.Interactions;
import webworks.math.Vec2;
import js.html.CanvasRenderingContext2D;

using webworks.util.ContextTools;

class Drawable {

	static var ctx_matrix = Matrix.get();
	static var last_alpha:Float;
	
	public var transform = Transform.get();
	public var alpha:Float = 1;

	public var interactive(default, set):Bool = false;
	function set_interactive(b:Bool) {
		if (b) Game.GAME_EVENTS.listen(GameEvents.PRE_UPDATE, pre_update);
		else Game.GAME_EVENTS.unlisten(GameEvents.PRE_UPDATE, pre_update);
		return interactive = b;
	}
	public var on_pointer_down:PointerEventData -> Void = (e) -> {};
	public var on_pointer_up:PointerEventData -> Void = (e) -> {};
	public var on_pointer_move:PointerEventData -> Void = (e) -> {};

	public var position(get, never):Vec2;
	function get_position() return transform.position;
	
	public var x(get,set):Float;
	function get_x() return position.x;
	function set_x(n:Float) return position.x = n;

	public var y(get,set):Float;
	function get_y() return position.y;
	function set_y(n:Float) return position.y = n;

	public var radians(get,set):Float;
	function get_radians() return transform.rotation;
	function set_radians(n:Float) return transform.rotation = n;

	public var angle(get,set):Float;
	function get_angle() return radians * (180/Math.PI);
	function set_angle(n:Float) return radians = n * Math.PI / 180;

	public var width:Float = 0;
	public var height:Float = 0;

	public var pivot:Vec2 = Vec2.get(0.5, 0.5);

	public var scale(get,never):Vec2;
	function get_scale() return transform.scale;

	public var rect(get, never):Rect;
	function get_rect() return Rect.get(x - width * pivot.x, y - width * pivot.y, width, height);
	
	public var parent:Null<Drawable>;
	public var children:Array<Drawable> = [];

	public var matrix(get,never):Matrix;
	function get_matrix() {
		var m = Matrix.get();
		m.transform(transform);
		m.translate(width * pivot.x, height * pivot.y);
		var p = parent;
		while (p != null) {
			m.transform(p.transform);
			//m.translate(p.width * p.pivot.x, p.height * p.pivot.y);
			p = p.parent;
		}
		m.translate(-width * pivot.x, -height * pivot.y);
		return m;
	}

	function pre_update(e) {
		if (interactive) Interactions.add(this);
	}

	static var stack:Array<Drawable>;

	function ctx_draw(ctx:CanvasRenderingContext2D) {
		ctx.save();
		pre_draw(ctx);
		draw(ctx);
		post_draw(ctx);
		ctx.restore();
	}

	function pre_draw(ctx:CanvasRenderingContext2D) {		
		last_alpha = ctx.globalAlpha;
		ctx.globalAlpha = alpha;
		apply_transform_to_ctx(ctx);
	}
	
	function draw(ctx:CanvasRenderingContext2D) {}
	
	function post_draw(ctx:CanvasRenderingContext2D) {
		ctx.globalAlpha = last_alpha;
		draw_children(ctx);		
	}

	function draw_children(ctx:CanvasRenderingContext2D) {
		ctx.translate(width * pivot.x, height * pivot.y);
		for (child in children) {
			child.pre_draw(ctx);
			child.draw(ctx);
			child.post_draw(ctx);
		}
	}

	function apply_transform_to_ctx(ctx:CanvasRenderingContext2D) {
		ctx.translate(transform.position.x, transform.position.y);
		ctx.rotate(transform.rotation);
		ctx.scale(scale.x, scale.y);
		ctx.translate(-width * pivot.x, -height * pivot.y);
	}

	public function add(child:Drawable, ?at:Int) {
		if (child.parent != null) child.parent.remove(child);
		child.parent = this;
		at == null ? children.push(child) : children.insert(at, child);
	}

	public function remove(child:Drawable) {
		child.parent = null;
		children.remove(child);
	}

	public function get_global_transform() {
		return matrix.to_transform(true);
	}

}