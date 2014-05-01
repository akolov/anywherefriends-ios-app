//
//  AWFSession.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 13/10/13.
//  Copyright (c) 2013 Anywherefriends. All rights reserved.
//

@import CoreData;
@import ObjectiveC.message;
@import ObjectiveC.runtime;

#import "AWFConfig.h"
#import "AWFSession.h"

#import <AFNetworking/AFNetworking.h>
#import <AXKRACExtensions/AFHTTPClient+AXKRACExtensions.h>
#import <AXKRACExtensions/RKObjectManager+AXKRACExtensions.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RestKit/RestKit.h>

#import "AWFActivity.h"
#import "AWFClient.h"
#import "AWFActivity+RestKit.h"
#import "AWFPerson+RestKit.h"
#import "NSManagedObject+RestKit.h"

@interface AWFSession ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *currentUserID;

@end

@implementation AWFSession

#pragma mark - Properties

+ (void)initialize {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (self != [AWFSession class]) {
      return;
    }

    // Initialize RestKit

    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:[AWFClient sharedClient]];
    [RKObjectManager setSharedManager:manager];

    // Initialize managed object store

    NSArray *bundles = @[[NSBundle bundleForClass:[self class]]];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:bundles];
    RKManagedObjectStore *objectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:model];
    manager.managedObjectStore = objectStore;
    [RKManagedObjectStore setDefaultStore:objectStore];

    // Response descriptors

    [manager addResponseDescriptorsFromArray:[AWFActivity responseDescriptors]];
    [manager addResponseDescriptorsFromArray:[AWFPerson responseDescriptors]];

    // Request descriptors

    [manager addRequestDescriptorsFromArray:[AWFActivity requestDescriptors]];
    [manager addRequestDescriptorsFromArray:[AWFPerson requestDescriptors]];

    // Core Data stack initialization

    [objectStore createPersistentStoreCoordinator];
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:AWFPersistentStoreName];

    BOOL stop = NO;
    NSPersistentStore *persistentStore;

    while (!stop) {
      NSError *error;

      NSDictionary *pragmaOptions = @{@"synchronous": @"NORMAL", @"journal_mode": @"WAL"};
      NSDictionary *storeOptions = @{NSSQLitePragmasOption: pragmaOptions,
                                     NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                     NSInferMappingModelAutomaticallyOption: @(YES)};
      persistentStore = [objectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil
                                                  withConfiguration:nil options:storeOptions error:&error];

      if (persistentStore) {
        stop = YES;
      }
      else {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
          if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
            ErrorLog(error.localizedDescription);
            stop = YES;
          }
        }
        else {
          stop = YES;
        }
      }
    }

    // Create the managed object contexts
    [objectStore createManagedObjectContexts];

    // Configure a managed object cache to ensure we do not create duplicate objects
    NSManagedObjectContext *context = objectStore.persistentStoreManagedObjectContext;
    objectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:context];

    // Fetch request blocks

    [manager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
      RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:AWFAPIPathUserActivity];

      BOOL match = [pathMatcher matchesPath:[URL relativeString] tokenizeQueryStrings:NO parsedArguments:NULL];
      if (match) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[AWFActivity entityName]];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]];
        fetchRequest.includesPropertyValues = NO;
        fetchRequest.includesSubentities = NO;
        return fetchRequest;
      }

      return nil;
    }];

    [manager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
      RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:AWFAPIPathUsers];
      NSDictionary *args;

      BOOL match = [pathMatcher matchesPath:[URL relativeString] tokenizeQueryStrings:YES parsedArguments:&args];
      if (match) {
        NSString *radius = args[@"r"];

        if (!radius) {
          return nil;
        }

        NSString *currentUserID = [AWFSession sharedSession].currentUserID;
        NSArray *subpredicates = @[[NSPredicate predicateWithFormat:@"personID != %@", currentUserID],
                                   [NSPredicate predicateWithFormat:@"friendship == %d", AWFFriendshipStatusNone],
                                   [NSPredicate predicateWithFormat:@"locationDistance <= %f", [radius doubleValue]]];

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[AWFPerson entityName]];
        fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationDistance" ascending:YES]];
        fetchRequest.includesPropertyValues = NO;
        fetchRequest.includesSubentities = NO;

        return fetchRequest;
      }
      
      return nil;
    }];

    [manager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
      RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:AWFAPIPathUserFriends];

      BOOL match = [pathMatcher matchesPath:[URL relativeString] tokenizeQueryStrings:NO parsedArguments:NULL];
      if (match) {
        NSString *currentUserID = [AWFSession sharedSession].currentUserID;
        NSArray *subpredicates = @[[NSPredicate predicateWithFormat:@"personID != %@", currentUserID],
                                   [NSPredicate predicateWithFormat:@"friendship != %d", AWFFriendshipStatusNone]];

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[AWFPerson entityName]];
        fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
        fetchRequest.includesPropertyValues = NO;
        fetchRequest.includesSubentities = NO;

        return fetchRequest;
      }
      
      return nil;
    }];
  });
}

