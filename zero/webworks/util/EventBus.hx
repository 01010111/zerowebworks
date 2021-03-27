package webworks.util;

class EventBus<T> {

	var listeners:Map<String, Array<T -> Void>> = new Map();
	
	public function new() {}

	public function listen(ev:String, fn:T -> Void) {
		if (!listeners.exists(ev)) listeners.set(ev, []);
		listeners[ev].push(fn);
	}

	public function dispatch(ev:String, data:T) {
		if (!listeners.exists(ev)) return;
		for (fn in listeners[ev]) fn(data);
	}

	public function unlisten(?ev:String, ?fn:T -> Void) {
		if 		(ev == null && fn == null) return;
		else if (ev == null && fn != null) for (key => value in listeners) listeners[key].remove(fn);
		else if (ev != null && fn == null) listeners.set(ev, []);
		else if (listeners.exists(ev)) listeners[ev].remove(fn);
	}

}