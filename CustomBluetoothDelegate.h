#import <CoreBluetooth/CoreBluetooth.h>
#import "CustomPeripheralDelegate.h"
#import "CustomProtocol.h"

@interface CustomBluetoothDelegate : NSObject <CBCentralManagerDelegate>

- (id)initWithDelegator:(id)delegator;
- (void)startScanWithCentralManager:(CBCentralManager *)central;
- (void)stopScanWithCentralManager:(CBCentralManager *)central;
- (void)connectToDeskWithCentralManager:(CBCentralManager *)central;

@end

@interface CustomBluetoothDelegate () 

@property (readwrite, weak) id<CustomProtocol> delegator;
@property (readwrite) NSMutableArray *peripherals;
@property (readwrite) CBPeripheral *desk;

@end
