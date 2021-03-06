//
//  CDZExtension.h
//
//
//  Created by baight on 14-8-21.
//  Copyright (c) 2014年 baight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define RGB(r,g,b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define OnePixelsWidth  (1/[UIScreen mainScreen].scale)

#define SystemVersionBiggerOrEqual(version) ([[UIDevice currentDevice].systemVersion compare:(version) options:NSNumericSearch] != NSOrderedAscending)
#define SystemVersionBiggerThan(version) ([[UIDevice currentDevice].systemVersion compare:(version) options:NSNumericSearch] == NSOrderedDescending)

#define IPhone4ScreenHeight     480
#define IPhone5ScreenHeight     568
#define IPhone6ScreenHeight     667
#define IPhone6PlusScreenHeight 736

#define StringNotNil(str) (str ? str : @"")
#define ArrayNotNil(arr) (arr ? arr : @[])
#define DictionaryNotNil(dic) (dic ? dic : @{})

#define RegexPhoneNumber        @"^1\\d{10}$"
#define RegexNumberOnly         @"^[0-9]*$"

void GCDAsyncInMain(dispatch_block_t block);
void GCDSyncInMain(dispatch_block_t block);
void GCDSafeSyncInMain(dispatch_block_t block); // 不会阻塞主线程
void GCDAsyncInMainAfter(NSTimeInterval time, dispatch_block_t block);

void GCDAsyncInBackground(dispatch_block_t block);
void GCDSyncInBackground(dispatch_block_t block);
void GCDAsyncInBackgroundAfter(NSTimeInterval time, dispatch_block_t block);


#pragma mark - UIView
@interface UIView (CDZViewExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, getter=x, setter=setX:) CGFloat left;
@property (nonatomic, getter=y, setter=setY:) CGFloat top;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
- (void)setBorderColor:(UIColor*)borderColor width:(CGFloat)width;

// 从xib中加载视图
// 如果视图是 UITableViewCell或其子类，则自动设置 cell的reuseIdentifier 为类名
// 如果是cell，建议与 UITableViewCell的扩展方法 reusableCellFromTable: 一起使用
// reusableCellFromTable: 的作用是：从tableView的回收cell里，取出一个 reuseIdentifier为cell类名一个cell
+ (id)loadFromBundleWithOwner:(id)owner;

// 获得 view 的 快照
- (UIImage*)snapshoot;

- (void)removeAllSubviews;
- (__kindof UIView*)viewWithClass:(Class)c;

- (__kindof UIView*)theFirstResponder;

// 移动自己 到 view 的右边，与其间距 interval
- (void)moveToRightOfView:(UIView*)view interval:(CGFloat)interval;
- (void)moveToBottomnOfView:(UIView*)view interval:(CGFloat)interval;
- (void)moveToLeftOfView:(UIView*)view inteval:(CGFloat)interval;

//获取 view 的 controller
- (UIViewController *)viewController;

- (UIView*)addTopLine:(UIColor*)color;
- (UIView*)addTopLine:(UIColor *)color edgeInsets:(UIEdgeInsets)insets;


- (UIView*)addBottomLine:(UIColor*)color;
- (UIView*)addBottomLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets;

- (UIView*)addLeftLine:(UIColor*)color;
- (UIView*)addLeftLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets;

- (UIView*)addRightLine:(UIColor*)color;
- (UIView*)addRightLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets;
@end

@interface UIScrollView (CDZScrollViewExtension)
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

- (NSInteger)totalPage;
- (NSInteger)currentPage;
@end

@interface CALayer (CDZLayerExtension)
- (void)resumeAnimation;
- (void)pauseAnimation;
@end

@interface UILabel (CDZLabelExtension)
- (instancetype)initWithTextColor:(UIColor*)textColor fontSize:(CGFloat)fontSize;

- (CGSize)textSize NS_AVAILABLE(10_0, 7_0);
@end

@interface UITextField (CDZTextFieldExtension)
@property (nonatomic, assign) CGFloat leftPadding;
@property (nonatomic, assign) CGFloat rightPadding;
@end

@interface UIButton (CDZButtonExtension)
- (instancetype)initWithTitleColor:(UIColor*)titleColor fontSize:(CGFloat)fontSize;
- (instancetype)initWithTitleColor:(UIColor*)titleColor fontSize:(CGFloat)fontSize backgroundColor:(UIColor*)backgroundColor;
@end

@interface UIImage (CDZImageExtension)
// 得到一张 1*1 的纯色图片
+ (UIImage*)imageOfColor:(UIColor*)color;
+ (UIImage*)roundImageOfColor:(UIColor*)color radius:(CGFloat)radius;
+ (UIImage*)roundImageOfColor:(UIColor*)color borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth radius:(CGFloat)radius scale:(CGFloat)scale;

- (UIImage*)stretchableImage;
- (UIImage*)imageWithTintColor:(UIColor*)color;

// 缩小图片尺寸（如果本身就小于指定尺寸，则不进行任何处理）
- (UIImage*)zoomoutToSize:(CGSize)size;
- (UIImage*)zoomoutToSize:(CGSize)size aspect:(bool)aspect;
// 缩放图片尺寸
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)scaleToSize:(CGSize)size aspect:(bool)aspect;
- (UIImage*)scaleToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;
- (UIImage*)scaleToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor*)bgColor;
@end

@interface UITableView (CDZTableViewExtension)
- (void)setClearTableFooterView;
- (void)setClearTableFooterViewWidthHeight:(CGFloat)height;
- (BOOL)isClearFooterView;
@end

@interface UITableViewCell (CDZTableViewCellExtension)
// 从tableView的回收cell里，取出一个 reuseIdentifier为cell类名一个cell
+ (instancetype)reusableCellFromTable:(UITableView*)tableView;
- (CGPoint)pointAtTableView;
- (UITableView*)tableView;
@end

