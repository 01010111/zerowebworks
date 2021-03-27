package webworks.display;

import webworks.math.Vec2;

class Transform {

	static var pool:Array<Transform> = [];
	public static function get() {
		if (pool.length > 0) return pool.shift().to_default();
		return new Transform().to_default();
	}

	public var position:Vec2 = Vec2.get(0, 0);
	public var scale:Vec2 = Vec2.get(1, 1);
	public var rotation:Float = 0;

	private function new() {}

	public function to_default() {
		position.set(0, 0);
		scale.set(1, 1);
		rotation = 0;
		return this;
	}

	public function put() pool.push(this);
	public function copy() {
		var out = get();
		out.position.copy_from(position);
		out.scale.copy_from(scale);
		out.rotation = rotation;
		return out;
	}
	public function copy_from(t:Transform) {
		position.copy_from(t.position);
		scale.copy_from(t.scale);
		rotation = t.rotation;
		return this;
	}

}