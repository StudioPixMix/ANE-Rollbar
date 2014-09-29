package com.studiopixmix.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.rollbar.android.Rollbar;
import com.studiopixmix.RollbarExtension;

public class RollbarReportErrorFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		try {
			String message = args[0].getAsString();
			String data = args[1].getAsString();
			
			if(data != null && data.length() > 0) {
				RollbarExtension.log("Reporting error : " + message + " [data: " + data + "]...");
				Rollbar.reportException(new Exception(message), "critical", data);
			}
			else {
				RollbarExtension.log("Reporting error : " + message + " ...");
				Rollbar.reportException(new Exception(message), "critical");
			}
			RollbarExtension.log("Error reported successfully.");
		}
		catch(Exception e) {
			RollbarExtension.log("Error when reporting error : " + e);
		}
		
		return null;
	}

}
