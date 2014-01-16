//
//  BasicCompHelper.m
//  MnFramework
//
//  Created by  on 12. 4. 9..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// UILabel, ImageView, UIButton, TextField, UITextView, Segmented Control
// UISlider, UISwitch, ProgressView, ScrollView + UIPageControl, 
// Activity Indicator View, DatePicker, PickerView stepper Creation
// Component associate Function (UITextView 크기)

// WebView, MapView, 

#import "BasicCompHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation BasicCompHelper
/**
 * easy Label Creation. set TextColor, numberOfLines etc by yourself
 * @param rect, text, fontsize
 * @author JHLee
 */
+ (UILabel *)labelCreation:(CGRect)rect
		     labelText:(NSString *)text
		     fontSize:(CGFloat)fontsize
{
	#if __has_feature(objc_arc)
		UILabel * label = [[UILabel alloc] initWithFrame:rect];
	#else
		UILabel * label = [[[UILabel alloc] initWithFrame:rect] autorelease];
	#endif
	label.text = text;
	label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:fontsize];
	label.backgroundColor = [UIColor clearColor];

	return label;
}

/**
 * detail Label Creation. 
 * @param rect, numberOfLines, text, textalignment, fontsize, textColor, bgColor
 * @author JHLee
 */
+ (UILabel *)detailLabelCreation:(CGRect)rect
			 numberOfLines:(NSInteger)numberoflines
		     labelText:(NSString *)text
			 textAlignment:(UITextAlignment)textalignment
			 font:(UIFont *)font
			 textColor:(UIColor *)textcolor
			 bgColor:(UIColor *)bgColor
{
	#if __has_feature(objc_arc)
		UILabel * label = [[UILabel alloc] initWithFrame:rect];
	#else
		UILabel * label = [[[UILabel alloc] initWithFrame:rect] autorelease];
	#endif
	label.numberOfLines = numberoflines;
	label.text = text;
	label.textAlignment = textalignment;
	label.font = font;
	label.textColor = textcolor;
	label.backgroundColor = bgColor;
	
	return label; 	
}

/**
 * easy Image Creation
 * @param rect, imageName
 * @author JHLee
 */
+ (UIImageView *)imageCreation:(CGRect)rect
					 imageName:(NSString *)imagename
{
	#if __has_feature(objc_arc)
		UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
	#else
		UIImageView * imageView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
	#endif

	if(imagename != nil)
		[imageView setImage:[UIImage imageNamed:imagename]];
	[imageView setBackgroundColor:[UIColor clearColor]];

	return imageView;
}

/**
 * easy Image Creation with imageWithContentsOfFile (not cash) 
 * there can be some problem with speed, but it releases immediately after usage, so memory control advantage exists
 * @param rect, imageName
 * @author JHLee
 */
+ (UIImageView *)imageCreationNotCash:(CGRect)rect
					 imageName:(NSString *)imagename
{
#if __has_feature(objc_arc)
	UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
#else
	UIImageView * imageView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
#endif
	NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"yuna.jpg" ofType:nil];
	[imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
	[imageView setBackgroundColor:[UIColor clearColor]];
	
	return imageView;
}

/**
 * easy button Creation 
 * @param rect, normalImg, highlightImg, buttonaction
 * @author JHLee
 */
