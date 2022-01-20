//
//  CCKTask.h
//  OFKanban
//
//  Created by Curt Clifton on 5/29/12.
//  Copyright (c) 2012 Curtis Clifton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OmniFocusTask;

@interface CCKTask : NSObject
- (id)initWithTaskID:(NSString *)taskID;

// CCC, 6/24/2012. Add read-only properties for the other bits you need to visualize tasks.
@property (nonatomic, readonly) NSString *taskID;
@property (nonatomic, readonly) NSString *title; // KVO-compliant, automatically updated on background queue
@end
