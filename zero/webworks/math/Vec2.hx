package webworks.math;

import webworks.display.Transform;
using Math;

class Vec2 {
	
	static var pool:Array<Vec2> = [];
	public static function get(x:Float = 0, y:Float = 0) {
		if (pool.length > 0) return pool.shift().set(x, y);
		return new Vec2().set(x, y);
	}

	static var epsilon:Float = 1e-8;
	static function zero(n:Float):Float return n.abs() <= epsilon ? 0 : n;

	public var x:Float = 0;
	public var y:Float = 0;

	public var length (get, set):Float;
	inline function get_length() return (x*x + y*y).sqrt();
	inline function set_length(v:Float)
	{
		normalize();
		scale(v);
		return v;
	}

	public var angle (get, set):Float;
	inline function get_angle() return ((Math.atan2(y, x) * (180 / Math.PI)) % 360 + 360) % 360;
	inline function set_angle(v:Float)
	{
		v *= (Math.PI / 180);
		var len = length;
		set(len * v.cos(), len * v.sin());
		return v;
	}

	public var radians (get, set):Float;
	inline function get_radians() return Math.atan2(y, x);
	inline function set_radians(v:Float)
	{
		var len = length;
		set(len * v.cos(), len * v.sin());
		return v;
	}

	private function new() {}

	public function set(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
		return this;
	}

	public function put() {
		pool.push(this);
	}

	public inline function copy_from(v:Vec2):Vec2 return set(v.x, v.y);
	public inline function normalize():Vec2 return set(x / length, y / length);
	public inline function scale(n:Float):Vec2 return set(x * n, y * n);

	public inline function copy():Vec2 return Vec2.get(x, y);
	public inline function equals(v:Vec2):Bool return x == v.x && y == v.y;
	public inline function in_circle(c:Vec2, r:Float):Bool return distance(c) < r;
	public inline function dot(v:Vec2):Float return zero(x * v.x + y * v.y);
	public inline function cross(v:Vec2):Float return zero(x * v.y - y * v.x);
	public inline function facing(v:Vec2):Float return zero(x / length * v.x / v.length + y / length * v.y / v.length);
	public inline function distance(v:Vec2):Float return ((x - v.x).pow(2) + (y - v.y).pow(2)).sqrt();
	public inline function rad_between(v:Vec2):Float return Math.atan2(v.y - y, v.x - x);
	public inline function toString():String return 'x: $x | y: $y | length: $length | angle: $angle';
	public inline function subtract(v:Vec2) return set(x - v.x, y - v.y);
	public inline function add(v:Vec2) return set(x + v.x, y + v.y);
	public inline function multiply(v:Vec2) return set(x * v.x, y * v.y);
	public inline function divide(v:Vec2) return set(x / v.x, y / v.y);
	
	public inline function rotate_around(pivot:Vec2, delta:Float) {
		subtract(pivot);
		this.radians += delta;
		add(pivot);
	}

	public inline function apply_transform(t:Transform) {
		subtract(t.position);
		multiply(t.scale);
		radians += t.rotation;
		add(t.position);
	}

}