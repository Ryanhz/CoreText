//
//  CTFrameParser.h
//  CoreText
//
//  Created by hzf on 16/8/24.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FE_CoreTextData.h"
#import "FE_CoreTextImageData.h"
#import "FE_CoreTextLinkData.h"
#import "FE_CTFrameParserConfig.h"


/**
 *  用于生成最后绘制界面需要的CTFrameRef实例。
 */
@interface FE_CTFrameParser : NSObject

+ (FE_CoreTextData *)parseTemplateFile:(NSString *)path config:(FE_CTFrameParserConfig*)config;

+ (FE_CoreTextData *)parseContent:(NSAttributedString *)content config:(FE_CTFrameParserConfig *)config;



@end