+ (instancetype)sharedSession {
  static AWFSession *session;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    session = [[AWFSession alloc] init];
  });
  return session;
}

+ (BOOL)hasSessionCookie {
  NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.baseURL];
  for (NSHTTPCookie *cookie in cookies) {
    if ([cookie.name isEqualToString:@"sid"] &&
        cookie.value.length > 0 &&
        [cookie.expiresDate compare:[NSDate date]] == NSOrderedDescending) {
      return YES;
    }
  }
  return NO;
}

+ (BOOL)isLoggedIn {
  return self.hasSessionCookie;
}

+ (NSURL *)baseURL {
  return [NSURL URLWithString:AWFAPIBaseURL];
}

+ (NSManagedObjectContext *)managedObjectContext {
  return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _currentUserID = [[NSUserDefaults standardUserDefaults] stringForKey:AWFUserDefaultsCurrentUserIDKey];
  }
  return self;
}

#pragma mark - Accessors

- (void)setCurrentUserID:(NSString *)currentUserID {
  if ([_currentUserID isEqualToString:currentUserID]) {
    return;
  }

  _currentUserID = currentUserID;
  _fetchedResultsController = nil;

  [[NSUserDefaults standardUserDefaults] setValue:currentUserID forKey:AWFUserDefaultsCurrentUserIDKey];
}

- (AWFPerson *)currentUser {
  return [self.fetchedResultsController.fetchedObjects lastObject];
}

- (NSFetchedResultsController *)fetchedResultsController {
  if (!self.currentUserID) {
    return nil;
  }

  if (!_fetchedResultsController) {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[AWFPerson entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"personID == %@", self.currentUserID];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"personID" ascending:NO]];
    request.includesPropertyValues = YES;
    request.includesSubentities = YES;
    request.fetchLimit = 1;

    _fetchedResultsController =
      [[NSFetchedResultsController alloc]
       initWithFetchRequest:request managedObjectContext:[AWFSession managedObjectContext]
       sectionNameKeyPath:nil cacheName:nil];

    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
      ErrorLog(error.localizedDescription);
    }
  }
  return _fetchedResultsController;
}

#pragma mark - Login and Signup

- (RACSignal *)createUserWithEmail:(NSString *)email
                          password:(NSString *)password
                         firstName:(NSString *)firstname
                          lastName:(NSString *)lastname
                            gender:(NSString *)gender
                     facebookToken:(NSString *)facebookToken
                      twitterToken:(NSString *)twitterToken
                           vkToken:(NSString *)vkToken {

  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  [parameters setValue:email forKey:AWFURLParameterEmail];
  [parameters setValue:password forKey:AWFURLParameterPassword];
  [parameters setValue:firstname forKey:AWFURLParameterFirstName];
  [parameters setValue:lastname forKey:AWFURLParameterLastName];
  [parameters setValue:gender forKey:AWFURLParameterGender];
  [parameters setValue:facebookToken forKey:AWFURLParameterFacebookToken];
  [parameters setValue:twitterToken forKey:AWFURLParameterTwitterToken];
  [parameters setValue:vkToken forKey:AWFURLParameterVKToken];

  @weakify(self);
  return [[[RKObjectManager sharedManager] rac_postObject:nil path:AWFAPIPathUser parameters:parameters]
          map:^id(RACTuple *x) {
            @strongify(self);
            self.currentUserID = [[x.second firstObject] personID];
            return self.currentUser;
          }];
}

- (RACSignal *)openSessionWithEmail:(NSString *)email password:(NSString *)password {

  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  [parameters setValue:email forKey:AWFURLParameterEmail];
  [parameters setValue:password forKey:AWFURLParameterPassword];

  @weakify(self);
  return [[[[AWFClient sharedClient] rac_postPath:AWFAPIPathLogin parameters:parameters]
           then:^RACSignal *{
             return [self getUserSelf];
           }]
          map:^id(AWFPerson *person) {
            @strongify(self);
            self.currentUserID = person.personID;
            [[NSNotificationCenter defaultCenter] postNotificationName:AWFUserDidLoginNotification object:self.currentUser];
            return self.currentUser;
          }];
}

- (RACSignal *)openSessionWithFacebookToken:(NSString *)facebookToken {

  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  [parameters setValue:facebookToken forKey:AWFURLParameterFacebookToken];

  @weakify(self);
  return [[[[AWFClient sharedClient] rac_postPath:AWFAPIPathLogin parameters:parameters]
           then:^RACSignal *{
             return [self getUserSelf];
           }]
          map:^id(AWFPerson *person) {
            @strongify(self);
            self.currentUserID = person.personID;
            [[NSNotificationCenter defaultCenter] postNotificationName:AWFUserDidLoginNotification object:self.currentUser];
            return self.currentUser;
          }];
}

