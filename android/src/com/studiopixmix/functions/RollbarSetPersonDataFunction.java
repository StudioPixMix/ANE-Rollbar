package com.studiopixmix.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.rollbar.android.Rollbar;
import com.studiopixmix.RollbarExtension;

public class RollbarSetPersonDataFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		try {
			String id = args[0].getAsString();
			String username = args[1].getAsString();
			String email = args[2].getAsString();
			
			RollbarExtension.log("Setting people data to [id:" + id + ", username:" + username + ", email:" + email + "] ...");
			Rollbar.setPersonData(id, username, email);
			RollbarExtension.log("People data set successfully.");
		}
		catch(Exception e) {
			RollbarExtension.log("Error when setting people data : " + e);
		}
		
		return null;
	}

}