+ (UIButton *)buttonCreation:(CGRect)rect
		   normalButtonImage:(NSString *)normalImg
		highlightButtonImage:(NSString *)highlightImg
					  target:(id)target
				buttonAction:(SEL)buttonaction
{
#if __has_feature(objc_arc)
	UIButton * button = [[UIButton alloc] initWithFrame:rect];
#else
	UIButton * button = [[[UIButton alloc] initWithFrame:rect] autorelease]; 
#endif
	if(normalImg != nil)
		[button setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
	if(highlightImg != nil)
		[button setBackgroundImage:[UIImage imageNamed:highlightImg] forState:UIControlStateHighlighted];
	[button addTarget:target action:buttonaction forControlEvents:UIControlEventTouchUpInside];
	return button;
}

/**
 * easy button Creation with Style
 * @param buttonType, rect, title, buttonaction
 * @author JHLee
 */
+ (UIButton *)buttonCreationWithStyle:(UIButtonType)buttonType
								 rect:(CGRect)rect
								title:(NSString *)title
							   target:(id)target
						 buttonAction:(SEL)buttonaction
{
	UIButton * button = [UIButton buttonWithType:buttonType];

	[button setFrame:rect];
	[button setTitle:title forState:UIControlStateNormal];
	[button addTarget:target action:buttonaction forControlEvents:UIControlEventTouchUpInside];
	return button;
}

/**
 * detail button Creation
 * @param rect, normalImg, highlightImg, title, titleColor, buttonaction, font
 * @author JHLee
 */
+ (UIButton *)detailButtonCreation:(CGRect)rect
				 normalButtonImage:(NSString *)normalImg
			  highlightButtonImage:(NSString *)highlightImg
							 title:(NSString *)title
						titleColor:(UIColor *)titleColor
							target:(id)target
					  buttonAction:(SEL)buttonaction
							  font:(UIFont *)font
{
#if __has_feature(objc_arc)
	UIButton * button = [[UIButton alloc] initWithFrame:rect];
#else
	UIButton * button = [[[UIButton alloc] initWithFrame:rect] autorelease]; 
#endif
	[button setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:highlightImg] forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:titleColor forState:UIControlStateNormal];
	[button.titleLabel setFont:font];	
	[button addTarget:self action:buttonaction forControlEvents:UIControlEventTouchUpInside];
	return button;
}

/**
 * easy textField Creation
 * @param rect, fontSize, delegate
 * @author JHLee
 */
+ (UITextField *)textFieldCreation:(CGRect)rect
					 fontSize:(CGFloat)fontsize	
					 delegate:(id<UITextFieldDelegate>)delegate
{	
#if __has_feature(objc_arc)
	UITextField * textField = [[UITextField alloc] initWithFrame:rect];
#else
	UITextField * textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
#endif
	[textField setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:12.0]];
	[textField setBorderStyle:UITextBorderStyleRoundedRect];
	[textField setDelegate:delegate];
	[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

	return textField;
}

/**
 * detail textField Creation
 * @param rect, font, textColor, bolderStyle, delegate, returnKeyType, secureEntry
 * @author JHLee
 */
+ (UITextField *)detailTextFieldCreation:(CGRect)rect
						  font:(UIFont *)font
						  textColor:(UIColor *)textColor
						  borderStyle:(UITextBorderStyle)bolderStyle
						  delegate:(id<UITextFieldDelegate>)delegate
						  returnKeyType:(UIReturnKeyType)returnKeyType
						  secureTextEntry:(BOOL)secureEntry

{	
#if __has_feature(objc_arc)
	UITextField * textField = [[UITextField alloc] initWithFrame:rect];
#else
	UITextField * textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
#endif	
	[textField setFont:font];
	[textField setTextColor:textColor];
	[textField setBorderStyle:bolderStyle];
	[textField setDelegate:delegate];
	[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	textField.returnKeyType = returnKeyType;
	textField.secureTextEntry = secureEntry;
	return textField;
}

/**
 * easy segmentedControl Creation
 * @param rect, items
 * @author JHLee
 */
+ (UISegmentedControl *)segmentedControlCreation:(CGRect)rect
										   items:(NSArray *)items
										  target:(id)target
										selector:(SEL)selector
										fontSize:(CGFloat)fontSize
{	
#if __has_feature(objc_arc)
	UISegmentedControl * segmentCon = [[UISegmentedControl alloc] initWithItems:items];
#else
	UISegmentedControl * segmentCon = [[[UISegmentedControl alloc] initWithItems:items] autorelease];
#endif
	segmentCon.momentary = YES;
	segmentCon.frame = rect;
	segmentCon.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentCon addTarget:target action:selector forControlEvents:UIControlEventValueChanged];

	UIFont * font = [UIFont fontWithName:@"ArialRoundedMTBold" size:fontSize];
	NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
	[segmentCon setTitleTextAttributes:attributes forState:UIControlStateNormal];
	
	return segmentCon;
}

