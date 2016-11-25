#ifdef __OBJC__
#import <UIKit/UIKit.h>
#endif

#import "CDEBaselineConsolidator.h"
#import "CDERebaser.h"
#import "CDEFileDownloadOperation.h"
#import "CDEFileUploadOperation.h"
#import "CDEICloudFileSystem.h"
#import "CDELocalCloudFileSystem.h"
#import "CDECloudDirectory.h"
#import "CDECloudFile.h"
#import "CDECloudFileSystem.h"
#import "CDECloudManager.h"
#import "CDEEventFile.h"
#import "CDEPersistentStoreEnsemble.h"
#import "CDEPersistentStoreImporter.h"
#import "CDEEventBuilder.h"
#import "CDEEventIntegrator.h"
#import "CDEEventMigrator.h"
#import "CDEEventStore.h"
#import "CDEPropertyChangeValue.h"
#import "CDESaveMonitor.h"
#import "CDEAsynchronousOperation.h"
#import "CDEAsynchronousTaskQueue.h"
#import "CDEAvailabilityMacros.h"
#import "CDEDefines.h"
#import "CDEFoundationAdditions.h"
#import "Ensembles.h"
#import "NSFileCoordinator+CDEAdditions.h"
#import "NSManagedObjectModel+CDEAdditions.h"
#import "NSMapTable+CDEAdditions.h"
#import "CDEDataFile.h"
#import "CDEEventRevision.h"
#import "CDEGlobalIdentifier.h"
#import "CDEObjectChange.h"
#import "CDEStoreModificationEvent.h"
#import "CDERevision.h"
#import "CDERevisionManager.h"
#import "CDERevisionSet.h"

FOUNDATION_EXPORT double EnsemblesVersionNumber;
FOUNDATION_EXPORT const unsigned char EnsemblesVersionString[];

