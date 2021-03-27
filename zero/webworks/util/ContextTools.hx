package webworks.util;

import webworks.math.Poly;
import webworks.display.Text;
import webworks.math.Vec2;
import webworks.core.Game;
import webworks.display.Sprite;
import webworks.display.Drawable;
import webworks.display.Transform;
import js.html.CanvasRenderingContext2D;

class ContextTools {

	static var last_alpha:Float = 1;

	/**
	 *	Clear the canvas
	**/
	public static function clear(ctx:CanvasRenderingContext2D, ?col:Color) {
		ctx.clearRect(0, 0, Game.width, Game.height);
		if (col != null) fill_rect(ctx, col, 0, 0, Game.width, Game.height);
	}

	/**
	 *	Draw a line with a given color, between points x1,y1 and x2,y2 with a given line weight
	**/
	public static function line(ctx:CanvasRenderingContext2D, col:Color, x1:Float, y1:Float, x2:Float, y2:Float, ?lw:Float, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		line_style(ctx, col, lw);
		ctx.moveTo(x1, y1);
		ctx.lineTo(x2, y2);
		ctx.stroke();
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}

	/**
	 *	Draw a filled circle with a given color, at coordinates x,y with a given radius
	**/
	public static function fill_circ(ctx:CanvasRenderingContext2D, col:Color, x:Float, y:Float, r:Float, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		ctx.fillStyle = col.to_string('#', false);
		ctx.beginPath();
		ctx.arc(x,y,r,0,2*Math.PI);
		ctx.fill();
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}

	/**
	 * Draw a stroked polygon with a given color, at coordinates x,y with a given radius, and line weight
	**/
	public static function draw_poly(ctx:CanvasRenderingContext2D, col:Color, poly:Poly, ?lw:Float, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		line_style(ctx, col, lw);
		ctx.beginPath();
		ctx.moveTo(poly[poly.length - 1].x, poly[poly.length - 1].y);
		for (p in poly) ctx.lineTo(p.x, p.y);
		ctx.stroke();
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}
	
	/**
	 *	Draw a filled polygon with a given color, at coordinates x,y with a given radius
	**/
	public static function fill_poly(ctx:CanvasRenderingContext2D, col:Color, poly:Poly, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		ctx.fillStyle = col.to_string('#', false);
		ctx.beginPath();
		ctx.moveTo(poly[poly.length - 1].x, poly[poly.length - 1].y);
		for (p in poly) ctx.lineTo(p.x, p.y);
		ctx.fill();
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}

	/**
	 * Draw a stroked circle with a given color, at coordinates x,y with a given radius, and line weight
	**/
	public static function draw_circ(ctx:CanvasRenderingContext2D, col:Color, x:Float, y:Float, r:Float, ?lw:Float, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		line_style(ctx, col, lw);
		ctx.arc(x,y,r,0,2*Math.PI);
		ctx.stroke();
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}

	/**
	 *	Draw a filled arc with a given color, at coordinates x,y with a given radius, start angle, and end angle
	**/
	public static function fill_arc(ctx:CanvasRenderingContext2D, col:Color, x:Float, y:Float, r:Float, sa:Float, ea:Float, ccw:Bool = false, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		ctx.fillStyle = col.to_string('#', false);
		ctx.beginPath();
		ctx.arc(x,y,r,sa,ea,ccw);
		ctx.fill();
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}

	/**
	 * Draw a stroked arc with a given color, at coordinates x,y with a given radius, start angle, end angle, and line weight
	**/
	public static function draw_arc(ctx:CanvasRenderingContext2D, col:Color, x:Float, y:Float, r:Float, sa:Float, ea:Float, ccw:Bool = false, ?lw:Float, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		line_style(ctx, col, lw);
		ctx.arc(x,y,r,sa,ea,ccw);
		ctx.stroke();
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}

	/**
	 *	Draw a filled rectangle with a given color, at coordinates x,y with a given width and height
	**/
	public static function fill_rect(ctx:CanvasRenderingContext2D, col:Color, x:Float, y:Float, w:Float, h:Float, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		ctx.fillStyle = col.to_string('#', false);
		ctx.fillRect(x,y,w,h);
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}

	/**
	 *	Draw a stroked rectangle with a given color, at coordinates x,y with a given width, height, and line weight
	**/
	public static function draw_rect(ctx:CanvasRenderingContext2D, col:Color, x:Float, y:Float, w:Float, h:Float, ?lw:Float, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		line_style(ctx, col, lw);
		ctx.strokeRect(x,y,w,h);
		if (alpha != null) ctx.globalAlpha = last_alpha;
	}

	/**
	 *	Set the line style for drawing paths
	**/
	static function line_style(ctx:CanvasRenderingContext2D, col:Color, ?lw:Float, ?alpha:Float) {
		if (alpha != null) {
			last_alpha = ctx.globalAlpha;
			ctx.globalAlpha = alpha;
		}
		ctx.lineWidth = lw != null ? lw : 1;
		ctx.strokeStyle = col.to_string('#', false);
		ctx.beginPath();
		if (alpha != null) ctx.globalAlpha = last_alpha;
		return ctx;
	}

	@:access(webworks.display.Drawable.draw)
	public static function graphic(ctx:CanvasRenderingContext2D, graphic:Drawable) {
		graphic.draw(ctx);
	}

	@:access(webworks.display.Sprite.draw)
	public static function sprite(ctx:CanvasRenderingContext2D, sprite:Sprite) {
		sprite.draw(ctx);
	}

	@:access(webworks.display.Text.draw)
	public static function text(ctx:CanvasRenderingContext2D, text:Text) {
		text.draw(ctx);
	}

}