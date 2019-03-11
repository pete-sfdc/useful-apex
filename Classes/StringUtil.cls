global class StringUtil {

	global class StringUtilException extends Exception {}

	// used enumerated values so only these values are available
	global enum RandOpts {ALPHAUPPER,ALPHALOWER,NUMBERS,SYMBOLS}

	// gives options of what kind of random string someone is looking for
	private static String alphabetUpper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	private static String alphabetLower = alphabetUpper.toLowerCase();
	private static String numbers = '0123456789';
	private static String symbols = '!#$%&()*+,-.:;<=>?@[]^_{|}~';

	// maps work faster than long if statements
	global static Map<RandOpts,String> RandMap = new Map<RandOpts,String>{
		RandOpts.ALPHAUPPER => alphabetUpper,
		RandOpts.ALPHALOWER => alphabetLower,
		RandOpts.NUMBERS => numbers,
		RandOpts.SYMBOLS => symbols
	};

	// uses only letters to generate random string of characters
	global static String getRandomStringLetters(Integer strLength) {
		return getRandomString(new List<RandOpts>{RandOpts.ALPHAUPPER,RandOpts.ALPHALOWER},strLength);
	}

	// uses the available sets of characters to generate a random string
	global static String getRandomStringOfEverything(Integer strLength) {
		return getRandomString(new List<RandOpts>(RandMap.keySet()),strLength);
	}

	// this method allows someone to pick and choose how to create a random string of characters
	global static String getRandomString(List<RandOpts> options, Integer stringLength) {
		// a string to build result on
		String randomString = '';
		// a string of characters to choose from
		String charactersToChooseFrom = '';
		// add all of the character options to the string of chracters to choose from
		for(RandOpts option:options) {
			charactersToChooseFrom += RandMap.get(option);
		}
		// random number is out of the loop for performance's sake
		Integer randomNumber;
		for(Integer i = 0; i < stringLength; i++) {
			// get a random number that's within the range of possible characters
			randomNumber = DataCreationUtil.getBoundedRandomNumber(charactersToChooseFrom.length());
			// grab the substring from the chracters to choose from and add it to the growing result
			randomString += charactersToChooseFrom.substring(randomNumber, randomNumber+1);
		}
		// return the result of random characters
		return randomString;
	}

	// reduces key strokes
	global static void throwException(String errStr) {
		throwException(new List<String>{errStr});
	}

	// reduces key strokes
	global static void throwException(List<String> errList) {
		throw new StringUtilException(String.join(errList,'; '));
	}

	// cleans string before running an SOQL query
	global static String soqlClense(String str) {
		return String.escapeSingleQuotes(str).trim().normalizeSpace().replace('*','%').replaceAll('[%]+','%');
	}

	// convert a string to ID; returns null if the string is not an ID
	global static Id toID(String strId) {
		Id idId;
		try {
			// cast string to Id; if not an Id, the cast will throw an exception
			idId = (Id)strId;
		} catch(Exception e) {}
		// return the resulting Id
		return idId;
	}

	// tests if a string is an Id
	global static Boolean isStringId(String strId) {
		Boolean good = false;
		// check that they sent something
		if(String.isNotBlank(strId)) {
			// if they sent something, try to convert it
			// if the toID method returns null, it was not
			// an ID
			good = String.isNotBlank(toID(strId));
		} else {
			// throw exception if string is blank
			throwException('Did not receive a string to test');
		}
		// return the result of testing
		return good;
	}

	// check if a string is an Id from a particular object by SObjectType string name
	global static Boolean isStringId(String objName, String strId) {
		Boolean good = false;
		// if the string object name and the string id are not blank
		if(String.isNotBlank(objName) && String.isNotBlank(strId)) {
			// get the sObjectType from the string object name
			Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
			// test by SObjectType
			good = isStringId(objType,strId);
		} else {
			// if either of the strings were blank
			List<String> errList = new List<String>();
			// write a message for each
			if(String.isBlank(objName)) errList.add('Did not recieve an Object Name');
			if(String.isBlank(strId)) errList.add('Did not recieve an Id');
			// pass the list of exceptions to be thrown
			throwException(errList);
		}
		// return the result of testing
		return good;
	}

	// check if a string is an id for a particular object by SObjectType
	global static Boolean isStringId(Schema.SObjectType sObjType, String strId) {
		Boolean good = false;
		// check if the sObjectType is not null and the string ID is not blank
		if(sObjType != null && String.isNotBlank(strId)) {
			// test the ID
			Id idId = toID(strId);
			// if the Id is not blank
			if(String.isNotBlank(idId)) {
				// test passed type agains the Id's sObjectType
				good = sObjType == idId.getSobjectType();
			}
		} else {
			List<String> errList = new List<String>();
			// if the SObjectType or the string were null, add exceptions to be thrown
			if(String.isBlank(strId)) errList.add('Did not receive an Id string');
			if(sObjType == null) errList.add('Did not receive an ObjectType');
			// throw exceptions
			throwException(errList);
		}
		// return test results
		return good;
	}

	// check if a string is an Id for a particular object by the DescribeSObjectResult
	global static Boolean isStringId(Schema.DescribeSObjectResult dr, String strId) {
		Boolean good = false;
		if(String.isNotBlank(strId) && dr != null) {
			good = isStringId(strId) && dr.getKeyPrefix() == strId.subString(0,3);
		} else {
			List<String> errList = new List<String>();
			if(String.isBlank(strId))  errList.add('Did not recieve String Id');
			if(dr == null)  errList.add('Did not recieve DescribeSObjectResult');
			throwException(errList);
		}
		return good;
	}

	// convert 15 character Id to 18 character Id
	global static Id convert15to18(String inputId) {
		Id outputId;
		// check if a string was actuall passed
		if(String.isNotBlank(inputId) && isStringId(inputId)) {
			// no sense in create a lot of variables unless they'll be used
			// 32 characters... a power of 2?
			String alphaNum = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345';
			String suffix = '';
			String str;
			Integer locations;
			String cleanedInputId = inputId.trim();
			// if the Id is already 18 characters
			if(cleanedInputId.length() == 18) {
				// just return itself
				outputId = cleanedInputId;
			} else if(cleanedInputId.length() == 15) {
				// if work needs to be done, do some loopgic (loop magic)
				//
				// the extra three characters in the 18 character Id 
				// indicate which of the preceeding 15 characters are uppercase
				// the locations are reversed (because binary), so 00010 (C) means
				// the second character is uppercase.
				//
				// Here's a play by play
				//
				// 0013600000MHAqU  	<- original Id
				// 00136 00000 MHAqU 	<- split into 3 groups of 5
				// 00000 00000 11101	<- set flags for the uppercase letters
				// 00000 00000 10111	<- flip each group because binary
				//   A     A     X 		<- letters
				//
				// 0013600000MHAqUAAX 	<- final 18 character ID

				// the two loops split the 15 characters into 3 groups of 5
				for(Integer i = 0; i < 3; i++) {
					// captures the locations of the uppercase letters
					locations = 0;
					for(Integer j = 0; j < 5; j++) {
						// selects the string within each group of 5
						str = cleanedInputId.subString(i*5+j, i*5+j+1);
						// if it's an uppercase letter
						if(str.toUpperCase().equals(str) && str >= 'A' && str <= 'Z') {
							// take its location
							locations = locations + ( 1 << j );
						}
					}
					// grab the letter that represents the capitalization for this group...
					// you'll notice that we did binary shifts to set the location and
					// magically it represents the location of the letter/number in
					// our string... Binary is cooler than people give it credit for.
					// ... Then we add the letter to the suffix string
					suffix += alphaNum.subString(locations, locations + 1);
				}
				// append the suffix string to the original Id string
				outputId = cleanedInputId+suffix;
			}
		} else {
			// throw a reasonably non-cryptic exception
			String errorCleanedStr = String.isNotBlank(inputId) ? inputId : 'null';
			throwException('Invalid ID ('+ errorCleanedStr +')');
		}
		// return the result
		return outputId;
	}

	// email addresses in sandboxes are converted. This unconverts them.
	global static String fixSandboxEmail(String emailStr) {
		return emailStr.replace('@example.com','').replace('=','@');
	}
}