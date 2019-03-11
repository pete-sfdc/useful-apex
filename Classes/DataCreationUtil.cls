public class DataCreationUtil {

	// Opportunity.Amount = oppAmtBase * random(oppAmtLimit)
	// MAX = oppAmtBase * oppAmtLimit
	// MIN = oppAmtBase
	public static Integer oppAmtBase = 1000;
	public static Integer oppAmtLimit = 4000000;
	// _____________________________________________________

	// largest street number
	public static Integer maxStreetNum = 8000;
	// largest phone number
	public static Integer phoneMax = 9999999;
	// use the test prefix or not
	public static Boolean useTestPrefix = true;
	// the actual test prefix
	public static String businessTestPrefix = 'TEST - ';
	// all of the phone numbers will start with 555 because it is a reserved area code
	public static String phonePrefix = '555';

	// zip codes to choose from
	public static List<String> zipCodes = new List<String>{
		'60601', '60602', '60603', '60604', '60605', '60606', '60607', '60608', '60609', '60610', '60611', '60612', '60613', '60614', '60615', '60616', '60617', '60618', '60619', '60620'
	};

	// street names to choose from
	public static List<String> streets = new List<String>{
		'W Adams St', 'W Administration Dr', 'W Balbo Ave', 'W Balbo Dr', 'W Banks St', 'W Bellevue Pl', 'W Benton Pl', 'W Best Dr', 'W Chicago Ave', 'W Congress Dr', 'W Congress Pkwy', 'W Cullerton St', 'W Delaware Pl', 'W Division St', 'W Eastgate Pl', 'W Elm St', 'W Erie St', 'W Goethe St', 'W Grand Ave', 'W Haddock Pl'
	};

	// first names to choose from
	public static List<string> firstNames = new List<String>{
		'James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Charles', 'Joseph', 'Thomas', 'Christopher', 'Daniel', 'Paul', 'Mark', 'Donald', 'George', 'Kenneth', 'Steven', 'Edward', 'Brian', 'Ronald', 'Anthony', 'Kevin', 'Jason', 'Matthew', 'Gary', 'Timothy', 'Jose', 'Larry', 'Jeffrey', 'Frank', 'Scott', 'Eric', 'Stephen', 'Andrew', 'Raymond', 'Gregory', 'Joshua', 'Jerry', 'Dennis', 'Walter', 'Patrick', 'Peter', 'Harold', 'Douglas', 'Henry', 'Carl', 'Arthur', 'Ryan', 'Roger', 'Joe', 'Juan', 'Jack', 'Albert', 'Jonathan', 'Justin', 'Terry', 'Gerald', 'Keith', 'Samuel', 'Willie', 'Ralph', 'Lawrence', 'Nicholas', 'Roy', 'Benjamin', 'Bruce', 'Brandon', 'Adam', 'Harry', 'Fred', 'Wayne', 'Billy', 'Steve', 'Louis', 'Jeremy', 'Aaron', 'Randy', 'Howard', 'Eugene', 'Carlos', 'Russell', 'Bobby', 'Victor', 'Martin', 'Ernest', 'Phillip', 'Todd', 'Jesse', 'Craig', 'Alan', 'Shawn', 'Clarence', 'Sean', 'Philip', 'Chris', 'Johnny', 'Earl', 'Jimmy', 'Antonio', 'Mary', 'Patricia', 'Linda', 'Barbara', 'Elizabeth', 'Jennifer', 'Maria', 'Susan', 'Margaret', 'Dorothy', 'Lisa', 'Nancy', 'Karen', 'Betty', 'Helen', 'Sandra', 'Donna', 'Carol', 'Ruth', 'Sharon', 'Michelle', 'Laura', 'Sarah', 'Kimberly', 'Deborah', 'Jessica', 'Shirley', 'Cynthia', 'Angela', 'Melissa', 'Brenda', 'Amy', 'Anna', 'Rebecca', 'Virginia', 'Kathleen', 'Pamela', 'Martha', 'Debra', 'Amanda', 'Stephanie', 'Carolyn', 'Christine', 'Marie', 'Janet', 'Catherine', 'Frances', 'Ann', 'Joyce', 'Diane', 'Alice', 'Julie', 'Heather', 'Teresa', 'Doris', 'Gloria', 'Evelyn', 'Jean', 'Cheryl', 'Mildred', 'Katherine', 'Joan', 'Ashley', 'Judith', 'Rose', 'Janice', 'Kelly', 'Nicole', 'Judy', 'Christina', 'Kathy', 'Theresa', 'Beverly', 'Denise', 'Tammy', 'Irene', 'Jane', 'Lori', 'Rachel', 'Marilyn', 'Andrea', 'Kathryn', 'Louise', 'Sara', 'Anne', 'Jacqueline', 'Wanda', 'Bonnie', 'Julia', 'Ruby', 'Lois', 'Tina', 'Phyllis', 'Norma', 'Paula', 'Diana', 'Annie', 'Lillian', 'Emily', 'Robin'
	};

	// last names to choose from
	public static List<String> lastNames = new List<String>{
		'Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Anderson', 'Thomas', 'Jackson', 'White', 'Harris', 'Martin', 'Thompson', 'Garcia', 'Martinez', 'Robinson', 'Clark', 'Rodriguez', 'Lewis', 'Lee', 'Walker', 'Hall', 'Allen', 'Young', 'Hernandez', 'King', 'Wright', 'Lopez', 'Hill', 'Scott', 'Green', 'Adams', 'Baker', 'Gonzalez', 'Nelson', 'Carter', 'Mitchell', 'Perez', 'Roberts', 'Turner', 'Phillips', 'Campbell', 'Parker', 'Evans', 'Edwards', 'Collins', 'Stewart', 'Sanchez', 'Morris', 'Rogers', 'Reed', 'Cook', 'Morgan', 'Bell', 'Murphy', 'Bailey', 'Rivera', 'Cooper', 'Richardson', 'Cox', 'Howard', 'Ward', 'Torres', 'Peterson', 'Gray', 'Ramirez', 'James', 'Watson', 'Brooks', 'Kelly', 'Sanders', 'Price', 'Bennett', 'Wood', 'Barnes', 'Ross', 'Henderson', 'Coleman', 'Jenkins', 'Perry', 'Powell', 'Long', 'Patterson', 'Hughes', 'Flores', 'Washington', 'Butler', 'Simmons', 'Foster', 'Gonzales', 'Bryant', 'Alexander', 'Russell', 'Griffin', 'Diaz', 'Hayes', 'Myers', 'Ford', 'Hamilton', 'Graham', 'Sullivan', 'Wallace', 'Woods', 'Cole', 'West', 'Jordan', 'Owens', 'Reynolds', 'Fisher', 'Ellis', 'Harrison', 'Gibson', 'Mcdonald', 'Cruz', 'Marshall', 'Ortiz', 'Gomez', 'Murray', 'Freeman', 'Wells', 'Webb', 'Simpson', 'Stevens', 'Tucker', 'Porter', 'Hunter', 'Hicks', 'Crawford', 'Henry', 'Boyd', 'Mason', 'Morales', 'Kennedy', 'Warren', 'Dixon', 'Ramos', 'Reyes', 'Burns', 'Gordon', 'Shaw', 'Holmes', 'Rice', 'Robertson', 'Hunt', 'Black', 'Daniels', 'Palmer', 'Mills', 'Nichols', 'Grant', 'Knight', 'Ferguson', 'Rose', 'Stone', 'Hawkins', 'Dunn', 'Perkins', 'Hudson', 'Spencer', 'Gardner', 'Stephens', 'Payne', 'Pierce', 'Berry', 'Matthews', 'Arnold', 'Wagner', 'Willis', 'Ray', 'Watkins', 'Olson', 'Carroll', 'Duncan', 'Snyder', 'Hart', 'Cunningham', 'Bradley', 'Lane', 'Andrews', 'Ruiz', 'Harper', 'Fox', 'Riley', 'Armstrong', 'Carpenter', 'Weaver', 'Greene', 'Lawrence', 'Elliott', 'Chavez', 'Sims', 'Austin', 'Peters', 'Kelley', 'Franklin', 'Lawson'
	};

	// business prefixes to choose from
	public static List<String> businessPrefixes = new List<String> {
		'Amalgamated', 'Combined', 'Global', 'Regional', 'American', 'International', 'British', 'European', 'Chinese', 'Mexican', 'Allied', 'New World', 'Old World', 'Canadian', 'Brazilian', 'Latvian', 'German', 'Swiss', 'Reasoned', 'Reasonable', 'Trustworthy', 'Best', 'Zanzibarbarian'
	};

	// business names to choose from
	public static List<String> businessNames = new List<String> {
		'Banks', 'Investment Counselors', 'Investment Banking', 'Venture Capital', 'Oil', 'Exploration', 'Investigation', 'Account Management', 'Bank & Trust', 'Trust Company', 'Bank of Agriculture', 'Agricultural Investment Bank', 'Group Ventures', 'Dynamics', 'Software', 'Consulting', 'Programming', 'Financial', 'Lasso Sales', 'Golfing Specialists', 'Adventure'
	};

	// business suffixes to choose from
	public static List<String> businessSuffixes = new List<String> {
		'Inc', 'LLC', 'Ltd'
	};

	// the random number seed will be an 8 digit integer
	public static Integer generateSeed() {
        return Math.round(Math.random()*10000000);
    }

    // this restricts the upper limit of the random number
	public static Integer getBoundedRandomNumber(Integer upperLimit) {
		return Math.mod(generateSeed(), upperLimit);
	}

	// 0 or 1
	public static Boolean flipCoin() {
		return getBoundedRandomNumber(2) == 0;
	}

	// returns a phone number that is pseudo randomly generated
    public static String getRandomPhoneNumber() {
    	String endPhone = String.valueOf(getBoundedRandomNumber(phoneMax));

    	if(endPhone.length() < 7) {
    		for(Integer i = 0; i < 7 - endPhone.length(); i++) {
	    		if(flipCoin()) {
	    			endPhone += '0';
	    		} else {
	    			endPhone = '0' + endPhone;
	    		}
    		}
    	}
    	String prePhone = phonePrefix + endPhone;
    	List<String> prePhoneList = prePhone.split('');
    	String phoneNum = '';
    	for(Integer i = 0; i < prePhoneList.size(); i++) {
    		if(String.isNotBlank(prePhoneList[i])) {
    			if(i == 0) {
    				phoneNum += '(' + prePhoneList[i];
    			} else if(i == 2) {
    				phoneNum += prePhoneList[i] + ') ';
    			} else if(i == 5) {
    				phoneNum += prePhoneList[i] + '-';
    			} else {
    				phoneNum += prePhoneList[i];
    			}
    		}
    	}
    	return phoneNum;
    }

    // returns a pseudo randomly generated address
	public static AddressWrapper getRandomAddress() {
		return new AddressWrapper();
	}

	// returns a pseudo random chicago zip code
	public static String getRandomPostalCode() {
		return zipCodes[getBoundedRandomNumber(zipCodes.size())];
	}

	// returns a pseudo random chicago street
	public static String getRandomStreet() {
		return getBoundedRandomNumber(maxStreetNum) + ' ' + streets[getBoundedRandomNumber(streets.size())];
	}

	// returns a peusdo randomly chosen business name
	public static String getBusinessName() {
		// adds the test prefix depending on the useTestPrefix static Boolean
		String businessName = useTestPrefix ? businessTestPrefix : '';
		// grabs the business prefix
		businessName += businessPrefixes[getBoundedRandomNumber(businessPrefixes.size())] + ' ';
		// grabs the business name
		businessName += businessNames[getBoundedRandomNumber(businessNames.size())] + ', ';
		// grabs the business suffix
		businessName += businessSuffixes[getBoundedRandomNumber(businessSuffixes.size())];
		// returns the result
		return businessName;
	}

	// returns a pseudo randomly chosen last name
	public static String getLastName() {
		return lastNames[getBoundedRandomNumber(lastNames.size())];
	}

	// returns a pseudo randomly chosen first name
	public static String getFirstName() {
		return firstNames[getBoundedRandomNumber(firstNames.size())];
	}

	// returns a formatted email address
	public static String formatEmail(String firstName, String lastName, String companyName) {
		String email = '';
		email += firstName.subString(0,1).toLowerCase();
		email += lastName.toLowerCase().deleteWhitespace().replaceAll('[^a-z]','');
		String cName = companyName.replace(businessTestPrefix, '');
		for(String businessSuffix:businessSuffixes) {
			cName = cName.replace(', ' + businessSuffix, '');
		}
		email += '=' + cName.toLowerCase().deleteWhitespace().replaceAll('[^a-z]','');
		email += '@example.com';
		return email;
	}

	// makes generating a pseudo random address easier
	public class AddressWrapper {
		public String City {get{ 
			if(String.isBlank(city)) city = 'Chicago';
			return city;
		}set;}
		public String State {get{ 
			if(String.isBlank(state)) state = 'IL';
			return state;
		}set;}
		public String Country {get{
			if(String.isBlank(country)) country = 'USA';
			return country;
		}set;}
		public String Street {get{
			if(street == null) Street = getRandomStreet();
			return street;
		}set;}
		public String PostalCode {get{
			if(postalCode == null) PostalCode = getRandomPostalCode();
			return postalCode;
		}set;}
	}

	// uses the above methods to create a random account record
	public static Account createRandomAccount() {
		// grab a random address
		AddressWrapper aw = getRandomAddress();
		return new Account(
			// get a pseudo randomly generated business name
			Name = getBusinessName(),
			// get a pseudo randomly generated phone number
			Phone = getRandomPhoneNumber(),
			// use the address information in the AddressWrapper
			BillingStreet = aw.Street,
			BillingCity = aw.City,
			BillingState = aw.State,
			BillingCountry = aw.Country,
			BillingPostalCode = aw.PostalCode
		);
	}

	// returns the specified number of random accounts
	public static List<Account> createAccounts(Integer numAccs) {
		// instantiate an empty list of accounts
		List<Account> accs = new List<Account>();
		// add the specified number of random accounts to the list
		for(Integer i = 0; i < numAccs; i++) {
			accs.add(createRandomAccount());
		}
		// return the list of randomly generated accounts
		return accs;
	}

	// pulled into a descrete function because it is used in two places
	public static Integer getNumberOfRecords(Integer multiplier, Integer variableMultiplier) {
		return  multiplier != null ? multiplier : getBoundedRandomNumber(variableMultiplier) + 1;
	}

	// returns opportunities created from the list of accounts.
	// the first integer is a straight multiplier
	// the second integer is a variable multiplier
	public static List<Opportunity> createOpportunities(List<Account> accs, Integer multiplier, Integer variableMultiplier) {
		// instantiate an empty list of opportunities
		List<Opportunity> opps = new List<Opportunity>();
		Integer numOfRecords;
		// loop through account records
		for(Account acc:accs) {
			// each account might have a variable number of opportunities created
			numOfRecords = getNumberOfRecords(multiplier, variableMultiplier);
			for(Integer i = 0; i < numOfRecords; i++) {
				opps.add(new Opportunity(
					// defaults to prospecting
					StageName = 'Prospecting',
					// defaults to 7 days in the future
					CloseDate = Date.today().addDays(7),
					// uses the account name to describe the opportunity
					Name = acc.Name + ' - Opp - ' + i,
					// populate the account lookup
					AccountId = acc.Id,
					// generate an ammount.
					Amount = oppAmtBase * getBoundedRandomNumber(oppAmtLimit)
				));
			}
		}
		// relieve memory pressure
		numOfRecords = null;
		// return the pseudo randomly generated opportunities
		return opps;
	}

	// return contacts created from the list of accounts
	// the first integer is a straight multiplier
	// the second integer is a variable multiplier
	public static List<Contact> createContacts(List<Account> accs, Integer multiplier, Integer variableMultiplier) {
		// instantiate an empty list of contacts
		List<Contact> cons = new List<Contact>();
		Integer numOfRecords;
		AddressWrapper aw;
		Contact con;
		// loop through account records
		for(Account acc:accs) {
			// each account might have a variable number of contacts created
			numOfRecords = getNumberOfRecords(multiplier, variableMultiplier);
			// loop and create the specified number of contacts for each account
			for(Integer i = 0; i < numOfRecords; i++) {
				// grab a random address
				aw = getRandomAddress();
				con = new Contact(
					// get psuedo randomly selected first name
					FirstName = getFirstName(),
					// get psuedo randomly selected last name
					LastName = getLastName(),
					// get psuedo randomly generated phone number
					Phone = getRandomPhoneNumber(),
					// populate account lookup
					AccountId = acc.Id,
					// use the address information in the AddressWrapper
					MailingStreet = aw.Street,
					MailingCity = aw.City,
					MailingState = aw.State,
					MailingCountry = aw.Country,
					MailingPostalCode = aw.PostalCode
				);
				// grab formmated email
				con.Email = formatEmail(con.FirstName, con.LastName, acc.Name);
				// add contact to list
				cons.add(con);
			}
		}
		// relieve memory pressure
		con = null;
		aw = null;
		numOfRecords = null;
		// return the psuedo randomly generated contacts
		return cons;
	}
}