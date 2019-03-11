public with sharing class Account_TH extends TriggerBase {

	private static DebugLog log;
	public static DebugLog getLog() {
		if(log == null) log = new DebugLog();
		return log;
	}

	public Account_TH() {
		if(TriggerFactory.debugOn) {
			getLog().addDebug(
				'Entered the "' + 
				(Trigger.isBefore ? 'before' : 'after') + ' ' + 
				(Trigger.isInsert ? 'insert' : '') + 
				(Trigger.isUpdate ? 'update' : '') + 
				(Trigger.isDelete ? 'delete' : '') + 
				(Trigger.isUndelete ? 'undelete' : '') +
				'" Account_TH with ' + 
				Trigger.new.size() + ' records'
			);
		}
	}

	public override void beforeInsert() {
		if(TriggerFactory.debugOn) getLog().addDebug('Hit Account_TH beforeInsert');
		needAddresses();
	}

	public override void afterInsert() {
		if(TriggerFactory.debugOn) getLog().addDebug('Hit Account_TH afterInsert');
		// Create Contacts
		bulkUpserts.addAll((List<SObject>)DataCreationUtil.createContacts((List<Account>)Trigger.new,null,10));
		// Create Opportunities
		bulkUpserts.addAll((List<SObject>)DataCreationUtil.createOpportunities((List<Account>)Trigger.new,null,10));

		if(TriggerFactory.debugOn) getLog().save();
		if(TriggerFactory.debugOn) getLog().email();
	}

	public override void beforeUpdate() {
		if(TriggerFactory.debugOn) getLog().addDebug('Hit Account_TH beforeUpdate');
		needAddresses();
	}

	public override void afterUpdate() {
		if(TriggerFactory.debugOn) getLog().addDebug('Hit Account_TH afterUpdate');
		List<Account> createCons = new List<Account>();
		List<Account> createOpps = new List<Account>();

		for(Account acc:[
			SELECT 	Id, Name, (
				SELECT 	Id 
				FROM 	Opportunities
			), (
				SELECT 	Id 
				FROM 	Contacts
			) 
			FROM 	Account 
			WHERE 	Id IN:Trigger.newMap.keySet()
		]) {
			if(acc.Opportunities == null || acc.Opportunities.isEmpty()) {
				createCons.add(acc);
			}
			if(acc.Contacts == null || acc.Contacts.isEmpty()) {
				createOpps.add(acc);
			}
		}

		if(createCons != null && !createCons.isEmpty()) {
			bulkUpserts.addAll((List<SObject>)DataCreationUtil.createContacts(createCons,null,10));
		}

		if(createOpps != null && !createOpps.isEmpty()) {
			bulkUpserts.addAll((List<SObject>)DataCreationUtil.createOpportunities(createOpps,null,10));
		}
		if(TriggerFactory.debugOn) getLog().print(false);
		if(TriggerFactory.debugOn) getLog().email();
	}

	public void needAddresses() {
		List<String> addressFields = new List<String>{
			'BillingStreet','BillingCity','BillingState','BillingCountry','BillingPostalCode'
		};
		Account tempAcc;
		for(Account acc:(List<Account>)Trigger.new) {
			Boolean makeAddress = false;
			// check if you have to make and address
			for(String addressField:addressFields) {
				if(String.isBlank((String)acc.get(addressField))) {
					makeAddress = true;
					break;
				}
			}
			// if you do...
			if(makeAddress) {
				// make a temp address
				tempAcc = DataCreationUtil.createRandomAccount();
				// write the new fields
				for(String addressField:addressFields) {
					acc.put(addressField,(String)tempAcc.get(addressField));
				}
				tempAcc = null;
			}
		}
	}
}