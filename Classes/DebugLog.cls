global class DebugLog {

	// allows for 100% test coverage
	public static Boolean switchForTest = false;

	// makes the process builder clep more elegant
	@InvocableMethod
    public static void processBuilderOff() {
        DebugLog.debug('Process Builder Processes Are Turned Off');
    }

    // TODO: make this part of a custom setting or a group of users
	global static List<String> devEmailAddresses = new List<String>{'peter.oconnell@salesforce.com'};

	// makes this class exceptional
	global class DebugLogException extends Exception {}

	/*  
	options for logging levels:
		LoggingLevel.NONE
		LoggingLevel.ERROR
		LoggingLevel.WARN
		LoggingLevel.INFO
		LoggingLevel.DEBUG
		LoggingLevel.FINE
		LoggingLevel.FINER
		LoggingLevel.FINEST 
	*/

	// this can be changed; however, there may not be a need
	global static LoggingLevel x_loggingLevel = LoggingLevel.DEBUG;

	// a standard log to facilitate logging between classes
	// because it's ok to be a lumberjack
	private static DebugLog x_StaticLog;
	global static DebugLog StaticLog() {
		if(x_StaticLog == null) x_StaticLog = new DebugLog();
		return x_StaticLog;
	}

	// strings used as templates
	global static String bottomBorder = '\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
	global static String topBorder = bottomBorder+'\n';
	global static String exceptionStr = 'MESSAGE: {2}\nSTACK TRACE:\n{3}';
	global static String classMethodExceptionStr = '~~~~~~~~~{0}.{1}~~~~~~~~~\nMESSAGE: {2}\nSTACK TRACE:\n{3}';
	global static String classMethodMessageStr = '~~~~~~~~~{0}.{1}~~~~~~~~~\nMESSAGE: {2}';
	global static String msgExceptionStr = '{0}\nMESSAGE:\n{1}\nSTACK TRACE:\n{2}';
	global static String emailSubjectStr = 'Debug Email - {0} - {1} - {2}';
	global static String emailBodyStr = 'To whom it may concern,\n\nOrgInfo:\n{0}\n\nUserInfo:\n{1}\n\n{2}\n\n\nSincerely,\n\nDebugLog :)';

	// formats the standard debug
	global static void debug(Exception e) {
		String debugMsg = makeDebugMsg(e);
		debug(debugMsg);
	}

	// formats the standard debug
	global static void debug(String msg, Exception e) {
		String debugMsg = makeDebugMsg(msg, e);
		debug(debugMsg);
	}

	// formats the standard debug
	global static void debug(String className, String methodName, Exception e) {
		String debugMsg = makeDebugMsg(className, methodName, e);
		debug(debugMsg);
	}

	// formats the standard debug
	global static void debug(String className, String methodName, String msg) {
		String debugMsg = makeDebugMsg(className, methodName, msg);
		debug(debugMsg);
	}

	// formats the standard debug
	global static void debug(String msg) {
		System.debug(
			x_loggingLevel,
			makePrintMsg(msg)
		);
	}

	// an instance array of debug messages
	global List<String> Msgs {get{
		if(Msgs == null) Msgs = new List<String>();
		return Msgs;
	}set;}

	// constructor!!! I FOUND IT!!!
	global DebugLog() {}

	// instance method to add a debug message
	global DebugLog addDebug(String msg) {
		Msgs.add(msg);
		return this;
	}

	// this method is overloaded, if I do say so myself
	global DebugLog addDebug(Exception e) {
		String debugMsg = makeDebugMsg(e);
		Msgs.add(debugMsg);
		return this;
	}

	// I wonder if it can handle the pressure...
	global DebugLog addDebug(String msg,Exception e) {
		String debugMsg = makeDebugMsg(msg,e);
		Msgs.add(debugMsg);
		return this;
	}

	// Looks like it's doing just fine
	global DebugLog addDebug(String className, String methodName, Exception e) {
		String debugMsg = makeDebugMsg(className,methodName,e);
		Msgs.add(debugMsg);
		return this;
	}

	// IT MADE IT!!!
	global DebugLog addDebug(String className, String methodName, String msg) {
		String debugMsg = makeDebugMsg(className,methodName,msg);
		Msgs.add(debugMsg);
		return this;
	}

	// add printout of execution context limits
	global DebugLog addLimits() {
		addDebug(LimitsUtil.getLimitsString());
		return this;
	}

	// add printout of execution context limits (with a message)
	global DebugLog addLimits(String msg) {
		addDebug(msg + '\n' + LimitsUtil.getLimitsString());
		return this;
	}

	// print the debug log to the... debug log
	global DebugLog print() {
		return print(true);
	}

	// print the debug log to the debug log with the option of clearing the messages afterwards
	global DebugLog print(Boolean clearMsgsAfterPrint) {
		String fullDebugStr = makePrintMsg(getFullDebug());
		System.debug(
			x_loggingLevel, 
			fullDebugStr
		);
		if(clearMsgsAfterPrint) Msgs = new List<String>();
		return this;
	}

	// email the debug log to the developers
	global DebugLog email() {
		try {
			Messaging.reserveSingleEmailCapacity(devEmailAddresses.size());
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			email.setToAddresses(devEmailAddresses);
			email.setSubject(getEmailSubject());
			email.setPlainTextBody(getEmailBody());
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
			if(Test.isRunningTest() && switchForTest) {
				throw new DebugLogException('SINGLE_EMAIL_LIMIT_EXCEEDED');
			}
		} catch(Exception e) {
			addDebug('DebugLog','email()',e);
			save();
		}
		return this;
	}

	// save the debug log to a custom object
	global DebugLog save() {
		return save(false,false);
	}

	// save the debug log to a custom object optionally include the
	// organization information and the current user information
	global DebugLog save(Boolean orgInfo, Boolean userInfo) {
		String logBody = getFullDebug();
		if(orgInfo) logBody = getOrgInfo() + '\n\n' + logBody;
		if(userInfo) logBody = getUserInfo() + '\n\n' + logBody;
		if(logBody.length() > DebugLog__c.Log__c.getDescribe().getLength()) {
			// the beginning of the log is often times not as important as the end.
			logBody = logBody.subString(
				logBody.length() - DebugLog__c.Log__c.getDescribe().getLength(), 
				logBody.length()
			);
		}
		insert new DebugLog__c(Log__c = logBody);
		return this;
	}

	// this was used in a lot of the methods, so we made it its own method
	// I'm so proud...
	public String getFullDebug() {
		return String.join(Msgs,'\n\n');
	}

	// get the email subject
	private String getEmailSubject() {
		return getOrgInfo().replace('\n',' - ');
	}

	// get the email body
	private String getEmailBody() {
		return String.format(
			emailBodyStr,
			new List<String>{
				getOrgInfo(),
				getUserInfo(),
				makePrintMsg(getFullDebug())
			}
		);
	}

	// get the organization inforation block
	private String getOrgInfo() {
		String orgInfoStr = 'Id: {0}\nName: {1} ({2})\nType: {3}';
		List<String> orgInfoList = new List<String>{
			OrgUtil.getId(),
			OrgUtil.getName(),
			(OrgUtil.isSandbox() ? 'Sandbox' : 'Production'),
			OrgUtil.getOrganizationType()
		};
		String finalOrgInfoStr = String.format(orgInfoStr, orgInfoList);
		return finalOrgInfoStr;
	}

	// get the current user information block
	private String getUserInfo() {
		String userInfoStr = 'Id: {0}\nName: {1}\nUsername: {2}\nEmail: {3}\nType: {4}\nProfileId: {5}\nUI Theme: {6}\nTimeZone: {7}';
		List<String> userInfoList = new List<String>{
			UserInfo.getUserId(),
			UserInfo.getFirstName() + ' ' + UserInfo.getLastName(),
			UserInfo.getUserName(),
			UserInfo.getUserEmail(),
			UserInfo.getUserType(),
			UserInfo.getProfileId(),
			UserInfo.getUiThemeDisplayed(),
			UserInfo.getTimeZone()+''
		};
		String finalUserInfoStr = String.format(userInfoStr, userInfoList);
		return finalUserInfoStr;
	}

	// this is another overloaded message... this generation... the worst...
	global static String makePrintMsg(String debugStr) {
		return topBorder + debugStr + bottomBorder;
	}

	// they think their so exceptional...
	global static String makeDebugMsg(Exception e) {
		return String.format(
			exceptionStr,
			new List<String>{
				e.getMessage(),
				e.getStackTraceString()
			}
		);
	}

	// or at least they like to add a message to their exceptions
	global static String makeDebugMsg(String msg, Exception e) {
		return String.format(
			msgExceptionStr,
			new List<String>{
				msg,
				e.getMessage(),
				e.getStackTraceString()
			}
		);
	}

	// or maybe comment on the class and method they're using along with an exception... seriously...
	global static String makeDebugMsg(String className, String methodName, Exception e) {
		return String.format(
			classMethodExceptionStr,
			new List<String>{
				className,
				methodName,
				e.getMessage(),
				e.getStackTraceString()
			}
		);
	}

	// or maybe comment on the class and method they're using along with a message
	global static String makeDebugMsg(String className, String methodName, String msg) {
		return String.format(
			classMethodMessageStr,
			new List<String>{
				className,
				methodName,
				msg
			}
		);
	}
}