//
//  XMLocationViewController.m
//  BaiduMap
//
//  Created by 尹文涛 on 16/3/29.
//  Copyright © 2016年 小木科技. All rights reserved.
//

#import "XMLocationViewController.h"

@interface XMLocationViewController ()<BMKSuggestionSearchDelegate>
{
    BMKSuggestionSearch *_searcher;// 搜索
}
@end

@implementation XMLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searcher =[[BMKSuggestionSearch alloc]init];
    _searcher.delegate = self;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClick:(id)sender {
    
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
        option.cityname = @"北京";
    option.keyword  = toBeString;
    BOOL flag = [_searcher suggestionSearch:option];
    
    if(flag)
    {
        NSLog(@"建议检索发送成功");
    }
    else
    {
        NSLog(@"建议检索发送失败");
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//实现Delegate处理回调结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSArray *array = result.ptList;
        
        // 解析数据
        for (NSValue *item in array) {
            CLLocationCoordinate2D coor;
            
            [item getValue:&coor];
            
            NSLog(@"latitude%f latitude:%f",coor.latitude,coor.latitude);
        }
        _dataSource = [NSArray arrayWithArray:result.keyList];
        [_tableview reloadData];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark -tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
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
