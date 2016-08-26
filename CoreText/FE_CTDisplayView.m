//
//  CTDisplayVIew.m
//  CoreText
//
//  Created by hzf on 16/8/23.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "FE_CTDisplayView.h"

@interface FE_CTDisplayView ()<UIGestureRecognizerDelegate>

@end

@implementation FE_CTDisplayView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1, -1);
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
    
    for (FE_CoreTextImageData *imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
}


- (instancetype)init {
    self = [super init];
    if (self) {
       [self setupEvents];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (void)setupEvents {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapGestureDetected:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    
    for (FE_CoreTextImageData *imageData in self.data.imageArray) {
        // 翻转坐标系，因为 imageData 中的坐标是 CoreText 的坐标系
        CGRect imageRect = imageData.imagePosition;
        
        CGPoint imagePosition = imageRect.origin;
        
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        
        if (CGRectContainsPoint(rect, point)) {
            DLog(@"touch");
            return;
        }

    }
    
    FE_CoreTextLinkData *linkData = [FE_CoreTextUitls touchLinkInView:self atPoint:point data:self.data];
    
    if (linkData) {
        DLog(@"sss");
        return;
    }
    
    
    
    
}

@end
