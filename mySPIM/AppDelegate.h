//
//  AppDelegate.h
//  mySPIM
//
//  Created by Xinbao Dong on 14-6-11.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (unsafe_unretained) IBOutlet NSTextView *code;
@property (unsafe_unretained) IBOutlet NSTextView *asmcode;
@property (nonatomic, retain) NSMutableArray *ins;
- (IBAction)codeToAsm:(id)sender;
- (IBAction)asmToCode:(id)sender;
@property (weak) IBOutlet NSTextField *PC;
- (IBAction)step:(id)sender;
- (IBAction)reset:(id)sender;
@property (unsafe_unretained) IBOutlet NSTextView *memory;

@end
