//
//  YYSimpleWebViewController.m
//  YYKitExample
//
//  Created by ibireme on 15/9/11.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYSimpleWebViewController.h"
#import "YYKit.h"

@interface YYSimpleWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *url;
@end

@implementation YYSimpleWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    _url = url;
    _webView = [UIWebView new];
    _webView.delegate = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lzSetNavigationTitle:@"微博"];

    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {

        [ws.navigationController popViewControllerAnimated:YES];
    }];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
//        make.left.right.and.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view).offset(-LZTabBarHeight);
//    }];
    _webView.frame = CGRectMake(0, LZNavigationHeight, self.view.frame.size.width, self.view.frame.size.height-LZNavigationHeight);
    if (kSystemVersion < 7) _webView.height -= 44;
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
     self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
