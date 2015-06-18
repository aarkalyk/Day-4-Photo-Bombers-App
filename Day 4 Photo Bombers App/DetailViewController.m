//
//  DetailViewController.m
//  Day 4 Photo Bombers App
//
//  Created by Student on 6/17/15.
//  Copyright (c) 2015 Arkalyk. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"
#import "ViewController.h"

@interface DetailViewController ()

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UIDynamicAnimator *animator;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //printing username
    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 50, 200, 40)];
    [myLabel setBackgroundColor:[UIColor clearColor]];
    [myLabel setText:self.photo[@"user"][@"username"]];
    [[self view] addSubview:myLabel];
    //printing number of likes
    NSString *like = [NSString stringWithFormat:@"%@",self.photo[@"likes"][@"count"]];
    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 80, 200, 40)];
    [likesLabel setBackgroundColor:[UIColor clearColor]];
    [likesLabel setText:[NSString stringWithFormat:@"%@ likes",like]];
    [[self view] addSubview:likesLabel];
    //adding imageview
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.photo[@"user"][@"profile_picture"]]];
    UIImageView *profilePic =[[UIImageView alloc] initWithFrame:CGRectMake(10,50,40,40)];
    profilePic.image=[UIImage imageWithData:imageData];
    [self.view addSubview:profilePic];
    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.95]];
    //adding a button
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [likeButton setTitle:@"LIKE" forState:UIControlStateNormal];
    [likeButton sizeToFit];
    likeButton.center = CGPointMake(560/2, 70);
    [self.view addSubview:likeButton];
    [likeButton addTarget:self action:@selector(likeButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    //printing comments
    NSMutableArray *comments = [NSMutableArray new];
    int count = [self.photo[@"comments"][@"count"] integerValue];
    for (int i = 0; i < count; i++) {
        [comments addObject:self.photo[@"comments"][@"data"][i][@"text"]];
    }
    if (count !=0) {
        NSString *comment = [NSString stringWithFormat:@"%@",comments[0]];
        UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 80, 200, 40)];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
        [commentLabel setText:[NSString stringWithFormat:@"%@",comment]];
        [[self view] addSubview:commentLabel];
    }
    /////////////////////////////////////
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, -320.f, 320.f, 320.f)];
    [self.view addSubview:self.imageView];
    
    [PhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)likeButtonPressed:(UIButton *)likeButton {
    NSLog(@"Button Pressed");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
    
    [self.animator addBehavior:snap];
}

-(void) close
{
    [self.animator removeAllBehaviors];
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180.f)];
    [self.animator addBehavior:snap];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
