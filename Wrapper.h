#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "CustomBluetoothDelegate.h"
#import "CustomBluetoothDelegate+Utils.h"
#import "CustomProtocol.h"
#import "Utils.h"

@interface Wrapper : NSObject <CustomProtocol>

- (id)init;
- (void)run;
- (void)fileHandleReadCompletion:(NSNotification *)notification;

@end

@interface Wrapper () {
  BOOL shouldKeepRunning;
}

@property (readwrite) NSFileHandle *stdIn;
@property (readwrite) CBCentralManager *bluetoothManager;
@property (readwrite) CBPeripheral *desk;
@property (readwrite) CustomBluetoothDelegate *bluetoothDelegate;
@property (readwrite) CustomPeripheralDelegate *deskDelegate;

- (void)startBluetooth;
- (void)quit;
- (void)dumpDetails;
- (void)experiment:(int)val;
- (void)rereadValues;
- (void)rediscoverServices;
- (void)writeValue:(NSData *)data service:(unsigned)serviceNumber characteristic:(unsigned)characteristicNumber;

@end
