//
//  ColorManager.h
//  SwiftDemo
//
//  Created by Ifeng科技 on 2019/10/8.
//  Copyright © 2019 Ifeng科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLThemeConfigGeneratable.h"
#import "YLThemeConfig.h"
/**
 FIX ME:block 内存引用问题
 单例强引用了 颜色设置的block, 而如果不加weak修饰,会导致block中引用的对象无法释放
 对引用的元素都是用weak修饰,可以不影响对象的声明周期,都要用weak修饰也挺蛋疼
 */

NS_ASSUME_NONNULL_BEGIN

extern NSString *const CC_SYSTEM_LIGHT;
extern NSString *const CC_SYSTEM_DARK;


typedef void (^SetThemeOperation)(id<YLThemeConfigGeneratable> colorGen);
typedef void (^SetThemeCustomOperation) (void);

@interface YLOperationDisposer:NSObject

- (void)dispose;

- (void)disposeByDisposeBag:(YLOperationDisposer *)disposeBag;

@end

@interface YLThemeController:NSObject

/** 主题配置,可以自定义*/
@property(nonatomic,strong,nonnull) id<YLThemeConfigGeneratable> themeConfig;

/** 单例方法*/
+ (instancetype)sharedController;

/** 设置当前的主题*/
- (void)configCurrentThemeName:(NSString *)themeName;

/**
 使用YLThemeConfigGeneratable 中的主题配置设置UI
 注意:block中的容器必须用weak修饰, 比如ViewController,自定义view等, 临时变量可以不同weak
 */
- (nullable YLOperationDisposer *)addSetColorOperation:(SetThemeOperation)op;

/**
 自定义设置UI
 注意:block中的容器必须用weak修饰, 比如ViewController,自定义view等, 临时变量可以不同weak
 */
- (nullable YLOperationDisposer *)addSetOperation:(SetThemeCustomOperation)op
           forThemeName:(NSString *)themeName;
@end




NS_ASSUME_NONNULL_END
