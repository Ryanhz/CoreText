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

static CGFloat ascentCallback(void *ref) {
    NSLog(@"%@", (__bridge NSDictionary *)ref);
    
    NSNumber *height = [(__bridge NSDictionary *)ref objectForKey:@"height"];
    return [height floatValue];
}

static CGFloat descentCallback(void *ref) {
    return 0;
}

static CGFloat widthCallback(void *ref) {
    NSNumber *width = [(__bridge NSDictionary *)ref objectForKey:@"width"];
    return [width floatValue];
}

+ (NSMutableDictionary *)attributesWithConfig:(FE_CTFrameParserConfig *)config {
    
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

+ (FE_CoreTextData *)parseTemplateFile:(NSString *)path config:(FE_CTFrameParserConfig*)config {
    
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    
    FE_CoreTextData *data = [self parseContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    
    return data;
}


+(NSAttributedString *)loadTemplateFile:(NSString *)path
                                 config:(FE_CTFrameParserConfig *)config
                             imageArray:(NSMutableArray *)imageArray
                              linkArray:(NSMutableArray *)linkArray{
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"img"]) {
                    //
                    FE_CoreTextImageData *imageDate = [[FE_CoreTextImageData alloc]init];
                    imageDate.name = dict[@"name"];
                    imageDate.position = [result length];
                    [imageArray addObject:imageDate];
                    
                    // 创建空白占位符，并且设置它的 CTRunDelegate 信息
                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"link"]) {
                    
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                    
                    //
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    FE_CoreTextLinkData *linkData = [[FE_CoreTextLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                }
            }
        }
        
        
    }
    return result;
}


+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(FE_CTFrameParserConfig *)config {
    
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegete = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    
    unichar objectReplacementChar = 0xffc;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegete);
    CFRelease(delegete);
    return space;
}


+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict config:(FE_CTFrameParserConfig *)config{
    
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    
    // color
    UIColor *color = [self colorFromTEmplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // font size
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize >0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    return attributedString;
}


+ (UIColor *)colorFromTEmplate:(NSString *)name {
    
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else {
        return nil;
    }
        
}





+ (FE_CoreTextData *)parseContent:(NSAttributedString *)content config:(FE_CTFrameParserConfig *)config {
  
    // 生成CTFramesetterRef
    
    CTFramesetterRef framesetter= CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)content);

    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //
    
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    //
    FE_CoreTextData *data= [[FE_CoreTextData alloc]init];
    data.ctFrame = frame;
    data.height = textHeight;

    
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(FE_CTFrameParserConfig *)config
                                  height:(CGFloat)height {
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}











@end
