//
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.
//

#import "ViewController.h"
#import "AKTransliteration.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UITextField* textField;
@property (nonatomic) IBOutlet UILabel* label;

@property (nonatomic) AKTransliteration* transliteration;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextDidChange) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onTextDidChange
{
    self.label.text = [self.transliteration transliterate:self.textField.text];
}

#pragma mark - Lazy

- (AKTransliteration*)transliteration
{
    if (_transliteration == nil) {
        _transliteration = [[AKTransliteration alloc] initForDirection:TD_EnRu];
    }
    return _transliteration;
}

@end
