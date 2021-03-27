package webworks.util;

abstract Color(Int) from Int from UInt to Int to UInt {

	public var red(get, set):Int;
	public var blue(get, set):Int;
	public var green(get, set):Int;
	public var alpha(get, set):Int;

	public inline function to_string(prefix:String = '', include_alpha:Bool) {
		var out = prefix;
		if (include_alpha) out += StringTools.hex(alpha, 2);
		out += '${StringTools.hex(red, 2)}${StringTools.hex(green, 2)}${StringTools.hex(blue, 2)}';
		return out;
	}

	public function new(Value:Int = 0) {
		this = Value;
	}
	
	inline function get_red():Int return (this >> 16) & 0xff;
	inline function get_green():Int return (this >> 8) & 0xff;
	inline function get_blue():Int return this & 0xff;
	inline function get_alpha():Int return (this >> 24) & 0xff;

	inline function set_red(Value:Int):Int {
		this &= 0xff00ffff;
		this |= boundChannel(Value) << 16;
		return Value;
	}

	inline function set_green(Value:Int):Int {
		this &= 0xffff00ff;
		this |= boundChannel(Value) << 8;
		return Value;
	}

	inline function set_blue(Value:Int):Int {
		this &= 0xffffff00;
		this |= boundChannel(Value);
		return Value;
	}

	inline function set_alpha(Value:Int):Int {
		this &= 0x00ffffff;
		this |= boundChannel(Value) << 24;
		return Value;
	}

	inline function boundChannel(Value:Int):Int {
		return Value > 0xff ? 0xff : Value < 0 ? 0 : Value;
	}

}