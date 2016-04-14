//
//  JMEmailSender.m
//  CoreLib
//
//  Created by CoreCode on 31.10.04.
/*	Copyright (c) 2016 CoreCode
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitationthe rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
// Some code here is derived from Apple Sample Code, but changes have been made

#import "JMEmailSender.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-macros"
#define WIN32 0
#ifdef USE_MAILCORE
#import <MailCore/MailCore.h>
//#import <MailCore/CTCoreAddress.h>
//#import <MailCore/CTCoreMessage.h>
#endif
#ifdef USE_APPLEMAIL
#import "Mail.h"
#endif
#pragma clang diagnostic pop

@implementation JMEmailSender


#ifdef USE_APPLEMAIL
+ (smtpResult)sendMailWithScriptingBridge:(NSString *)content subject:(NSString *)subject to:(NSString *)recipients timeout:(uint16_t)secs attachment:(NSString *)attachmentFilePath
{
	asl_NSLog_debug(@"sendMailWithScriptingBridge %@\n\n sub: %@\n rec: %@", content, subject, recipients);

	BOOL validAddressFound = FALSE;
	NSArray *recipientList = [recipients componentsSeparatedByString:@"\n"];
	NSString *recipient;

	if (recipients == nil)
		return kSMTPToNilFailure;

	@try
	{
		smtpResult res;
		/* create a Scripting Bridge object for talking to the Mail application */
		MailApplication *mail = [SBApplication applicationWithBundleIdentifier:@"com.apple.Mail"];

        [mail setTimeout:secs*60];

#if defined(TARGET_OS_MAC) && TARGET_OS_MAC && !TARGET_OS_IPHONE
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#endif
		if ( [attachmentFilePath length] > 0 && [NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
			content = [content stringByAppendingFormat:@"\n\ninline-attachment-base64:\n%@", [attachmentFilePath.fileURL.contents base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0]];
#if (__MAC_OS_X_VERSION_MIN_REQUIRED < 1090)
#pragma clang diagnostic pop
#endif
#endif

		NSDictionary *messageProperties = [NSDictionary dictionaryWithObjectsAndKeys:subject, @"subject", content, @"content", nil];
		MailOutgoingMessage *emailMessage =	[[[mail classForScriptingClass:@"outgoing message"] alloc] initWithProperties:messageProperties];

		/* add the object to the mail app */
		[[mail outgoingMessages] addObject:emailMessage];

		/* set the sender, show the message */
		//emailMessage.visible = YES;

		/* create a new recipient and add it to the recipients list */
		for (recipient in recipientList) // the recipient string can be a newline seperated list of recipients
		{
			if (recipient.isValidEmail)
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
			return kSMTPToNilFailure;





		if ( [attachmentFilePath length] > 0 && ![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
		{
			MailAttachment *theAttachment;
			
           if (OS_IS_POST_10_6)
				theAttachment = [[[mail classForScriptingClass:@"attachment"] alloc] initWithProperties:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSURL URLWithString:attachmentFilePath], @"fileName",
								  nil]];
			else
				theAttachment = [[[mail classForScriptingClass:@"attachment"] alloc] initWithProperties:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  [[NSURL URLWithString:attachmentFilePath] path], @"fileName",
								  nil]];
			

			[[emailMessage.content attachments] addObject: theAttachment];
			
#if ! __has_feature(objc_arc)
			[theAttachment release];
#endif
		}
		if ( [mail lastError] != nil )
			return kSMTPScriptingBridgeFailure;

		if ([emailMessage send])
			res = kSMTPSuccess;
		else
			res = kSMTPScriptingBridgeFailure;
		asl_NSLog_debug(@"sent!");
#if ! __has_feature(objc_arc)
		[emailMessage release];
#endif
		return res;
	}
	@catch (NSException *e)
	{
		asl_NSLog(ASL_LEVEL_WARNING, @"sendMailWithScriptingBridge, exception %@", [e description]);

		return kSMTPScriptingBridgeFailure;
	}

	return kSMTPScriptingBridgeFailure;  // just to silence the compiler
}
#endif

#ifdef USE_MAILCORE
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
			return kSMTPToNilFailure;
		if (sender == nil || [sender length] == 0 || !sender.isValidEmail)
			return kSMTPFromNilFailure;

		/* create a new recipient and add it to the recipients list */
		for (recipient in recipientList) // the recipient string can be a newline seperated list of recipients
		{
			if (recipient.isValidEmail)
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
			return kSMTPToNilFailure;

		CTCoreMessage *msg = [[CTCoreMessage alloc] init];

		[msg setTo:set];
		[msg setFrom:[NSSet setWithObject:[CTCoreAddress addressWithName:@"" email:sender]]];
		[msg setBody:mail];
		[msg setSubject:subject];

		[CTSMTPConnection sendMessage:msg server:server username:username  password:password  port:port useTLS:tls useAuth:auth];

		[msg release];

		return kSMTPSuccess;
	}
	@catch (NSException *e)
	{
		asl_NSLog(ASL_LEVEL_WARNING, @"e-mail delivery failed with unknown problem, exception %@", [e description]);

		return kSMTPMailCoreFailure;
	}

	return kSMTPMailCoreFailure; // just to silence the compiler
}
#endif

//// this uses sending through mail with scripting or sending through CGI if supported and else falls back to opening a mail to be sent manually using mailto link
//// return YES if the mail was sent in background and NO if a mail has been created
//+ (BOOL)sendOrCreateMail:(NSString *)content subject:(NSString *)subject to:(NSString *)recipient;
//+ (BOOL)sendOrCreateMail:(NSString *)content subject:(NSString *)subject to:(NSString *)recipient
//{
//	smtpResult result = kSMTPCGIFailure;
//
//#ifdef USE_CGIMAIL
//	if (result != kSMTPSuccess)	result = [self sendMailWithCGI:content subject:subject to:recipient timeout:60 checkBlocklists:NO];
//#endif
//
//#ifdef USE_APPLEMAIL
//	if (result != kSMTPSuccess)	result = [self sendMailWithScriptingBridge:content subject:subject to:recipient timeout:60 attachment:nil]
//#endif
//
//	if (result != kSMTPSuccess)
//	{
//		NSString *mailtoLink = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@", recipient, subject, content];
//
//		[mailtoLink.escaped.URL open];
//
//		return NO;
//	}
//	else
//		return YES;
//}
@end
