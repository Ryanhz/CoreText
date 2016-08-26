//
//  FE_CoreTextUitls.h
//  CoreText
//
//  Created by hzf on 16/8/25.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FE_CoreTextLinkData.h"
#import "FE_CoreTextData.h"

@interface FE_CoreTextUitls : NSObject

+ (FE_CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(FE_CoreTextData *)data;

@end
