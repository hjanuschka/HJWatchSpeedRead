//
//  InterfaceController.h
//  Sample WatchKit Extension
//
//  Created by Helmut on 06.05.15.
//  Copyright (c) 2015 Helmut. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *speed_label;
- (IBAction)start_read;
- (IBAction)end_read;
- (IBAction)speed_read:(float)value;

@end
