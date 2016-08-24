//
//  CTFrameParser.h
//  CoreText
//
//  Created by hzf on 16/8/24.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "FE_CTFrameParserConfig.h"


/**
 *  用于生成最后绘制界面需要的CTFrameRef实例。
 */
@interface FE_CTFrameParser : NSObject

+ (CoreTextData *)parseContent:(NSString *)content config:(FE_CTFrameParserConfig *)config;



@end
