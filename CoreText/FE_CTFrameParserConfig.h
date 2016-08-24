//
//  CTFrameParserConfig.h
//  CoreText
//
//  Created by hzf on 16/8/24.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用于配置绘制的参数，例如：文字颜色，大小，行间距等
 */
@interface FE_CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;

@end
