/**
 * Netbottom: A nettop(1) clone without the curses that are curses.
 * ----------
 *
 * Jonathan Levin, http://NewOSXBook.com/
 *
 * This is a simple program meant to accompany the bonus networking chapter I'm putting
 * into MOXiI 2 Volume I (read http://NewOSXBook.com/ChangeLog.html for the story behind that)
 *
 * This is essentially doing what my old lsock(j) did, but I no longer maintain lsock because
 * A) AAPL keeps breaking the APIs with every single version and B) some people have closed source
 * my sample and actually started selling it!
 *
 * The advantage in this example is that it's using the private NetworkStatistics.framework, so that
 * hides all the underlying com.apple.network.statistics #%$@#% that keeps breaking on me.
 *
 *
 * Variables:
 *
 *     JCOLOR = 0 to disable color (which is on by default)
 *     RESOLV = 1 to add DNS resolving (may be slower)
 *
 * This compiles on both MacOS and iOS cleanly:
 *  To compile for MacOS:
 *     gcc netbottom.c -o /tmp/netbottom.x86 -framework CoreFoundation -framework NetworkStatistics   -framework CoreFoundation -F /System/Library/PrivateFrameworks
 *
 *
 * To compile on *OS you'll first need to create the "tbd" file for NetworkStatistics, since it's a private framework and there
 * are no TBDs for it. You'll need to first use jtool's --tbd option (in Alpha 4 and later) on the dyld_shared_cache_arm64, like so:
 *
 *
 * mkdir -p /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/PrivateFrameworks/NetworkStatistics.framework/
 *
 * jtool2 --tbd /Volumes/PeaceB16B92.N102OS/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64:NetworkStatistics \
 *     > /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/PrivateFrameworks/NetworkStatistics.framework/NetworkStatistics.tbd
 *
 * and then,
 *
 *     gcc-arm64  netbottom.c -o /tmp/netbottom.x86 -framework CoreFoundation -framework NetworkStatistics   -framework CoreFoundation -F /System/Library/PrivateFrameworks
 *
 * On iOS you'll also need an entitlement
 
 <pre>
 #if 0
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
 <key>com.apple.private.network.statistics</key>
 <true/>
 <key>platform-application</key>
 <true/>
 </dict>
 </plist>
 #endif
 </pre>
 
 * and/or sysctl net.statistics_privcheck=0
 *
 
 
 *
 *
 * PoC ONLY. There is a LOT that can be fixed here - for one, DNS lookups in main queue may block for a long while!
 *           also because I don't listen on events I don't get all the TCP state changes.
 *
 * License: FREE, ABSE, But again - if you plan on close sourcing this, it would be nice if you A) let me know and B) give credit
 * where due (That means AAPL, for awesome (though Block-infested) APIs, and this sample.
 *
 */



// The missing NetworkStatistics.h...
typedef void     *NStatManagerRef;
typedef void     *NStatSourceRef;

NStatManagerRef    NStatManagerCreate (const struct __CFAllocator *,
                                       dispatch_queue_t,
                                       void (^)(void *, void *));

int NStatManagerSetInterfaceTraceFD(NStatManagerRef, int fd);
int NStatManagerSetFlags(NStatManagerRef, int Flags);
int NStatManagerAddAllTCPWithFilter(NStatManagerRef, int something, int somethingElse);
int NStatManagerAddAllUDPWithFilter(NStatManagerRef, int something, int somethingElse);
void *NStatSourceQueryDescription(NStatSourceRef);

void NStatManagerDestroy(void *manager);

void NStatSourceSetCountsBlock(void *source, void (^)(CFDictionaryRef));
void NStatSourceSetDescriptionBlock(void *source, void (^)(CFDictionaryRef));

void NStatManagerAddAllTCP(void *manager);
void NStatManagerAddAllUDP(void *manager);


