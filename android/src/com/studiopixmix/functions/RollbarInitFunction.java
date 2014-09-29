package com.studiopixmix.functions;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.rollbar.android.Rollbar;
import com.studiopixmix.RollbarExtension;

public class RollbarInitFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		try {
			Rollbar.init((Context)(context.getActivity()), args[0].getAsString(), args[1].getAsString());
		} catch (Exception e) {
			RollbarExtension.log("Error initializing Rollbar : " + e);
			return null;
		}
		return null;
	}

}
