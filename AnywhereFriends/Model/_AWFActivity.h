// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AWFActivity.h instead.

#import <CoreData/CoreData.h>


extern const struct AWFActivityAttributes {
	__unsafe_unretained NSString *activityID;
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *type;
} AWFActivityAttributes;

extern const struct AWFActivityRelationships {
	__unsafe_unretained NSString *creator;
} AWFActivityRelationships;

extern const struct AWFActivityFetchedProperties {
} AWFActivityFetchedProperties;

@class AWFPerson;






@interface AWFActivityID : NSManagedObjectID {}
@end

@interface _AWFActivity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AWFActivityID*)objectID;





@property (nonatomic, strong) NSString* activityID;



//- (BOOL)validateActivityID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* dateCreated;



//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status;



@property int16_t statusValue;
- (int16_t)statusValue;
- (void)setStatusValue:(int16_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* type;



@property int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) AWFPerson *creator;

//- (BOOL)validateCreator:(id*)value_ error:(NSError**)error_;





@end

@interface _AWFActivity (CoreDataGeneratedAccessors)

@end

@interface _AWFActivity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveActivityID;
- (void)setPrimitiveActivityID:(NSString*)value;




- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int16_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int16_t)value_;




- (NSNumber*)primitiveType;
- (void)setPrimitiveType:(NSNumber*)value;

- (int16_t)primitiveTypeValue;
- (void)setPrimitiveTypeValue:(int16_t)value_;





- (AWFPerson*)primitiveCreator;
- (void)setPrimitiveCreator:(AWFPerson*)value;


@end
