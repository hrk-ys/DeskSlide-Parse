//
//  DSController.m
//  DeskSlideOSX
//
//  Created by Hiroki Yoshifuji on 2014/02/27.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "DSController.h"

#import <ParseOSX/Parse.h>

// Class key
NSString *const kDSDocumentClassKey = @"Document";

// Field keys
NSString *const kDSDocumentTypeKey = @"type";
NSString *const kDSDocumentTextKey = @"text";
NSString *const kDSDocumentFileKey = @"file";


// DocumentType
NSString *const kDSDocumentTypeText = @"text";
NSString *const kDSDocumentTypeFile = @"file";

NSString* const kDSSendImageMenuItemTitle = @"クリップボードの画像を送信";
NSString* const kDSSelectImageMenuItemTitle = @"送信するファイルを選択";

@implementation DSController

- (void)awakeFromNib
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    [self.statusItem setImage:[NSImage imageNamed:@"menu_icon"]];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusMenu setAutoenablesItems:NO];
}

- (NSString *)pastText
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray      *texts      = [pasteboard readObjectsForClasses:@[ [NSString class] ] options:@{ }];
    if (texts && texts.firstObject) {
        return texts[0];
    }
    
    return nil;
}

- (NSImage *)pastImage
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray      *images     = [pasteboard readObjectsForClasses:@[ [UIImage class] ] options:@{ }];
    if (images && images.firstObject) {
        return images[0];
    }
    
    return nil;
}

- (NSImage *)resizeMenuImage:(NSImage *)sourceImage
{
    NSSize originalSize = [sourceImage size];
    float  scale        = MAX(
                              20 / originalSize.width,
                              20 / originalSize.height
                              );
    float width  = originalSize.width * scale;
    float height = originalSize.height * scale;
    
    return [self resizeImage:sourceImage width:width height:height];
}

- (NSImage *)resizeImage:(NSImage *)sourceImage width:(float)resizeWidth height:(float)resizeHeight
{
    NSImage *resizedImage = [[NSImage alloc] initWithSize:NSMakeSize(resizeWidth, resizeHeight)];
    NSSize   originalSize = [sourceImage size];
    
    [resizedImage lockFocus];
    
    [sourceImage drawInRect:NSMakeRect(0, 0, resizeWidth, resizeHeight) fromRect:NSMakeRect(0, 0, originalSize.width, originalSize.height) operation:NSCompositeSourceOver fraction:1.0];
    
    [resizedImage unlockFocus];
    
    return resizedImage;
}

#pragma  mark -

- (void)menuWillOpen:(NSMenu *)menu
{
    if ([PFUser currentUser]) {
        NSString *text = [self pastText];
        if (text) {
            if (text.length > 30) text = [NSString stringWithFormat:@"%@...", [text substringToIndex:30]];
            [self.sendTextMenuItem setTitle:[NSString stringWithFormat:@"クリップボードのテキストを送信: [%@]", text]];
        } else {
            [self.sendTextMenuItem setTitle:[NSString stringWithFormat:@"クリップボードのテキストを送信"]];
        }
        
        NSImage *image = [self pastImage];
        
        if (image) {
            [self.sendImageMenuItem setImage:[self resizeMenuImage:image]];
        } else {
            [self.sendImageMenuItem setImage:NULL];
        }
    }
}

- (void)updateMenuItem
{
    if ([PFUser currentUser]) {
        [self.loginMenuItem setEnabled:NO];
        [self.logoutMenuItem setEnabled:YES];
        [self.sendTextMenuItem setEnabled:YES];
        [self.sendImageMenuItem setEnabled:YES];
        [self.selectFileMenuItem setEnabled:YES];
    }
    else {
        [self.loginMenuItem setEnabled:YES];
        [self.logoutMenuItem setEnabled:NO];
        [self.sendTextMenuItem setEnabled:NO];
        [self.sendImageMenuItem setEnabled:NO];
        [self.selectFileMenuItem setEnabled:NO];
    }
}

- (void)showError:(NSError *)error forWindow:(NSWindow *)window
{
    [self showTitle:@"エラー" message:[error userInfo][@"error"] forWindow:window];
    
    return;
    NSAlert *alert = [NSAlert alertWithError:error];
    
    [alert beginSheetModalForWindow:window
                      modalDelegate:self
                     didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                        contextInfo:nil];
}

