//
//  JMEmailSender.m
//  CoreLib
//
//  Created by CoreCode on 31.10.04.
/*	Copyright (c) 2014 CoreCode
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
// Some code here is derived from Apple Sample Code, but changes have been made

#import "JMEmailSender.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-macros"
#define WIN32 0
#ifdef MAILCORE
#import <MailCore/MailCore.h>
//#import <MailCore/CTCoreAddress.h>
//#import <MailCore/CTCoreMessage.h>
#endif
#ifdef APPLEMAIL
#import "Mail.h"
#endif
#pragma GCC diagnostic pop

@implementation JMEmailSender


#ifdef APPLEMAIL
+ (smtpResult)sendMailWithScriptingBridge:(NSString *)content subject:(NSString *)subject timeout:(uint16_t)secs to:(NSString *)recipients attachment:(NSString *)attachmentFilePath
{
	asl_NSLog_debug(@"sendMailWithScriptingBridge %@\n\n sub: %@\n rec: %@", content, subject, recipients);

	BOOL validAddressFound = FALSE;
	NSArray *recipientList = [recipients componentsSeparatedByString:@"\n"];
	NSString *recipient;

	if (recipients == nil)
		return kToNilFailure;

	@try
	{
		smtpResult res;
		/* create a Scripting Bridge object for talking to the Mail application */
		MailApplication *mail = [SBApplication applicationWithBundleIdentifier:@"com.apple.Mail"];

        [mail setTimeout:secs*60];

		/* create a new outgoing message object */
		NSDictionary *messageProperties = [NSDictionary dictionaryWithObjectsAndKeys:subject, @"subject", content, @"content", nil];
		MailOutgoingMessage *emailMessage =	[[[mail classForScriptingClass:@"outgoing message"] alloc] initWithProperties:messageProperties];

		/* add the object to the mail app */
		[[mail outgoingMessages] addObject:emailMessage];

		/* set the sender, show the message */
		//emailMessage.visible = YES;

		/* create a new recipient and add it to the recipients list */
		for (recipient in recipientList) // the recipient string can be a newline seperated list of recipients
		{
			if (isValidEmail([recipient UTF8String]))
			{
				asl_NSLog_debug(@"sendMail: messageframework - sending to: %@", recipient);

				validAddressFound = TRUE;
				NSDictionary *recipientProperties = [NSDictionary dictionaryWithObjectsAndKeys:recipient, @"address", nil];
				MailToRecipient *theRecipient =	[[[mail classForScriptingClass:@"to recipient"] alloc] initWithProperties:recipientProperties];
				[emailMessage.toRecipients addObject:theRecipient];
#if ! __has_feature(objc_arc)
				[theRecipient release];
#endif
			}
			else
			{
				asl_NSLog_debug(@"sendMail: %@ is not valid email!", recipient);
			}
		}

		asl_NSLog_debug(@"going to send");
		if (validAddressFound != TRUE)
			return kToNilFailure;
		
		
		if ( [attachmentFilePath length] > 0 ) {
			MailAttachment *theAttachment;
			
            /* In Snow Leopard, the fileName property requires an NSString representing the path to the
             * attachment.  In Lion, the property has been changed to require an NSURL.   */
			SInt32 osxMinorVersion;
			Gestalt(gestaltSystemVersionMinor, &osxMinorVersion);
			
            /* create an attachment object */
			if ( osxMinorVersion >= 7 )
				theAttachment = [[[mail classForScriptingClass:@"attachment"] alloc] initWithProperties:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSURL URLWithString:attachmentFilePath], @"fileName",
								  nil]];
			else
            /* The string we read from the text field is a URL so we must create an NSURL instance with it
             * and retrieve the old style file path from the NSURL instance. */
				theAttachment = [[[mail classForScriptingClass:@"attachment"] alloc] initWithProperties:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  [[NSURL URLWithString:attachmentFilePath] path], @"fileName",
								  nil]];
			
            /* add it to the list of attachments */
			[[emailMessage.content attachments] addObject: theAttachment];
			
