package com.studiopixmix.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.rollbar.android.Rollbar;
import com.studiopixmix.RollbarExtension;

public class RollbarInitFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		try {
			String token = args[0].getAsString();
			String env = args[1].getAsString();
			
			RollbarExtension.log("Initializing Rollbar with token \"" + token + "\" (environment : " + env + ") ...");
			Rollbar.init(context.getActivity(), token, env);
			RollbarExtension.log("Rollbar initialized succesfully ? " + Rollbar.isInit());
		}
		catch (Exception e) {
			RollbarExtension.log("Error initializing Rollbar : " + e);
		}
		
		return null;
	}

}
