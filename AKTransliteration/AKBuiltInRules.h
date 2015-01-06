//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

typedef NS_ENUM(NSUInteger, e_TransliterateDirection) {
    TD_RuEn,
    TD_EnRu,

    TD_Count
};

@interface AKBuiltInRules : NSObject

+(NSDictionary*)rulesForDirection:(e_TransliterateDirection)transliterateDirection;

@end