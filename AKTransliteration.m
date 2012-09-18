//
// AKTransliteration.m
//
// Copyright (c) 2012 Aleksey Kozhevnikov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AKTransliteration.h"

@interface AKTransliteration ()

@property(nonatomic, strong) NSArray* sortedKeys;
@property(nonatomic, strong) NSDictionary* rules;

@end

@implementation AKTransliteration

-(id)initForDirection:(e_TransliterateDirection)direction
{
  self = [super init];
  if( !self ) {
    return nil;
  }
  NSString* path = [[NSBundle mainBundle] pathForResource:[AKTransliteration rulesFileNameForDirection:direction]
                                                   ofType:@"plist"];
  self.rules = [NSDictionary dictionaryWithContentsOfFile:path];
  self.sortedKeys = [[self.rules allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    // 'ab' should be before 'a'
    if( [obj1 hasPrefix:obj2] ) {
      return NSOrderedAscending;
    } else if( [obj2 hasPrefix:obj1] ) {
      return NSOrderedDescending;
    } else {
      return [obj1 compare:obj2];
    }
  }];
  return self;
}

+(NSString*)rulesFileNameForDirection:(e_TransliterateDirection)direction
{
  switch( direction ) {
    case TD_RuEn:
      return @"RuEnRules";
    case TD_EnRu:
      return @"EnRuRules";
    default:
    {
      COMPILE_ASSERT( TD_Count == 2 );
    }
  }
  return nil;
}

-(NSString*)transliterate:(NSString*)string
{
  NSMutableString* result = [[NSMutableString alloc] initWithCapacity:string.length];
  for( int i = 0; i < string.length; ++i ) {
    unichar character = [string characterAtIndex:i];
    NSString* characterString = [NSString stringWithCharacters:&character length:1];
    // Find first match
    NSInteger keyIndex = [self.sortedKeys indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
      NSString* key = (NSString*)obj;
      if( i + key.length <= string.length
         && [[string substringWithRange:NSMakeRange(i, key.length)] caseInsensitiveCompare:key] == NSOrderedSame )
      {
        return YES;
      }
      return NO;
    }];
    // Append right rule part to result
    if( keyIndex == NSNotFound ) {
      [result appendString:characterString];
    } else {
      NSString* toAppend = nil;
      id value = [self.rules valueForKey:[self.sortedKeys objectAtIndex:keyIndex]];
      if( !value ) {
        continue;
      }
      if( [value isKindOfClass:[NSString class]] ) {
        toAppend = value;
      } else if( [value isKindOfClass:[NSArray class]] ) {
        toAppend = [value objectAtIndex:0];
      } else {
        NSAssert( NO, @"Right part of rule should be string or array of strings." );
      }
      if( [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:character] ) {
        toAppend = [toAppend capitalizedString];
      }
      [result appendString:toAppend];
      // If left rule part is more than one symbol
      i += ((NSString*)[self.sortedKeys objectAtIndex:keyIndex]).length - 1;
    }
  }
  return result;
}

@end
