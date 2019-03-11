/*
	HOW TO MAKE A TRIGGER HANDLER THAT USES TriggerFactory:

		TriggerHandler classes must follow the naming convention: <SObjectName>_TH (i.e. "Account_TH")

		Custom objects will not have the "__c" ending
			A TriggerHandler for "Custom_Object__c" would be "Custom_Object_TH"

		The underscores in a namespace are reduced to 1 underscore
			A TriggerHandler for "something__Weird_Object__c" would be "something_Weird_Object_TH"

		If the name gets to be too long for a handler name the code will truncate the beginning 
		and remove erroneous starting characters
			A TriggerHandler for "wow__This_Is_A_Little_Out_Of_Control_Michelle__c" would be "s_Is_A_Little_Out_Of_Control_Michelle_TH"
*/

public class TriggerFactory {

	public class TriggerFactoryException extends Exception {}

	public static Boolean switchForTest = false;

	// collection used in the trigger switch
	public static Set<Schema.SObjectType> turnedOffObjects;

	private static OrgAdminSettings__c x_OrgAdminSettings;
	public static OrgAdminSettings__c Settings() {
		if(x_OrgAdminSettings == null) x_OrgAdminSettings = OrgAdminSettings__c.getInstance();
		return x_OrgAdminSettings;
	}

	// turning off debugging can speed up code execution
	public static Boolean debugOn = Settings().DebugOn__c;
	// Trigger Switch works in conjunction with a custom setting called Trigger_Switch__c
	// which allows you to turn off triggers for certain SObjects
	public static Boolean triggerSwitchOn = Settings().TriggerSwitchOn__c;
	// Master Switch to turn off ALL triggers
	public static Boolean allTriggersTurnedOff = Settings().TurnAllTriggersOff__c;
	// Master Switch to turn off ALL before triggers
	public static Boolean beforeTriggersOn = Settings().BeforeTriggersOn__c;
	// Master Switch to turn off ALL after triggers
	public static Boolean afterTriggersOn = Settings().AfterTriggersOn__c;
	// Master Switch to turn off ALL insert triggers
	public static Boolean insertTriggersOn = Settings().InsertTriggersOn__c;
	// Master Switch to turn off ALL update triggers
	public static Boolean updateTriggersOn = Settings().UpdateTriggersOn__c;
	// Master Switch to turn off ALL delete triggers
	public static Boolean deleteTriggersOn = Settings().DeleteTriggersOn__c;
	// Master Switch to turn off ALL undelete triggers
	public static Boolean undeleteTriggersOn = Settings().UndeleteTriggersOn__c;

	// this is the logic that uses Trigger_Switch__c custom setting records to 
	// turn off triggers for certain SObjects
	public static Set<Schema.SObjectType> getTurnedOffObjects() {
		// if the static variable is null
		if(turnedOffObjects == null) {
			// initialize a new set
			turnedOffObjects = new Set<Schema.SObjectType>();
			// pulled out of loop to reduce heap
			Schema.SObjectType tempSObjectType;
			// loop through Trigger_Switch__c records
			for(Trigger_Switch__c ts:Trigger_Switch__c.getall().values()) {
				// if Object triggers are disabled, 
				if(!ts.Enabled__c) {
					// convert String to SObjectType
					tempSObjectType = Schema.getGlobalDescribe().get(ts.Name);
					// if the String represents a real SObject
					if(tempSObjectType != null) {
						// add to list of objects who's triggers are turned off
						turnedOffObjects.add(tempSObjectType);
					}
				}
			}
		}
		return turnedOffObjects;
	}

	// THIS IS THE ENTRY POINT
	public static void initialize(Schema.SObjectType sType) {
		if(allTriggersTurnedOff) { // if triggers are turned off do not run triggers
			if(debugOn) System.debug('Did Not Run ' + sType.getDescribe().getName() + ' Triggers because ALL triggers are turned off');
			return;
		} else if(triggerSwitchOn && getTurnedOffObjects().contains(sType)) { // trigger switch is on AND object is turned off, don't run triggers
			if(debugOn) System.debug('Did Not Run ' + sType.getDescribe().getName() + ' Triggers because this object was turned off');
			return;
		} else {
			// create instance of trigger handler for SOBJECT
			TriggerBase handler = getHandler(sType);
			// if a trigger handler was found
			if(handler != null) { 
				// run the trigger handler
				execute(handler);
			} else {
				// if no trigger handler is found, write debug
				if(debugOn) System.debug(
					'There is no handler for ' + 
					sType.getDescribe().getLabel() + 
					' (' + sType.getDescribe().getName() + ')' + 
					'. If there should be, please check that your handler '+
					'follows the naming convention and that it extends TriggerBase.'
				);
			}
		}
	}


