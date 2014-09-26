package com.studiopixmix {
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
		/** The Native Extension context. */
		private static var extensionContext:ExtensionContext;
		
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
		
		
		// CONSTRUCTOR :
		public function Rollbar() {
		}
		
		
		////////////////
		// PUBLIC API //
		////////////////
		
		/**
		 * Asks the Native Extension to return the result of the addition of both int given.
		 */
		public static function init(accessToken:String, environment:String):void {
			if (!isSupported) {
				log("Platform is not supported, aborting...");
				return;
			}
		
			log("Creating context ...");
			extensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
			if(extensionContext != null)
				extensionContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
			else {
				log("Failed to create context ! Aborting...");
				return;
			}
			log("Context : " + extensionContext);

			log("Initializing Rollbar...");
			extensionContext.call("rollbarANE_init", accessToken, environment);
			
			return;
		}
		
		/**
		 * Disposes the Native Extension context.
		 */
		public function dispose():void {
			log("Disposing context ...");
			extensionContext.dispose();
			extensionContext = null;
			log("Context disposed.");
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
		 * Logs the given message.
		 */
		private static function log(message:String):void {
			trace("[Rollbar] " + message);
		}
	}
}