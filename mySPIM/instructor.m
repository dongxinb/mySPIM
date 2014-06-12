//
//  instructor.m
//  mySPIM
//
//  Created by Xinbao Dong on 14-6-11.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "instructor.h"
#import "MIPS.h"

@implementation instructor
- (id)init {
    self = [super init];
    if (self) {
        self.reg = [[NSArray alloc] initWithObjects:@"$zero",@"$at",@"$v0",@"$v1",@"$a0",@"$a1",@"$a2",@"$a3",@"$t0",@"$t1",@"$t2",@"$t3",@"$t4",@"$t5",@"$t6",@"$t7",@"$s0",@"$s1",@"$s2",@"$s3",@"$s4",@"$s5",@"$s6",@"$s7",@"$t8",@"$t9",@"$k0",@"$k1",@"$gp",@"$sp",@"$fp",@"$ra", nil];
        self.opcode = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"000010", @"j",
                       @"001000", @"addi",
                       @"000100", @"beq",
                       @"000101", @"bne",
                       @"100011", @"lw",
                       @"101011", @"sw",
                       @"001010", @"slti",
                       nil];
        self.funct = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"100000", @"add",
                      @"100010", @"sub",
                      @"100100", @"and",
                      @"100101", @"or",
                      @"100110", @"xor",
                      @"101010", @"slt",
                      nil];
        self.convert = [NSArray arrayWithObject:@"beq"];
        self.bracket = [NSArray arrayWithObjects:@"lw", @"sw", nil];
    }
    return self;
}

- (void)run
{
    [MIPS sharedInstance].PC += 4;
    if ([self.op isEqualToString:@"add"]) {
        [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:[[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue] + [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[2]]] intValue]];
    }else if ([self.op isEqualToString:@"sub"]) {
        [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:[[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue] - [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[2]]] intValue]];
    }else if ([self.op isEqualToString:@"and"]) {
        [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:[[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue] & [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[2]]] intValue]];
    }else if ([self.op isEqualToString:@"or"]) {
        [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:[[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue] | [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[2]]] intValue]];
    }else if ([self.op isEqualToString:@"xor"]) {
        [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:[[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue] ^ [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[2]]] intValue]];
    }else if ([self.op isEqualToString:@"slt"]) {
//        int d = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] intValue];
        int s = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue];
        int t = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[2]]] intValue];
        if (s < t) {
            [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:1];
        }else {
            [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:0];
        }
    }else if ([self.op isEqualToString:@"j"]) {
//        int address = [[MIPS sharedInstance].label[self.para[0]] intValue];
        int address = [(self.para[0]) intValue];
        [MIPS sharedInstance].PC = address;
    }else if ([self.op isEqualToString:@"addi"]) {
        [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:[[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue] + [self.para[2] intValue]];
    }else if ([self.op isEqualToString:@"beq"]) {
        int s = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] intValue];
        int t = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue];
        if (s == t) {
            [MIPS sharedInstance].PC += [self.para[2] intValue] * 4;
        }
    }else if ([self.op isEqualToString:@"bne"]) {
        int s = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] intValue];
        int t = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue];
        if (s != t) {
            [MIPS sharedInstance].PC += [self.para[2] intValue] * 4;
        }
    }else if ([self.op isEqualToString:@"lw"]) {
        int offset = [self.para[2] intValue];
        int s = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue];
        offset += s;
        NSString *get = [[MIPS sharedInstance].memory substringWithRange:NSMakeRange(offset * 2, 4)];
        const char *x = [get cStringUsingEncoding:NSASCIIStringEncoding];
        int num = x[3] - (x[3] > '9' ? 87:'0') + 16 * (x[2] - (x[2] > '9' ? 87:'0')) + 16*16*(x[1] - (x[1] > '9' ? 87:'0')) + 16*16*16*(x[0]-(x[0] > '9' ? 87:'0'));
        [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:num];
        
    }else if ([self.op isEqualToString:@"sw"]) {
        int offset = [self.para[2] intValue];
        int s = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue];
        int t = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] intValue];
        offset += s;
        [[MIPS sharedInstance].memory replaceCharactersInRange:NSMakeRange(offset * 2, 4) withString:[NSString stringWithFormat:@"%04x", t]];
        NSLog(@"%@", [[MIPS sharedInstance].memory substringToIndex:20]);
        
//        [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:]
    }else if ([self.op isEqualToString:@"slti"]) {
        int s = [[MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[1]]] intValue];
        if (s < [self.para[2] intValue]) {
            [MIPS sharedInstance].regis[[self.reg indexOfObject:self.para[0]]] = [NSNumber numberWithInt:1];
        }
    }else if ([self.op isEqualToString:@""]) {
        
    }else if ([self.op isEqualToString:@""]) {
        
    }else if ([self.op isEqualToString:@""]) {
        
    }else if ([self.op isEqualToString:@""]) {
        
    }else if ([self.op isEqualToString:@""]) {
        
    }
}


