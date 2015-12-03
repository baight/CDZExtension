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

#define IPhone4ScreenHeight     480
#define IPhone5ScreenHeight     568
#define IPhone6ScreenHeight     667
#define IPhone6PlusScreenHeight 736

#define GCDAsyncInMain(block)        dispatch_async(dispatch_get_main_queue(), (block))
#define GCDSyncInMain(block)         dispatch_sync(dispatch_get_main_queue(), (block))
#define GCDAsyncInMainAfter(time, block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*(time)), dispatch_get_main_queue(), (block))

#define GCDAsyncInBackground(block)  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), (block))
#define GCDSyncInBackground(block)   dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), (block))
#define GCDAsyncInBackgroundAfter(time, block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*(time)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), (block))



#define StringNotNil(str) (str ? str : @"")
#define ArrayNotNil(arr) (arr ? arr : @[])

#pragma mark - UIView
@interface UIView (CDZViewExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
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
- (UIView*)viewWithClass:(Class)c;

// 移动自己 到 view 的右边，与其间距 interval
- (void)moveToRightOfView:(UIView*)view interval:(CGFloat)interval;
- (void)moveToBottomnOfView:(UIView*)view interval:(CGFloat)interval;
- (void)moveToLeftOfView:(UIView*)view inteval:(CGFloat)interval;

//获取 view 的 controller
- (UIViewController *)viewController;

- (void)addTopLine:(UIColor*)color;
- (void)addTopLine:(UIColor *)color edgeInsets:(UIEdgeInsets)insets;


- (void)addBottomLine:(UIColor*)color;
- (void)addBottomLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets;

- (void)addLeftLine:(UIColor*)color;
- (void)addLeftLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets;

- (void)addRightLine:(UIColor*)color;
- (void)addRightLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets;
@end

@interface UIScrollView (CDZScrollViewExtension)
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

- (NSInteger)totalPage;
- (NSInteger)currentPage;
@end

@interface UILabel (CDZLabelExtension)
- (CGSize)textSize;
@end

@interface UIImage (CDZImageExtension)
// 得到一张 1*1 的纯色图片
+ (UIImage*)imageOfColor:(UIColor*)color;
+ (UIImage*)roundImageOfColor:(UIColor*)color radius:(CGFloat)radius;
+ (UIImage*)roundImageOfColor:(UIColor*)color borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth radius:(CGFloat)radius scale:(CGFloat)scale;

- (UIImage*)stretchableImage;

// 缩小图片尺寸（如果本身就小于指定尺寸，则不进行任何处理）
- (UIImage*)zoomoutToSize:(CGSize)size;
- (UIImage*)zoomoutToSize:(CGSize)size aspect:(bool)aspect;
// 缩放图片尺寸
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)scaleToSize:(CGSize)size aspect:(bool)aspect;
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
@end

#pragma mark - UIViewController
@interface UIViewController(CDZControllerExtension)
+ (id)loadFromNib;
- (BOOL)isVisible;
@end

@interface UINavigationController (CDZNavigationControllerExtension)
- (void)popToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)popControllersCount:(NSInteger)count animated:(BOOL)animated;
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

- (NSString*)urlStringWithParamsDictionary:(NSDictionary*)dic;
- (NSDictionary*)dictionaryOfUrlParams;
- (long long) hexadecimalValue;

- (NSMutableAttributedString*)attributedStringWithAttribute:(NSString*)attribute value:(id)value range:(NSRange)range;
@end

@interface NSMutableArray (CDZArrayExtension)
- (void)removeFirstObject;
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
@end

@interface NSDate (CDZDateExtension)
+ (NSString*)stringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval formate:(NSString*)formate;
- (NSString*)stringWithFormat:(NSString*)formate;
@end

@interface NSData (CDZDataExtension)
- (NSString*)stringWithEncoding:(NSStringEncoding)encoding;
- (NSString*)stringValue;
@end

@interface NSError (CDZErrorExtension)
- (NSString*)errorMessage;
@end

