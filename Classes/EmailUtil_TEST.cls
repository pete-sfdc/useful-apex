@isTest
public class EmailUtil_TEST {
	public static String emailTemplateName = 'Test_Email_Template';
	public static String emailTextBody = 'Text Body\nHere you go';
	public static String emailHTMLBody = '<div><!--[endif]--></div>';
	public static testmethod void simpleTest() {
		EmailTemplate et = new EmailTemplate(
			isActive = true,
			Encoding = 'UTF-8',
			Name = emailTemplateName,
			DeveloperName = emailTemplateName,
			TemplateType = 'text',
			FolderId = UserInfo.getUserId(),
			Body = emailTextBody,
			HtmlValue = emailHTMLBody,
			Subject = emailTextBody
		);
		insert et;
		EmailUtil.getHTMLTemplates(new List<String>{emailTemplateName});
	}
}