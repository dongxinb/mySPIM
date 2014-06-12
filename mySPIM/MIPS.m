//
//  MIPS.m
//  mySPIM
//
//  Created by Xinbao Dong on 14-6-11.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "MIPS.h"
#import "instructor.h"

@implementation MIPS
+ (MIPS *)sharedInstance
{
    static MIPS *_MIPS = nil;
    @synchronized(self) {
        if (_MIPS == nil) {
            _MIPS = [[MIPS alloc] init];
        }
    }
    return _MIPS;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self reload];
    }
    return self;
}

- (void)step
{
    int i = self.PC / 4;
    instructor *ins = self.instructorSet[i];
    [ins run];
}

- (void)reload
{
    self.regis = [[NSMutableArray alloc] initWithCapacity:32];
    for (int i = 0; i < 32; i ++) {
        self.regis[i] = [NSNumber numberWithInt:0];
    }
    self.PC = 0;
    self.memory = [[NSMutableString alloc] initWithCapacity:65536];
    
    for (int i = 0; i < 65536; i ++) {
        [self.memory insertString:@"0" atIndex:0];
//        [self.memory replaceCharactersInRange:NSMakeRange(i, 1) withString:@"0"];
    }
//    NSLog(@"%@", self.memory);
//    NSMutableString

}

- (void)checkLabel:(NSString *)str
{

    self.label = [[NSMutableDictionary alloc] init];
    
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    NSArray *temp = [str componentsSeparatedByString:@"\n"];
    for (int i = 0; i < temp.count; i ++) {
        NSRange range;
        range = [temp[i] rangeOfString:@":"];
        if (range.location != NSNotFound) {
            NSString *res = [temp[i] substringToIndex:range.location];
            res = [res stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.label[res] = [NSNumber numberWithInt:i * 4];
        }
        
    }
}

- (void)loadFromCode:(NSString *)str
{
    self.instructorSet = [[NSMutableArray alloc] init];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    NSArray *temp = [str componentsSeparatedByString:@"\n"];
    for (int i = 0; i < temp.count; i ++) {
        if ([[temp[i] stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
            continue;
        }
        instructor *ins = [[instructor alloc] init];
        NSArray *ttt = [temp[i] componentsSeparatedByString:@":"];
        if (ttt.count == 1) {
            ttt = [temp[i] componentsSeparatedByString:@"|"];
            if (ttt.count == 2) {
                [ins assemble:ttt[1]];
            }else {
                [ins assemble:ttt[0]];
            }
        }else {
            [ins assemble:ttt[1]];
        }
        [self.instructorSet addObject:ins];
    }
    
}

- (void)loadFromAsm:(NSString *)str
{
    self.instructorSet = [[NSMutableArray alloc] init];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *temp = [str componentsSeparatedByString:@"\n"];
    for (int i = 0; i < temp.count; i ++) {
        if ([[temp[i] stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
            continue;
        }
        instructor *ins = [[instructor alloc] init];
        NSArray *ttt = [temp[i] componentsSeparatedByString:@"|"];
        if (ttt.count == 2) {
            [ins disassemble:ttt[1]];
        }else {
            [ins disassemble:temp[i]];
        }
        [self.instructorSet addObject:ins];
    }
    
}


@end




