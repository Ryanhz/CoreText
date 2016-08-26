//
//  FE_CoreTextLinkData.h
//  CoreText
//
//  Created by hzf on 16/8/24.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FE_CoreTextLinkData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSRange range;

@end
