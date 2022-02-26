#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CBCharacteristic (Utils)

- (BOOL)hasNotification;
- (BOOL)isWritable;
- (BOOL)isReadable;
- (NSString *)getStringifiedPermissions;

@end

@interface CBDescriptor (Utils)

- (NSString *)getType;

@end
