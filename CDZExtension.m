//
//  CDZExtension.m
//
//
//  Created by baight on 14-8-21.
//  Copyright (c) 2014年 baight. All rights reserved.
//

#import "CDZExtension.h"
#import <ImageIO/ImageIO.h>

inline void GCDAsyncInMain(dispatch_block_t block){
    dispatch_async(dispatch_get_main_queue(), block);
}
inline void GCDSyncInMain(dispatch_block_t block){
    dispatch_sync(dispatch_get_main_queue(), block);
}
inline void GCDSafeSyncInMain(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
inline void GCDAsyncInMainAfter(NSTimeInterval time, dispatch_block_t block){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*(time)), dispatch_get_main_queue(), block);
}

inline void GCDAsyncInBackground(dispatch_block_t block){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
inline void GCDSyncInBackground(dispatch_block_t block){
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
inline void GCDAsyncInBackgroundAfter(NSTimeInterval time, dispatch_block_t block){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*(time)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

#pragma mark - UIView
@implementation UIView (CDZViewExtension)
+ (id)loadFromBundleWithOwner:(id)owner{
    NSString* className = NSStringFromClass([self class]);
    id obj = [[[NSBundle mainBundle] loadNibNamed:className owner:owner options:nil] firstObject];
    if([obj isKindOfClass:[UITableViewCell class]]){
        [obj setValue:className forKey:@"reuseIdentifier"];
    }
    return obj;
}

- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (CGFloat)right{
    return CGRectGetMaxX(self.frame);
}
- (void)setRight:(CGFloat)right;{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)bottom{
    return CGRectGetMaxY(self.frame);
}
- (void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}
- (CGSize)size{
    return self.frame.size;
}

- (CGFloat)centerX{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}
- (CGFloat)centerY{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}
- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.masksToBounds = YES;
}
- (UIColor*)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}
- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}
- (void)setBorderColor:(UIColor*)borderColor width:(CGFloat)width{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = width;
    self.layer.masksToBounds = YES;
}

- (UIImage*)snapshoot{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width,self.bounds.size.height), self.opaque, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if([self isKindOfClass:[UIScrollView class]]){
        UIScrollView* s = (UIScrollView*)self;
        CGContextTranslateCTM(context, -s.contentOffset.x, -s.contentOffset.y);
    }
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)removeAllSubviews{
    for(UIView* v in self.subviews){
        [v removeFromSuperview];
    }
}
- (__kindof UIView*)viewWithClass:(Class)c;{
    for(UIView* v in self.subviews){
        if( [v isMemberOfClass:c]){
            return v;
        }
    }
    return nil;
}

- (__kindof UIView*)theFirstResponder{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView theFirstResponder];
        if (responder) {
            return responder;
        }
    }
    return nil;
}

- (void)moveToRightOfView:(UIView *)view interval:(CGFloat)interval{
    CGSize size = view.bounds.size;
    if([view isKindOfClass:[UILabel class]]){
        UILabel* label = (UILabel*)view;
        size = [label.text sizeWithFont:label.font];
        if(size.width > view.bounds.size.width){
            size.width = view.bounds.size.width;
        }
    }
    CGRect rect = self.frame;
    rect.origin.x = view.frame.origin.x + size.width + interval;
    self.frame = rect;
}

- (void)moveToLeftOfView:(UIView*)view inteval:(CGFloat)interval{
    CGSize size = view.bounds.size;
    if([view isKindOfClass:[UILabel class]]){
        UILabel* label = (UILabel*)view;
        size = [label.text sizeWithFont:label.font];
        if(size.width > view.bounds.size.width){
            size.width = view.bounds.size.width;
        }
    }
    CGRect rect = self.frame;
    rect.origin.x = view.frame.origin.x - interval;
    self.frame = rect;
}

