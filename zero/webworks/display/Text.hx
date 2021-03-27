package webworks.display;

import webworks.util.Color;
import js.html.CanvasRenderingContext2D;

using webworks.util.ContextTools;
using Std;

class Text extends Drawable {
	
	static var pool:Array<Text> = [];
	public static function get(format:TextFormat) {
		return pool.length > 0 ? pool.shift().set_format(format) : new Text().set_format(format);
	}
	
	public var format:TextFormat;
	public var text:String = '';
	
	private function new() {}
	public function put() pool.push(this);

	public function set_format(format:TextFormat) {
		if (format.size == null) format.size = 12;
		if (format.font == null) format.font = 'monospaced';
		if (format.color == null) format.color = 0x000000;
		if (format.style == null) format.style = NORMAL;
		if (format.draw_style == null) format.draw_style = FILL;
		this.format = format;
		return this;
	}

	override function draw(ctx:CanvasRenderingContext2D) {
		if (format != null) {
			if (text.length == 0) return;
			var font_prefix = switch format.style {
				case null, NORMAL: '';
				case BOLD: 'bold ';
				case ITALIC: 'italic ';
				case BOLD_ITALIC: 'italic bold ';
			}
			ctx.font = '$font_prefix${format.size}px ${format.font}';
			if (format.align != null) ctx.textAlign = format.align.string();
			if (format.baseline != null) ctx.textBaseline = format.baseline.string();
			if (format.draw_style == FILL || format.draw_style == BOTH) {
				ctx.fillStyle = format.color.to_string('#', false);
				ctx.fillText(text, 0, 0, format.max_width);
			}
			if (format.draw_style == STROKE || format.draw_style == BOTH) {
				ctx.strokeStyle = (format.line_color != null ? format.line_color : format.color).to_string('#', false);
				ctx.lineWidth = format.line_width != null ? format.line_width : 1;
				ctx.strokeText(text, 0, 0, format.max_width);
			}
		}
	}

}

typedef TextFormat = {
	?size:Int,
	?font:String,
	?color:Color,
	?draw_style:TextDrawStyle,
	?style:TextStyle,
	?align:TextAlign,
	?baseline:TextBaseline,
	?line_width:Float,
	?line_color:Color,
	?max_width:Float,
}

enum TextAlign {
	start;
	end;
	left;
	right;
	center;
}

enum TextBaseline {
	top;
	hanging;
	middle;
	alphabetic;
	ideographic;
	bottom;
}

enum TextDrawStyle {
	FILL;
	STROKE;
	BOTH;
}

enum TextStyle {
	NORMAL;
	BOLD;
	ITALIC;
	BOLD_ITALIC;
}