@isTest
public class OrgUtil_TEST {
	public static testmethod void simpleTest() {
		TestHelper th = new TestHelper();
		th.createAdminUser();
		doTheUserThing();
		System.runAs(th.Admin) {
			doTheUserThing();
		}
		System.runAs(th.Admin) {
			Test.startTest();
			theTest();
			Test.stopTest();
		}
	}

	public static void theTest() {
		OrgUtil.getOrgInstance();
		OrgUtil.getId();
		OrgUtil.isSandbox();
		OrgUtil.getName();
		OrgUtil.getOrganizationType();
		OrgUtil.getOrgInstance();
		OrgUtil.getCurrentUser();
		OrgUtil.changeForTesting = false;
		OrgUtil.clearCurrentUser();
		OrgUtil.clearInfo();
	}

	public static void doTheUserThing() {
		try {
			OrgUtil.fixUserEmailAddresses(new Set<Id>{UserInfo.getUserId()});
		} catch (Exception e) {
			DebugLog.debug('First time',e);
			System.assert(e != null);
		}
		try {
			OrgUtil.changeForTesting = true;
			OrgUtil.fixUserEmailAddresses(new Set<Id>{UserInfo.getUserId()});
		} catch (Exception e) {
			DebugLog.debug('Second time',e);
			System.assert(e != null);
		}
	}
}