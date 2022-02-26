#import "CustomBluetoothDelegate.h"

@interface CustomBluetoothDelegate (Utils)

+ (NSString *)getAuthStateString:(CBCentralManager *)central;
+ (NSString *)getManagerStateString:(CBCentralManager *)central;
+ (void)printAuthState:(CBCentralManager *)central;
+ (void)printManagerState:(CBCentralManager *)central;

@end
