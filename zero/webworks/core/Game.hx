package webworks.core;

import webworks.util.Interactions;
import webworks.input.Pointer;
import webworks.input.Keys;
import webworks.util.EventBus;
import webworks.core.Assets;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import js.Browser.window as window;
import js.Browser.document as document;

class Game {
	
	public static var APP_EVENTS:EventBus<AppEventData> = new EventBus();
	public static var GAME_EVENTS:EventBus<GameEventData> = new EventBus();

	public static var width:Int;
	public static var height:Int;

	static var last:Float;
	static var active:Bool = true;
	static var scene:Scene;
	static var canvas:CanvasElement;
	static var ctx:CanvasRenderingContext2D;
	static var init_scene:Class<Scene>;

	public static function init(initial_scene:Class<Scene>, ?assets:AssetList) {
		width = window.innerWidth;
		height = window.innerHeight;
		init_scene = initial_scene;
		init_canvas();
		init_events();
		Keys.init();
		Pointer.init();
		Interactions.init();
		Preloader.init(ctx);
		Assets.load(assets, on_loaded, Preloader.draw);
	}

	static function init_events() {
		window.onresize = (e) -> APP_EVENTS.dispatch(AppEvents.RESIZE, { width: window.innerWidth, height: window.innerHeight });
		window.onfocus = (e) -> APP_EVENTS.dispatch(AppEvents.FOCUS, {});
		window.onblur = (e) -> APP_EVENTS.dispatch(AppEvents.FOCUS_LOST, {});
		APP_EVENTS.listen(AppEvents.FOCUS, (ev) -> active = true);
		APP_EVENTS.listen(AppEvents.FOCUS_LOST, (ev) -> active = false);
		APP_EVENTS.listen(AppEvents.RESIZE, (ev) -> {
			width = window.innerWidth;
			height = window.innerHeight;
		});
		GAME_EVENTS.listen(GameEvents.UPDATE, (ev) -> {
			scene.update(ev.dt);
			scene.draw(ctx);
		});
	}

	static function init_canvas() {
		canvas = document.createCanvasElement();
		ctx = canvas.getContext2d();
		document.body.appendChild(canvas);
		var resize = (ev:AppEventData) -> {
			canvas.width = ev.width;
			canvas.height = ev.height;
		}
		resize({ width: width, height: height });
		APP_EVENTS.listen(AppEvents.RESIZE, resize);
	}

	static function load(?assets:AssetList) {
		if (assets == null) on_loaded();
	}

	static function on_loaded() {
		scene = Type.createInstance(init_scene, []);
		scene.init();
		window.requestAnimationFrame(loop);
	}

	static function loop(time) {
		window.requestAnimationFrame(loop);
		if (!active && (last = time) == time) return;
		if (last == null) last = time;
		var dt = (time - last)/1000;
		GAME_EVENTS.dispatch(GameEvents.PRE_UPDATE, {});
		GAME_EVENTS.dispatch(GameEvents.UPDATE, { dt: dt });
		GAME_EVENTS.dispatch(GameEvents.POST_UPDATE, {});
		last = time;
	}

}

class AppEvents {
	public static var RESIZE = 'RESIZE';
	public static var FOCUS = 'FOCUS';
	public static var FOCUS_LOST = 'FOCUS_LOST';
}

class GameEvents {
	public static var UPDATE = 'UPDATE';
	public static var PRE_UPDATE = 'PRE_UPDATE';
	public static var POST_UPDATE = 'POST_UPDATE';
}

typedef AppEventData = {
	?width:Int,
	?height:Int
}

typedef GameEventData = {
	?dt:Float
}