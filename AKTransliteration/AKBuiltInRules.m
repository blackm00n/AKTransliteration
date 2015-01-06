//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "AKBuiltInRules.h"

@implementation AKBuiltInRules

+(NSDictionary*)rulesForDirection:(e_TransliterateDirection)transliterateDirection
{
    NSString* path = [[NSBundle mainBundle] pathForResource:[self rulesFileNameForDirection:transliterateDirection] ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
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

@end