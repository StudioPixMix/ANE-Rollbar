package com.studiopixmix.functions;

import java.io.PrintWriter;
import java.io.StringWriter;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.studiopixmix.RollbarExtension;
import com.rollbar.android.Rollbar;

public class RollbarInitFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		try {
			Rollbar.init((Context)(context.getActivity()), args[0].getAsString(), args[1].getAsString());
		} catch (Exception e) {
			return null;
		}
		return null;
	}

}
