//
//  HttpObject.h
//  YuWa
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum YuWaType{
    YuWaType_Register,//注册账号
    YuWaType_Register_Code,//注册验证码
    
    YuWaType_Logion,//登入
    YuWaType_Logion_Quick,//快捷登录
    YuWaType_Logion_Code,//快捷登录验证码
    
    YuWaType_Logion_Forget_Tel,//找回密码
    YuWaType_Reset_Code,//重置密码验证码
    
    YuWaType_Business_VIP,//商务会员协议
    YuWaType_argeenment,//用户协议
    
    YuWaType_RB_HOME, //发现首页
    YuWaType_RB_DETAIL, //笔记详情
    YuWaType_RB_RELATED, //相关笔记
    YuWaType_RB_LIKE, //添加点赞（喜欢）
    YuWaType_RB_LIKE_CANCEL, //取消点赞（喜欢）
    YuWaType_RB_ALDUM, //获取用户专辑列表
    YuWaType_RB_CREATE_ALDUM, //创建专辑
    YuWaType_RB_COLLECTION_TO_ALDUM, //添加收藏到我的专辑
    YuWaType_RB_COLLECTION_CANCEL, //取消收藏
    YuWaType_RB_ATTENTION_ADD, //关注发布者
    YuWaType_RB_ATTENTION_CANCEL, //删除关注
    YuWaType_RB_COMMENT, //评论发布
    YuWaType_RB_COMMENT_LIST, //评论列表
    YuWaType_RB_SEARCH_QUICK, //笔记热门搜索
    YuWaType_RB_SEARCH_KEY, //搜索相关
    YuWaType_RB_SEARCH_RESULT, //搜索结果
    YuWaType_RB_NODE_PUBLISH, //发布笔记
    YuWaType_RB_ATTENTION, //我的关注
    
    YuWaType_IMG_UP, //上传图片
    
    YuWaType_STORM_NEARSHOP, //商家
    YuWaType_STORM_TAG, //子标签
    YuWaType_STORM_SEARCH_HOT, //热门搜索
    YuWaType_STORM_SEARCH, //搜索店铺
    
    YuWaType_NOTCCAFICATIONJ_ORDER, //预约通知
    YuWaType_NOTCCAFICATIONJ_PAY, //付款通知
    
    YuWaType_FRIENDS_INFO, //好友信息
    
    YuWaType_BAOBAO_LVUP, //雨娃宝宝升级
    YuWaType_RBAdd_AlbumDetail, //专辑详情
    YuWaType_RBAdd_DelAlbum, //删除笔记
    YuWaType_RBAdd_DelNode,//取消收藏单个笔记
    
    YuWaType_BAOBAO_SevenConsume, //近7次消费金额
    YuWaType_BAOBAO_ConsumeType, //消费在哪个大类里面
    YuWaType_BAOBAO_LuckyDraw, //抢优惠券
    
    YuWaType_WAWA_CheckUpNumber,//检查抓娃娃次数
    YuWaType_WAWA_CatchWaWa,//开始抓娃娃
    
    
    YuWaType_Other_Node,//别人的笔记
    YuWaType_Other_Aldum,//别人的专辑
    
    YuWaType_
    
}kYuWaType;





@interface HttpObject : NSObject
#pragma mark - Singleton
+ (id)manager;

//Get无Hud请求
- (void)getNoHudWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

//Post请求
- (void)postDataWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

//Post无Hud请求
- (void)postNoHudWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

//上传照片
- (void)postPhotoWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail withPhoto:(NSData *)photo;


@end
