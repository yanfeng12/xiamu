# xiamu
自己练习写的一款小软件,项目功能有:3Dtouch,数据库,runtime传值,聊天页面,本地推送,自定义启动页,指纹密码识别,iCloud储存,新闻缓存,直播测试,加速传感器测试,朋友圈,微博.

微博WebP报错:[-[YYImageDecoder _updateSourceWebP]: 1834] WebP is not available, check the documentation to see how to install WebP component: https://github.com/ibireme/YYImage#installation

解决方法:1.add Vendor/WebP.framework(static library) to your Xcode project.
2.点击 Build Settings ，然后在搜索框里输入‘macros’,在 Preprocessor Macros 的 Debug 后面会有 DEBUG=1,去掉
