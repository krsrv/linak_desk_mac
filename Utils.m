#import "Utils.h"

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@implementation CBCharacteristic (Utils)

- (BOOL)hasNotification {
  return self.properties & CBCharacteristicPropertyNotify;
}

- (BOOL)isWritable {
  return self.properties & (CBCharacteristicPropertyWrite | CBCharacteristicPropertyWriteWithoutResponse);
}

- (BOOL)isReadable {
  return self.properties & CBCharacteristicPropertyRead;
}

- (NSString *)getStringifiedPermissions {
  NSMutableArray *permissions = [NSMutableArray arrayWithCapacity:10];
  if (self.properties & CBCharacteristicPropertyBroadcast)
    [permissions addObject:@"broadcast"];
  if (self.properties & CBCharacteristicPropertyRead)
    [permissions addObject:@"read"];
  if (self.properties & CBCharacteristicPropertyWriteWithoutResponse)
    [permissions addObject:@"write without response"];
  if (self.properties & CBCharacteristicPropertyWrite)
    [permissions addObject:@"write"];
  if (self.properties & CBCharacteristicPropertyNotify)
    [permissions addObject:@"notify"];
  if (self.properties & CBCharacteristicPropertyIndicate)
    [permissions addObject:@"indicate"];
  if (self.properties & CBCharacteristicPropertyAuthenticatedSignedWrites)
    [permissions addObject:@"authenticated writes"];
  if (self.properties & CBCharacteristicPropertyNotifyEncryptionRequired)
    [permissions addObject:@"notify for trusted device"];
  if (self.properties & CBCharacteristicPropertyIndicateEncryptionRequired)
    [permissions addObject:@"indicate for trusted device"];
  if (self.properties & CBCharacteristicPropertyExtendedProperties)
    [permissions addObject:@"extended properties"];

  return [permissions componentsJoinedByString:@", "];
}

@end

@implementation CBDescriptor (Utils)

- (NSString *)getType {
  if ([self.UUID.UUIDString isEqualTo:CBUUIDCharacteristicExtendedPropertiesString])
    return @"Extended property";
  if ([self.UUID.UUIDString isEqualTo:CBUUIDCharacteristicUserDescriptionString])
    return @"Description";
  if ([self.UUID.UUIDString isEqualTo:CBUUIDClientCharacteristicConfigurationString])
    return @"CCCD";
  if ([self.UUID.UUIDString isEqualTo:CBUUIDServerCharacteristicConfigurationString])
    return @"SCCD";
  if ([self.UUID.UUIDString isEqualTo:CBUUIDCharacteristicFormatString])
    return @"Format";
  if ([self.UUID.UUIDString isEqualTo:CBUUIDCharacteristicAggregateFormatString])
    return @"Aggregate format";
  [NSException raise:@"Invalid type" format:@"Descriptor UUID %@ is invalid", self.UUID];
  return nil;
}

@end
