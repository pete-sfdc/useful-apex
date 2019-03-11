/*
	An easy place to grab org and user information.
	There are some optimizations that grab information
	without using queries. However, some data can only
	be grabbed using a query. The queries are dynamically
	built with no joins.
*/
global class OrgUtil {

	// this variable allows for 100% code coverage
	public static Boolean changeForTesting = false;
	// makes this class exceptional
	public class OrgUtilException extends Exception {}
	// current user cache
	private static User CurrentUser;
	// organization info cache
	private static Organization Info;

	// to allow flxibility while building tight apps
	global static void clearCurrentUser() {
		CurrentUser = null;
	}

	// query all of the fields for the current user
	global static User getCurrentUser() {
		// if the CurrentUser cache hasn't been populated
		if(CurrentUser == null) {
			// grab current userId
			Id userId = UserInfo.getUserId();
			// build dynamic query
			CurrentUser = (User)Database.query(String.format(
				// the template for the user query
				'SELECT {0} FROM {1} WHERE Id =:userId LIMIT 1',
				new List<String>{
					// grab all of the fields on User
					SObjectUtil.getFieldsStr('User'),
					// name of the object being queried
					'User'
				}
			));
		}
		// return the current user
		return CurrentUser;
	}

	// to allow flxibility while building tight apps
	global static void clearInfo() {
		Info = null;
	}

	// query all of the fields for the current organization
	global static Organization getInfo() {
		// if the organization info cache has not been populated
		if(Info == null) {
			// build a dynamic query
			Info = (Organization)Database.query(String.format(
				// template for the query
				'SELECT {0} FROM {1} LIMIT 1',
				new List<String>{
					// grab all of the fields on the Organization object
					SObjectUtil.getFieldsStr('Organization'),
					// the field being queried
					'Organization'
				}
			));
		}
		// return the current organization info
		return Info;
	}

	// keeps things lighter
	global static String getName() {
		return Info == null ? UserInfo.getOrganizationName() : getInfo().Name;
	}

	// Organization Type is commonly requested
	global static String getOrganizationType() {
		return getInfo().OrganizationType;
	}

	// there is a way to get this without querying organization
	global static String getOrgInstance() {
		String instance;
		// if the organization info cache hasn't been populated
		if(Info == null) {
			// split the salesforce URL by "."
			for(String partOfURL:URL.getSalesforceBaseUrl().getHost().split('[.]')) {
				// check if the current part is the instance part
				if(String.isNotBlank(partOfURL) && Pattern.matches('(na|ap|eu|cs)[0-9]{1,2}', partOfURL.trim())) {
					// populate instance
					instance = partOfUrl;
					// break the loop
					break;
				}
			}
		} else {
			// if the organization info cache has been populated, just use the value
			instance = getInfo().InstanceName.toLowerCase();
		}
		// return the instance
		return instance;
	}

	// commonly request information from organization
	global static String getId() {
		return Info == null ?  UserInfo.getOrganizationId() : getInfo().Id;
	}

	// very commonly requested information from organization
	global static Boolean isSandbox() {
		return Info == null ? getOrgInstance().contains('cs') : getInfo().isSandbox;
	}

	// allows admins to unlock a number of people in a sandbox
	global static Set<Id> fixUserEmailAddresses(Set<Id> userIds) {
		Set<Id> updatedUserIds;
		// checks to see if the code is being used in a sandbox
		if(changeForTesting || isSandbox()) {
			// instantiate an empty list of users
			List<User> users = new List<User>();
			// loop through users that need to be fixed
			for(User u:[
				SELECT	Id, Email
				FROM 	User
				WHERE 	Id IN:userIds
				AND 	Email LIKE '%=%@example.com'
			]) {
				u.Email = StringUtil.fixSandboxEmail(u.Email);
				users.add(u);
			}
			// if there were users that need to be fixed
			if(users != null && !users.isEmpty()) {
				// update their records
				update users;
				// populate set with Id's of users that were fixed
				updatedUserIds = (new Map<Id,User>(users)).keySet();
			}
		} else {
			// throw exeption if code is not being run in a sandbox environment
			throw new OrgUtilException('You can only do this in a Sandbox environment');
		}
		// return a set of Ids of users that were updated
		return updatedUserIds;
	}
}