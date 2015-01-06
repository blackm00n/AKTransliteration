//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

@interface AKTransliteration : NSObject

-(instancetype)initWithRules:(NSDictionary*)rules;

-(NSString*)transliterate:(NSString*)string;
-(BOOL)transliterate:(NSString*)string into:(NSString**)result;

@end
