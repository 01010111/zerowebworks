package webworks.core;

import js.html.ImageElement;
import js.html.AudioElement;
import js.Browser.document as document;

class Assets {
	
	static var images:Map<String, ImageElement> = [];
	static var audio:Map<String, AudioElement> = [];
	static var text:Map<String, String> = [];

	static var loaded:Map<String, Bool> = [];
	static var on_loading:Float -> Void = n -> {};
	static var on_loaded:Void -> Void = () -> {};

	public static function load(?assets:AssetList, ?on_loaded:Void -> Void, ?on_loading: Float -> Void) {
		if (assets == null) return on_loaded == null ? null : on_loaded();
		if (on_loading != null) Assets.on_loading = on_loading;
		if (on_loaded != null) Assets.on_loaded = on_loaded;
		if (assets.images != null) for (image in assets.images) load_image(image);
		if (assets.audio != null) for (audio in assets.audio) load_audio(audio);
		if (assets.text != null) for (text in assets.text) load_text(text);
		check_load();
	}

	public static function get_image(src:String) return images[src];
	public static function get_audio(src:String) return audio[src];
	public static function get_text(src:String) return text[src];

	static function load_image(src:String) {
		loaded.set(src, false);
		var image = document.createImageElement();
		image.src = src;
		image.style.display = 'none';
		document.body.appendChild(image);
		image.onload = () -> check_load(src);
		images.set(src, image);
	}

	static function load_audio(src:String) {
		loaded.set(src, false);
		var audio = document.createAudioElement();
		audio.src = src;
		audio.style.display = 'none';
		document.body.appendChild(audio);
		audio.onload = () -> check_load(src);
		audio.loop = false;
		Assets.audio.set(src, audio);
	}

	static function load_text(src:String) {
		//loaded.set(src, false);
	}

	static function check_load(?src:String) {
		if (src != null) loaded.set(src, true);
		var has_loaded:Int = 0;
		var total:Int = 0;
		for (key => value in loaded) if (total++ > -1 && value == true) has_loaded++;
		on_loading(has_loaded/total);
		if (has_loaded == total) on_loaded();
	}

}

typedef AssetList = {
	?images:Array<String>,
	?audio:Array<String>,
	?text:Array<String>,
}