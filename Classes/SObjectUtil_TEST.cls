@isTest
public class SObjectUtil_TEST {
	public static testmethod void simpleTest() {
		String sObjectName = 'Account';
		String fieldName = 'Industry';
		SObjectUtil.getObject(sObjectName);
		SObjectUtil.getPicklistSelectOptions(sObjectName, fieldName);
		SObjectUtil.getStringListOfPicklistValues(sObjectName, fieldName);
		SObjectUtil.getFieldList(sObjectName);
		Schema.DescribeFieldResult dfr = SObjectUtil.getField(sObjectName, fieldName);
		SObjectUtil.Field f = SObjectUtil.getFieldAnalysis(sObjectName, fieldName);
		f.isMasterDetail();
		f.isLookup();
		f.isRollupSummary();
		f.isFormulaField();
		f.isPicklist();
		f = new SObjectUtil.Field(dfr);
		f = new SObjectUtil.Field(SObjectUtil.getFieldMap(sObjectName).get(fieldName));
		SObjectUtil.getUsefulFields(sObjectName);
		SObjectUtil.getFieldsStr(sObjectName);
	}
}