- (void)moveToBottomnOfView:(UIView*)view interval:(CGFloat)interval{
    CGRect rect = self.frame;
    rect.origin.y = view.frame.origin.y + view.bounds.size.height + interval;
    self.frame = rect;
}

//获取view的controller
- (UIViewController *)viewController{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIView*)addTopLine:(UIColor*)color{
    return [self addTopLine:color edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (UIView*)addTopLine:(UIColor *)color edgeInsets:(UIEdgeInsets)insets{
    CGFloat lineWidth = 1/[UIScreen mainScreen].scale;
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(insets.left, -lineWidth + insets.top, self.width-insets.left - insets.right, lineWidth)];
    v.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    v.backgroundColor = color;
    [self addSubview:v];
    return v;
}
- (UIView*)addBottomLine:(UIColor*)color{
    return [self addBottomLine:color edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (UIView*)addBottomLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets;{
    CGFloat lineWidth = 1/[UIScreen mainScreen].scale;
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(insets.left, self.height-lineWidth - insets.bottom, self.width - insets.left - insets.right, lineWidth)];
    v.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    v.backgroundColor = color;
    [self addSubview:v];
    return v;
}
- (UIView*)addLeftLine:(UIColor*)color{
    return [self addLeftLine:color edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (UIView*)addLeftLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets{
    CGFloat lineWidth = 1/[UIScreen mainScreen].scale;
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(insets.left-lineWidth, insets.top, lineWidth, self.height - insets.top - insets.bottom)];
    v.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    v.backgroundColor = color;
    [self addSubview:v];
    return v;
}
- (UIView*)addRightLine:(UIColor*)color{
    return [self addRightLine:color edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (UIView*)addRightLine:(UIColor*)color edgeInsets:(UIEdgeInsets)insets{
    CGFloat lineWidth = 1/[UIScreen mainScreen].scale;
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(self.width - lineWidth - insets.right, insets.top, lineWidth, self.height - insets.top - insets.bottom)];
    v.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    v.backgroundColor = color;
    [self addSubview:v];
    return v;
}

@end

@implementation UIScrollView (CDZScrollViewExtension)
- (CGFloat)contentWidth{
    return self.contentSize.width;
}
- (void)setContentWidth:(CGFloat)contentWidth{
    CGSize size = self.contentSize;
    size.width= contentWidth;
    self.contentSize = size;
}
- (CGFloat)contentHeight{
    return self.contentSize.height;
}
- (void)setContentHeight:(CGFloat)contentHeight{
    CGSize size = self.contentSize;
    size.height = contentHeight;
    self.contentSize = size;
}
- (NSInteger)totalPage{
    NSInteger page = self.contentSize.width / self.bounds.size.width;
    if(self.contentSize.width - page*self.bounds.size.width > 10){
        page++;
    }
    return page;
}
- (NSInteger)currentPage{
    NSInteger page = self.contentOffset.x / self.bounds.size.width;
    if(self.contentOffset.x - page*self.bounds.size.width > self.bounds.size.width/2){
        page++;
    }
    return page;
}
@end

@implementation CALayer (CDZLayerExtension)
- (void)resumeAnimation{
    CFTimeInterval pausedTime = [self timeOffset];
    self.timeOffset = 0.0;
    self.speed = 1.0;
    self.beginTime = 0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}
- (void)pauseAnimation{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.timeOffset = pausedTime;
    self.speed = 0.0;
}
@end

@implementation UILabel(CDZLabelExtension)
- (instancetype)initWithTextColor:(UIColor*)textColor fontSize:(CGFloat)fontSize{
    if (self = [super init]) {
        if (textColor) {
            self.textColor = textColor;
        }
        if (fontSize > 0) {
            self.font = [UIFont systemFontOfSize:fontSize];
        }
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (CGSize)textSize{
    return [self.text sizeWithFont:self.font];
}
@end

@implementation UITextField (CDZTextFieldExtension)
- (CGFloat)leftPadding{
    return self.leftView.frame.size.width;
}
- (void)setLeftPadding:(CGFloat)leftPadding{
    if (self.leftView == nil) {
        self.leftView = [[UIView alloc]init];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    CGRect frame = self.leftView.frame;
    frame.size.width = leftPadding;
    self.leftView.frame = frame;
}
- (CGFloat)rightPadding{
    return self.rightView.frame.size.width;
}
- (void)setRightPadding:(CGFloat)rightPadding{
    if (self.rightView == nil) {
        self.rightView = [[UIView alloc]init];
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    CGRect frame = self.rightView.frame;
    frame.size.width = rightPadding;
    self.rightView.frame = frame;
}
@end

@implementation UIButton (CDZButtonExtension)
- (instancetype)initWithTitleColor:(UIColor*)titleColor fontSize:(CGFloat)fontSize{
    return [self initWithTitleColor:titleColor fontSize:fontSize backgroundColor:nil];
}
- (instancetype)initWithTitleColor:(UIColor*)titleColor fontSize:(CGFloat)fontSize backgroundColor:(UIColor*)backgroundColor{
    if (self = [super init]) {
        if (titleColor) {
            [self setTitleColor:titleColor forState:UIControlStateNormal];
            [self setTitleColor:titleColor.darkColor forState:UIControlStateHighlighted];
        }
        if (fontSize > 0) {
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
        if (backgroundColor) {
            [self setBackgroundImage:[UIImage imageOfColor:backgroundColor] forState:UIControlStateNormal];
        }
    }
    return self;
}
@end

@implementation UIImage (CDZImageExtension)
+ (UIImage*)imageOfColor:(UIColor*)color{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage*)roundImageOfColor:(UIColor*)color radius:(CGFloat)radius{
    return [self roundImageOfColor:color borderColor:nil borderWidth:0 radius:radius scale:[UIScreen mainScreen].scale];
}
+ (UIImage*)roundImageOfColor:(UIColor*)color borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth radius:(CGFloat)radius scale:(CGFloat)scale{
    CGFloat diameter = radius*2;
    CGFloat size = diameter + borderWidth;
    CGFloat halfBorderWidth = borderWidth/2;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(halfBorderWidth, halfBorderWidth, diameter, diameter));
    if(borderColor && borderWidth > 0){
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else{
        CGContextDrawPath(context, kCGPathFill);
    }
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)stretchableImage{
    return [self stretchableImageWithLeftCapWidth:self.size.width/2 topCapHeight:self.size.height/2];
}
- (UIImage*)imageWithTintColor:(UIColor*)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)zoomoutToSize:(CGSize)size{
    return [self zoomoutToSize:size aspect:false];
}
- (UIImage*)zoomoutToSize:(CGSize)size aspect:(bool)aspect{
    if(self.size.width*self.scale > size.width || self.size.height*self.scale > size.height){
        return [self scaleToSize:size aspect:aspect];
    }
    else{
        return self;
    }
}
- (UIImage*)scaleToSize:(CGSize)size{
    return [self scaleToSize:size aspect:false];
}
- (UIImage*)scaleToSize:(CGSize)size aspect:(bool)aspect{
    int width = size.width, height = size.height;
    if(aspect){
        // 先假设以宽为基准
        width = size.width;
        height = size.width * self.size.height/self.size.width;
        
        // 如果假设不成立，则改为以高为基准
        if(height > size.height){
            height = size.height;
            width = size.height * self.size.width/self.size.height;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width,
                                                      height),
                                           YES,
                                           0);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

@interface CDZClearFooterView : UIView
@end
@implementation CDZClearFooterView
@end
@implementation UITableView (CDZTableViewExtension)
- (void)setClearTableFooterView{
    self.tableFooterView = [[CDZClearFooterView alloc]init];
    self.tableFooterView.backgroundColor = [UIColor clearColor];
}
- (void)setClearTableFooterViewWidthHeight:(CGFloat)height{
    self.tableFooterView = [[CDZClearFooterView alloc]initWithFrame:CGRectMake(0, 0, 1, height)];
    self.tableFooterView.backgroundColor = [UIColor clearColor];
}
- (BOOL)isClearFooterView{
    return [self.tableFooterView isKindOfClass:[CDZClearFooterView class]];
}
@end

@implementation UITableViewCell (CDZTableViewCellExtension)
+ (instancetype)reusableCellFromTable:(UITableView*)tableView{
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
}
- (CGPoint)pointAtTableView{
    UITableView* tableView = [self tableView];
    CGPoint point = [self convertPoint:CGPointMake(0, 0) toView:tableView];
    return point;
}
- (UITableView*)tableView{
    UIView* tableView = self.superview;
    while (tableView != nil) {
        if([tableView isKindOfClass:[UITableView class]]){
            return (UITableView*)tableView;
        }
        tableView = tableView.superview;
    }
    return nil;
}
@end

@implementation UINavigationBar (CDZNavigationBarExtension)
- (void)setTitleColor:(UIColor *)titleColor{
    if(titleColor == nil){
        return;
    }
    NSMutableDictionary* dic;
    if(self.titleTextAttributes == nil){
        dic = [[NSMutableDictionary alloc]init];
    }else{
        dic = [[NSMutableDictionary alloc]initWithDictionary:self.titleTextAttributes];
    }
    [dic setObject:titleColor forKey:NSForegroundColorAttributeName];
    self.titleTextAttributes = dic;
}
- (UIColor*)titleColor{
    return self.titleTextAttributes[NSForegroundColorAttributeName];
}
@end

@implementation UIScreen (CDZScreenExtension)
- (CGFloat)width{
    return self.bounds.size.width;
}
- (CGFloat)height{
    return self.bounds.size.height;
}
@end

@implementation UIColor (CDZColorExtension)
+ (UIColor*) colorWithHexadecimal:(long)hexColor{
    return [UIColor colorWithHexadecimal:hexColor alpha:1.];
}
+ (UIColor *)colorWithHexadecimal:(long)hexColor alpha:(float)opacity{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}
- (UIColor*)lightColor{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:(1+r)/2 green:(1+g)/2 blue:(1+b)/2 alpha:a];
}
- (UIColor*)darkColor{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r/2 green:g/2 blue:b/2 alpha:a];
}
- (UIColor*)disableColor{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    CGFloat va = (r + g + b) / 3;
    if(va > 0.5){
        return [UIColor colorWithRed:(va+r)/2/2 green:(va+g)/2/2 blue:(va+b)/2/2 alpha:a];
    }
    else{
        return [UIColor colorWithRed:(1+ (va+r)/2)/2 green:(1+ (va+g)/2)/2 blue:(1+ (va+b)/2)/2 alpha:a];
    }
}
- (BOOL)isEqualToColor:(UIColor*)color{
    CGFloat redValue, greenValue, blueValue, alphaValue;
    CGFloat myRedValue, myGreenValue, myBlueValue, myAlphaValue;
    [color getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue];
    [self getRed:&myRedValue green:&myGreenValue blue:&myBlueValue alpha:&myAlphaValue];
    return (redValue == myRedValue && greenValue == myGreenValue && blueValue == myBlueValue && alphaValue == myAlphaValue);
}
@end

#pragma mark - UIViewController
@implementation UIViewController(CDZControllerExtension)
+ (id)loadFromNib{
    __autoreleasing UIViewController* c = [[self alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
    return c;
}
- (BOOL)isVisible{
    return (self.isViewLoaded && self.view.window != nil);
}
@end

@implementation UINavigationController (CDZNavigationControllerExtension)
- (void)popToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated{
    if (index >= self.viewControllers.count) {
        return;
    }
    UIViewController* c = [self.viewControllers objectAtIndex:index];
    [self popToViewController:c animated:animated];
}
- (void)popToViewControllerOfClass:(Class)controlelrClass animated:(BOOL)animated{
    if (self.viewControllers.count == 0) {
        return;
    }
    __block UIViewController* popToController = nil;
    [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController * obj, NSUInteger idx, BOOL *  stop) {
        if ([obj isKindOfClass:controlelrClass]) {
            popToController = obj;
            *stop = YES;
        }
    }];
    if (popToController) {
        [self popToViewController:popToController animated:animated];
    }
    else{
        [self popViewControllerAnimated:YES];
    }
}
- (void)popViewControllersOfCount:(NSInteger)count animated:(BOOL)animated{
    if (count + 1 > self.viewControllers.count) {
        [self popToRootViewControllerAnimated:animated];
    }
    else {
        UIViewController* c = [self.viewControllers objectAtIndex:self.viewControllers.count-1-count];
        [self popToViewController:c animated:YES];
    }
}

@end

@implementation UIApplication (CDZApplicationExtension)
- (UIViewController*)topViewController{
    UIWindow * window = [self appWindow];
    UIViewController* controller = window.rootViewController;
    do{
        while (controller.presentedViewController) {
            controller = controller.presentedViewController;
        }
        if ([controller isKindOfClass:[UINavigationController class]]){
            UINavigationController* nav = (UINavigationController*)controller;
            controller = [nav topViewController];
        }
        else if ([controller isKindOfClass:[UIViewController class]]){
            //controller = controller;
        }
        else{
            break;
        }
    } while (controller.presentedViewController);
    
    return controller;
}
- (UIWindow*)appWindow{
    UIWindow* appWindow = self.keyWindow;
    if(appWindow.windowLevel != UIWindowLevelNormal){
        for(UIWindow* w in self.windows){
            if(w.windowLevel == UIWindowLevelNormal && !w.hidden){
                appWindow = w;
                break;
            }
        }
    }
    return appWindow;
}
@end

#pragma mark - SBJson
@implementation NSString (SBJson)
- (id)JSONValue{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) return nil;
    return result;
}
@end

@implementation NSArray (SBJson)
- (NSString*)JSONRepresentation{
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    
    __autoreleasing NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}
@end

@implementation NSDictionary (SBJson)
- (NSString*)JSONRepresentation{
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    
    __autoreleasing NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}
@end

#pragma mark - NSObject

@implementation NSObject (CDZObjectExtension)
+ (NSString*)classString{
    return NSStringFromClass([self class]);
}
@end

@implementation NSString (CDZStringExtension)
+ (NSString*)documentDirectoryPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}
+ (NSString*)cacheDirectoryPath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}
+ (NSString*)temporaryDirectoryPath{
    return NSTemporaryDirectory();
}
+ (NSString*)stringWithInteger:(NSInteger)integer{
    return [NSString stringWithFormat:@"%zd", integer, nil];
}
- (instancetype)initWithInteger:(NSInteger)integer{
    return [self initWithFormat:@"%zd", integer, nil];
}
- (void)enumerateCharactersUsingBlock:(void (^)(unichar c, NSUInteger idx, BOOL *stop))block{
    if(block == nil){
        return;
    }
    BOOL stop = NO;
    for(NSInteger index = 0; index < self.length; index++){
        unichar c = [self characterAtIndex:index];
        block(c, index, &stop);
        if(stop){
            break;
        }
    }
}

- (NSString*)urlStringWithParamsDictionary:(NSDictionary*)dic{
    if(dic.count == 0){
        return [self copy];
    }
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:self];
    NSRange range = [urlString rangeOfString:@"?"];
    if(range.location == NSNotFound){
        [urlString appendString:@"?"];
    }
    else if(![urlString hasSuffix:@"&"]){
        [urlString appendString:@"&"];
    }
    for(NSString* key in dic){
        NSString* value = dic[key];
        [urlString appendFormat:@"%@=%@&", key, value];
    }
    [urlString deleteCharactersInRange:NSMakeRange(urlString.length-1, 1)];
    return urlString;
}
- (NSDictionary*)urlParamDictionary{
    NSString* urlString;
    if (SystemVersionBiggerOrEqual(@"7.0")){
        urlString = [self stringByRemovingPercentEncoding];
    }
    else {
        urlString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSString* params = urlString;
    NSRange range = [urlString rangeOfString:@"?"];
    if(range.location != NSNotFound && range.location != urlString.length-1){
        params = [urlString substringFromIndex:range.location+1];
    }
    
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    NSArray* a = [params componentsSeparatedByString:@"&"];
    for(NSString* p in a){
        NSArray* keyValue = [p componentsSeparatedByString:@"="];
        if(keyValue.count > 1){
            NSString* key = [keyValue firstObject];
            NSString* value = [keyValue lastObject];
            if(key && value){
                [d setObject:value forKey:key];
            }
        }
    }
    return d;
}

- (NSString*)percentEncodingString{
    if (SystemVersionBiggerOrEqual(@"7.0")) {
        return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSMutableCharacterSet URLQueryAllowedCharacterSet]];
    }
    else {
        return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}
- (NSURL*)urlValue{
    NSString* percentEncodingString = [self percentEncodingString];
    return [NSURL URLWithString:percentEncodingString];
}

- (long long) hexadecimalValue{
    if(self.length == 0){
        return 0;
    }
    long long ans = 0;
    NSUInteger times = 0;
    for(NSInteger i = self.length - 1; i >= 0; i--){
        unichar c = [self characterAtIndex:i];
        // 数字
        if(c <= '9'){
            ans += (c - '0') << times;
        }
        // 大写字母
        else if(c <= 'A'){
            ans += (c - 'A' + 10) << times;
        }
        // 小写字母
        else{
            ans += (c - 'a' + 10) << times;
        }
        times += 4;
    }
    return ans;
}

- (BOOL)matchesRegex:(NSString*)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
- (NSMutableAttributedString*)attributedString{
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc]initWithString:self];
    return mas;
}
- (NSMutableAttributedString*)attributedStringWithAttribute:(NSString*)attribute value:(id)value range:(NSRange)range{
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc]initWithString:self];
    [mas addAttribute:attribute value:value range:range];
    return mas;
}
- (NSMutableAttributedString*)attributedStringAddingImage:(UIImage*)image atIndex:(NSUInteger)index offset:(CGPoint)offset{
    NSTextAttachment* textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(offset.x, -offset.y, image.size.width, image.size.height);
    NSAttributedString* imageAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc]initWithString:self];
    [mas insertAttributedString:imageAttributedString atIndex:index];
    return mas;
}
@end

