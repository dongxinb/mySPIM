//
//  instructor.h
//  mySPIM
//
//  Created by Xinbao Dong on 14-6-11.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface instructor : NSObject

@property (nonatomic, retain) NSArray *reg;
@property (nonatomic, retain) NSDictionary *opcode;
@property (nonatomic, retain) NSDictionary *funct;
@property (nonatomic, retain) NSArray *convert;
@property (nonatomic, retain) NSArray *bracket;

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *asscode;

@property (nonatomic, retain) NSString *op;
@property (nonatomic, retain) NSArray *para;

//@property (nonatomic, assign)


- (NSString *)checkLabel: (NSString *)input;
- (NSString *)assemble: (NSString *)input;
- (NSString *)disassemble: (NSString *)input;
- (void)run;

@end
