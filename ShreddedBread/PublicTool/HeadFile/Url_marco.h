//
//  Url_marco.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#ifndef Url_marco_h
#define Url_marco_h

// 笑话的接口  需要给一个 CurrentPage 页数  每页会有三十个笑话
#define ZCM_JOKEBOOK_URL_BAOZOU(CurrentPage) ([NSString stringWithFormat:@"%@%ld%@",@"http://m2.qiushibaike.com/article/list/text?page=",CurrentPage,@"&count=30&readarticles=%5B117251884,117251501,117248537,117248231,117251207%5D&rqcnt=27&r=4275b1c51470994049730"])

// 视频接口
#define WSL_VIDEO_URL_BAOZOU(CurrentPage) ([NSString stringWithFormat:@"%@%ld%@",@"http://m2.qiushibaike.com/article/list/video?page=",CurrentPage,@"&count=30&readarticles=%5B117252889%5D&rqcnt=4&r=4275b1c51470999829203"])

// 视频的接口 网易奇葩
#define GJ_VIDEO_URLStr_JINPING(CurrentPage) ([NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/VAP4BFE3U/y/%ld-10.html",CurrentPage])



// 头像链接
#define ICON_USER_String(Uid,Icon) [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/thumb/%@",[Uid substringToIndex:4],Uid,Icon]

#define ICON_USER_URL(Uid,Icon) [NSURL URLWithString:ICON_USER_String(Uid,Icon)]


#endif
