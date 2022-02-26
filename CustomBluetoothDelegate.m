#import "CustomBluetoothDelegate.h"
#import "CustomBluetoothDelegate+Utils.h"

#import "CustomPeripheralDelegate.h"
#import "CustomProtocol.h"
#import "Utils.h"
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@implementation CustomBluetoothDelegate 

- (CustomBluetoothDelegate *)init {
  return [self initWithDelegator:nil];
}

- (CustomBluetoothDelegate *)initWithDelegator:(id)delegator {
  [super init];
  _delegator = delegator;
  return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  NSLog(@"State update: %@", [CustomBluetoothDelegate getManagerStateString:central]);
  if (central.state == CBManagerStatePoweredOn) {
    [self startScanWithCentralManager:central];
  }
  else if (central.isScanning) {
    [self stopScanWithCentralManager:central];
  }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
  if (!self.peripherals) {
    self.peripherals = [[NSMutableArray alloc] init];
  }
  [self.peripherals addObject:peripheral];
  NSLog(@"Found device: \"%@\" with advertisement %@, strength %@", peripheral.name, advertisementData, RSSI);

  if ([peripheral.name isEqual:@"DESK 6606"]) {
    [self initializeDesk];
    [self connectToDeskWithCentralManager:central];
    [self stopScanWithCentralManager:central];
  }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  if (self.desk != peripheral) {
    [self.delegator didFailToConnectToDesk:peripheral error:[NSError errorWithDomain:@"Established connection to another device" code:1 userInfo:nil]];
  } else {
    [self.delegator didConnectToDesk:peripheral];
  }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  NSLog(@"Failed to connect to %@", [peripheral name]);
  NSLog(@"%@", error);
}
  
- (void)startScanWithCentralManager:(CBCentralManager *)central {
  NSLog(@"Starting scan");
  [central scanForPeripheralsWithServices:nil options:@{
    CBCentralManagerScanOptionAllowDuplicatesKey:@NO
  }];
  // TODO: Add a timer to call the stopScan method
}

- (void)stopScanWithCentralManager:(CBCentralManager *)central {
  if (!central.isScanning) {
    return;
  }
  NSLog(@"Stopping scan");
  [central stopScan];
}

- (void)connectToDeskWithCentralManager:(CBCentralManager *)central {
  if (!self.desk) {
    return;
  }
  NSLog(@"Connecting to desk %@", [self.desk name]);
  [central connectPeripheral:self.desk options:@{
    CBConnectPeripheralOptionNotifyOnNotificationKey: @YES
  }];
}

- (void)initializeDesk {
  self.desk = [self.peripherals lastObject];
  NSLog(@"Storing %@ as desk", [self.desk name]);
}

@end
