//
//  YPViewController.m
//  个人详情页
//
//  Created by 吴园平 on 06/10/2016.
//  Copyright © 2016 吴园平. All rights reserved.
//

#import "YPViewController.h"
#import "UIImage+YPimage.h"

@interface YPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hightConstraints;
//tableView最原始偏移量
@property (nonatomic,assign) CGFloat oriOffsetY;

@property (nonatomic,weak) UILabel *label;

@end


#define YPHeadViewH 200
#define YPHeadViewMinH 64 //向上拖动压缩到的最小高度
#define YPTabBarH 44  //头部视图下方的功能条



@implementation YPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消系统设置的scrollView顶部内边距,该属性为UIViewController的属性，故只要是它的子类均可直接使用
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航条
    [self setUpNavigationBar];
    
    //设置tableView的数据源和代理
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    
    //先 记录最开始的偏移量(屏幕尺寸就是我们初始设置的scrollView，减去 scrollview的内容 即为偏移量，坐标系右下均为正)
    _oriOffsetY = - (YPTabBarH + YPHeadViewH); //界面一显示即为我们设置的偏移量 -244
    
    //再 设置tableView顶部额外滚动区域
    self.tableV.contentInset = UIEdgeInsetsMake(YPHeadViewH + YPTabBarH, 0, 0, 0);// 一显示就相当于scrollview滚动，触发scrollViewDidScroll方法
    
}
/*
- (void)viewDidAppear:(BOOL)animated{
    //当视图已经显示的时候，控件已经加载完毕，可以确保打印控件尺寸正确
    NSLog(@"%@",NSStringFromCGRect(self.tableV.frame));
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableV.contentInset));//查看内边距
    // = >> 凡是在导航控制器下的scollView（包括它的子类）,会默认设置一个顶部内边距64
}
*/
//设置导航条
- (void)setUpNavigationBar{
   
    //1.设置导航条开始时透明，并非隐藏,如果设置背景图片为nil，系统会自动生成透明图片看得见，故得要设置为空的图片，并且模式为默认
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
     
     //清空导航条阴影的线
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //2.设置导航条标题视图为透明
    UILabel *label = [[UILabel alloc] init];
    label.text = @"你吴哥";
    label.textColor = [UIColor colorWithWhite:0 alpha:0];//左边1为白色0为黑色，右边1为不透明0透明(黑色透明)
    // 尺寸自适应：会自动计算文字大小
    [label sizeToFit];
    self.label = label;
    
    self.navigationItem.titleView = label;
    
    
}

//滚动tableView的时候就会调用，因为tableView是scrollView的子类,注意：这个方法就是不断变化的
//UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //计算tableView滚动范围，即计算tableView的偏移量：tableView的内容与可视范围的差值
    //获取当前偏移量y值
    CGFloat curOffsetY = scrollView.contentOffset.y; //为刚开始设置的顶部内边距-244
    //计算偏移量差值
    CGFloat offsetMinus = curOffsetY - _oriOffsetY;
    
    //拖动tableView得重新设置头部视图高度
    CGFloat h = YPHeadViewH - offsetMinus;
    if (h < YPHeadViewMinH) {
        h = YPHeadViewMinH;//头部视图高度最低为导航条高度
    }
    //修改头部视图的高度约束，用constant
    _hightConstraints.constant = h;
  
    
    //拖动时，处理导航条变化的业务逻辑
    CGFloat alpha = offsetMinus / (YPHeadViewH - YPHeadViewMinH);
    if (alpha > 1) {
        alpha = 0.99;//系统检测到alpha为1时自动半透明，不符合需求，故只要让他不为1即可
    }
    //设置导航条的背景图片 （白色透明 -> 白色不透明alpha -> 0.99）
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];//左边1为白色0为黑色，右边1为不透明0透明
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //设置导航条标题的颜色 (黑色透明 -> 黑色不透明)
    //方式一
    self.label.textColor = [UIColor colorWithWhite:0 alpha:alpha];
    //方式二
    /*
     UILabel *label = (UILabel *)self.navigationItem.titleView;//tips，因为我们已经明确知道了他的标题视图
     label.textColor = [UIColor colorWithWhite:0 alpha:alpha];
     
     */
    
}





#pragma mark - tableView数据源

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%li",@"good job",(long)indexPath.row ];

    return cell;
}


























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}











@end
