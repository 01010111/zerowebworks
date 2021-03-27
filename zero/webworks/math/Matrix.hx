package webworks.math;

import webworks.display.Transform;
using Math;

class Matrix {
	
	static var pool:Array<Matrix> = [];
	public static function get(a = 1.0, b = 0.0, c = 0.0, d = 1.0, tx = 0.0, ty = 0.0) {
		return pool.length > 0 ? pool.shift().set(a,b,c,d,tx,ty) : new Matrix().set(a,b,c,d,tx,ty);
	}
	
	public var a:Float;
	public var b:Float;
	public var c:Float;
	public var d:Float;
	public var tx:Float;
	public var ty:Float;

	private function new() {}

	public function set(a,b,c,d,tx,ty) {
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
		return this;
	}

	public function put() {
		identity();
		pool.push(this);
	}

	public function copy() return get(a,b,c,d,tx,ty);
	public function copy_from(m:Matrix) set(m.a,m.b,m.c,m.d,m.tx,m.ty);

	public function identity() {
		a = 1;
		b = 0;
		c = 0;
		d = 1;
		tx = 0;
		ty = 0;
	}
	
	public function multiply(m:Matrix) {
		var a1 = a * m.a + b * m.c;
		b = a * m.b + b * m.d;
		a = a1;

		var c1 = c * m.a + d * m.c;
		d = c * m.b + d * m.d;
		c = c1;

		var tx1 = tx * m.a + ty * m.c + m.tx;
		ty = tx * m.b + ty * m.d + m.ty;
		tx = tx1;
	}

	public function transform(t:Transform) {
		scale(t.scale.x, t.scale.y);
		rotate(t.rotation);
		translate(t.position.x, t.position.y);
	}

	public function rotate(radians:Float) {
		var cos = radians.cos();
		var sin = radians.sin();

		var a1 = a * cos - b * sin;
		b = a * sin + b * cos;
		a = a1;

		var c1 = c * cos - d * sin;
		d = c * sin + d * cos;
		c = c1;

		var tx1 = tx * cos - ty * sin;
		ty = tx * sin + ty * cos;
		tx = tx1;
	}

	public function scale(x:Float, y:Float) {
		a *= x;
		b *= y;
		c *= x;
		d *= y;
		tx *= x;
		ty *= y;
	}

	public function translate(dx:Float, dy:Float) {
		tx += dx;
		ty += dy;
	}

	public function to_transform(?t:Transform, weak:Bool = false) {		
		if (t == null) t = Transform.get();
		var delta = a * d - b * c;
		t.position.set(tx, ty);
		if (a != 0 || b != 0) {
			var r = Math.sqrt(a * a + b * b);
			t.rotation = b > 0 ? Math.acos(a / r) : -Math.acos(a / r);
			t.scale.set(r, delta / r);
		}
		else if (c != 0 || d != 0) {
			var s = Math.sqrt(c * c + d * d);
			t.rotation =
			Math.PI / 2 - (d > 0 ? Math.acos(-c / s) : -Math.acos(c / s));
			t.scale.set(delta / s, s);
		}
		if (weak) put();
		return t;
	}

}