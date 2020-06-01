//
//  ColorManager.m
//  SwiftDemo
//
//  Created by Ifeng科技 on 2019/10/8.
//  Copyright © 2019 Ifeng科技. All rights reserved.
//

#import "YLThemeController.h"


NSString *const CC_SYSTEM_LIGHT = @"YLThemeSystemLight";
NSString *const CC_SYSTEM_DARK = @"YLThemeSystemDark";

@interface YLOperationDisposer()

@property(nonatomic,copy) SetThemeOperation op;
@property(nonatomic,weak) YLThemeController *controller;
@property(nonatomic,copy) SetThemeCustomOperation customOp;

@property(nonatomic,strong) NSMutableArray *bag;

@end

@implementation YLOperationDisposer

- (void)dispose {
    for (YLOperationDisposer *disposer in _bag) {
        [self disposeForDisposer:disposer];
    }
    [self disposeForDisposer:self];
}

- (void)disposeByDisposeBag:(YLOperationDisposer *)disposeBag {
    if (!disposeBag) return;
    [disposeBag.bag addObject:self];
}

- (void)disposeForDisposer:(YLOperationDisposer *)disposer {
    NSMutableArray *opArr = [disposer.controller valueForKey:@"opArr"];
    [opArr removeObject:disposer];
    
    NSMutableDictionary *dict = [disposer.controller valueForKey:@"themeOpDict"];
    for (NSString *key in dict.allKeys) {
        NSMutableArray *arr = dict[key];
        [arr removeObject:disposer];
    }
}

- (NSMutableArray *)bag {
    if (!_bag) {
        _bag = [NSMutableArray arrayWithCapacity:1];
    }
    return _bag;
}

@end


#pragma mark -

@interface YLThemeController()

@property(nonatomic,strong) NSMutableArray *opArr;

@property(nonatomic,strong) NSMutableDictionary *themeOpDict;

@end

@implementation YLThemeController

#pragma mark  public
+ (instancetype)sharedController {
    static dispatch_once_t onceToken;
    static YLThemeController *controller;
    dispatch_once(&onceToken, ^{
        controller = [[YLThemeController alloc] init];
    });
    return controller;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self.themeConfig themeDidChange:CC_SYSTEM_LIGHT userInfo:nil];
    }
    return self;
}

- (void)configCurrentThemeName:(NSString *)themeName {
    if (!themeName) return;
    [self.themeConfig themeDidChange:themeName userInfo:nil];
    NSMutableArray *opArr = self.opArr;
    
    for (YLOperationDisposer *op in opArr) {
        if (op.op) {
            op.op(self.themeConfig);
        }
    }
    
    opArr = self.themeOpDict[themeName];
    for (YLOperationDisposer *op in opArr) {
        op.customOp();
    }
}

- (YLOperationDisposer *)addSetOperation:(SetThemeCustomOperation)op
           forThemeName:(NSString *)themeName {
    if ( !themeName || !op ) return nil;
    NSMutableArray *opArr = self.themeOpDict[themeName];
    
    YLOperationDisposer *disposer = [YLOperationDisposer new];
    disposer.customOp = op;
    disposer.controller = self;
    
    if (!opArr) {
        opArr = [NSMutableArray arrayWithCapacity:1];
        self.themeOpDict[themeName] = opArr;
    }
    [opArr addObject:disposer];
    op();
    return disposer;
}

- (YLOperationDisposer *)addSetColorOperation:(SetThemeOperation)op {
    if (!op) return nil;
    NSMutableArray *opArr = self.opArr;
    
    YLOperationDisposer *disposer = [YLOperationDisposer new];
    disposer.op = op;
    disposer.controller = self;
    
    if (!opArr) {
        opArr = [NSMutableArray arrayWithCapacity:1];
    }
    [opArr addObject:disposer];
    
    op(self.themeConfig);
    return disposer;
}


#pragma mark getter
- (id<YLThemeConfigGeneratable>)themeConfig {
    if (!_themeConfig) {
        _themeConfig = [[YLThemeConfig alloc] init];
    }
    return _themeConfig;
}


- (NSMutableArray *)opArr {
    if (!_opArr) {
        _opArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _opArr;
}

- (NSMutableDictionary *)themeOpDict {
    if (!_themeOpDict) {
        _themeOpDict = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _themeOpDict;
}

@end