@interface UINavigationBar (CDZNavigationBarExtension)
@property (readwrite) UIColor* titleColor;
@end

@interface UIScreen (CDZScreenExtension)
- (CGFloat)width;
- (CGFloat)height;
@end

@interface UIColor (CDZColorExtension)
+ (UIColor*)colorWithHexadecimal:(long)hexColor;
+ (UIColor*)colorWithHexadecimal:(long)hexColor alpha:(float)opacity;
- (UIColor*)lightColor;
- (UIColor*)darkColor;
- (UIColor*)disableColor;

- (BOOL)isEqualToColor:(UIColor*)color;
@end

#pragma mark - UIViewController
@interface UIViewController(CDZControllerExtension)
+ (id)loadFromNib;
- (BOOL)isVisible;
@end

@interface UINavigationController (CDZNavigationControllerExtension)
- (void)popToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)popToViewControllerOfClass:(Class)controlelrClass animated:(BOOL)animated;
- (void)popViewControllersOfCount:(NSInteger)count animated:(BOOL)animated;
@end

@interface UIApplication (CDZApplicationExtension)
- (UIViewController*)topViewController;
- (UIWindow*)appWindow;
@end

#pragma mark - SBJson
@interface NSString (SBJson)
- (id)JSONValue;
@end

@interface NSArray (SBJson)
- (NSString*)JSONRepresentation;
@end

@interface NSDictionary (SBJson)
- (NSString*)JSONRepresentation;
@end

#pragma mark - NSObject
@interface NSObject (CDZObjectExtension)
+ (NSString*)classString;
@end

@interface NSString (CDZStringExtension)
+ (NSString*)documentDirectoryPath;
+ (NSString*)cacheDirectoryPath;
+ (NSString*)temporaryDirectoryPath;

+ (NSString*)stringWithInteger:(NSInteger)integer;
- (instancetype)initWithInteger:(NSInteger)integer;

- (void)enumerateCharactersUsingBlock:(void (^)(unichar c, NSUInteger idx, BOOL *stop))block;

// 对字符串后边添加url格式的参数。默认对不参数不进行百分号编码。
- (NSString*)stringByAppendingURLQueryDictionary:(NSDictionary*)dic;
// 对字符串后边添加url格式的参数。addingPercentEncoding表示是否对参数进行百分号编码。
- (NSString*)stringByAppendingURLQueryDictionary:(NSDictionary*)dic addingPercentEncoding:(BOOL)addingPercentEncoding;
// 获取字符串中的url参数。默认对参数进行反百分号解码。
- (NSDictionary*)URLQueryDictionary;
// 获取字符串中的url参数。removingPercentEncoding表示是否进行百分号解码。
- (NSDictionary*)URLQueryDictionaryWithRemovingPercentEncoding:(BOOL)removingPercentEncoding;

// 对字符串进行百分号编码。
- (NSString*)percentEncodingString;
- (NSURL*)urlValue;

- (long long) hexadecimalValue;

- (BOOL)matchesRegex:(NSString*)regex;

- (NSMutableAttributedString*)attributedString;
- (NSMutableAttributedString*)attributedStringWithAttribute:(NSString*)attribute value:(id)value range:(NSRange)range;
- (NSMutableAttributedString*)attributedStringAddingImage:(UIImage*)image atIndex:(NSUInteger)index offset:(CGPoint)offset;
@end

@interface NSURL (CDZURLExtentsion)
// 获取url中的参数。默认对参数进行反百分号解码。
- (NSDictionary*)queryDictionary;
// 获取url中的参数。removingPercentEncoding表示是否进行百分号解码。
- (NSDictionary*)queryDictionaryWithRemovingPercentEncoding:(BOOL)removingPercentEncoding;
@end

@interface NSArray (CDZArrayExtension)
- (id)objectOfClass:(Class)objectClass;
- (NSUInteger)indexOfObjectOfClass:(Class)objectClass;
@end

@interface NSMutableArray (CDZMutableArrayExtension)
- (void)removeFirstObject;
- (void)removeObjectOfClass:(Class)objectClass;
@end

@interface ALAsset (CDZAssetExtension)
- (UIImage*)image;             // 全分辨率图
- (UIImage*)imageOfFullScreen; // 全屏图
- (UIImage*)imageOfThumbnail;  // 缩略图
- (UIImage*)imageWithMaxSize:(CGSize)size;  // 获取缩略图，size为最大尺寸
- (UIImage*)imageWithMaxPixelLength:(NSUInteger)size;  // 获取缩略图，size为最大边长
@end

@interface NSDictionary (CDZDictionaryExtension)
- (id)objectExceptNullForKey:(id)aKey;
- (NSMutableArray*)array;
@end

@interface NSDate (CDZDateExtension)
+ (NSString*)stringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval formate:(NSString*)formate;
+ (NSDate*)dateFromString:(NSString*)dateString formate:(NSString*)formate;
+ (NSDate*)today;

- (NSDateComponents*)components;
- (NSString*)stringWithFormat:(NSString*)formate;
@end

@interface NSData (CDZDataExtension)
- (NSString*)stringWithEncoding:(NSStringEncoding)encoding;
- (NSString*)stringValue;
- (NSString*)absoluteString;
@end

@interface NSMutableData (CDZMutableDataExtension)
- (void)appendString:(NSString*)string;     // use NSUTF8StringEncoding
- (void)appendString:(NSString*)string encoding:(NSStringEncoding)encoding;
@end

@interface UIFont (CDZFontExtension)
+ (UIFont*)lightSystemFontOfSize:(CGFloat)size;
@end

@interface NSError (CDZErrorExtension)
- (instancetype)initWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString*)description;
@end

