//
//  CTFrameParserConfig.m
//  CoreText
//
//  Created by hzf on 16/8/24.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "FE_CTFrameParserConfig.h"

@implementation FE_CTFrameParserConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _width = 200.0;
        _fontSize = 16;
        _lineSpace = 8;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}



@end
