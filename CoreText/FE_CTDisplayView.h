//
//  CTDisplayVIew.h
//  CoreText
//
//  Created by hzf on 16/8/23.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FE_CoreTextData.h"
#import "FE_CoreTextImageData.h"
#import "FE_CoreTextLinkData.h"
#import "FE_CoreTextUitls.h"


/**
 *  持有CoreTextData类的实例，负责将CTFrameRef绘制到界面上。
 */
@interface FE_CTDisplayView : UIView

@property(nonatomic, strong) FE_CoreTextData *data;

@end
