global class LimitsUtil {
    // pass the percentage that you want to test against, and this function will test it
    global static Boolean reachedPercentCPU(Decimal percent) {
        return percentOfCPUUsed() >= percent;
    }
    // returns the percent of CPU used as a decimal percent (i.e. 0.01 = 1.0%)
    global static Decimal percentOfCPUUsed() {
        return percentOfTwoInts(Limits.getCpuTime(),Limits.getLimitCpuTime());
    }
    // returns the percent of CPU remaining as a decimal percent (i.e. 0.02 = 2.0%)
    global static Decimal percentOfCPURemaining() {
        return 1.0 - percentOfCPUUsed();
    }
    // returns the number of Queueable Jobs that can still be queued in the execution context
    global static Integer queueableJobsRemaining() {
        return Limits.getLimitQueueableJobs() - Limits.getQueueableJobs();
    }
    // returns the number of SOQL queries that can still be used in the execution context
    global static Integer soqlRemaining() {
        return Limits.getLimitQueries() - Limits.getQueries();
    }
    // returns the number of SOSL queries that can still be used in the execution context
    global static Integer soslRemaining() {
        return Limits.getLimitSoslQueries() - Limits.getSoslQueries();
    }
    // returns the number of HTTP requests that can still be used in the execution context
    global static Integer calloutsRemaining() {
        return Limits.getLimitCallouts() - Limits.getCallouts();
    }
    // returns the number of aggregate queries that can still be used in the execution context
    global static Integer aggregateQueriesRemaining() {
        return Limits.getLimitAggregateQueries() - Limits.getAggregateQueries();
    }
    // returns the number of query locator rows that can still be returned in the execution context
    global static Integer queryLocatorRowsRemaining() {
        return Limits.getLimitQueryLocatorRows() - Limits.getQueryLocatorRows();
    }
    // returns the number of rows that can still be DML'ed in the execution context
    global static Integer dmlRowsRemaining() {
        return Limits.getLimitAggregateQueries() - Limits.getAggregateQueries();
    }
    // returns the number of sendEmail calls that can still be used in the execution context
    global static Integer emailCallsRemaining() {
        return Limits.getLimitEmailInvocations() - Limits.getEmailInvocations();
    }
    // returns the percent of heap (memory) that has been used in the execution context
    global static Decimal percentOfHeapUsed() {
        return percentOfTwoInts(Limits.getHeapSize(), Limits.getLimitHeapSize());
    }
    // returns the percent of heap (memory) that can still be used in the execution context
    global static Decimal percentOfHeapRemaining() {
        return 1.0 - percentOfHeapUsed();
    }
    // returns the number of mobile push calls that can still be used in the execution context
    global static Integer mobilePushCallsRemaining() {
        return Limits.getLimitMobilePushApexCalls() - Limits.getMobilePushApexCalls();
    }
    // calculates the percent of two integers
    public static Decimal percentOfTwoInts(Integer numerator, Integer denominator) {
        Integer scaleValue = numerator >= denominator ? String.valueOf(numerator).replace('.','').length() : String.valueOf(denominator).replace('.','').length();
        return (((Decimal)numerator) / ((Decimal)denominator)).setScale(scaleValue);
    }
    // returns a string of all the limits
    global static String getLimitsString() {
        String separator = ' / ';
        Decimal percentOfCPUUsed = percentOfCPUUsed() * 100;
        percentOfCPUUsed = percentOfCPUUsed.setScale(percentOfCPUUsed.precision() - (percentOfCPUUsed >= 1 ? 4 : 2));
        Decimal percentOfHeapUsed = percentOfHeapUsed() * 100;
        percentOfHeapUsed = percentOfHeapUsed.setScale(percentOfHeapUsed.precision() - (percentOfHeapUsed >= 1 ? 4 : 2));
        List<String> rows = new List<String>{
            'Queries: ' + Limits.getQueries() + separator + Limits.getLimitQueries(),
            'CpuTime: ' + Limits.getCpuTime() + separator + Limits.getLimitCpuTime() + ' (' + percentOfCPUUsed + '%)',
            'HeapSize: ' + Limits.getHeapSize() + separator + Limits.getLimitHeapSize() + ' (' + percentOfHeapUsed + '%)',
            'Callouts: ' + Limits.getCallouts() + separator + Limits.getLimitCallouts(),
            'DMLRows: ' + Limits.getDMLRows() + separator + Limits.getLimitDMLRows(),
            'DMLStatements: ' + Limits.getDMLStatements() + separator + Limits.getLimitDMLStatements(),
            'QueryRows: ' + Limits.getQueryRows() + separator + Limits.getLimitQueryRows(),
            'QueryLocatorRows: ' + Limits.getQueryLocatorRows() + separator + Limits.getLimitQueryLocatorRows(),
            'SoslQueries: ' + Limits.getSoslQueries() + separator + Limits.getLimitSoslQueries(),
            'AggregateQueries: ' + Limits.getAggregateQueries() + separator + Limits.getLimitAggregateQueries(),
            'FutureCalls: ' + Limits.getFutureCalls() + separator + Limits.getLimitFutureCalls(),
            'QueueableJobs: ' + Limits.getQueueableJobs() + separator + Limits.getLimitQueueableJobs(),
            'MobilePushApexCalls: ' + Limits.getMobilePushApexCalls() + separator + Limits.getLimitMobilePushApexCalls(),
            'EmailInvocations: ' + Limits.getEmailInvocations() + separator + Limits.getLimitEmailInvocations()
        };
        return 'EXECUTION CONTEXT LIMITS\n' + String.join(rows,'\n');
    }
    // prints a list of all the limits in the debug log
    global static void printLimitsString() {
        DebugLog.debug(getLimitsString());
    }
    /*
        // available calls
        Limits.getAggregateQueries()
        Limits.getLimitAggregateQueries()
        Limits.getCallouts()
        Limits.getLimitCallouts()
        Limits.getCpuTime()
        Limits.getLimitCpuTime()
        Limits.getDMLRows()
        Limits.getLimitDMLRows()
        Limits.getDMLStatements()
        Limits.getLimitDMLStatements()
        Limits.getEmailInvocations()
        Limits.getLimitEmailInvocations()
        Limits.getFutureCalls()
        Limits.getLimitFutureCalls()
        Limits.getHeapSize()
        Limits.getLimitHeapSize()
        Limits.getMobilePushApexCalls()
        Limits.getLimitMobilePushApexCalls()
        Limits.getQueries()
        Limits.getLimitQueries()
        Limits.getQueryLocatorRows()
        Limits.getLimitQueryLocatorRows()
        Limits.getQueryRows()
        Limits.getLimitQueryRows()
        Limits.getQueueableJobs()
        Limits.getLimitQueueableJobs()
        Limits.getSoslQueries()
        Limits.getLimitSoslQueries()

        // depricated calls
        Limits.getPicklistDescribes()
        Limits.getLimitPicklistDescribes()
        Limits.getRunAs()
        Limits.getLimitRunAs()
        Limits.getSavepoints()
        Limits.getLimitSavepoints()
        Limits.getRecordTypesDescribes()
        Limits.getLimitRecordTypesDescribes()
        Limits.getSavepointRollbacks()
        Limits.getLimitSavepointRollbacks()
        Limits.getScriptStatements()
        Limits.getLimitScriptStatements()
        Limits.getFieldsDescribes()
        Limits.getLimitFieldsDescribes()
        Limits.getFieldSetsDescribes()
        Limits.getLimitFieldSetsDescribes()
        Limits.getChildRelationshipsDescribes()
        Limits.getLimitChildRelationshipsDescribes()
        Limits.getFindSimilarCalls()
        Limits.getLimitFindSimilarCalls()
    */
}