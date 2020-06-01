//
//  ColorGeneratable.h
//  SwiftDemo
//
//  Created by Ifeng科技 on 2019/10/8.
//  Copyright © 2019 Ifeng科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol YLThemeConfigGeneratable <NSObject>

/**
 提示:继承YLThemeConfig ,重载 YLThemeConfigGeneratable 中定义的实现来自定义配置
 这些方法可以删除,只是demo
 */
@required

- (void)themeDidChange:(NSString *)themeName
              userInfo:(nullable NSDictionary *)userInfo;

- (UIColor *)background_red;
- (UIColor *)background_blue;
- (UIColor *)txt_color;

@end

NS_ASSUME_NONNULL_END


/**
 优点:1.将所有颜色抽象了出来
 2.颜色的设置在单独的plist文件中,易于动态配置
 (例如:如果要新增主题,只要新加对应主题的plist文件,在代码中新增一个主题名字即可)
 
 缺点:1.要给每个颜色起名字,并且要清楚地知道每个颜色对UI的影响
 2.代码中的颜色方法要与plist文件中颜色保持一致
 */
