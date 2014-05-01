// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AWFPerson.h instead.

#import <CoreData/CoreData.h>


extern const struct AWFPersonAttributes {
	__unsafe_unretained NSString *bio;
	__unsafe_unretained NSString *birthday;
	__unsafe_unretained NSString *bodyBuild;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *eyeColor;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *friendship;
	__unsafe_unretained NSString *gender;
	__unsafe_unretained NSString *hairColor;
	__unsafe_unretained NSString *hairLength;
	__unsafe_unretained NSString *height;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *locationDistance;
	__unsafe_unretained NSString *locationLatitude;
	__unsafe_unretained NSString *locationLocality;
	__unsafe_unretained NSString *locationLongitude;
	__unsafe_unretained NSString *locationThoroughfare;
	__unsafe_unretained NSString *locationUpdated;
	__unsafe_unretained NSString *personID;
	__unsafe_unretained NSString *weight;
} AWFPersonAttributes;

extern const struct AWFPersonRelationships {
	__unsafe_unretained NSString *activitiesCreated;
} AWFPersonRelationships;

extern const struct AWFPersonFetchedProperties {
} AWFPersonFetchedProperties;

@class AWFActivity;























@interface AWFPersonID : NSManagedObjectID {}
@end

@interface _AWFPerson : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AWFPersonID*)objectID;





@property (nonatomic, strong) NSString* bio;



//- (BOOL)validateBio:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* birthday;



//- (BOOL)validateBirthday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* bodyBuild;



@property int16_t bodyBuildValue;
- (int16_t)bodyBuildValue;
- (void)setBodyBuildValue:(int16_t)value_;

//- (BOOL)validateBodyBuild:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* dateUpdated;



//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* eyeColor;



//- (BOOL)validateEyeColor:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* friendship;



@property int16_t friendshipValue;
- (int16_t)friendshipValue;
- (void)setFriendshipValue:(int16_t)value_;

//- (BOOL)validateFriendship:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* gender;



@property int16_t genderValue;
- (int16_t)genderValue;
- (void)setGenderValue:(int16_t)value_;

//- (BOOL)validateGender:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* hairColor;



//- (BOOL)validateHairColor:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* hairLength;



@property int16_t hairLengthValue;
- (int16_t)hairLengthValue;
- (void)setHairLengthValue:(int16_t)value_;

//- (BOOL)validateHairLength:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* height;



@property float heightValue;
- (float)heightValue;
- (void)setHeightValue:(float)value_;

//- (BOOL)validateHeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* locationDistance;



@property double locationDistanceValue;
- (double)locationDistanceValue;
- (void)setLocationDistanceValue:(double)value_;

//- (BOOL)validateLocationDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* locationLatitude;



@property double locationLatitudeValue;
- (double)locationLatitudeValue;
- (void)setLocationLatitudeValue:(double)value_;

//- (BOOL)validateLocationLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* locationLocality;



//- (BOOL)validateLocationLocality:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* locationLongitude;



@property double locationLongitudeValue;
- (double)locationLongitudeValue;
- (void)setLocationLongitudeValue:(double)value_;

//- (BOOL)validateLocationLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* locationThoroughfare;



//- (BOOL)validateLocationThoroughfare:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* locationUpdated;



//- (BOOL)validateLocationUpdated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* personID;



//- (BOOL)validatePersonID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* weight;



@property float weightValue;
- (float)weightValue;
- (void)setWeightValue:(float)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *activitiesCreated;

- (NSMutableSet*)activitiesCreatedSet;





@end

@interface _AWFPerson (CoreDataGeneratedAccessors)

- (void)addActivitiesCreated:(NSSet*)value_;
- (void)removeActivitiesCreated:(NSSet*)value_;
- (void)addActivitiesCreatedObject:(AWFActivity*)value_;
- (void)removeActivitiesCreatedObject:(AWFActivity*)value_;

@end

@interface _AWFPerson (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBio;
- (void)setPrimitiveBio:(NSString*)value;




- (NSDate*)primitiveBirthday;
- (void)setPrimitiveBirthday:(NSDate*)value;




- (NSNumber*)primitiveBodyBuild;
- (void)setPrimitiveBodyBuild:(NSNumber*)value;

- (int16_t)primitiveBodyBuildValue;
- (void)setPrimitiveBodyBuildValue:(int16_t)value_;




- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveEyeColor;
- (void)setPrimitiveEyeColor:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSNumber*)primitiveFriendship;
- (void)setPrimitiveFriendship:(NSNumber*)value;

- (int16_t)primitiveFriendshipValue;
- (void)setPrimitiveFriendshipValue:(int16_t)value_;




- (NSNumber*)primitiveGender;
- (void)setPrimitiveGender:(NSNumber*)value;

- (int16_t)primitiveGenderValue;
- (void)setPrimitiveGenderValue:(int16_t)value_;




- (NSString*)primitiveHairColor;
- (void)setPrimitiveHairColor:(NSString*)value;




- (NSNumber*)primitiveHairLength;
- (void)setPrimitiveHairLength:(NSNumber*)value;

- (int16_t)primitiveHairLengthValue;
- (void)setPrimitiveHairLengthValue:(int16_t)value_;




- (NSNumber*)primitiveHeight;
- (void)setPrimitiveHeight:(NSNumber*)value;

- (float)primitiveHeightValue;
- (void)setPrimitiveHeightValue:(float)value_;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSNumber*)primitiveLocationDistance;
- (void)setPrimitiveLocationDistance:(NSNumber*)value;

- (double)primitiveLocationDistanceValue;
- (void)setPrimitiveLocationDistanceValue:(double)value_;




- (NSNumber*)primitiveLocationLatitude;
- (void)setPrimitiveLocationLatitude:(NSNumber*)value;

- (double)primitiveLocationLatitudeValue;
- (void)setPrimitiveLocationLatitudeValue:(double)value_;




- (NSString*)primitiveLocationLocality;
- (void)setPrimitiveLocationLocality:(NSString*)value;




- (NSNumber*)primitiveLocationLongitude;
- (void)setPrimitiveLocationLongitude:(NSNumber*)value;

- (double)primitiveLocationLongitudeValue;
- (void)setPrimitiveLocationLongitudeValue:(double)value_;




- (NSString*)primitiveLocationThoroughfare;
- (void)setPrimitiveLocationThoroughfare:(NSString*)value;




- (NSDate*)primitiveLocationUpdated;
- (void)setPrimitiveLocationUpdated:(NSDate*)value;




- (NSString*)primitivePersonID;
- (void)setPrimitivePersonID:(NSString*)value;




- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (float)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(float)value_;





- (NSMutableSet*)primitiveActivitiesCreated;
- (void)setPrimitiveActivitiesCreated:(NSMutableSet*)value;


@end
