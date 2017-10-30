//
//  FirstDetilViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/12.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "FirstDetilViewController.h"
#import "EditViewController.h"
#import "LZDataModel.h"
#import "LZSqliteTool.h"
@interface FirstDetilViewController ()


@end

@implementation FirstDetilViewController
- (void)dealloc {
    
    LZLog(@"%@--dealloc",NSStringFromClass([self class]));
}
- (void)loadData {
    
    NSArray* array = [LZSqliteTool LZSelectGroupElementsFromTable:LZSqliteDataTableName groupID:LZSqliteGroupID];
    
    if (self.dataSource.count > 0) {
        
        [self.dataSource removeAllObjects];
    }
    
    [self.dataSource addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNaviBar];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
        make.left.right.and.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
}
- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"数据库测试"];
    
    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        LZLog(@"leftButton");
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [self lzSetRightButtonWithTitle:nil selectedImage:@"add_new" normalImage:@"add_new" actionBlock:^(UIButton *button) {
        LZLog(@"rightButton");
        
        EditViewController *editVC = [[EditViewController alloc]init];
        [self.navigationController pushViewController:editVC animated:YES];
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZGroupSingleViewController"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LZGroupSingleViewController"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.textLabel.textColor = LZColorGray;
        cell.textLabel.font = LZFontDefaulte;
    }
    
    LZDataModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.nickName;
    cell.detailTextLabel.text = model.dsc;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据删除后,不可恢复,是否确定删除?" preferredStyle:UIAlertControllerStyleAlert];
    
    LZWeakSelf(ws)
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:[ws.dataSource objectAtIndex:indexPath.row]];
        [ws.dataSource removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // 当为0时 删除分组?
        //        if (self.dataArray == 0) {
        //
        //            [LZSqliteTool LZDeleteFromGroupTable:LZSqliteGroupTableName element:self.groupModel];
        //        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
