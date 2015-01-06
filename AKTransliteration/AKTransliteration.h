//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

typedef NS_ENUM(NSUInteger, e_TransliterateDirection) {
  TD_RuEn,
  TD_EnRu,
  
  TD_Count
};

@interface AKTransliteration : NSObject

-(id)initForDirection:(e_TransliterateDirection)direction;

-(NSString*)transliterate:(NSString*)string;
-(BOOL)transliterate:(NSString*)string into:(NSString**)result;

@end
