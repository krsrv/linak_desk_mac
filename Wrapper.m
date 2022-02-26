#import "Wrapper.h"
#import "Wrapper+Parser.h"
#import "Utils.h"

@implementation Wrapper

- (id)init {
  NSLog(@"Starting up...");

  // Set up an interactive shell:
  // https://stackoverflow.com/questions/4610641/stop-nsrunloop-on-keypress
  _stdIn = [[NSFileHandle fileHandleWithStandardInput] retain];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
      selector:@selector(fileHandleReadCompletion:)
      name:NSFileHandleReadCompletionNotification
      object:_stdIn];
  [[NSFileHandle fileHandleWithStandardInput] readInBackgroundAndNotify];
  
  shouldKeepRunning = YES;
  return self;
}

- (void)run {
  while (shouldKeepRunning && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)startBluetooth {
  self.bluetoothDelegate = [[CustomBluetoothDelegate alloc] initWithDelegator:self];
  self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self.bluetoothDelegate queue:dispatch_get_main_queue()];

  NSLog(@"Bluetooth manager initial state - %@", [CustomBluetoothDelegate getManagerStateString:self.bluetoothManager]);
  NSLog(@"Bluetooth auth initial state - %@", [CustomBluetoothDelegate getAuthStateString:self.bluetoothManager]);
}

- (void)quit {
  [self.stdIn closeFile];
  [self.stdIn release];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  shouldKeepRunning = NO;
}

- (void)fileHandleReadCompletion:(NSNotification *)notification {
  NSData *data = [[notification userInfo]
                    objectForKey:NSFileHandleNotificationDataItem];
  NSString *string = [[[NSString alloc]
                        initWithData:data
                        encoding:NSUTF8StringEncoding] autorelease];
  if (string) {
    string = [string stringByTrimmingCharactersInSet:
      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self parseStringInput:string];
  }
}

- (void)didConnectToDesk:(CBPeripheral *)desk {
  NSLog(@"Connnected to desk %@", desk.name);
  self.desk = desk;
  self.deskDelegate = [[CustomPeripheralDelegate alloc] init];
  [self.desk setDelegate:self.deskDelegate];
  [self.desk discoverServices:nil];
}

- (void)didFailToConnectToDesk:(CBPeripheral *)peripheral error:(NSError *)error {
  NSLog(@"Failed to connect to desk. Error: %@", error);
  if (peripheral) {
    NSLog(@"Probably connected to other device %@", peripheral.name);
  }
}

- (void)dumpDetails {
  if (!self.desk) {
    NSLog(@"Need to connect with desk first");
    return;
  }

  int i = 0;
  CBPeripheral *peripheral = self.desk;
  for (CBService *service in peripheral.services) {
    i++;
    //NSLog(@"Service %d (%@)", i, service.UUID);
    int j = 0;
    for (CBCharacteristic *characteristic in service.characteristics) {
      j++;
      //NSLog(@"\tCharacteristic %d (%@): %@ (permissions: %@)", j, characteristic.UUID, characteristic.value, [characteristic getStringifiedPermissions]);
      NSLog(@"%d.%d: %@ (%@, %@)", i, j, characteristic.value, characteristic.UUID, [characteristic getStringifiedPermissions]);
      for (CBDescriptor *descriptor in characteristic.descriptors) {
        if ([descriptor.UUID.UUIDString isEqualTo:CBUUIDClientCharacteristicConfigurationString]) {
          continue;
        }
        NSString *valueString = [[NSString alloc] initWithData:descriptor.value encoding:NSUTF8StringEncoding];
        NSLog(@"\t%@: %@ (%@)", [descriptor getType], valueString, descriptor.value);
      }
      NSString *readableString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
      if (readableString) {
        //NSLog(@"\t\t%@", readableString);
      }
    }
  }
}

- (void)rereadValues {
  if (!self.desk) {
    NSLog(@"Need to connect with desk first");
    return;
  }

  CBPeripheral *peripheral = self.desk;
  for (CBService *service in peripheral.services) {
    for (CBCharacteristic *characteristic in service.characteristics) {
      if ([characteristic isReadable]) {
        [peripheral readValueForCharacteristic:characteristic];
      }
      for (CBDescriptor *descriptor in characteristic.descriptors) {
        [peripheral readValueForDescriptor:descriptor];
      }
    }
  }
}

- (void)rediscoverServices {
  if (!self.desk) {
    NSLog(@"Need to connect with desk first");
  }
  [self.desk discoverServices:nil];
}

- (void)writeValue:(NSData *)data service:(unsigned)serviceNumber characteristic:(unsigned)characteristicNumber {
  if (!self.desk) {
    NSLog(@"Need to connect with desk first");
    return;
  }

  CBPeripheral *peripheral = self.desk;
  if ([peripheral.services count] < serviceNumber) {
    NSLog(@"Index supplied is greater than number of services in peripheral");
    return;
  }
  CBService *service = peripheral.services[serviceNumber - 1];
  if ([service.characteristics count] < characteristicNumber) {
    NSLog(@"Index supplied is greater than number of characteristics in service");
    return;
  }
  CBCharacteristic *characteristic = service.characteristics[characteristicNumber - 1];
  if (![characteristic isWritable]) {
    NSLog(@"WARNING: Not a writable characteristic");
    //return;
  }

  NSLog(@"Sending %@ to characteristic %@", data, characteristic.UUID);
  [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)experiment:(int)val {
  //NSArray *indices = @[@1, @0, @0, @0, @4, @0, @4, @1, @4, @2, @4, @3];
  CBPeripheral *peripheral = self.desk;
  //for (int i = 0; i < [indices count]/2; i++) {
  //  int si = [indices[2*i] integerValue], ci = [indices[2*i+1] integerValue];
    int si = 0, ci = 0;
    CBCharacteristic *characteristic = peripheral.services[si].characteristics[ci];
    //const unsigned char j[] = {val, 0};
    const char j[] = {val};
    NSData *data = [NSData dataWithBytes:j length:sizeof(j)];
    NSLog(@"Sending %@ to characteristic %@", data, characteristic.UUID);
    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  //}
}
@end