/**
 * detail segmentedControl Creation
 * @param rect, items, target, selector, segmentControlStyle, tintColor
 * @author JHLee
 */
+ (UISegmentedControl *)detailSegmentedControlCreation:(CGRect)rect
												 items:(NSArray *)items
												target:(id)target
											  selector:(SEL)selector
								   segmentControlStyle:(UISegmentedControlStyle)segmentControlStyle
											 tintColor:(UIColor *)tintColor
												  font:(UIFont *)_font
{	
#if __has_feature(objc_arc)
	UISegmentedControl * segmentCon = [[UISegmentedControl alloc] initWithItems:items];
#else
	UISegmentedControl * segmentCon = [[[UISegmentedControl alloc] initWithItems:items] autorelease];
#endif
	segmentCon.momentary = YES;
	segmentCon.frame = rect;
	segmentCon.segmentedControlStyle = segmentControlStyle;
	segmentCon.tintColor = tintColor;
	[segmentCon addTarget:target action:selector forControlEvents:UIControlEventValueChanged];
	
	UIFont * font = _font;
	NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
	[segmentCon setTitleTextAttributes:attributes forState:UIControlStateNormal];

	return segmentCon;
}

/**
 * textView Creation
 * @param rect, delegate, fontSize
 * @author JHLee
 */
+ (UITextView *) textViewCreation:(CGRect)rect
  						 delegate:(id<UITextViewDelegate>)delegate
 						 fontSize:(CGFloat)fontSize
{	
#if __has_feature(objc_arc)
	UITextView * textView = [[UITextView alloc] initWithFrame:rect];
#else
	UITextView * textView = [[[UITextView alloc] initWithFrame:rect] autorelease];
#endif
	textView.delegate = delegate;
	textView.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:fontSize];
	textView.backgroundColor = [UIColor clearColor];
	textView.layer.cornerRadius = 5.0f;
	textView.layer.borderColor = [[UIColor grayColor] CGColor];
	textView.layer.borderWidth = 1.0f;
	
	return textView;
}

/**
 * detail textView Creation
 * @param rect, delegate, font, textColor, bgColor, keyboardType
 * @author JHLee
 */
+ (UITextView *) detailTextViewCreation:(CGRect)rect
							   delegate:(id<UITextViewDelegate>)delegate
							   font:(UIFont *)font
						  textColor:(UIColor *)textColor
							bgColor:(UIColor *)bgColor
					   keyBoardType:(UIKeyboardType)keyBoardType

{	
#if __has_feature(objc_arc)
	UITextView * textView = [[UITextView alloc] initWithFrame:rect];
#else
	UITextView * textView = [[[UITextView alloc] initWithFrame:rect] autorelease];
#endif
	textView.delegate = delegate;
	textView.font = font;
	textView.textColor = textColor;
	textView.backgroundColor = bgColor;	
	textView.keyboardType = keyBoardType;
	
	return textView;
}

/**
 * textView Setting for Correction, secure, enables ReturnKey Automatic
 * @param textView, correctionType, spellCheckType, autoCapiglizeType, returnKeyType, secureTextEntry
 * @author JHLee
 */
+ (void) moreDetailSetting:(UITextView *)textView
					autoCorrectType:(UITextAutocorrectionType)correctionType
					spellCheckingType:(UITextSpellCheckingType)spellCheckType
					autoCapitlizeType:(UITextAutocapitalizationType)autoCapitalizeType
					returnKeyAuto:(BOOL)returnKeyAuto
					secureTextEntry:(BOOL)secureTextEntry
{
	textView.autocorrectionType = correctionType;
	textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textView.spellCheckingType = UITextSpellCheckingTypeNo;
	textView.enablesReturnKeyAutomatically = returnKeyAuto;
	textView.secureTextEntry = secureTextEntry;
}

/**
 * textView Setting for Border
 * @param textView, cornerRadius, borderColor, borderWidth
 * @author JHLee
 */