@implementation NSArray (CDZArrayExtension)
- (id)objectOfClass:(Class)objectClass{
    if (objectClass == nil) {
        return nil;
    }
    for (id obj in self) {
        if ([obj isKindOfClass:objectClass]) {
            return obj;
        }
    }
    return nil;
}
- (NSUInteger)indexOfObjectOfClass:(Class)objectClass{
    if (objectClass == nil) {
        return NSNotFound;
    }
    NSUInteger index = 0;
    for (id obj in self) {
        if ([obj isKindOfClass:objectClass]) {
            return index;
        }
        index++;
    }
    return NSNotFound;
}
@end

@implementation  NSMutableArray (CDZMutableArrayExtension)
- (void)removeFirstObject{
    if(self.count > 0){
        [self removeObjectAtIndex:0];
    }
}
@end

@implementation ALAsset (CDZAssetExtension)
- (UIImage*)image{
    ALAssetRepresentation *assetRep = [self defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:UIImageOrientationUp];
    return img;
}
- (UIImage*)imageOfFullScreen{
    ALAssetRepresentation *assetRep = [self defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:UIImageOrientationUp];
    return img;
}
- (UIImage*)imageOfThumbnail{
    CGImageRef  ref = [self thumbnail];
    UIImage *img = [UIImage imageWithCGImage:ref];
    return img;
}
- (UIImage*)imageWithMaxSize:(CGSize)size{
    ALAssetRepresentation *assetRep = [self defaultRepresentation];
    CGSize mySize = [assetRep dimensions];
    
    UIImage* img = nil;
    if(mySize.width > mySize.height){
        if(mySize.width > size.width){
            img = [self imageWithMaxPixelLength:size.width];
        }
        else{
            img = [self image];
        }
    }
    else{
        if(mySize.height > size.height){
            img = [self imageWithMaxPixelLength:size.height];
        }
        else{
            img = [self image];
        }
    }
    return img;
}

