// 0.账号相关
#define IWAppKey @"1359433872"
#define IWAppSecret @"37c372aa97a9329fc561947151c1bd38"
#define IWRedirectURI @"http://ios.itcast.cn"
#define IWLoginURL [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", IWAppKey, IWRedirectURI]

#define IWAPPURL @"http://latiao.izanpin.com/api/"
#define IWArticleURL @"http://latiao.izanpin.com/api/article"
#define IWLoginURl @"http://latiao.izanpin.com/api/user/login"
#define IWCodeLoginURl @"http://latiao.izanpin.com/api/user/smsLogin"

#define PROBE_DEVICES_CHANGED @"probechanged"
// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.自定义Log
#ifdef DEBUG
#define IWLog(...) NSLog(__VA_ARGS__)
#else
#define IWLog(...)
#endif

// 4.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

// 5.微博cell上面的属性
/** 昵称的字体 */
#define IWStatusNameFont [UIFont systemFontOfSize:18]
/** 被转发微博作者昵称的字体 */
#define IWRetweetStatusNameFont IWStatusNameFont

/** 时间的字体 */
#define IWStatusTimeFont [UIFont systemFontOfSize:12]
/** 来源的字体 */
#define IWStatusSourceFont IWStatusTimeFont

/** 正文的字体 */
#define IWStatusContentFont [UIFont systemFontOfSize:16]
/** 被转发微博正文的字体 */
#define IWRetweetStatusContentFont IWStatusContentFont

/** 表格的边框宽度 */
#define IWStatusTableBorder 5
#define IWSettingTableBorder IWStatusTableBorder

/** cell的边框宽度 */
#define IWStatusCellBorder 10
#define IWSettingCellMargin 5

// 6.微博cell内部相册
#define IWPhotoW 70
#define IWPhotoH 70
#define IWPhotoMargin 5

// 7.
#define IWUserDefaults [NSUserDefaults standardUserDefaults]
#define IWGlobalBg IWColor(232, 233, 232)



