@isTest
public class TriggerBase_TEST {
	public static testmethod void simpleTest() {
		TestHelper th = new TestHelper();
		th.runSetup();
		System.runAs(th.Admin) {
			Test.startTest();
			TriggerBase tb = new TriggerBase();
			tb.setupBefore();
			tb.beforeInsert();
			tb.beforeUpdate();
			tb.beforeDelete();
			tb.setupAfter();
			tb.afterInsert();
			tb.afterUpdate();
			tb.afterDelete();
			tb.afterUndelete();
			tb.andFinally();
			List<Account> accs = DataCreationUtil.createAccounts(2);
			tb.bulkUpserts.addAll((List<SObject>)accs);
			tb.bulkDML();
			tb.bulkDML();
			tb.bulkDeletes.addAll(tb.bulkUpserts);
			tb.bulkDML();
			Test.stopTest();
		}
	}
}