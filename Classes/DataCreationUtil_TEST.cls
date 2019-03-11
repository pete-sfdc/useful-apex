@isTest
public class DataCreationUtil_TEST {
	public static testmethod void simpleTest() {
		TestHelper th = new TestHelper();
		th.createAdminUser();
		System.runAs(th.Admin) {
			Test.startTest();
			List<Account> accs = DataCreationUtil.createAccounts(10);
			DataCreationUtil.createContacts(accs, 2, null);
			DataCreationUtil.createContacts(accs, null, 2);
			DataCreationUtil.createOpportunities(accs, 2, null);
			DataCreationUtil.createOpportunities(accs, null, 2);
			Test.stopTest();
		}
	}
}