- (void)showTitle:(NSString *)title message:(NSString *)message forWindow:(NSWindow *)window
{
    NSAlert *alert = [NSAlert alertWithMessageText:title
                                     defaultButton:@"OK"
                                   alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", message];
    
    [alert beginSheetModalForWindow:window
                      modalDelegate:self
                     didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                        contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert
         returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
}


#pragma mark -

- (void)sendImage:(PFFile*)imageFile progressBlock:(PFProgressBlock)progressBlock
{
    // Save PFFile
    
    [self.sendImageMenuItem setEnabled:NO];
    [self.selectFileMenuItem setEnabled:NO];
    progressBlock(0);
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *doc = [PFObject objectWithClassName:kDSDocumentClassKey];
            [doc setObject:kDSDocumentTypeFile forKey:kDSDocumentTypeKey];
            [doc setObject:imageFile forKey:kDSDocumentFileKey];
            
            [doc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self showTitle:@"" message:@"送信しました" forWindow:NULL];
                }
                else {
                    // Log details of the failure
                    [self showError:error forWindow:nil];
                }
                self.sendImageMenuItem.title = kDSSendImageMenuItemTitle;
                self.selectFileMenuItem.title = kDSSelectImageMenuItemTitle;
                
                [self.sendImageMenuItem setEnabled:YES];
                [self.selectFileMenuItem setEnabled:YES];
            }];
        }
        else {
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        if (progressBlock) progressBlock(percentDone);
    }];
}




- (IBAction)preformOpen:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://desk-slide.hrk-ys.net/"]];
}

- (IBAction)onLogin:(id)sender
{
    [self.loginWindow makeKeyAndOrderFront:sender];
}

- (IBAction)onLogout:(id)sender
{
    [PFUser logOut];
    [self updateMenuItem];
    [self showTitle:@"" message:@"ログアウトしました" forWindow:NULL];
}

- (IBAction)onSendText:(id)sender
{
    NSString *text = [self pastText];
    if (!text) {
        NSError *error = [NSError errorWithDomain:@"com.hrk-ys.desk-slide" code:1 userInfo:@{ @"error": @"送信したいテキストをコピーしてください" }];
        [self showError:error forWindow:nil];
    }
    
    PFObject *doc = [PFObject objectWithClassName:kDSDocumentClassKey];
    [doc setObject:kDSDocumentTypeText forKey:kDSDocumentTypeKey];
    [doc setObject:text forKey:kDSDocumentTextKey];
    
    [doc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self showError:error forWindow:nil];
            
            return;
        }
        
       
        [self showTitle:@"" message:@"送信しました" forWindow:NULL];
    }];
}

- (IBAction)onSendImage:(id)sender
{
    NSImage *image = [self pastImage];
    if (!image) {
        NSError *error = [NSError errorWithDomain:@"com.hrk-ys.desk-slide" code:1 userInfo:@{ @"error": @"送信したい画像をコピーしてください" }];
        [self showError:error forWindow:nil];
        
        return;
    }
    
    NSData *data = [image TIFFRepresentation];
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    [self sendImage:imageFile progressBlock:^(int percentDone) {
        [self.sendImageMenuItem setTitle:[NSString stringWithFormat:@"%@: %d %%", kDSSendImageMenuItemTitle, percentDone]];
    }];
}

- (IBAction)onSelectFile:(id)sender {
    
    NSOpenPanel *openPanel	= [NSOpenPanel openPanel];
    NSArray *allowedFileTypes = [NSArray arrayWithObjects:@"png",@"'PNG'", @"jpg", @"'JPG'", @"jpeg", @"'JPEG'", nil];
    //  NSOpenPanel interface has changed since Mac OSX v10.6.
    [openPanel setAllowedFileTypes:allowedFileTypes];
    NSInteger pressedButton = [openPanel runModal];
    
    if( pressedButton == NSOKButton ){
        
        // get file path
        NSURL * filePath = [openPanel URL];
        PFFile *imageFile = [PFFile fileWithName:[[[filePath path] pathComponents] lastObject]
                                  contentsAtPath:filePath.path];
        [self sendImage:imageFile progressBlock:^(int percentDone) {
            [self.selectFileMenuItem setTitle:[NSString stringWithFormat:@"%@: %d %%", kDSSelectImageMenuItemTitle, percentDone]];
        }];
        // open file here
        
    }else if( pressedButton == NSCancelButton ){
    }else{
     	// error
    }

}


#pragma mark - login

- (IBAction)tappedLoginButton:(NSButton*)sender
{
    NSString *username = self.usernameField.stringValue;
    NSString *password = self.passwordField.stringValue;
    
    if (!username || username.length < 1 ||
        !password || password.length < 1) {
        [self showTitle:@"エラー" message:@"Username Passwordを入力してください" forWindow:self.loginWindow];
    }
    
    
    [sender setEnabled:NO];
    [self.loginMenuItem setEnabled:NO];
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        [sender setEnabled:YES];
                                        if (user) {
                                            [self updateMenuItem];
                                            [self.loginWindow close];
                                            
                                            [self showTitle:@"" message:@"ログインしました" forWindow:nil];
                                        } else {
                                            [self showError:error forWindow:self.loginWindow];
                                        }
                                    }];
}

@end
