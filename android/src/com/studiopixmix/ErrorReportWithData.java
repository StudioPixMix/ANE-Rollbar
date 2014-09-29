package com.studiopixmix;

/**
 * An exception with a significant name for force-reporting error with data
 */
public class ErrorReportWithData extends Exception {
	private static final long serialVersionUID = 1L;

	public ErrorReportWithData(String message) {
		super(message);
	}
}