+ (void) textViewBoundarySetting:(UITextView *)textView
					cornerRadius:(CGFloat)cornerRadius
 					 borderColor:(UIColor *)borderColor
					 borderWidth:(CGFloat)borderWidth
{
	textView.layer.cornerRadius = cornerRadius;
	textView.layer.borderColor = [borderColor CGColor];
	textView.layer.borderWidth = borderWidth;
}

/**
 * UISlider creation
 * @param rect, target, action
 * @author JHLee
 */
+ (UISlider *) sliderCreation:(CGRect)rect
						 target:(id)target
						 action:(SEL)action
{	
#if __has_feature(objc_arc)
	UISlider * slider = [[UISlider alloc] initWithFrame:rect];
#else
	UISlider * slider = [[[UISlider alloc] initWithFrame:rect] autorelease];
#endif
	slider.minimumValue = 0.0f;
	slider.maximumValue = 1.0f;
	slider.value = 0.5;
	slider.continuous = YES;
	
	[slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
	return slider;
}

/**
 * detail UISlider creation
 * @param rect, target, action, maxValue, minValue, value 
 * @author JHLee
 */
+ (UISlider *) detailSliderCreation:(CGRect)rect
							 target:(id)target
							 action:(SEL)action
						   maxValue:(CGFloat)maxValue
						   minValue:(CGFloat)minValue
							  value:(CGFloat)value
{	
#if __has_feature(objc_arc)
	UISlider * slider = [[UISlider alloc] initWithFrame:rect];
#else
	UISlider * slider = [[[UISlider alloc] initWithFrame:rect] autorelease];
#endif
	slider.maximumValue = maxValue;
	slider.minimumValue = minValue;
	slider.value = value;
	slider.continuous = YES;
	
	[slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
	return slider;
}

/**
 * UISlider Setting For minImage & maxImage
 * @param slider, minImage, maxImage
 * @author JHLee
 */
+ (void) sliderSetting:(UISlider *)slider minImage:(UIImage *)minImage maxImage:(UIImage *)maxImage
{
	[slider setMinimumTrackImage:minImage forState:UIControlStateNormal];
	[slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
}

/**
 * UIProgressView Creation
 * @param rect, value, style
 * @author JHLee
 */
+ (UIProgressView *) progressViewCreation:(CGRect)rect
							progressValue:(CGFloat)value
									style:(UIProgressViewStyle)style
{
#if __has_feature(objc_arc)
	UIProgressView *  progressView = [[UIProgressView alloc] initWithFrame:rect];
#else
	UIProgressView *  progressView = [[UIProgressView alloc] initWithFrame:rect];
#endif
	
	[progressView setProgress:value animated:YES];
	[progressView setProgressViewStyle:style];
	return progressView;
}

/**
 * UIProgresView Setting
 * @param progressView, progressImage, trackImage, progressTintColor, trackTintColor
 * @author JHLee
 */
+ (void) progressViewSetting:(UIProgressView *)progressView
			   progressImage:(UIImage *)progressImage
				  trackImage:(UIImage *)trackImage
		   progressTintColor:(UIColor *)progressTintColor
			  trackTintColor:(UIColor *)trackTintColor
{
	if(progressImage != nil)
		[progressView setProgressImage:progressImage];
	if(progressTintColor != nil)
		[progressView setProgressTintColor:progressTintColor];
	if(trackImage != nil)
		[progressView setTrackImage:trackImage];
	if(trackTintColor != nil)
		[progressView setTrackTintColor:trackTintColor];
}	

/**
 * UIScrollView creation
 * @param rect, size
 * @author JHLee
 */
+ (UIScrollView *) scrollViewCreation:(CGRect)rect contentSize:(CGSize)size
{	
#if __has_feature(objc_arc)
	UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:rect];
#else
	UIScrollView * scrollView = [[[UIScrollView alloc] initWithFrame:rect] autorelease];
#endif
	[scrollView setContentSize:size];
	
	return scrollView;
}
@end
