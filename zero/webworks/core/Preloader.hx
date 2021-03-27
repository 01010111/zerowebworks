package webworks.core;

import js.html.CanvasRenderingContext2D;

using webworks.util.ContextTools;

class Preloader {
	
	static var ctx:CanvasRenderingContext2D;

	public static function init(ctx:CanvasRenderingContext2D) {
		Preloader.ctx = ctx;
	}

	public static function draw(amt:Float) {
		ctx.clear(0x000000);
		ctx.draw_rect(0xFFDDDDDD, Game.width/2 - Game.width/4, Game.height/2 - 8, Game.width/2, 16, 2);
		ctx.fill_rect(0xFFDDDDDD, Game.width/2 - Game.width/4 + 4, Game.height/2 - 4, (Game.width/2 - 8) * amt, 8);
	}

}