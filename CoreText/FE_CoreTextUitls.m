//
//  FE_CoreTextUitls.m
//  CoreText
//
//  Created by hzf on 16/8/25.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "FE_CoreTextUitls.h"
#import <CoreText/CoreText.h>

@implementation FE_CoreTextUitls

+ (FE_CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(FE_CoreTextData *)data {
   
    CFIndex idx = [self touchContentOffsetInView:view atPoint:point data:data];
    if (idx == -1) {
        return nil;
    }
    
    FE_CoreTextLinkData * foundLink = [self linkAtIndex:idx linkArray:data.linkArray];
    return foundLink;
}


+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(FE_CoreTextData *)data {
    
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    
    if (!lines) {
        return -1;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    //获得每一行的 origin 坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    // 翻转坐标系
    CGAffineTransform transfrom = CGAffineTransformMakeTranslation(0, view.height);
    transfrom = CGAffineTransformScale(transfrom, 1.f, -1.f);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的 CGRect 信息
        CGRect flippedRect = [self getlineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transfrom);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            // 获得当前点击坐标对应的字符串偏移
            
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
            //
        }
    }
    return idx;
    
    
}


+ (CGRect)getlineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y, width, height);
}

+ (FE_CoreTextLinkData *)linkAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray {
    
    FE_CoreTextLinkData *link = nil;
    for (FE_CoreTextLinkData *data in linkArray) {
        if (NSLocationInRange(i, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}

@end