extern CFStringRef kNStatProviderInterface;
extern CFStringRef kNStatProviderRoute;
extern CFStringRef kNStatProviderSysinfo;
extern CFStringRef kNStatProviderTCP;
extern CFStringRef kNStatProviderUDP;
extern CFStringRef kNStatSrcKeyAvgRTT;
extern CFStringRef kNStatSrcKeyChannelArchitecture;
extern CFStringRef kNStatSrcKeyConnProbeFailed;
extern CFStringRef kNStatSrcKeyConnectAttempt;
extern CFStringRef kNStatSrcKeyConnectSuccess;
extern CFStringRef kNStatSrcKeyDurationAbsoluteTime;
extern CFStringRef kNStatSrcKeyEPID;
extern CFStringRef kNStatSrcKeyEUPID;
extern CFStringRef kNStatSrcKeyEUUID;
extern CFStringRef kNStatSrcKeyInterface;
extern CFStringRef kNStatSrcKeyInterfaceCellConfigBackoffTime;
extern CFStringRef kNStatSrcKeyInterfaceCellConfigInactivityTime;
extern CFStringRef kNStatSrcKeyInterfaceCellUlAvgQueueSize;
extern CFStringRef kNStatSrcKeyInterfaceCellUlMaxQueueSize;
extern CFStringRef kNStatSrcKeyInterfaceCellUlMinQueueSize;
extern CFStringRef kNStatSrcKeyInterfaceDescription;
extern CFStringRef kNStatSrcKeyInterfaceDlCurrentBandwidth;
extern CFStringRef kNStatSrcKeyInterfaceDlMaxBandwidth;
extern CFStringRef kNStatSrcKeyInterfaceIsAWD;
extern CFStringRef kNStatSrcKeyInterfaceIsAWDL;
extern CFStringRef kNStatSrcKeyInterfaceIsCellFallback;
extern CFStringRef kNStatSrcKeyInterfaceIsExpensive;
extern CFStringRef kNStatSrcKeyInterfaceLinkQualityMetric;
extern CFStringRef kNStatSrcKeyInterfaceName;
extern CFStringRef kNStatSrcKeyInterfaceThreshold;
extern CFStringRef kNStatSrcKeyInterfaceType;
extern CFStringRef kNStatSrcKeyInterfaceTypeCellular;
extern CFStringRef kNStatSrcKeyInterfaceTypeLoopback;
extern CFStringRef kNStatSrcKeyInterfaceTypeUnknown;
extern CFStringRef kNStatSrcKeyInterfaceTypeWiFi;
extern CFStringRef kNStatSrcKeyInterfaceTypeWired;
extern CFStringRef kNStatSrcKeyInterfaceUlBytesLost;
extern CFStringRef kNStatSrcKeyInterfaceUlCurrentBandwidth;
extern CFStringRef kNStatSrcKeyInterfaceUlEffectiveLatency;
extern CFStringRef kNStatSrcKeyInterfaceUlMaxBandwidth;
extern CFStringRef kNStatSrcKeyInterfaceUlMaxLatency;
extern CFStringRef kNStatSrcKeyInterfaceUlMinLatency;
extern CFStringRef kNStatSrcKeyInterfaceUlReTxtLevel;
extern CFStringRef kNStatSrcKeyInterfaceWifiConfigFrequency;
extern CFStringRef kNStatSrcKeyInterfaceWifiConfigMulticastRate;
extern CFStringRef kNStatSrcKeyInterfaceWifiDlEffectiveLatency;
extern CFStringRef kNStatSrcKeyInterfaceWifiDlErrorRate;
extern CFStringRef kNStatSrcKeyInterfaceWifiDlMaxLatency;
extern CFStringRef kNStatSrcKeyInterfaceWifiDlMinLatency;
extern CFStringRef kNStatSrcKeyInterfaceWifiScanCount;
extern CFStringRef kNStatSrcKeyInterfaceWifiScanDuration;
extern CFStringRef kNStatSrcKeyInterfaceWifiUlErrorRate;
extern CFStringRef kNStatSrcKeyLocal;
extern CFStringRef kNStatSrcKeyMinRTT;
extern CFStringRef kNStatSrcKeyPID;
extern CFStringRef kNStatSrcKeyProbeActivated;
extern CFStringRef kNStatSrcKeyProcessName;
extern CFStringRef kNStatSrcKeyProvider;
extern CFStringRef kNStatSrcKeyRcvBufSize;
extern CFStringRef kNStatSrcKeyRcvBufUsed;
extern CFStringRef kNStatSrcKeyReadProbeFailed;
extern CFStringRef kNStatSrcKeyRemote;
extern CFStringRef kNStatSrcKeyRouteDestination;
extern CFStringRef kNStatSrcKeyRouteFlags;
extern CFStringRef kNStatSrcKeyRouteGateway;
extern CFStringRef kNStatSrcKeyRouteGatewayID;
extern CFStringRef kNStatSrcKeyRouteID;
extern CFStringRef kNStatSrcKeyRouteMask;
extern CFStringRef kNStatSrcKeyRouteParentID;
extern CFStringRef kNStatSrcKeyRxBytes;
extern CFStringRef kNStatSrcKeyRxCellularBytes;
extern CFStringRef kNStatSrcKeyRxDupeBytes;
extern CFStringRef kNStatSrcKeyRxOOOBytes;
extern CFStringRef kNStatSrcKeyRxPackets;
extern CFStringRef kNStatSrcKeyRxWiFiBytes;
extern CFStringRef kNStatSrcKeyRxWiredBytes;
extern CFStringRef kNStatSrcKeySndBufSize;
extern CFStringRef kNStatSrcKeySndBufUsed;
extern CFStringRef kNStatSrcKeyStartAbsoluteTime;
extern CFStringRef kNStatSrcKeyTCPCCAlgorithm;
extern CFStringRef kNStatSrcKeyTCPState;
extern CFStringRef kNStatSrcKeyTCPTxCongWindow;
extern CFStringRef kNStatSrcKeyTCPTxUnacked;
extern CFStringRef kNStatSrcKeyTCPTxWindow;
extern CFStringRef kNStatSrcKeyTrafficClass;
extern CFStringRef kNStatSrcKeyTrafficMgtFlags;
extern CFStringRef kNStatSrcKeyTxBytes;
extern CFStringRef kNStatSrcKeyTxCellularBytes;
extern CFStringRef kNStatSrcKeyTxPackets;
extern CFStringRef kNStatSrcKeyTxReTx;
extern CFStringRef kNStatSrcKeyTxWiFiBytes;
extern CFStringRef kNStatSrcKeyTxWiredBytes;
extern CFStringRef kNStatSrcKeyUPID;
extern CFStringRef kNStatSrcKeyUUID;
extern CFStringRef kNStatSrcKeyVUUID;
extern CFStringRef kNStatSrcKeyVarRTT;
extern CFStringRef kNStatSrcKeyWriteProbeFailed;
extern CFStringRef kNStatSrcTCPStateCloseWait;
extern CFStringRef kNStatSrcTCPStateClosed;
extern CFStringRef kNStatSrcTCPStateClosing;
extern CFStringRef kNStatSrcTCPStateEstablished;
extern CFStringRef kNStatSrcTCPStateFinWait1;
extern CFStringRef kNStatSrcTCPStateFinWait2;
extern CFStringRef kNStatSrcTCPStateLastAck;
extern CFStringRef kNStatSrcTCPStateListen;
extern CFStringRef kNStatSrcTCPStateSynReceived;
extern CFStringRef kNStatSrcTCPStateSynSent;
extern CFStringRef kNStatSrcTCPStateTimeWait;


