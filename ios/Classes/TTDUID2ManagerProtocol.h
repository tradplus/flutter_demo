

@protocol TTDUID2ManagerProtocol <NSObject>
@optional

- (void)startWithCallback:(void (^_Nullable)( NSError * _Nullable error))callback;
- (void)resetSetting;
@property (nonatomic,strong)NSString *_Nullable email;
@property (nonatomic,strong)NSString *_Nullable emailHash;
@property (nonatomic,strong)NSString *_Nullable phone;
@property (nonatomic,strong)NSString *_Nullable phoneHash;
@property (nonatomic,strong)NSString *_Nullable subscriptionID;
@property (nonatomic,strong)NSString *_Nullable serverPublicKey;
@property (nonatomic,strong)NSString *_Nullable appName;

@property (nonatomic,assign)BOOL isTestMode;
@property (nonatomic,strong)NSString *_Nullable customURLString;

@end
