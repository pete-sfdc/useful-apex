/*
	This virtual class enforces trigger behaviors 
	and makes sure code code executes in the prescribed context

	I used a virtual class so a developer would only have to override
		trigger context methods that they needed
*/
global virtual class TriggerBase {

	/*
		Two collections for bulk DMLs
			Creates a system where DMLs can be bulkified
			automatically if their result isn't necessary within
			one of the trigger methods
	*/

	global List<SObject> bulkUpserts {get{
		if(bulkUpserts == null) bulkUpserts = new List<SObject>();
		return bulkUpserts;
	}set;}

	global List<SObject> bulkDeletes {get{
		if(bulkDeletes == null) bulkDeletes = new List<SObject>();
		return bulkDeletes;
	}set;}

	global TriggerBase() {}

	// OVERRIDE THESE METHODS IN YOUR TRIGGER HANDLER
	global virtual void setupBefore(){
		if(TriggerFactory.debugOn) System.debug('Hit setupBefore');
	}
	global virtual void beforeInsert(){
		if(TriggerFactory.debugOn) System.debug('Hit beforeInsert');
	}
	global virtual void beforeUpdate(){
		if(TriggerFactory.debugOn) System.debug('Hit beforeUpdate');
	}
	global virtual void beforeDelete(){
		if(TriggerFactory.debugOn) System.debug('Hit beforeDelete');
	}
	global virtual void setupAfter(){
		if(TriggerFactory.debugOn) System.debug('Hit setupAfter');
	}
	global virtual void afterInsert(){
		if(TriggerFactory.debugOn) System.debug('Hit afterInsert');
	}
	global virtual void afterUpdate(){
		if(TriggerFactory.debugOn) System.debug('Hit afterUpdate');
	}
	global virtual void afterDelete(){
		if(TriggerFactory.debugOn) System.debug('Hit afterDelete');
	}
	global virtual void afterUndelete(){
		if(TriggerFactory.debugOn) System.debug('Hit afterUndelete');
	}
	global virtual void andFinally() {
		if(TriggerFactory.debugOn) System.debug('Hit andFinally');
	}
	// _______________________________________________

	/*
		Logic for bulk DML
	*/
	global void bulkDML() {
		if(TriggerFactory.debugOn) System.debug('Hit bulkDML');
		// generic lists only support insert, update, and delete
		// so we have to split this list into the correct DML calls
		if(!bulkUpserts.isEmpty()) {
			List<SObject> listI = new List<SObject>();
			List<SObject> listU = new List<SObject>();
			for(SObject bulkUpsert:bulkUpserts) {
				// if a record has no an Id, then it should be inserted
				if(bulkUpsert.get('Id') == null) {
					listI.add(bulkUpsert);
				} else { // if the record has an Id, then update it
					listU.add(bulkUpsert);
				}
			}

			// insert if insert list is not empty
			if(!listI.isEmpty()) insert listI;
			// update if update list is not empty
			if(!listU.isEmpty()) update listU;
		}

		// delete if delete list is not empty
		if(!bulkDeletes.isEmpty()) delete bulkDeletes;
	}
}