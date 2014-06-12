//
//  MIPS.h
//  mySPIM
//
//  Created by Xinbao Dong on 14-6-11.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIPS : NSObject
+ (MIPS *)sharedInstance;
@property (nonatomic, retain) NSMutableArray *regis;
@property (nonatomic, retain) NSMutableString *memory;
@property (nonatomic, retain) NSMutableDictionary *label;
@property (nonatomic, retain) NSMutableArray *instructorSet;
@property (nonatomic, assign) int PC;
//@property (nonatomic, assign) int re;

- (void)checkLabel:(NSString *)str;
- (void)loadFromCode:(NSString *)str;
- (void)loadFromAsm:(NSString *)str;
- (void)step;
- (void)reload;
@end
