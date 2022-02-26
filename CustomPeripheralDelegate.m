#import "CustomPeripheralDelegate.h"
#import "Utils.h"

@implementation CustomPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  if (error) {
    NSLog(@"ERROR updating notification state: %@", error);
    return;
  }
  NSLog(@"Subscribed to characteristic %@", characteristic.UUID);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  if (error) {
    NSLog(@"ERROR writing value: %@", error);
    return;
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  if (error) {
    NSLog(@"ERROR updating value: %@", error);
    return;
  }
  NSLog(@"Updated characteristic %@", characteristic.UUID);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  if (error) {
    NSLog(@"ERROR discovering services: %@", error);
    return;
  }
  
  for (CBService *service in peripheral.services) {
    [peripheral discoverCharacteristics:nil forService:service];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  if (error) {
    NSLog(@"ERROR discovering characteristic for service: %@", error);
    return;
  }

  // NSLog(@"Service %@", service);
  int i = 0;
  for (CBCharacteristic *characteristic in service.characteristics) {
    i++;
    if ([characteristic isReadable]) {
      [peripheral readValueForCharacteristic:characteristic];
    }
    if ([characteristic hasNotification]) {
      [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
    // NSLog(@"%d:\t%@", i, characteristic);
    // NSLog(@"\tPermissions: %@", [CustomPeripheralDelegate getCharacteristicPermissions:characteristic]);
    [peripheral discoverDescriptorsForCharacteristic:characteristic];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  if (error) {
    NSLog(@"ERROR discovering descriptor for characteristic: %@", error);
    return;
  }

  // NSLog(@"Characteristic %@", characteristic);
  int i = 0;
  for (CBDescriptor *descriptor in characteristic.descriptors) {
     i++;
     // NSLog(@"%d: %@", i, descriptor);
     [peripheral readValueForDescriptor:descriptor];
  }
  // }
  // NSLog(@"\n");
}

@end
