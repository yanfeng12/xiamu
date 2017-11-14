## xiamu
自己练习写的一款小软件,项目功能有:3Dtouch,数据库,runtime传值,聊天页面,本地推送,自定义启动页,指纹密码识别,iCloud储存,新闻缓存,直播测试,加速传感器测试,朋友圈,微博.
# 2017.04 创建工程

# 2017.11.03 添加微博,朋友圈,感谢YYkit,https://github.com/zhengwenming/WeChat

# 2017.11.09 解决微博图片不显示问题
微博WebP报错:[-[YYImageDecoder _updateSourceWebP]: 1834] WebP is not available, check the documentation to see how to install WebP component: https://github.com/ibireme/YYImage#installation

解决方法:1.add Vendor/WebP.framework(static library) to your Xcode project.
2.点击 Build Settings ，然后在搜索框里输入‘macros’,在 Preprocessor Macros 的 Debug 后面会有 DEBUG=1,去掉

# 2017.11.09 更新YYkit 更新启动页,启动页使用XHLaunchAd.XHLaunchAd之前使用的是YYkit,现在是自己的缓存机制.

# 2017.11.09 创建pod,未来会把第三方都是用pod

# 2017.11.13 以后新添加的第三方库都用pod
pod使用方法:
1.终端cd到项目
2.touch Podfile,创建Podfile文件
3.vim Podfile
4.按键盘上的英文'i'键
下面的"Podsfile" 0L, 0C将变成-- INSERT --
5.输入以下文字,vim不支持鼠标.'NewHaipei'就是工程名字,NewHaipei.xcodeproj的名字,不是文件夹名字.
target ‘NewHaipei’ do
pod 'BAWKWebView', '~> 1.0.8'
end
6.先按左上角的esc键，再按shift+;键，再输入wq，点击回车，就保存并退出去了
7.pod install

# 2017.11.13 添加OC和JS交互 使用https://github.com/BAHome

# 2017.11.14 微博cell的相关事件使用的是代理,朋友圈使用的是block

