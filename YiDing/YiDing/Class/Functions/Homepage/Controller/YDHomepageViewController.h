//
//  YDHomepageViewController.h
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDHomepageMainTableViewHandle.h"
#import "YDHomepageServerCenter.h"

@interface YDHomepageViewController : UIViewController <YDHomepageMainTableViewHandleDelegate,
    YDHomepageServerCenterDelegate>

@end
