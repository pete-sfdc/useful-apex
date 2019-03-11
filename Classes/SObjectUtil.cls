/*
	The Schema method strings are useful, but can be a pain to remember
	This class is built so that you don't have to remember.

	TODO: 	Make methods that preceed each method that use DescribeResult's or SObjectType's
			instead of strings. It would be more safe and the field names would validate.
			Also, when parsing these classes, we could track down object and field
			references. Compile time errors are way better than runtime errors.
*/
global class SObjectUtil {

	// grab the describe result of an object by string
	global static DescribeSObjectResult getObject(String sObjectName) {
		return Schema.getGlobalDescribe().get(sObjectName).getDescribe();
	}

	// returns a List<String> of sObject fields from String object name
	global static List<String> getFields(String sObjectName) {
		List<String> fields = new List<String>(getFieldMap(sObjectName).keySet());
		fields.sort();
		return fields;
	}

	global static List<String> getUsefulFields(String sObjectName) {
		// this list will be populated at the end if values are found
		List<String> finalList = new List<String>();
		// use a set to prevent duplicates; add standard fields that might not fit filters
		Set<String> fieldSet = new Set<String>{'Id','Name','CreatedDate','LastModifiedDate','CreatedById','LastModifiedById'};
		DescribeFieldResult dfr;
		// loop through them fields
		for(Schema.SObjectField fType:getFieldList(sObjectName)) {
			dfr = fType.getDescribe();
			if(dfr.isAccessible() && (dfr.isUpdateable() || dfr.isCalculated())) {
				fieldSet.add(dfr.getName());
			}
		}
		// relieve some pressure
		dfr = null;
		// if the field set is not empty, add it to the list and sort
		if(!fieldSet.isEmpty()) {
			finalList.addAll(fieldSet);
			finalList.sort();
		}
		// relieve some more pressure
		fieldSet = null;
		return finalList;
	}

	// returns a concatenated string of fields by from String of sObject name
	global static String getFieldsStr(String sObjectName) {
		return String.join(getFields(sObjectName),', ');
	}

	// returns describe result of field by sObject name and field name passed as strings
	// this can easily be done with Account.Industry.getDescribe() but might be useful
	// for young and impressionable developers... or if you're using a dynamic pattern
	global static DescribeFieldResult getField(String sObjectName, String fieldName) {
		return getObject(sObjectName).fields.getMap().get(fieldName).getDescribe();
	}

	// get list of fields for sObject by sObject field name (string)
	global static List<Schema.SObjectField> getFieldList(String sObjectName) {
		return getFieldMap(sObjectName).values();
	}

	// get field map for sObject by sObject field name (string)
	global static Map<String,Schema.SObjectField> getFieldMap(String sObjectName) {
		return getObject(sObjectName).fields.getMap();
	}

	// get field analysis object by (string) sobject name and (string) field name
	global static Field getFieldAnalysis(String sObjectName, String fieldName) {
		return new Field(sObjectName, fieldName);
	}

	// get field analysis object by (string) sobject name and (string) field name
	global static List<Field> getFieldAnalysis(String sObjectName, List<String> fieldNames) {
		List<Field> fields = new List<Field>();
		for(String fieldName:fieldNames) {
			fields.add(getFieldAnalysis(sObjectName,fieldName));
		}
		return fields;
	}

	// get picklist values as array of SelectOptions by string object name and string field name
	global static List<SelectOption> getPicklistSelectOptions(String sObjectName, String fieldName) {
		List<SelectOption> picklistSelectOptions = new List<SelectOption>();
		for(Schema.PicklistEntry ple:getPicklistEntries(sObjectName,fieldName)) {
			picklistSelectOptions.add(new SelectOption(ple.getValue(),ple.getLabel()));
		}
		return picklistSelectOptions;
	}

	// get picklist values as array of Picklist Entries by string object name and string field name
	global static List<Schema.PicklistEntry> getPicklistEntries(String sObjectName, String fieldName) {
		return getField(sObjectName,fieldName).getPicklistValues();
	}

	// get picklist values as array of strings by string object name and string field name
	global static List<String> getStringListOfPicklistValues(String sObjectName, String fieldName) {
		List<String> temp = new List<String>();
		for(Schema.PicklistEntry ple:getPicklistEntries(sObjectName, fieldName)) {
			temp.add(ple.getValue());
		}
		return temp;
	}

	// field analysis object that makes describing fields easier... and cooler :)
	global class Field {
		global Schema.DescribeFieldResult Base {get;set;}
		global Field(Schema.DescribeFieldResult fieldResult) {
			this.Base = fieldResult;
		}
		global Field(Schema.SObjectField field) {
			this.Base = field.getDescribe();
		}
		global Field(String sObjectName, String fieldName) {
			this.Base = SObjectUtil.getField(sObjectName,fieldName);
		}

		// methods that don't exist on DescribeFieldResult, yet are surprisingly useful...
		global Boolean isMasterDetail() {
			return Base.getType() == Schema.DisplayType.REFERENCE && Base.getRelationshipOrder() != null;
		}
		global Boolean isLookup() {
			return Base.getType() == Schema.DisplayType.REFERENCE && !isMasterDetail();
		}
		global Boolean isRollupSummary() {
			return String.isBlank(Base.getCalculatedFormula()) && Base.isCalculated();
		}
		global Boolean isFormulaField() {
			return String.isNotBlank(Base.getCalculatedFormula());
		}
		global Boolean isPicklist() {
			return Base.getPicklistValues() != null && !Base.getPicklistValues().isEmpty();
		}
	}
}