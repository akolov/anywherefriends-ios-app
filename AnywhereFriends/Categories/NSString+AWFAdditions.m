//
//  NSString+AWFAdditions.m
//  AnywhereFriends
//
//  Created by Alexander Kolov on 21/05/14.
//  Copyright (c) 2014 Anywherefriends. All rights reserved.
//

#import "NSString+AWFAdditions.h"

@implementation NSString (AWFAdditions)

- (NSDictionary *)dictionaryFromQueryString {
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  NSArray *keyValuePairs = [self componentsSeparatedByString:@"&"];

  for (NSString *keyValuePair in keyValuePairs) {
    NSArray *element = [keyValuePair componentsSeparatedByString:@"="];
    if (element.count != 2) {
      continue;
    }

    NSString *key = element[0], *value = element[1];

    if (key.length == 0) {
      continue;
    }

    dictionary[key] = value;
  }

  return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
