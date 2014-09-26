#import <Foundation/Foundation.h>
#import <Rollbar/Rollbar.h>
#import <Rollbar/RollbarConfiguration.h>

#import "FlashRuntimeExtensions.h"

FREContext extCtx = nil;

/**
 * Macros used to ease the process.
 */
#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

/**
 * Logs the given message in the native log and dispatches the Event.Log event on the AS3-side.
 */
void logAndDispatch(NSString* tag, NSString* message) {
    NSString* completeMessage = [NSString stringWithFormat:@"[%@] %@", tag, message];
    
    NSLog(@"%@", completeMessage);
    
    FREDispatchStatusEventAsync(extCtx, (uint8_t*) "Event.Log", (uint8_t*) [completeMessage UTF8String]);
}

FREResult FREGetObject(FREObject object, NSString** value) {
	FREResult result;
	uint32_t length = 0;
	const uint8_t* tempValue = NULL;

	result = FREGetObjectAsUTF8( object, &length, &tempValue );
	if( result != FRE_OK ) return result;

	*value = [NSString stringWithUTF8String: (char*) tempValue];
	return FRE_OK;
}

// PUBLIC METHODS

DEFINE_ANE_FUNCTION(rollbarANE_init) {
    logAndDispatch(@"rollbarANE_init", @"Entering...");

    FREResult result;
	NSString* accessToken;
	NSString* configEnvironment;

	if ((result = FREGetObject(argv[0], &accessToken)) != FRE_OK)
		return (FREObject)result;
	if ((result = FREGetObject(argv[1], &configEnvironment)) != FRE_OK)
		return (FREObject)result;

	RollbarConfiguration *config = [RollbarConfiguration configuration];
	config.environment = configEnvironment;

    [Rollbar initWithAccessToken:accessToken configuration:config];
    return FRE_OK;
}

// CONTEXT & EXTENSION INITIALIZER/FINALIZER

/**
 * Method called by the initializer when initializing the ANE.
 * Registers the links between AS3 method and Obj-C methods.
 */
void RollbarExtensionContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    logAndDispatch(@"RollbarExtensionContextInitializer", @"Declaring functions...");
    
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION(rollbarANE_init, NULL)
    };
    
	*numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
	*functionsToSet = functionMap;
    
    extCtx = ctx;
    
    logAndDispatch(@"RollbarExtensionContextInitializer", @"Functions declared.");
}

void RollbarExtensionContextFinalizer(FREContext ctx) {
    logAndDispatch(@"RollbarExtensionContextFinalizer", @"Context disposed.");
    return;
}

/**
 * Method called when initializing the extension context.
 * The name of this method must match the initializer node in the iPhone-ARM platform of the extension.xml file.
 */
void RollbarExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    logAndDispatch(@"RollbarExtensionInitializer", @"Initializing extension...");
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &RollbarExtensionContextInitializer;
    *ctxFinalizerToSet = &RollbarExtensionContextFinalizer;
    
    logAndDispatch(@"RollbarExtensionInitializer", @"Extension initialized.");
}