#if ! __has_feature(objc_arc)
			[theAttachment release];
#endif
            /* Test for errors */
			if ( [mail lastError] != nil )
				return kScriptingBridgeFailure;
		}
		
		
		if ([emailMessage send])
			res = kSuccess;
		else
			res = kScriptingBridgeFailure;
		asl_NSLog_debug(@"sent!");
#if ! __has_feature(objc_arc)
		[emailMessage release];
#endif
		return res;
	}
	@catch (NSException *e)
	{
		asl_NSLog(ASL_LEVEL_WARNING, @"sendMailWithScriptingBridge, exception %@", [e description]);

		return kScriptingBridgeFailure;
	}

	return kScriptingBridgeFailure;  // just to silence the compiler
}
#endif

#ifdef MAILCORE
+ (smtpResult)sendMailWithMailCore:(NSString *)mail subject:(NSString *)subject timeout:(uint16_t)secs server:(NSString *)server port:(uint16_t)port from:(NSString *)sender to:(NSString *)recipients auth:(BOOL)auth tls:(BOOL)tls username:(NSString *)username password:(NSString *)password
{
	asl_NSLog_debug(@"sendMailWithMailCore %@\n\n sub: %@\n sender: %@\nrec: %@", mail, subject, sender, recipients);

	BOOL validAddressFound = FALSE;
	NSArray *recipientList = [recipients componentsSeparatedByString:@"\n"];
	NSMutableSet *set = [NSMutableSet setWithCapacity:[recipientList count]];
	NSString *recipient;

	@try
	{
		struct timeval delay = {  secs, 0 };
		mailstream_network_delay = delay; 
		
		
		if (recipients == nil)
			return kToNilFailure;
		if (sender == nil || [sender length] == 0 || !isValidEmail([sender UTF8String]))
			return kFromNilFailure;

		/* create a new recipient and add it to the recipients list */
		for (recipient in recipientList) // the recipient string can be a newline seperated list of recipients
		{
			if (isValidEmail([recipient UTF8String]))
			{
				asl_NSLog_debug(@"sendMail: mailcore - sending to: %@", recipient);

				validAddressFound = TRUE;
				[set addObject:[CTCoreAddress addressWithName:@"" email:recipient]];
			}
			else
			{
				asl_NSLog_debug(@"sendMail: %@ is not valid email!", recipient);
			}
		}

		if (!validAddressFound)
			return kToNilFailure;

		CTCoreMessage *msg = [[CTCoreMessage alloc] init];

		[msg setTo:set];
		[msg setFrom:[NSSet setWithObject:[CTCoreAddress addressWithName:@"" email:sender]]];
		[msg setBody:mail];
		[msg setSubject:subject];

		[CTSMTPConnection sendMessage:msg server:server username:username  password:password  port:port useTLS:tls useAuth:auth];

		[msg release];

		return kSuccess;
	}
	@catch (NSException *e)
	{
		asl_NSLog(ASL_LEVEL_WARNING, @"e-mail delivery failed with unknown problem, exception %@", [e description]);

		return kMailCoreFailure;
	}

	return kMailCoreFailure; // just to silence the compiler
}
#endif
@end

BOOL isValidEmail(const char *email)
{
	char *i = NULL, *j = NULL;

	if (strlen(email) > 254)
		return FALSE;

	i = strchr(email, '@');

	if (i)
		j = strchr(i, '.');

	if (!i || !j || (j - i < 2))
		return FALSE;

	if (strchr(email, ';') || strchr(email, ':') || strchr(email, '|') || strchr(email, '/') || strchr(email, ',') || strchr(email, '&'))
		return FALSE;

	while ((i = strchr(j, '.')))
	{
		j = i;
		++j;
	}

	if (strlen(email) - ((int)(j - email)) < 2)
		return FALSE;

	return TRUE;
}
