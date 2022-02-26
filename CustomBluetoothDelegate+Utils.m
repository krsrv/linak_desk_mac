#import "CustomBluetoothDelegate+Utils.h"

@implementation CustomBluetoothDelegate (Utils)

+ (NSString *)getAuthStateString:(CBCentralManager *)central {
  NSString *stateMessage;
  switch(central.authorization) {
    case CBManagerAuthorizationAllowedAlways:
      stateMessage = @"Authorized";
      break;
    case CBManagerAuthorizationDenied:
      stateMessage = @"Denied";
      break;
    case CBManagerAuthorizationNotDetermined:
      stateMessage = @"Not yet authorized";
      break;
    case CBManagerAuthorizationRestricted:
      stateMessage = @"Restricted";
      break;
  }
  return stateMessage;
}

+ (NSString *)getManagerStateString:(CBCentralManager *)central {
  NSString *stateMessage;
  switch(central.state) {
    case CBManagerStatePoweredOff:
      stateMessage = @"Disabled";
      break;
    case CBManagerStatePoweredOn:
      stateMessage = @"Enabled";
      break;
    case CBManagerStateResetting:
      stateMessage = @"Resetting";
      break;
    case CBManagerStateUnauthorized:
      stateMessage = @"Unauthorized access";
      break;
    case CBManagerStateUnknown:
      stateMessage = @"Gone to the dogs";
      break;
    case CBManagerStateUnsupported:
      stateMessage = @"BLE central/client role not supported";
      break;
  }
  return stateMessage;
}

+ (void)printManagerState:(CBCentralManager *)central {
  NSLog(@"%@", [CustomBluetoothDelegate getManagerStateString:central]);
}

+ (void)printAuthState:(CBCentralManager *)central {
  NSLog(@"%@", [CustomBluetoothDelegate getAuthStateString:central]);
}

@end
