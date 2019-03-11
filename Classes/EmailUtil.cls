public class EmailUtil {

	// object to hold merged values of email templates
	public class TemplateObj {
		public String HtmlBody {get;set;}
		public String PlainTextBody {get;set;}
		public String Subject {get;set;}
		public TemplateObj(Messaging.SingleEmailMessage msg) {
			this.HtmlBody = msg.getHtmlBody();
			this.PlainTextBody = msg.getPlainTextBody();
			this.Subject = msg.getSubject();
		}
	}

	// pass an array of email template developer names
	// this function will return a map, keyed by the email template developer names
	public static Map<String,TemplateObj> getHTMLTemplates(List<String> devTemplateNames) {
		// instantiate an empty "String => TemplateObj" map
		Map<String,TemplateObj> templateMap = new Map<String,TemplateObj>();
		// instantiate an empty array of SingleEmailMesssages
		List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage msg;
		// loop through the email templates
		for(EmailTemplate et:queryEmailTemplates(devTemplateNames)) {
			// instantiate a new SingleEmailMessage
			msg = new Messaging.SingleEmailMessage();
			// set the to addresses to a bogus email address
			msg.setToAddresses(new List<String>{'wrong@example.com'});
			// use the current template
			msg.setTemplateId(et.Id);
			// target object is the current user
			msg.setTargetObjectId(UserInfo.getUserId());
			// this will be transitory, so there's no need to create an activity
			msg.saveAsActivity = false;
			// add the new email message to the array
			msgs.add(msg);
		}
		// relieve some memory pressure
		msg = null;
		if(msgs != null && !msgs.isEmpty()) {
			// as it turns out, this is best practice
			msgs = mergeHTMLBodys(msgs);
			// populate the template map keyed by email template developer names
			for(Integer i = 0; i < msgs.size(); i++) {
				templateMap.put(devTemplateNames[i],new TemplateObj(msgs[i]));
			}
			// hail the garbage collector
			msgs = null;
		}
		// return the template map keyed by email template developer names
		return templateMap;
	}

	// merges the HTML body of the SingleEmailMessages sent to it
	public static List<Messaging.SingleEmailMessage> mergeHTMLBodys(List<Messaging.SingleEmailMessage> msgs) {
		if(msgs != null && !msgs.isEmpty()) {
			// establish a savepoint
			Savepoint sp = Database.setSavepoint();
			// send the emails (which would be sent after all of the rollups are calculated)
			Messaging.sendEmail(msgs);
			// rollback before emails are actually sent
			Database.rollback(sp);
		}
		// return list of SingleEmailMesssages with merged HTML bodies
		return msgs;	
	}

	// this query method was introduced to try and reduce the amount of uncertainty in the world
	public static List<EmailTemplate> queryEmailTemplates(List<String> devTemplateNames) {
		return [
			SELECT 	Id, Name, DeveloperName 
			FROM 	EmailTemplate 
			WHERE 	DeveloperName IN:devTemplateNames
		];
	}
}