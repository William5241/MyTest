//
//  ALStatisticsConst.h
//  AllinCommon
//
//  Created by ZhangKaiChao on 16/5/10.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#ifndef ALStatisticsConst_h
#define ALStatisticsConst_h

/// 是否开启打印日志.
#define kLogSwitch

/// 捕获的方法.
static NSString * const kEventSelector = @"EventSelector";
/// 处理捕获方法后的block.
static NSString * const kEventHandlerBlock = @"EventHandlerBlock";
/// 执行事件的对象.
static NSString * const kEventSender = @"EventSender";
/// 点击cell的indexpath.
static NSString * const kIndexPath = @"IndexPath";

/// 业务统计项.
/// 操作类型.
static NSString * const kTriggerType = @"triggerType";
/// 点击内容描述.
static NSString * const kTriggerName = @"triggerName";
/// 事件id.
static NSString * const kActionId = @"actionId";
/// 来源页面.
static NSString * const kSrcLocation = @"srcLocation";
/// 目标页面.
static NSString * const kToLocation = @"toLocation";
/// 资源类型.
static NSString * const kRefType = @"refType";
/// 资源id.
static NSString * const kRefId = @"refId";
/// 区块id.
static NSString * const kLocationId = @"locationId";


/// Tool.
/// url跳转app.
static NSString * const kURLHandleManager = @"URLHandleManager";
/// vc.
static NSString * const kUIViewController = @"UIViewController";




/// view.
/// UITableview.
static NSString * const kUITableView = @"UITableView";
/// UICollectionView.
static NSString * const kUICollectionView = @"UICollectionView";
/// UIControl.
static NSString * const kUIControl = @"UIControl";
static NSString * const kUITextView = @"UITextView";
/// 上下拉.
static NSString * const kMJRefreshComponent = @"MJRefreshComponent";
/// 九宫格图片.
static NSString * const kCustomCellImageView = @"CustomCellImageView";
/// 轮播图片.
static NSString * const kAllinLoopScrollView = @"AllinLoopScrollView";




#endif /* ALStatisticsConst_h */