@interface NWStatisticsManager : NSObject
{}

- (BOOL)addAllUDP:(unsigned long long)arg1;
- (BOOL)addAllTCP:(unsigned long long)arg1;

@end

@protocol NWStatisticsSourceDelegate <NSObject>

@optional
-(void)sourceDidReceiveDescription:(id)arg1;
-(void)sourceDidReceiveCounts:(id)arg1;

@end

@interface NWStatisticsSource : NSObject {
    unsigned long long _countsSeqno;
    NSObject<NWStatisticsSourceDelegate> * _delegate;
    unsigned long long _descriptorSeqno;
    unsigned int  _filter;
    struct nstat_counts {
        unsigned long long nstat_rxpackets;
        unsigned long long nstat_rxbytes;
        unsigned long long nstat_txpackets;
        unsigned long long nstat_txbytes;
        unsigned long long nstat_cell_rxbytes;
        unsigned long long nstat_cell_txbytes;
        unsigned long long nstat_wifi_rxbytes;
        unsigned long long nstat_wifi_txbytes;
        unsigned long long nstat_wired_rxbytes;
        unsigned long long nstat_wired_txbytes;
        unsigned int nstat_rxduplicatebytes;
        unsigned int nstat_rxoutoforderbytes;
        unsigned int nstat_txretransmit;
        unsigned int nstat_connectattempts;
        unsigned int nstat_connectsuccesses;
        unsigned int nstat_min_rtt;
        unsigned int nstat_avg_rtt;
        unsigned int nstat_var_rtt;
    } _last_counts;
    NWStatisticsManager * _manager;
    unsigned int _provider;
    unsigned long long _reference;
    bool _removing;
}

