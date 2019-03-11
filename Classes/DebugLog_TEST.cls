@isTest
public class DebugLog_TEST {

	public class DebugLog_TESTException extends Exception {}

	public static testmethod void simpleTest() {

		TestHelper th = new TestHelper();
		th.runSetup();

		System.runAs(th.Admin) {
			Test.startTest();
			String testStr = 'testing testing testing';
			try {
				throw new DebugLog_TESTException('Exceptional');
			} catch(Exception e) {
				DebugLog.debug(e);
				DebugLog.debug(testStr,e);
				DebugLog.debug('DebugLog_TEST','simpleTest()',e);

				DebugLog.StaticLog().addDebug(e);
				DebugLog.StaticLog().addDebug(testStr,e);
				DebugLog.StaticLog().addDebug('DebugLog_TEST','simpleTest()',e);
			}
			DebugLog.debug('DebugLog_TEST','simpleTest()',testStr);
			DebugLog.StaticLog().addDebug('DebugLog_TEST','simpleTest()',testStr);
			DebugLog.StaticLog().addDebug(testStr);
			DebugLog.processBuilderOff();
			DebugLog.debug(testStr);
			DebugLog.StaticLog().addLimits(testStr);
			DebugLog.StaticLog().addLimits();
			DebugLog.StaticLog().print(false);
			DebugLog.StaticLog().email();
			DebugLog.switchForTest = true;
			DebugLog.StaticLog().email();
			DebugLog.switchForTest = false;
			DebugLog.StaticLog().save(true,true);
			DebugLog.StaticLog().save();
			DebugLog.StaticLog().print();
			
			// grab the length of the Log__c field on DebugLog__c object
			Integer lengthMax = DebugLog__c.Log__c.getDescribe().getLength();
			// create a string that is too big
			String bigStr = 'a'.repeat(lengthMax + 1);
			
			DebugLog.StaticLog().addDebug(bigStr);
			DebugLog.StaticLog().save();
			Test.stopTest();
		}
	}
}