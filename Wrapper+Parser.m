#import "Wrapper.h"
#import "Wrapper+Parser.h"

@implementation Wrapper (Parser)

- (void)parseStringInput:(NSString *)string {
  NSString *lowercaseString = [string lowercaseString];
  if ([lowercaseString isEqualToString:@"quit"]) {
    [self quit];
    return;
  }
  
  if ([lowercaseString isEqualToString:@"start"]) {
    [self startBluetooth];
  } else if ([lowercaseString isEqualToString:@"dump"]) {
    [self dumpDetails];
  } else if ([lowercaseString isEqualToString:@"reread"]) {
    [self rereadValues];
  } else if ([lowercaseString isEqualToString:@"rediscover"]) {
    [self rediscoverServices];
  } else if ([lowercaseString hasPrefix:@"exp"]) {
    int val = [[[lowercaseString componentsSeparatedByString:@" "] lastObject] integerValue];
    [self experiment:val];
  } else if ([lowercaseString hasPrefix:@"write "]) {
    NSArray *arguments = [lowercaseString componentsSeparatedByString:@" "];
    if ([arguments count] < 4) {
      NSLog(@"Needs at least 4 parameters: \"write <service_index> <characteristic_index> <data>\"");
    } else {
      int serviceNumber = [arguments[1] integerValue];
      int characteristicNumber = [arguments[2] integerValue];
      if (serviceNumber <= 0 || characteristicNumber <= 0) {
        NSLog(@"Arguments should be positive integers");
      } else {
        // The last argument is the data in integer array
        NSMutableData *data = [NSMutableData dataWithLength:0];
        for (NSString *argument in [arguments subarrayWithRange:NSMakeRange(3, [arguments count] - 3)]) {
          const char number[] = {[argument integerValue]};
          [data appendBytes:number length:sizeof(number)];
        }
        //NSNumberFormatter *nf = [[[NSNumberFormatter alloc] init] autorelease];
        //NSNumber *decimal = [nf numberFromString:lastArgument];
        //NSData *data; 
        //if (decimal == nil) {
        //  data = [lastArgument dataUsingEncoding:NSUTF8StringEncoding];
        //} else {
        //  const char number[] = {[decimal integerValue], 0};
        //  data = [NSData dataWithBytes:&number length:sizeof(number)];
        //}
        [self writeValue:data service:serviceNumber characteristic:characteristicNumber];
      }
    }
  }

  [self.stdIn readInBackgroundAndNotify];
}

@end

