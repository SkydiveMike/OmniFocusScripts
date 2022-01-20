//
//  NSAppleEventDescriptor+CCKValueUnboxing.h
//  OFKanban
//
//  Created by Curt Clifton on 6/24/12.
//  Copyright (c) 2012 Curtis Clifton. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CCKOffendingDescriptorKey;

@interface NSAppleEventDescriptor (CCKValueUnboxing)
- (NSArray *)arrayValue:(NSError **)error;
- (NSDictionary *)dictionaryValue:(NSError **)error;
- (id)unboxedValue:(NSError **)error;
@end
