package webworks.util;

using Math;

class NumberTools {
	
	public static function randomf(min:Float, max:Float) {
		return min + Math.random() * (max - min);
	}

	public static function random(min:Int, max:Int) {
		return (min + Math.random() * (max - min)).floor();
	}

	public static function sign_of(n:Float) {
		return n == 0 ? 0 : n < 0 ? -1 : 1;
	}

	
}

typedef Maths = Math;