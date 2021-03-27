package webworks.math;

using Math;

class Rect {
	
	static var pool:Array<Rect> = [];
	public static function get(x:Float = 0, y:Float = 0, w:Float = 0, h:Float = 0) {
		if (pool.length == 0) return new Rect().set(x, y, w, h);
		return pool.shift().set(x, y, w, h);
	}

	public var x:Float = 0;
	public var y:Float = 0;
	public var width:Float = 0;
	public var height:Float = 0;

	public var top(get, set):Float;
	function get_top() return y;
	function set_top(n:Float) {
		height += y - n;
		return y = n;
	}

	public var bottom(get, set):Float;
	function get_bottom() return y + height;
	function set_bottom(n:Float) {
		height += y + height - n;
		return n;
	}

	public var left(get, set):Float;
	function get_left() return x;
	function set_left(n:Float) {
		width += x - n;
		return x = n;
	}

	public var right(get, set):Float;
	function get_right() return x + width;
	function set_right(n:Float) {
		width += x + width - n;
		return n;
	}

	private function new() {}

	public function set(x:Float = 0, y:Float = 0, w:Float = 0, h:Float = 0) {
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
		return this;
	}

	public function put() {
		pool.push(this);
	}

	public inline function copy_from(v:Rect):Rect return set(v.x, v.y, v.width, v.height);

	public inline function copy():Rect return Rect.get(x, y, width, height);
	public inline function equals(v:Rect):Bool return x == v.x && y == v.y && width == v.width && height == v.height;
	public inline function toString():String return 'x: $x | y: $y | width: $width | height: $height';
	public inline function contains_point(v:Vec2) return v.x >= x && v.y >= y && v.x <= x + width && v.y <= y + height;
	public inline function to_poly():Poly return [Vec2.get(left, top), Vec2.get(right, top), Vec2.get(right, bottom), Vec2.get(left, bottom)];

}