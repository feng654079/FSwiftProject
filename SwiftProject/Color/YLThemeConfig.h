//
//  ThemeColor.h
//  SwiftDemo
//
//  Created by Ifeng科技 on 2019/10/8.
//  Copyright © 2019 Ifeng科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLThemeConfigGeneratable.h"
NS_ASSUME_NONNULL_BEGIN

@interface YLThemeConfig : NSObject <YLThemeConfigGeneratable>

/** 当前主题的名称 默认 SystemLight */
@property(nonatomic,strong) NSString *currentThemeName;

+ (UIColor *)colorWithHexStr:(NSString *)hexString;


@end




NS_ASSUME_NONNULL_END
