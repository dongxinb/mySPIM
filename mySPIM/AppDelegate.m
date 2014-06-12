//
//  AppDelegate.m
//  mySPIM
//
//  Created by Xinbao Dong on 14-6-11.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "AppDelegate.h"
#import "MIPS.h"
#import "instructor.h"
@class AppDelegate;
@interface AppDelegate ()
@property (nonatomic, retain)NSArray *reg;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.reg = [[NSArray alloc] initWithObjects:@"$zero",@"$at",@"$v0",@"$v1",@"$a0",@"$a1",@"$a2",@"$a3",@"$t0",@"$t1",@"$t2",@"$t3",@"$t4",@"$t5",@"$t6",@"$t7",@"$s0",@"$s1",@"$s2",@"$s3",@"$s4",@"$s5",@"$s6",@"$s7",@"$t8",@"$t9",@"$k0",@"$k1",@"$gp",@"$sp",@"$fp",@"$ra", nil];
    self.ins = [[NSMutableArray alloc] init];
    for (int i = 0; i < 16; i ++) {
        NSTextField *text = [[NSTextField alloc] initWithFrame:CGRectMake(465, 460 - i * 22, 115, 20)];
        int temp = [([MIPS sharedInstance].regis[i]) intValue];
        text.stringValue = [NSString stringWithFormat:@"[%@] %08x", self.reg[i], temp];
        text.alignment = NSRightTextAlignment;
        [text setEditable:NO];
        [self.window.contentView addSubview:text];
        [self.ins addObject:text];
    }
    for (int i = 16; i < 32; i ++) {
        NSTextField *text = [[NSTextField alloc] initWithFrame:CGRectMake(600, 460 - (i-16) * 22, 105, 20)];
        int temp = [([MIPS sharedInstance].regis[i]) intValue];
        text.stringValue = [NSString stringWithFormat:@"[%@] %08x", self.reg[i], temp];
        text.alignment = NSRightTextAlignment;
        [text setEditable:NO];
        [self.window.contentView addSubview:text];
        [self.ins addObject:text];
    }
    [self showMemory];
//    text.
    
}

- (IBAction)codeToAsm:(id)sender
{
//    NSLog(@"%@", self.code.string);
    NSString *str = [NSString stringWithString:self.code.string];
    NSString *output = [[NSString alloc] init];
    NSString *assoutput = [[NSString alloc] init];
    [[MIPS sharedInstance] checkLabel:str];
    [[MIPS sharedInstance] loadFromCode:str];
    NSArray *array = [MIPS sharedInstance].instructorSet;
    for (int i = 0; i < array.count; i ++) {
        instructor *ii = array[i];
        output = [output stringByAppendingString:[NSString stringWithFormat:@"%08x | %@\n",i * 4, ii.code]];
        assoutput = [assoutput stringByAppendingString:[NSString stringWithFormat:@"%08x | %@\n", i * 4, ii.asscode]];
    }
    self.code.string = output;
    self.asmcode.string = assoutput;
}

- (IBAction)asmToCode:(id)sender {
    NSString *str = [NSString stringWithString:self.asmcode.string];
    NSString *output = [[NSString alloc] init];
    NSString *assoutput = [[NSString alloc] init];
//    [[MIPS sharedInstance] checkLabel:str];
    [[MIPS sharedInstance] loadFromAsm:str];
    NSArray *array = [MIPS sharedInstance].instructorSet;
    for (int i = 0; i < array.count; i ++) {
        instructor *ii = array[i];
        output = [output stringByAppendingString:[NSString stringWithFormat:@"%08x | %@\n",i * 4, ii.code]];
        if (ii.asscode != nil) {
            assoutput = [assoutput stringByAppendingString:[NSString stringWithFormat:@"%08x | %@\n", i * 4, ii.asscode]];
        }else {
            
        }
        
        
    }
    self.code.string = output;
    self.asmcode.string = assoutput;
}
- (IBAction)step:(id)sender
{
    [[MIPS sharedInstance] step];
    self.PC.stringValue = [NSString stringWithFormat:@"0x%08x",[MIPS sharedInstance].PC];
    for (int i = 0; i < 32; i ++) {
        NSTextField *text = self.ins[i];
        int temp = [([MIPS sharedInstance].regis[i]) intValue];
        NSString *str = [NSString stringWithFormat:@"[%@] %08x", self.reg[i], temp];
        if ([str isEqualToString:text.stringValue]) {
            text.textColor = [NSColor blackColor];
        }else {
            text.textColor = [NSColor redColor];
        }
        text.stringValue = str;
    }
    NSString *s1 = [NSString stringWithString:self.code.string];
    NSString *s2 = [NSString stringWithString:self.asmcode.string];
    NSRange range1 = [s1 rangeOfString:[NSString stringWithFormat:@"%08x ", [MIPS sharedInstance].PC]];
    NSRange range2 = [s2 rangeOfString:[NSString stringWithFormat:@"%08x ", [MIPS sharedInstance].PC]];
    [self.code setSelectedRange:range1];
    [self.asmcode setSelectedRange:range2];
    [self showMemory];
    
}

- (IBAction)reset:(id)sender
{
    [[MIPS sharedInstance] reload];for (int i = 0; i < 32; i ++) {
        NSTextField *text = self.ins[i];
        int temp = [([MIPS sharedInstance].regis[i]) intValue];
        text.stringValue = [NSString stringWithFormat:@"[%@] %08x", self.reg[i], temp];
    }
    self.PC.stringValue = [NSString stringWithFormat:@"0x%08x",[MIPS sharedInstance].PC];
}

- (void)showMemory
{
    NSString *str = [[NSString alloc] init];
    for (int i = 0; i < [MIPS sharedInstance].memory.length; i += 8) {
        NSString *sub = [[MIPS sharedInstance].memory substringWithRange:NSMakeRange(i, 8)];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"[%08x] %@\n", i / 2, sub]];
    }
    self.memory.string = str;
//    [MIPS sharedInstance].memory
}
@end







