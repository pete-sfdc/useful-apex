@isTest
public class LimitsUtil_TEST {
	public static testmethod void simpleTest() {
		LimitsUtil.reachedPercentCPU(0.5);
		LimitsUtil.percentOfCPUUsed();
		LimitsUtil.percentOfCPURemaining();
		LimitsUtil.soqlRemaining();
		LimitsUtil.queueableJobsRemaining();
		LimitsUtil.soslRemaining() ;
		LimitsUtil.calloutsRemaining();
		LimitsUtil.aggregateQueriesRemaining();
		LimitsUtil.queryLocatorRowsRemaining();
		LimitsUtil.dmlRowsRemaining();
		LimitsUtil.emailCallsRemaining();
		LimitsUtil.percentOfHeapRemaining();
		LimitsUtil.mobilePushCallsRemaining();
		LimitsUtil.getLimitsString();
	}
}