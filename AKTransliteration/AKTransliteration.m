//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "AKTransliteration.h"

@interface AKTransliteration ()

@property(nonatomic, readonly) NSArray* sortedKeys;
@property(nonatomic, readonly) NSDictionary* firstLetterIndex;
@property(nonatomic, readonly) NSDictionary* rules;

@end

@implementation AKTransliteration

-(instancetype)initWithRules:(NSDictionary*)rules;
{
  self = [super init];
  if( self == nil ) {
    return nil;
  }

  _rules = rules;

  _sortedKeys = [[self.rules allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
    // 'ab' should be before 'a'
    if( [obj1 hasPrefix:obj2] ) {
      return NSOrderedAscending;
    } else if( [obj2 hasPrefix:obj1] ) {
      return NSOrderedDescending;
    } else {
      return [obj1 compare:obj2];
    }
  }];

  _firstLetterIndex = ({
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for( NSUInteger i = 0; i < self.sortedKeys.count; ++i ) {
      NSString* key = self.sortedKeys[i];
      NSString* firstLetter = [key substringToIndex:1];
      if( result[firstLetter] == nil ) {
        result[firstLetter] = @(i);
      }
    }
    result;
  });

  return self;
}

-(NSString*)transliterate:(NSString*)string
{
  NSString* result = nil;
  [self transliterate:string into:&result];
  return result;
}

-(BOOL)transliterate:(NSString*)string into:(NSString**)returnResult
{
  BOOL success = YES;
  NSCharacterSet* letters = [NSCharacterSet letterCharacterSet];
  NSCharacterSet* uppercaseLetters = [NSCharacterSet uppercaseLetterCharacterSet];
  NSMutableString* result = [[NSMutableString alloc] initWithCapacity:string.length];
  for( NSUInteger i = 0; i < string.length; ++i ) {
    unichar character = [string characterAtIndex:i];
    NSString* characterString = [[NSString stringWithCharacters:&character length:1] lowercaseString];
    // Find first match
    NSUInteger keyIndex = NSNotFound;
    NSNumber* startSearchIndex = self.firstLetterIndex[characterString];
    if( startSearchIndex ) {
      for( NSUInteger k = [startSearchIndex unsignedIntegerValue]; k < self.sortedKeys.count; ++k ) {
        NSString* key = self.sortedKeys[k];
        if( i + key.length <= string.length
           && [[string substringWithRange:NSMakeRange(i, key.length)] caseInsensitiveCompare:key] == NSOrderedSame )
        {
          keyIndex = k;
          break;
        }
      }
    }
    // Append right rule part to result
    if( keyIndex == NSNotFound ) {
      if( [letters characterIsMember:character] ) {
        success = NO;
      }
      [result appendString:characterString];
    } else {
      NSString* toAppend = nil;
      id value = [self.rules valueForKey:self.sortedKeys[keyIndex]];
      if( value == nil ) {
        continue;
      }
      if( [value isKindOfClass:[NSString class]] ) {
        toAppend = value;
      } else if( [value isKindOfClass:[NSArray class]] ) {
        toAppend = [value objectAtIndex:0];
      } else {
        NSAssert(NO, @"Right part of rule should be string or array of strings.");
      }
      if( [uppercaseLetters characterIsMember:character] ) {
        toAppend = [toAppend capitalizedString];
      }
      [result appendString:toAppend];
      // If left rule part is more than one symbol
      i += ((NSString*)self.sortedKeys[keyIndex]).length - 1;
    }
  }
  if( returnResult ) {
    *returnResult = result;
  }
  return success;
}

@end
