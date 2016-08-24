//
//  CTFrameParser.m
//  CoreText
//
//  Created by hzf on 16/8/24.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "FE_CTFrameParser.h"



/*
 kCTParagraphStyleSpecifierAlignment = 0,                 //对齐属性
 kCTParagraphStyleSpecifierFirstLineHeadIndent = 1,       //首行缩进
 kCTParagraphStyleSpecifierHeadIndent = 2,                //段头缩进
 kCTParagraphStyleSpecifierTailIndent = 3,                //段尾缩进
 kCTParagraphStyleSpecifierTabStops = 4,                  //制表符模式
 kCTParagraphStyleSpecifierDefaultTabInterval = 5,        //默认tab间隔
 kCTParagraphStyleSpecifierLineBreakMode = 6,             //换行模式
 kCTParagraphStyleSpecifierLineHeightMultiple = 7,        //多行高
 kCTParagraphStyleSpecifierMaximumLineHeight = 8,         //最大行高
 kCTParagraphStyleSpecifierMinimumLineHeight = 9,         //最小行高
 kCTParagraphStyleSpecifierLineSpacing = 10,              //行距
 kCTParagraphStyleSpecifierParagraphSpacing = 11,         //段落间距  在段的未尾（Bottom）加上间隔，这个值为负数。
 kCTParagraphStyleSpecifierParagraphSpacingBefore = 12,   //段落前间距 在一个段落的前面加上间隔。TOP
 kCTParagraphStyleSpecifierBaseWritingDirection = 13,     //基本书写方向
 kCTParagraphStyleSpecifierMaximumLineSpacing = 14,       //最大行距
 kCTParagraphStyleSpecifierMinimumLineSpacing = 15,       //最小行距
 kCTParagraphStyleSpecifierLineSpacingAdjustment = 16,    //行距调整
 kCTParagraphStyleSpecifierCount = 17,        //
 
 
 
 
 
 
 kCTLeftTextAlignment = 0,                //左对齐
 kCTRightTextAlignment = 1,               //右对齐
 kCTCenterTextAlignment = 2,              //居中对齐
 kCTJustifiedTextAlignment = 3,           //文本对齐
 kCTNaturalTextAlignment = 4              //自然文本对齐
 */

@implementation FE_CTFrameParser

+ (NSDictionary *)attributesWithConfig:(FE_CTFrameParserConfig *)config {
    
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef) @"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    
    const CFIndex kNumberOfSetting = 3;
    
    CTParagraphStyleSetting setting1;
    setting1.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    setting1.valueSize = sizeof(CGFloat);
    setting1.value = &lineSpacing;
    
    
    CTParagraphStyleSetting setting2;
    setting2.spec = kCTParagraphStyleSpecifierMaximumLineSpacing;
    setting2.valueSize = sizeof(CGFloat);
    setting2.value = &lineSpacing;
    
    CTParagraphStyleSetting setting3;
    setting3.spec = kCTParagraphStyleSpecifierMinimumLineSpacing;
    setting3.valueSize = sizeof(CGFloat);
    setting3.value = &lineSpacing;
    
    CTParagraphStyleSetting theSettings[kNumberOfSetting] = {
        setting1,
        setting2,
        setting3
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSetting);
    
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dic[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dic[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    
    CFRelease(fontRef);
    CFRelease(theParagraphRef);
    return dic;
    
}



+ (CoreTextData *)parseContent:(NSString *)content config:(FE_CTFrameParserConfig *)config {
    NSDictionary *attribites = [self attributesWithConfig:config];
    
    NSAttributedString *contentString = [[NSAttributedString alloc]initWithString:content attributes:config];
    
    //
    
    return nil;
}












@end
