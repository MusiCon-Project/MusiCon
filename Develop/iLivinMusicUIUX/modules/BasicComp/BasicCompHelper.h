//
//  BasicCompHelper.h
//  MnFramework
//
//  Created by  on 12. 4. 9..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicCompHelper : NSObject
// UILabel Creation & Setting
+ (UILabel *)labelCreation:(CGRect)rect labelText:(NSString *)text fontSize:(CGFloat)fontsize;
+ (UILabel *)detailLabelCreation:(CGRect)rect numberOfLines:(NSInteger)numberoflines labelText:(NSString *)text textAlignment:(UITextAlignment)textalignment font:(UIFont *)font textColor:(UIColor *)textcolor bgColor:(UIColor *)bgColor;

// UIImageView Creation & Setting
+ (UIImageView *)imageCreation:(CGRect)rect imageName:(NSString *)imagename;

// UIButton Creation & Setting
+ (UIButton *)buttonCreation:(CGRect)rect normalButtonImage:(NSString *)normalImg highlightButtonImage:(NSString *)highlightImg	target:(id)target buttonAction:(SEL)buttonaction;
+ (UIButton *)buttonCreationWithStyle:(UIButtonType)buttonType rect:(CGRect)rect title:(NSString *)title target:(id)target buttonAction:(SEL)buttonaction;
+ (UIButton *)detailButtonCreation:(CGRect)rect normalButtonImage:(NSString *)normalImg highlightButtonImage:(NSString *)highlightImg
			  title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target buttonAction:(SEL)buttonaction font:(UIFont *)font;

// UITextField Creation & Setting
+ (UITextField *)textFieldCreation:(CGRect)rect fontSize:(CGFloat)fontsize delegate:(id<UITextFieldDelegate>)delegate;
+ (UITextField *)detailTextFieldCreation:(CGRect)rect font:(UIFont *)font textColor:(UIColor *)textColor borderStyle:(UITextBorderStyle)bolderStyle	delegate:(id<UITextFieldDelegate>)delegate returnKeyType:(UIReturnKeyType)returnKeyType secureTextEntry:(BOOL)secureEntry;

// UISegmentedControl Creation & Setting
+ (UISegmentedControl *)segmentedControlCreation:(CGRect)rect items:(NSArray *)items target:(id)target selector:(SEL)selector fontSize:(CGFloat)fontSize;
+ (UISegmentedControl *)detailSegmentedControlCreation:(CGRect)rect items:(NSArray *)items target:(id)target selector:(SEL)selector segmentControlStyle:(UISegmentedControlStyle)segmentControlStyle tintColor:(UIColor *)tintColor font:(UIFont *)font;

// UITextView Creation & Setting
+ (UITextView *) textViewCreation:(CGRect)rect delegate:(id<UITextViewDelegate>)delegate fontSize:(CGFloat)fontSize;
+ (UITextView *) detailTextViewCreation:(CGRect)rect delegate:(id<UITextViewDelegate>)delegate font:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor keyBoardType:(UIKeyboardType)keyBoardType;
+ (void) moreDetailSetting:(UITextView *)textView autoCorrectType:(UITextAutocorrectionType)correctionType spellCheckingType:(UITextSpellCheckingType)spellCheckType autoCapitlizeType:(UITextAutocapitalizationType)autoCapitalizeType returnKeyAuto:(BOOL)returnKeyAuto secureTextEntry:(BOOL)secureTextEntry;
+ (void) textViewBoundarySetting:(UITextView *)textView cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

// UISlider Creation & Setting
+ (UISlider *) sliderCreation:(CGRect)rect target:(id)target action:(SEL)action;
+ (UISlider *) detailSliderCreation:(CGRect)rect target:(id)target action:(SEL)action maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue value:(CGFloat)value;
+ (void) sliderSetting:(UISlider *)slider minImage:(UIImage *)minImage maxImage:(UIImage *)maxImage;

+ (UIProgressView *) progressViewCreation:(CGRect)rect progressValue:(CGFloat)value style:(UIProgressViewStyle)style;
+ (void) progressViewSetting:(UIProgressView *)progressView progressImage:(UIImage *)progressImage trackImage:(UIImage *)trackImage progressTintColor:(UIColor *)progressTintColor trackTintColor:(UIColor *)trackTintColor;

//UIScrollView Creation
+ (UIScrollView *) scrollViewCreation:(CGRect)rect contentSize:(CGSize)size;
@end
