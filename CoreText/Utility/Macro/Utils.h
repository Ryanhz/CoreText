//
//  Utils.h
//  CoreText
//
//  Created by hzf on 16/8/24.
//  Copyright © 2016年 hzf. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

#ifdef DEBUG


#define DLog(...) NSLog(__VA_ARGS__)

#else

#define DLog(...)


#endif

#define RGB(A, B, C)    [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]





#endif /* Utils_h */
