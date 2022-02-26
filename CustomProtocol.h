@protocol CustomProtocol <NSObject>

@required
- (void)didConnectToDesk:(CBPeripheral *)desk;
- (void)didFailToConnectToDesk:(CBPeripheral *)desk error:(NSError *)error;

@end
