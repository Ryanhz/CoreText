//
//  ViewController.m
//  CoreText
//
//  Created by hzf on 16/8/23.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import "ViewController.h"
#import "FE_CTDisplayView.h"
#import "FE_CTFrameParserConfig.h"
#import "FE_CTFrameParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setDisplayView3];
//    [self setCTDisplayView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setCTDisplayView {
    FE_CTDisplayView *displayView = [[FE_CTDisplayView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 200)];
    displayView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:displayView];
    
}

- (void)setDisplayView3 {
    FE_CTDisplayView *displayView = [[FE_CTDisplayView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 200)];
    displayView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:displayView];
    
    FE_CTFrameParserConfig *config = [[FE_CTFrameParserConfig alloc]init];
    config.textColor = [UIColor redColor];
    config.width = displayView.width;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mode" ofType:@"json"];
    FE_CoreTextData *data = [FE_CTFrameParser parseTemplateFile:path config:config];
    
    displayView.data = data;
    displayView.height = data.height;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
