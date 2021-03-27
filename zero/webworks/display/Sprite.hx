package webworks.display;

import webworks.core.Assets;
import webworks.math.Rect;
import js.html.ImageElement;
import js.html.CanvasRenderingContext2D;

using webworks.util.ContextTools;

class Sprite extends Drawable {

	static var pool:Array<Sprite> = [];
	public static function get(src:String) return pool.length > 0 ? pool.shift().reset(src) : new Sprite().reset(src);
	
	var image:ImageElement;
	var frame:Rect = Rect.get();
	
	private function new() {}
	public function put() pool.push(this);

	function reset(src:String, alpha:Float = 1, ?t:Transform) {
		if (t != null) transform.copy_from(t);
		else {
			transform.to_default();
			pivot.set(0.5, 0.5);
		}
		this.alpha = alpha;
		image = Assets.get_image(src);
		if (image != null) {
			width = image.width;
			height = image.height;
			frame.set(0, 0, image.width, image.height);
		}
		else Assets.load({ images: [src] }, () -> reset(src, this.alpha, transform));
		return this;
	}

	override function _draw(ctx:CanvasRenderingContext2D) {
		apply_transform_to_ctx(ctx);
		if (image != null) ctx.drawImage(
			image,
			frame.x,
			frame.y,
			frame.width,
			frame.height,
			0,
			0,
			frame.width,
			frame.height
		);
		draw_children(ctx);
	}

}