	private static String triggerHandlerSuffix = '_TH';

	private static TriggerBase getHandler(Schema.SObjectType sType) {
		TriggerBase handlerClass;
		try {
			// this is where the conversion from SObject name to 
			// trigger handler class name happens
			String className = sType.getDescribe().getName();
			// call method to convert the object name to handler class name
			className = convertObjectNameToHandlerName(className);
			// create an instance of the trigger handler class
			handlerClass = (TriggerBase)Type.forName(className).newInstance(); // magic

			// for complete test coverage -------------------------------------
			if(switchForTest) throw new TriggerFactoryException('BREAK STUFF');
			// ________________________________________________________________
		} catch(Exception e) {
			System.debug(e);
		}
		return handlerClass;
	}

	// receives an object name and converts it to a trigger handler class name
	public static String convertObjectNameToHandlerName(String sObjectName) {
		String className;
		try {
			if(debugOn) System.debug('convertObjectNameToHandlerName("'+sObjectName+'")');
			// removes __c from custom objects
			className = sObjectName.removeEnd('__c');
			if(debugOn) System.debug('"'+className+'" removed custom object suffix');
			// adds trigger handler suffix to sObject name
			className += triggerHandlerSuffix;
			if(debugOn) System.debug('"'+className+'" added trigger handler suffix');
			// normalizes underscores (in the case of objects with a namespace)
			classname = className.replace('__','_');
			if(debugOn) System.debug('"'+className+'" normalized underscores ');
			// the limit for a class name is 40 characters
			// if, at this point, the name is longer than 40 characters
			if(className.length() > 40) {
				// remove characters from the beginning to bring the name down to 40 characters
				className = className.subString(className.length()-40,className.length());
				if(debugOn) System.debug('"'+className+'" class name was greater than 40 characters');
			}
			// if removing extra characters from the beginning made the class name
			// start with an underscore (underbar) remove that character
			className = className.removeStart('_');
			if(debugOn) System.debug('"'+className+'" removed beginning underscore');
		} catch(Exception e) {
			if(debugOn) System.debug('\nEXCEPTION WHEN TRYING TO CREATE NAME\n'+e.getMessage()+'\n'+e.getStackTraceString()+'\n');
		}
		return className;
	}

	// execute the trigger handler
	private static void execute(TriggerBase handler) {
		if(debugOn) System.debug(LimitsUtil.getLimitsString());
		// Trigger is a variable that is automatically populated in
		// the System class when a trigger is runnning
		if (Trigger.isBefore && beforeTriggersOn) { // BEFORE
			// if there is something you always setup in a before triggers
			handler.setupBefore();
			if(Trigger.isDelete && deleteTriggersOn) {
			 	handler.beforeDelete(); // delete
			} else if(Trigger.isInsert && insertTriggersOn) {
			 	handler.beforeInsert(); // insert
			} else if(Trigger.isUpdate && updateTriggersOn) {
			 	handler.beforeUpdate(); // update
			}
		} else if(Trigger.isAfter && afterTriggersOn) { // AFTER
			// if there is something you always setup in a before triggers
			handler.setupAfter();
			if(Trigger.isDelete && deleteTriggersOn) {
				handler.afterDelete(); // delete
			} else if(Trigger.isInsert && insertTriggersOn) {
				handler.afterInsert(); // insert
			} else if(Trigger.isUpdate && updateTriggersOn) {
				handler.afterUpdate(); // update
			} else if(Trigger.isUndelete && undeleteTriggersOn) {
				handler.afterUndelete(); // undelete
			}
		}
		// run bulkDML
		handler.bulkDML();
		// if there is code to wrap everything up, put it here
		handler.andFinally();
	}

	// makes this class exceptionable
	private class TriggerException extends Exception {}
}