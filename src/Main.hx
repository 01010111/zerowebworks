import webworks.display.Transform;
import webworks.math.Poly;
import webworks.display.Text;

class Main extends Scene {
	
	static function main() {
		Game.init(Main, { images: ['me.png'] });
	}
	
	var parent:Sprite;
	var child:Sprite;
	var poly:Poly;
	var child_poly:Poly;
	var parent_poly:Poly;
	var time = 0.0;
	var v = Vec2.get(Game.width/2 - 200, Game.height/2 - 200);

	override function init() {
		parent = Sprite.get('me.png');
		child = Sprite.get('me.png');
		child.interactive = true;
		child.on_pointer_down = (e) -> trace(e);

		parent.position.set(Game.width/2, Game.height/2);
		//child.position.set(200, 0);
		parent.scale.set(0.25, 0.25);
		child.scale.set(0.5, 0.5);

		parent.add(child);
	}
	
	override function update(dt:Float) {
		time += dt;
		parent.angle += 5 * dt;
		//child.angle -= 5 * dt;
		//parent.scale.x += time.sin()/512;
		//parent.scale.y += time.cos()/256;
		//child.scale.x += time.cos()/256;
		//child.scale.y += time.sin()/512;
		child.x += time.sin();
		child.y += time.cos();
		//parent.x += time.cos();
		//parent.y += time.sin();

		var ct = child.get_global_transform();
		var pt = parent.get_global_transform();
		child_poly = child.rect.to_poly().apply_transform(ct);
		parent_poly = parent.rect.to_poly().apply_transform(pt);
		ct.put();
		pt.put();
	}
	
	override function draw(ctx:Context2D) {
		ctx.clear(0xFFFFFF);
		ctx.sprite(parent);
		ctx.draw_poly(0x000000, child_poly, 4);
		ctx.draw_poly(0x000000, parent_poly, 4);

		for (j in 0...(Game.height/50).floor()) for (i in 0...(Game.width/50).floor()) {
			ctx.line(0xd0d0d0, i * 50, 0, i * 50, Game.height, 1, 0.02);
			ctx.line(0xd0d0d0, 0, j * 50, Game.width, j * 50, 1, 0.02);
		}
		for (j in 0...(Game.height/100).floor()) for (i in 0...(Game.width/100).floor()) {
			ctx.line(0x808080, i * 100, 0, i * 100, Game.height, 2, 0.02);
			ctx.line(0x808080, 0, j * 100, Game.width, j * 100, 2, 0.02);
		}
	}

}