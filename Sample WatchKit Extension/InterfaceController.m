//
//  InterfaceController.m
//  Sample WatchKit Extension
//
//  Created by Helmut on 06.05.15.
//  Copyright (c) 2015 Helmut. All rights reserved.
//

#import "InterfaceController.h"
#import "HJWatchSpeedRead.h"

@interface InterfaceController() <HJWatchSpeedReadDelegate>

@property HJWatchSpeedRead * speed_reader;

@end


@implementation InterfaceController

- (void) HJWatchSpeedReadController:(HJWatchSpeedRead *)HJWatchSpeedReadController showWord:(NSAttributedString *)word {


    [self.speed_label setAttributedText:word];
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.speed_label setText:@" "];
   _speed_reader = [[HJWatchSpeedRead alloc] initWithBodyText:@"Mitten in der Euro-Krise wollen die EU-Abgeordneten ihre monatlichen Budgets um 1.500 Euro auf 22.879 Euro erhöhen. Die Abgeordneten argumentieren, dass es seit dem Jahr 2011 keine Erhöhungen gegeben hat. Das müsse nachgeholt werden. Die Gesamtkosten für alle EU-Abgeordneten im Zuge einer fünfjährigen Legislaturperiode würden sich damit auf eine Milliarde Euro erhöhen."];
    _speed_reader.wordsPerMinute=250;
    _speed_reader.delegate=self;
    
 
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)start_read {
    [_speed_reader start];
}

- (IBAction)end_read {
        [_speed_reader stop];
}

- (IBAction)speed_read:(float)value {
    NSLog(@"SET TO VALUE: %03f", value);
    _speed_reader.wordsPerMinute=ceil(value);
    
    
}
@end



