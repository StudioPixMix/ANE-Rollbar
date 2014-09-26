package com.studiopixmix;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * The entry point of the Native Extension.
 */
public class RollbarExtension implements FREExtension {
	private static final String TAG = RollbarExtension.class.getSimpleName();
	
	/** The context used. */
	private static RollbarExtensionContext context;
	
	/**
	 * Creates the Extension context.
	 */
	@Override public FREContext createContext(String type) {
		
		log("Creating context (type:" + type + ") ...");
		context = new RollbarExtensionContext();
		log("Context created : " + context);
		
		return context;
	}

	@Override
	public void dispose() {
		log("Disposing context ...");
		context.dispose();
		context = null;
		log("Context disposed.");
	}

	@Override
	public void initialize() {
		log("Initializing ...");
	}

	
	/**
	 * Logs the given tagged message to Android and ActionScript.
	 * @param tag		The logging tag for android, prefix for ActionScript
	 * @param message	The logged message
	 */
	public static void log(String message) {
		Log.i(TAG, message);
//		if(context != null)
//			context.dispatchStatusEventAsync("Event.Log", "[" + TAG + "] " + message);
	}
}