- (NSString *)assemble: (NSString *)input
{
    while ([input hasPrefix:@" "]) {
        input = [input substringFromIndex:1];
    }
    
    self.code = [NSString stringWithString:input];
    
    NSRange range;
    NSString *result = [[NSString alloc] init];
    
    range = [input rangeOfString:@" "];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSString *para1 = [input substringToIndex:range.location];
    para1 = [para1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    input = [input substringFromIndex:range.location];
    input = [input stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *array = [input componentsSeparatedByString:@","];
//    NSLog(@"%@", self.funct[para1]);
    
    if (self.opcode[para1] != nil) {
        self.op = para1;
        if (array.count == 1) {
            if ([para1 isEqualToString:@"j"]) {
                result = self.opcode[para1];
                NSString *s = array[0];
                s = [s stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSArray *temp2 = [s componentsSeparatedByString:@"0x"];
                if (temp2.count == 1) {
                    result = [result stringByAppendingString:[self binaryStringWithInteger:[[MIPS sharedInstance].label[array[0]] intValue] OfFigure:26]];
                    
                    
                    self.para = [NSArray arrayWithObject:[NSNumber numberWithInt:[[MIPS sharedInstance].label[array[0]] intValue]]];
                    self.code = [NSString stringWithFormat:@"%@ 0x%08x", para1, [[MIPS sharedInstance].label[array[0]] intValue]];
                }else {
                    result = [result stringByAppendingString:[self binaryStringWithInteger:[self IntegerWithBinaryString:temp2[1]] OfFigure:26]];
                    self.para = [NSArray arrayWithObject:[NSNumber numberWithInt:[self IntegerWithBinaryString:temp2[1]]]];
                    self.code = [NSString stringWithFormat:@"%@ 0x%08x", para1, [self IntegerWithBinaryString:temp2[1]]];
                }
                
                
                //返回标号！！！
            }else {
                return nil;
            }
        }else if (array.count == 2) {
            range = [array[1] rangeOfString:@"("];
            if (range.location != NSNotFound) {
                NSArray *temp = [array[1] componentsSeparatedByString:@"("];
                NSScanner* scan = [NSScanner scannerWithString:temp[0]];
                int offset;
                [scan scanInt:&offset];
                if (![scan isAtEnd]) {
                    return nil;
                }
                NSString *s = [temp[1] stringByReplacingOccurrencesOfString:@")" withString:@""];
                if ([self.reg indexOfObject:array[0]] == NSNotFound || [self.reg indexOfObject:s] == NSNotFound) {
                    return nil;
                }
                result = self.opcode[para1];
                result = [result stringByAppendingString:[self binaryStringWithInteger:[self.reg indexOfObject:s] OfFigure:5]];
//                result = [result stringByAppendingString:@"/"];
                result = [result stringByAppendingString:[self binaryStringWithInteger:[self.reg indexOfObject:array[0]] OfFigure:5]];
                result = [result stringByAppendingString:[self binaryStringWithInteger:offset OfFigure:16]];
                self.para = [[NSArray alloc] initWithObjects:array[0], s, [NSNumber numberWithInt:offset], nil];
            }else {
                //未实现，两个参数的
                return nil;
            }
        
        }else if (array.count == 3) {
            if ([self.reg indexOfObject:array[0]] == NSNotFound || [self.reg indexOfObject:array[1]] == NSNotFound) {
                return nil;
            }else {
                result = self.opcode[para1];
                NSScanner *scan = [NSScanner scannerWithString:array[2]];
                int imme;
                [scan scanInt:&imme];
                if (![scan isAtEnd]) {
                    return nil;
                }
                int ttt = 1;
                if ([self.convert indexOfObject:para1] != NSNotFound) {
                    ttt = 0;
                }
                result = [result stringByAppendingString:[self binaryStringWithInteger:[self.reg indexOfObject:array[ttt]] OfFigure:5]];
                result = [result stringByAppendingString:[self binaryStringWithInteger:[self.reg indexOfObject:array[1 - ttt]] OfFigure:5]];
                result = [result stringByAppendingString:[self binaryStringWithInteger:imme OfFigure:16]];
                self.para = [[NSArray alloc] initWithObjects:array[0], array[1], [NSNumber numberWithInt:imme], nil];
                
            }
            
            
        }else {
            return nil;
        }
    }else if (self.funct[para1] != nil) {
        self.op = para1;
        if (array.count == 3) {
            result = @"000000";
            for (int i = 0; i < array.count; i ++) {
//                NSLog(@"%d", [self.reg indexOfObject:array[i]]);
                if ([self.reg indexOfObject:array[i]] == NSNotFound) {
                    return nil;
                }
            }
            result = [result stringByAppendingString:[self binaryStringWithInteger:[self.reg indexOfObject:array[1]] OfFigure:5]];
            result = [result stringByAppendingString:[self binaryStringWithInteger:[self.reg indexOfObject:array[2]] OfFigure:5]];
            result = [result stringByAppendingString:[self binaryStringWithInteger:[self.reg indexOfObject:array[0]] OfFigure:5]];
            result = [result stringByAppendingString:@"00000"];
            result = [result stringByAppendingString:[self.funct valueForKey:para1]];
            
            self.para = [[NSArray alloc] initWithArray:array];
        }else {
            return nil;
        }
    }else {
        return nil;
    }
    self.asscode = result;
    return result;
}


- (NSString *)disassemble: (NSString *)input
{
    while ([input hasPrefix:@" "]) {
        input = [input substringFromIndex:1];
    }
    
    if (input.length != 32) {
        return nil;
    }
    self.asscode = input;
    NSString *result;
    const char *char_content = [input cStringUsingEncoding:NSASCIIStringEncoding];
    for (int i = 0; i < input.length; i ++) {
        if (char_content[i] != '0' && char_content[i] != '1') {
            return nil;
        }
    }
    self.asscode = input;
    if ([input hasPrefix:@"000000"]) {
        NSString *s = [input substringWithRange:NSMakeRange(6, 5)];
        NSString *t = [input substringWithRange:NSMakeRange(11, 5)];
        NSString *d = [input substringWithRange:NSMakeRange(16, 5)];
        NSString *i = [input substringFromIndex:26];
        int ss = [self IntegerWithBinaryString:s];
        int tt = [self IntegerWithBinaryString:t];
        int dd = [self IntegerWithBinaryString:d];
        self.op = [self searchKeyWithValue:i inDictionary:self.funct];
        result = [NSString stringWithFormat:@"%@ %@,%@,%@", self.op, self.reg[dd], self.reg[ss], self.reg[tt]];
        self.para = [NSArray arrayWithObjects:self.reg[dd], self.reg[ss], self.reg[tt], nil];
        self.code = result;
        
    }else {
        NSString *o = [input substringWithRange:NSMakeRange(0, 6)];
        o = [self searchKeyWithValue:o inDictionary:self.opcode];
        if (o == nil) {
            return nil;
        }
        self.op = o;
        if ([o isEqualToString:@"j"]) {
            int address =[self IntegerWithBinaryString:[input substringFromIndex:6]];
            self.para = [NSArray arrayWithObject:[NSNumber numberWithInt:address]];
            result = [NSString stringWithFormat:@"%@ 0x%08x", o, address];
            
            //jump！！！！跳转
        }else {
            NSString *s = [input substringWithRange:NSMakeRange(6, 5)];
            NSString *t = [input substringWithRange:NSMakeRange(11, 5)];
            NSString *i = [input substringFromIndex:16];
            int ss = [self IntegerWithBinaryString:s];
            int tt = [self IntegerWithBinaryString:t];
            int ii = [self IntegerWithBinaryString:i];
            if ([self.convert indexOfObject:o] != NSNotFound) {
                result = [NSString stringWithFormat:@"%@ %@,%@,%d", o, self.reg[ss], self.reg[tt], ii];
                self.para = [NSArray arrayWithObjects:self.reg[ss], self.reg[tt], [NSNumber numberWithInt:ii], nil];
            }else {
                if ([self.bracket indexOfObject:o] != NSNotFound) {
                    result = [NSString stringWithFormat:@"%@ %@,%d(%@)", o, self.reg[tt], ii, self.reg[ss]];
                    self.para = [NSArray arrayWithObjects:self.reg[tt], self.reg[ss], [NSNumber numberWithInt:ii], nil];
                }else {
                    result = [NSString stringWithFormat:@"%@ %@,%@,%d", o, self.reg[tt], self.reg[ss], ii];
                    self.para = [NSArray arrayWithObjects:self.reg[tt], self.reg[ss], [NSNumber numberWithInt:ii], nil];
                }
            }
            
            
        }
        
        
        
    }
    self.code = result;
    return result;
}


- (NSString *)checkLabel: (NSString *)input
{
    NSRange range;
    range = [input rangeOfString:@":"];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSString *res = [input substringToIndex:range.location];
    res = [res stringByReplacingOccurrencesOfString:@" " withString:@""];
    return res;
}

- (NSString *)searchKeyWithValue: (NSString *)str inDictionary: (NSDictionary *)dic
{
    for (NSString *key in dic) {
        if ([dic[key] isEqualToString:str]) {
            return key;
        }
    }
    return nil;
}

- (NSString *)binaryStringWithInteger: (NSInteger)value OfFigure: (NSInteger)figure{
    NSMutableString *string = [NSMutableString string];
    while (figure != 0) {
        [string insertString:(value & 1)? @"1": @"0" atIndex:0];
        value /= 2;
        figure --;
    }
    return string;
}

- (int)IntegerWithBinaryString: (NSString *)str
{
    const char *char_content = [str cStringUsingEncoding:NSASCIIStringEncoding];
    int t = 1, res = 0;
    for (int i = (int)str.length - 1; i >= 0; i --) {
        res = res + (char_content[i] - '0') * t;
        t *= 2;
    }
    return res;
}

@end




