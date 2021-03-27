package webworks.math;

import webworks.display.Transform;
import webworks.math.Vec2;

typedef Poly = Array<Vec2>;

class PolyUtils {
	
	public static function contains_point(poly:Poly, v:Vec2) {
		var out = false;
		var i = 0;
		var j = poly.length - 1;
		while (i < poly.length) {
			if ((poly[i].y > v.y) != (poly[j].y > v.y) && v.x < (poly[j].x - poly[i].x) * (v.y - poly[i].y) / (poly[j].y - poly[i].y) + poly[i].x) out = !out;
			j = i++;
		}
		return out;
	}

	public static function apply_transform(poly:Poly, t:Transform) {
		for (p in poly) p.apply_transform(t);
		return poly;
	}

	public static function put(poly:Poly) {
		for (p in poly) p.put();
	}

	public static function add_point(poly:Poly, v:Vec2) {
		for (p in poly) p.add(v);
	}

}

/**

int pnpoly(int nvert, float *vertx, float *verty, float testx, float testy)
{
  int i, j, c = 0;
  for (i = 0, j = nvert-1; i < nvert; j = i++) {
    if ( ((verty[i]>testy) != (verty[j]>testy)) &&
	 (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
       c = !c;
  }
  return c;
}

**/