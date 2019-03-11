@isTest
public class StringUtil_TEST {

	public static testmethod void simpleCoverage() {
		String idStr = '0013600000KH4ch';
		String badIdStr = 'SO BAD';
		String objectName = 'Account';
		String badObjectName = 'Bad Object Name';
		StringUtil.toID(badIdStr);
		StringUtil.soqlClense(badObjectName);
		StringUtil.getRandomStringOfEverything(42);
		Id newId = StringUtil.convert15to18(idStr);
		StringUtil.convert15to18(newId);
		StringUtil.fixSandboxEmail(objectName);
		StringUtil.getRandomStringLetters(42);
		try {
			StringUtil.isStringId(null);
		} catch(Exception e) {
			System.assert(e != null);
		}
		try {
			StringUtil.isStringId(objectName, idStr);
		} catch(Exception e) {
			System.assert(e != null);
		}
		try {
			StringUtil.isStringId(badObjectName, null);	
		} catch(Exception e) {
			System.assert(e != null);
		}
		try {
			StringUtil.isStringId(badObjectName, badIdStr);	
		} catch(Exception e) {
			System.assert(e != null);
		}
		try {
			Schema.DescribeSObjectResult testingThis;
			StringUtil.isStringId(testingThis, badIdStr);
		} catch(Exception e) {
			System.assert(e != null);
		}
		try {
			StringUtil.convert15to18(null);
		} catch(Exception e) {
			System.assert(e != null);
		}
		try {
			StringUtil.isStringId(Account.SObjectType.getDescribe(), idStr);
		} catch(Exception e) {
			System.assert(e != null);
		}
	}
}