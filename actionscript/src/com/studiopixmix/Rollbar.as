package com.studiopixmix {
	
	import flash.display.Stage;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	/**
	 * A simple ANE to initialize Rollbar SDK.
	 */
	public class Rollbar {
		
		// CONSTANTS :
		/** This should be in the manifest, in the &lt;extension&gt; section. */
		public static const EXTENSION_ID:String = "com.studiopixmix.Rollbar";
		/** The internal logging event name. */
		private static const EVENT_LOG:String = "Event.Log";
		
		// PROPERTIES :
		/** The logging function you want to use. Defaults to trace. */
		public static var logger:Function = trace;
		/** The prefix appended to every log message. Defaults to "[Rollbar]". */
		public static var logPrefix:String = "[Rollbar]";
		
		/** The Native Extension context. */
		private static var extensionContext:ExtensionContext;
		
		private static var _isInitialized:Boolean;
		/** Whether the extension have been initialized. */
		public static function get isInitialized():Boolean { return _isInitialized; }
		
		/** Whether the _isSupported var has already been initialized. */
		private static var _isSupportedInitialized:Boolean;
		private static var _isSupported:Boolean;
		/** Whether the Native Extension is supported on the actual platform. */
		public static function get isSupported():Boolean {
			if(!_isSupportedInitialized) {
				var os:String = Capabilities.manufacturer.toLowerCase();
				_isSupported = os.indexOf("ios") >= 0 || os.indexOf("android") >= 0;
				_isSupportedInitialized = true;
			}
			return  _isSupported;
		}
		
		
		////////////////
		// PUBLIC API //
		////////////////
		
		/**
		 * Initializes Rollbar if it is supported on the current platform.
		 * 
		 * @param stage						A reference to the flash native stage
		 * @param accessToken				Rollbar access token to use
		 * @param environment				The environment to use (free form)
		 * @param includeLogcatOnAndroid	Whether to include logcat in reports on Android (requires android.permission.READ_LOGS permission)
		 */
		public static function init(stage:Stage, accessToken:String, environment:String, includeLogcatOnAndroid:Boolean):void {
			
			// Init only once :
			if(isInitialized) {
				log("Rollbar is already initialized. Aborting.");
				return;
			}
			
			// AS3 SDK :
			log("Initializing AS3 SDK ...");
			RollbarAS.init(stage, accessToken, environment);
			
			// Native SDK :
			if (!isSupported) {
				log("Platform is not supported, aborting...");
				return;
			}
			
			log("Initializing native SDK ...");
			extensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
			if(extensionContext != null)
				extensionContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
			else {
				log("Failed to create context ! Aborting...");
				return;
			}
			
			extensionContext.call("rollbarANE_init", accessToken, environment, includeLogcatOnAndroid);
			log("Rollbar succesfully initialized.");
			
			_isInitialized = true;
		}
		
		/**
		 * Registers the given person data as the current user for Rollbar reporting.
		 */
		public static function setPersonData(id:String, username:String, email:String):void {
			if(!isSupported)  
				return;
			
			RollbarAS.setPersonData(id, username, email);
			
			if(extensionContext) 
				extensionContext.call("rollbarANE_setPersonData", id, username, email);
			
			log("Person data set to [id:" + id + ", username:" + username + ", email:" + email + "].");
		}
		
		/**
		 * Reports the given error message to Rollbar. When native Rollbar SDK is available, native SDK is used, otherwise, the method falls
		 * back to using the AS3 SDK.
		 */
		public static function reportError(message:String, data:String = null):void {
			if(!isSupported) 
				RollbarAS.handleError(new Error(message), data);
			else 
				extensionContext.call("rollbarANE_reportError", message, data ? data.toString() : null);
			log("Error reported : " + message + " [data:" + data + "]");
		}
		
		/**
		 * Disposes the Native Extension context.
		 */
		public static function dispose():void {
			if(extensionContext) {
				log("Disposing context ...");
				extensionContext.removeEventListener(StatusEvent.STATUS, onStatusEvent);
				extensionContext.dispose();
				extensionContext = null;
				log("Context disposed.");
			}
			else
				log("Extension already disposed.");
		}
		
		
		/////////////////
		// PRIVATE API //
		/////////////////
		
		/**
		 * Handles all events the native code can throw.
		 */
		private static function onStatusEvent(ev:StatusEvent):void {
			if(ev.code == EVENT_LOG)
				log(ev.level);
			else
				log("Native event received : " + ev.code + "->" + ev.level + " (" + ev + ")");
		}
		
		/**
		 * Outputs the given message(s) using the provided logger function, or using trace.
		 */
		private static function log(message:String, ... additionnalMessages):void {
			if(logger == null) return;
			
			if(!additionnalMessages)
				additionnalMessages = [];
			
			logger((logPrefix && logPrefix.length > 0 ? logPrefix + " " : "") + message + " " + additionnalMessages.join(" "));
		}
	}
}