- (RACSignal *)closeSession {
  @weakify(self);
  RACSignal *signal = [[AWFClient sharedClient] rac_postPath:AWFAPIPathLogout parameters:nil];
  [signal doCompleted:^{
    @strongify(self);
    self.currentUserID = nil;
  }];
  return signal;
}

#pragma mark - Profile

- (RACSignal *)getUserSelf {
  @weakify(self);
  return [[[RKObjectManager sharedManager] rac_getObject:nil path:AWFAPIPathUser parameters:nil]
          map:^id(RACTuple *x) {
            @strongify(self);
            self.currentUserID = [[x.second firstObject] personID];
            return self.currentUser;
          }];
}

- (RACSignal *)updateUserSelfLocation:(CLPlacemark *)placemark {
  NSMutableDictionary *placemarkDict = [NSMutableDictionary dictionary];
  [placemarkDict setValue:placemark.name forKey:@"name"];
  [placemarkDict setValue:placemark.ISOcountryCode forKey:@"ISOcountryCode"];
  [placemarkDict setValue:placemark.country forKey:@"country"];
  [placemarkDict setValue:placemark.postalCode forKey:@"postalCode"];
  [placemarkDict setValue:placemark.administrativeArea forKey:@"administrativeArea"];
  [placemarkDict setValue:placemark.subAdministrativeArea forKey:@"subAdministrativeArea"];
  [placemarkDict setValue:placemark.locality forKey:@"locality"];
  [placemarkDict setValue:placemark.subLocality forKey:@"subLocality"];
  [placemarkDict setValue:placemark.thoroughfare forKey:@"thoroughfare"];
  [placemarkDict setValue:placemark.subThoroughfare forKey:@"subThoroughfare"];

  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:placemarkDict options:0 error:&error];
  if (!jsonData) {
    return [RACSignal error:error];
  }

  NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSDictionary *parameters = @{AWFURLParameterLocation: json};

  return [[RKObjectManager sharedManager] rac_putObject:self.currentUser path:AWFAPIPathUser parameters:parameters];
}

- (RACSignal *)updateUserSelf {
  return [[RKObjectManager sharedManager] rac_putObject:self.currentUser path:AWFAPIPathUser parameters:nil];
}

#pragma mark - Search

- (RACSignal *)getUsersAtCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(CGFloat)radius
                         pageNumber:(NSUInteger)pageNumber pageSize:(NSUInteger)pageSize {

  NSDictionary *parameters = @{@"lat": @(coordinate.latitude),
                               @"lon": @(coordinate.longitude),
                               @"r": @(radius),
                               @"page": @(pageNumber),
                               @"per_page": @(pageSize)};

  return [[[RKObjectManager sharedManager] rac_getObjectsAtPath:AWFAPIPathUsers parameters:parameters]
          map:^id(RACTuple *x) {
            return [x.second array];
          }];
}

#pragma mark - Friends

- (RACSignal *)getUserSelfFriends {
  return [[[RKObjectManager sharedManager] rac_getObjectsAtPath:AWFAPIPathUserFriends parameters:nil]
          map:^id(RACTuple *x) {
            return [x.second array];
          }];
}

- (RACSignal *)friendUser:(AWFPerson *)person {
  NSDictionary *parameters = @{AWFURLParameterIDs: person.personID};
  return [[RKObjectManager sharedManager] rac_postObject:nil path:AWFAPIPathUserFriends parameters:parameters];
}

- (RACSignal *)unfriendUser:(AWFPerson *)person {
  NSDictionary *parameters = @{AWFURLParameterIDs: person.personID};
  return [[RKObjectManager sharedManager] rac_deleteObject:nil path:AWFAPIPathUserFriends parameters:parameters];
}

- (RACSignal *)approveFriendRequestFromUser:(AWFPerson *)person {
  NSDictionary *parameters = @{AWFURLParameterIDs: person.personID};
  return [[RKObjectManager sharedManager] rac_postObject:nil path:AWFAPIPathUserFriendsApprove parameters:parameters];
}

- (RACSignal *)rejectFriendRequestFromUser:(AWFPerson *)person {
  NSDictionary *parameters = @{AWFURLParameterIDs: person.personID};
  return [[RKObjectManager sharedManager] rac_postObject:nil path:AWFAPIPathUserFriendsReject parameters:parameters];
}

#pragma mark - Activity

- (RACSignal *)getUserSelfActivity {
  return [[[RKObjectManager sharedManager] rac_getObjectsAtPath:AWFAPIPathUserActivity parameters:nil]
          map:^id(RACTuple *x) {
            return [x.second array];
          }];
}

- (RACSignal *)markActivityAsRead:(AWFActivity *)activity {
  return [[RKObjectManager sharedManager] rac_putObject:activity path:AWFAPIPathUserActivity parameters:nil];
}

@end
