//
//  LYProduct.h
//  ShoppingGuide
//
//  Created by CoderLL on 16/9/4.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYProduct : NSObject
/**
 *  productID
 */
@property (nonatomic, assign) NSInteger productID;
/**
 * cover_image_url
 */
//@property (nonatomic, copy) NSString *cover_image_url;

/**
 *  created_at
 */
@property (nonatomic, assign) NSInteger created_at;

/**
 * describe
 */
@property (nonatomic, copy) NSString *describe;

/**
 *  editor_id
 */
@property (nonatomic, assign) NSInteger editor_id;

/**
 *  favorites_count
 */
@property (nonatomic, assign) NSInteger favorites_count;

/**
 * image_urls
 */
@property (nonatomic, strong) NSArray *image_urls;

/**
 *  is_favorite
 */
@property (nonatomic, assign) BOOL is_favorite;

/**
 * name
 */
//@property (nonatomic, copy) NSString *Title;

/**
 * price
 */
//@property (nonatomic, copy) NSString *price;

/**
 *  purchase_id
 */
@property (nonatomic, assign) NSInteger purchase_id;

/**
 *  purchase_status
 */
@property (nonatomic, assign) NSInteger purchase_status;

/**
 *  purchase_type
 */
@property (nonatomic, assign) NSInteger purchase_type;

/**
 * purchase_url
 */
//@property (nonatomic, copy) NSString *purchase_url;

/**
 *  updated_at
 */
@property (nonatomic, assign) NSInteger updated_at;

/**
 * url
 */
//@property (nonatomic, copy) NSString *url;


//"GoodsID":"40987945983",				/*商品淘宝id*/
//"Title":"巧迪尚惠睫毛膏 晶钻摩翘睫毛膏纤长浓密券翘不晕染防水不易脱妆",				/*商品标题*/
//"D_title":"巧迪尚惠睫毛膏",				/*商品短标题*/
//"Pic":"http:\/\/img.alicdn.com...",				/*商品主图*/
//"Cid":"3",				/*分类ID*/
//"Org_Price":"49.00",				/*正常售价*/
//"Price":"29.00",				/*券后价*/
//"IsTmall":"1",				/*是否天猫*/
//"Sales_num":"216",				/*商品销量*/
//"Dsr":"4.8",				/*商品描述分*/
//"SellerID":"513862865",				/*卖家ID*/
//"Commission_jihua":"31.00",				/*计划(通用)佣金比例*/
//"Commission_queqiao":"0.00",				/*高佣鹊桥佣金比例*/
//"Jihua_link":"http:\/\/pub.alimama.com\/myunion.htm...",				/*计划链接*/
//"Introduce":"晶钻摩翘睫毛膏 纤长浓密  券翘不晕染 防水不易脱妆",				/*商品文案*/
//"Quan_id":"bbecf968081942808bcec1fcf4ee1af4",				/*优惠券ID*/
//"Quan_price":"20.00",				/*优惠券金额*/
//"Quan_time":"2016-07-07 00:00:00",				/*优惠券结束时间*/
//"Quan_surplus":"7731",				/*优惠券剩余数量*/
//"Quan_receive":"269",				/*已领券数量*/
//"Quan_condition":"单笔满48元可用，每人限领1 张",				/*优惠券使用条件*/
//"Quan_link":"http://shop.m.taobao.com/shop/coupon.htm?seller_id=xxx&activity_id=xxx",				/*手机券链接*/
//"Quan_m_link":"http:\/\/dwz.cn\/3GxCEK",				/*手机优惠券短链*/
//"ali_click":"https:\/\/detail.tmall.com\/item.htm?id=40987945983"				/*淘宝客链接（需用大淘客助手转链）*/

@property (nonatomic, copy) NSString *GoodsID;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *D_title;
@property (nonatomic, copy) NSString *Pic;
@property (nonatomic, copy) NSString *Price;
@property (nonatomic, copy) NSString *ali_click;












@end
