package com.studiopixmix;
/**
 * An exception with a significant name for force-reporting error with data
 */
public class ErrorReport extends Exception {
	private static final long serialVersionUID = 1L;

	public ErrorReport(String message) {
		super(message);
	}

}
