// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AWFPerson.m instead.

#import "_AWFPerson.h"

const struct AWFPersonAttributes AWFPersonAttributes = {
	.bio = @"bio",
	.birthday = @"birthday",
	.bodyBuild = @"bodyBuild",
	.dateUpdated = @"dateUpdated",
	.email = @"email",
	.eyeColor = @"eyeColor",
	.firstName = @"firstName",
	.friendship = @"friendship",
	.gender = @"gender",
	.hairColor = @"hairColor",
	.hairLength = @"hairLength",
	.height = @"height",
	.lastName = @"lastName",
	.locationDistance = @"locationDistance",
	.locationLatitude = @"locationLatitude",
	.locationLocality = @"locationLocality",
	.locationLongitude = @"locationLongitude",
	.locationThoroughfare = @"locationThoroughfare",
	.locationUpdated = @"locationUpdated",
	.personID = @"personID",
	.weight = @"weight",
};

const struct AWFPersonRelationships AWFPersonRelationships = {
	.activitiesCreated = @"activitiesCreated",
};

const struct AWFPersonFetchedProperties AWFPersonFetchedProperties = {
};

@implementation AWFPersonID
@end

@implementation _AWFPerson

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AWFPerson" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AWFPerson";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AWFPerson" inManagedObjectContext:moc_];
}

- (AWFPersonID*)objectID {
	return (AWFPersonID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"bodyBuildValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bodyBuild"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"friendshipValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"friendship"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"genderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"gender"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"heightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"height"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"locationDistanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"locationDistance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"locationLatitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"locationLatitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"locationLongitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"locationLongitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bio;






@dynamic birthday;






@dynamic bodyBuild;



- (int16_t)bodyBuildValue {
	NSNumber *result = [self bodyBuild];
	return [result shortValue];
}

- (void)setBodyBuildValue:(int16_t)value_ {
	[self setBodyBuild:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveBodyBuildValue {
	NSNumber *result = [self primitiveBodyBuild];
	return [result shortValue];
}

- (void)setPrimitiveBodyBuildValue:(int16_t)value_ {
	[self setPrimitiveBodyBuild:[NSNumber numberWithShort:value_]];
}





@dynamic dateUpdated;






@dynamic email;






@dynamic eyeColor;






@dynamic firstName;






@dynamic friendship;



- (int16_t)friendshipValue {
	NSNumber *result = [self friendship];
	return [result shortValue];
}

- (void)setFriendshipValue:(int16_t)value_ {
	[self setFriendship:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveFriendshipValue {
	NSNumber *result = [self primitiveFriendship];
	return [result shortValue];
}

- (void)setPrimitiveFriendshipValue:(int16_t)value_ {
	[self setPrimitiveFriendship:[NSNumber numberWithShort:value_]];
}





@dynamic gender;



- (int16_t)genderValue {
	NSNumber *result = [self gender];
	return [result shortValue];
}

- (void)setGenderValue:(int16_t)value_ {
	[self setGender:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveGenderValue {
	NSNumber *result = [self primitiveGender];
	return [result shortValue];
}

- (void)setPrimitiveGenderValue:(int16_t)value_ {
	[self setPrimitiveGender:[NSNumber numberWithShort:value_]];
}





@dynamic hairColor;






@dynamic hairLength;






@dynamic height;



- (float)heightValue {
	NSNumber *result = [self height];
	return [result floatValue];
}

- (void)setHeightValue:(float)value_ {
	[self setHeight:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveHeightValue {
	NSNumber *result = [self primitiveHeight];
	return [result floatValue];
}

- (void)setPrimitiveHeightValue:(float)value_ {
	[self setPrimitiveHeight:[NSNumber numberWithFloat:value_]];
}





@dynamic lastName;






@dynamic locationDistance;



- (double)locationDistanceValue {
	NSNumber *result = [self locationDistance];
	return [result doubleValue];
}

- (void)setLocationDistanceValue:(double)value_ {
	[self setLocationDistance:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLocationDistanceValue {
	NSNumber *result = [self primitiveLocationDistance];
	return [result doubleValue];
}

- (void)setPrimitiveLocationDistanceValue:(double)value_ {
	[self setPrimitiveLocationDistance:[NSNumber numberWithDouble:value_]];
}





@dynamic locationLatitude;



- (double)locationLatitudeValue {
	NSNumber *result = [self locationLatitude];
	return [result doubleValue];
}

- (void)setLocationLatitudeValue:(double)value_ {
	[self setLocationLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLocationLatitudeValue {
	NSNumber *result = [self primitiveLocationLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLocationLatitudeValue:(double)value_ {
	[self setPrimitiveLocationLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic locationLocality;






@dynamic locationLongitude;



- (double)locationLongitudeValue {
	NSNumber *result = [self locationLongitude];
	return [result doubleValue];
}

- (void)setLocationLongitudeValue:(double)value_ {
	[self setLocationLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLocationLongitudeValue {
	NSNumber *result = [self primitiveLocationLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLocationLongitudeValue:(double)value_ {
	[self setPrimitiveLocationLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic locationThoroughfare;






@dynamic locationUpdated;






@dynamic personID;






@dynamic weight;



- (float)weightValue {
	NSNumber *result = [self weight];
	return [result floatValue];
}

- (void)setWeightValue:(float)value_ {
	[self setWeight:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveWeightValue {
	NSNumber *result = [self primitiveWeight];
	return [result floatValue];
}

- (void)setPrimitiveWeightValue:(float)value_ {
	[self setPrimitiveWeight:[NSNumber numberWithFloat:value_]];
}





@dynamic activitiesCreated;

	
- (NSMutableSet*)activitiesCreatedSet {
	[self willAccessValueForKey:@"activitiesCreated"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"activitiesCreated"];
  
	[self didAccessValueForKey:@"activitiesCreated"];
	return result;
}
	






@end
