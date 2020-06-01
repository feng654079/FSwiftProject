//
//  ThemeColor.m
//  SwiftDemo
//
//  Created by Ifeng科技 on 2019/10/8.
//  Copyright © 2019 Ifeng科技. All rights reserved.
//

#import "YLThemeConfig.h"

/** 以下来自YYKit大神代码*/
static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf(str.UTF8String, "%X",&result);
    return result;
}

static BOOL hexStrToRGBA(NSString *str , CGFloat *r , CGFloat *g, CGFloat *b ,CGFloat *a) {
    NSCharacterSet *set  = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *result = [str stringByTrimmingCharactersInSet:set].uppercaseString;
    if ([result hasPrefix:@"#"]) {
        result = [result substringFromIndex:1];
    } else if ([result hasPrefix:@"0X"]) {
        result = [result substringFromIndex:2];
    }
    NSInteger length = [result length];
    if (
        length != 3       //RGB
        && length != 4    //RGBA
        && length != 6    //RRGGBB
        && length != 8    //RRGGBBAA
        ) {
        return NO;
    }
    
    if (length < 5) {
        *r = hexStrToInt([result substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([result substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([result substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4) {
            *a = hexStrToInt([result substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        } else {
            *a = 1;
        }
    } else {
        *r = hexStrToInt([result substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([result substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([result substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) {
            *a = hexStrToInt([result substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        } else {
            *a = 1;
        }
    }
    return YES;
}



@interface YLThemeConfig()

@property(nonatomic,strong) NSDictionary *configMap;

@end

@implementation YLThemeConfig

#pragma mark  public
+ (UIColor *)colorWithHexStr:(NSString *)hexString {
    CGFloat r,g,b,a;
    if (hexStrToRGBA(hexString, &r, &g, &b, &a)) {
        return  [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _currentThemeName = @"SystemLight";
    }
    return self;
}

#pragma mark  private
- (UIColor *)colorForName:(NSString *)name {
    NSString *hex = self.configMap[name];
    return [self.class colorWithHexStr:hex];
}

#pragma mark  setter
- (void)setCurrentThemeName:(NSString *)currentThemeName {
    if (currentThemeName == nil) return;
    _currentThemeName = currentThemeName;
    _configMap = nil;
}


#pragma mark getter
- (NSDictionary *)configMap {
    if (!_configMap) {
        NSBundle *bunldle = [NSBundle bundleForClass:self.class];
        NSString *path = [bunldle pathForResource:_currentThemeName ofType:@"plist"];
//        NSArray *pathArr = [bunldle pathsForResourcesOfType:@"plist" inDirectory:nil];
//        NSInteger themeCount = 0;
//        for (NSString *aPath in pathArr) {
//            if ([[aPath componentsSeparatedByString:@"/"].lastObject hasPrefix:@"YLTheme"]) {
//                themeCount++;
//            }
//        }
//        NSLog(@"主题数:%ld",themeCount);
        _configMap = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _configMap;
}



#pragma mark - YLThemeConfigGeneratable
- (void)themeDidChange:(NSString *)themeName userInfo:(NSDictionary *)userInfo {
    self.currentThemeName = themeName;
}

- (UIColor *)background_red {
    return [self colorForName:@"background_red"];
}

- (UIColor *)background_blue {
    return [self colorForName:@"background_blue"];
}

- (UIColor *)txt_color {
    return [self colorForName:@"txt_color"];
}
@end