@property (readonly) const struct nstat_counts _counts;
@property (readonly) long long connectAttempts;
@property (readonly) long long connectSuccesses;
@property (nonatomic, readonly, copy) NSDictionary *counts;
@property (retain) NSObject<NWStatisticsSourceDelegate> *delegate;
@property bool hasCounts;
@property bool hasDescriptor;
@property bool hasNewKernelInfo;
@property (readonly) NWStatisticsManager *manager;
@property unsigned long long reference;
@property (getter=isRemoved) bool removed;
@property bool removing;
@property (readonly) double rttAverage;
@property (readonly) double rttMinimum;
@property (readonly) double rttVariation;
@property (readonly) unsigned long long rxBytes;
@property (readonly) unsigned long long rxCellularBytes;
@property (readonly) long long rxDuplicateBytes;
@property (readonly) long long rxOutOfOrderBytes;
@property (readonly) unsigned long long rxPackets;
@property (readonly) unsigned long long rxWiFiBytes;
@property (readonly) unsigned long long rxWiredBytes;
@property (readonly) unsigned long long txBytes;
@property (readonly) unsigned long long txCellularBytes;
@property (readonly) unsigned long long txPackets;
@property (readonly) long long txRetransmittedBytes;
@property (readonly) unsigned long long txWiFiBytes;
@property (readonly) unsigned long long txWiredBytes;

@end

@protocol NWStatisticsManagerDelegate <NSObject>

@optional
- (void)statisticsManager:(NWStatisticsManager *)mgr didReceiveDirectSystemInformation:(NSDictionary *)info;
- (void)statisticsManager:(NWStatisticsManager *)mgr didRemoveSource:(NWStatisticsSource *)source;
- (void)statisticsManager:(NWStatisticsManager *)mgr didAddSource:(NWStatisticsSource *)source;
@end


CFStringRef NStatSourceCopyProperty(NStatSourceRef, CFStringRef);
void NStatSourceSetDescriptionBlock(NStatSourceRef arg, void (^)(CFDictionaryRef));
void NStatSourceSetRemovedBlock(NStatSourceRef arg, void (^)(void));
void NStatSourceSetEventsBlock(NStatSourceRef arg, void (^)(NWStatisticsSource *src));

/// End NetworkStatistics.h