// 下边的方法，摘自网络，http://blog.csdn.net/huangmindong/article/details/34884257
// Helper methods for thumbnailForAsset:maxPixelSize:
static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count){
    ALAssetRepresentation *rep = (__bridge id)info;
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        NSLog(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }
    return countRead;
}
static void releaseAssetCallback(void *info){
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}
// Returns a UIImage for the given asset, with size length at most the passed size.
// The resulting UIImage will be already rotated to UIImageOrientationUp, so its CGImageRef
// can be used directly without additional rotation handling.
// This is done synchronously, so you should call this method on a background queue/thread.
- (UIImage *)imageWithMaxPixelLength:(NSUInteger)size{
    NSParameterAssert(size > 0);
    ALAssetRepresentation *rep = [self defaultRepresentation];
    CGDataProviderDirectCallbacks callbacks ={
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)
  @{   (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
       (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithUnsignedInteger:size],
       (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
       });
    
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return toReturn;
}
@end

@implementation NSDictionary (CDZDictionaryExtension)
- (id)objectExceptNullForKey:(id)aKey{
    id object = [self objectForKey:aKey];
    if([object isKindOfClass:[NSNull class]]){
        return nil;
    }
    else{
        return object;
    }
}
- (NSMutableArray*)array{
    NSMutableArray* array = [NSMutableArray array];
    for (NSString* key in self) {
        id obj = [self objectForKey:key];
        [array addObject:obj];
    }
    return array;
}
@end

@implementation NSDate (CDZDateExtension)
+ (NSString*)stringFromTimeIntervalSince1970:(NSTimeInterval)timeInterval formate:(NSString*)formate{
    NSDate* date = [[NSDate alloc]initWithTimeIntervalSince1970:timeInterval];
    return [date stringWithFormat:formate];
}
+ (NSDate*)dateFromString:(NSString*)dateString formate:(NSString*)formate{
    if (dateString == nil || formate == nil) {
        return nil;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formate];
    return [formatter dateFromString:dateString];
}
+ (NSDate*)today{
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* components = [calendar components:unitFlags fromDate:now];
    
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    return [calendar dateFromComponents:components];
}

- (NSDateComponents*)components{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:self];
    return comps;
}
- (NSString*)stringWithFormat:(NSString*)formate{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formate];
    return [formatter stringFromDate:self];
}
@end

@implementation NSData (CDZDataExtension)
- (NSString*)stringWithEncoding:(NSStringEncoding)encoding{
    return [[NSString alloc]initWithData:self encoding:encoding];
}
- (NSString*)stringValue{
    NSString* string = [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
    if(string.length == 0){
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        string = [[NSString alloc] initWithData:self encoding:enc];
    }
    return string;
}
- (NSString*)absoluteString{
    NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
    return [[self.description componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}
@end

@implementation UIFont (CDZFontExtension)
+ (UIFont*)lightSystemFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"STHeitiSC-Light" size:size];
}
@end

@implementation NSError (CDZErrorExtension)
- (instancetype)initWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString*)description{
    return [self initWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey:StringNotNil(description)}];
}
@end



