//
//  CoreTextData.h
//  CoreText
//
//  Created by hzf on 16/8/24.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FE_CoreTextImageData.h"

/**
 *  用于保存由CTFrameParser类生成的CTFrameRef实例以及CTFrameRef实际绘制需要的高度
 */
@interface FE_CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *linkArray;

@end
