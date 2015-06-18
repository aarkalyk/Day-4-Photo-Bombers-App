//
//  ViewController.m
//  Day 4 Photo Bombers App
//
//  Created by Student on 6/17/15.
//  Copyright (c) 2015 Arkalyk. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import <SimpleAuth/SimpleAuth.h>
#import "DetailViewController.h"
#import "PresentDetailTransition.h"
#import "dismissDetailTransition.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSMutableData *usernames;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UITextField *searchBox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    if (self.accessToken == nil){
        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
            self.accessToken = responseObject[@"credentials"][@"token"];
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            NSLog(@"saved crdedentials");
            [self downloadImages:[[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/thesummerstartupschool/media/recent?access_token=%@", self.accessToken]];
            // downlaod images
        }];
    }else{
        NSLog(@"using previous credentials");
        [self downloadImages:[[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/thesummerstartupschool/media/recent?access_token=%@", self.accessToken]];
        //dowlnoad images
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonPressed:(UIButton *)sender {
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@", self.searchBox.text, self.accessToken];
    NSLog(@"works! %@", urlString);
    [self downloadImages:urlString];
}


#pragma mark - helper methods
-(void) downloadImages: (NSString *) link
{
    NSURLSession *session = [NSURLSession sharedSession];
    //NSLog(@"%@", urlString);
    NSURL *url = [[NSURL alloc] initWithString:link];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session  downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //NSLog(@"response is %@", response);
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDitionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"response dictionary is %@", responseDitionary);
        self.photos = responseDitionary[@"data"];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    [task resume];
}

#pragma mark - UICollectionView methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //returns newly created Cell
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    //cell.imageView.image = [UIImage imageNamed:@"ggg_image.jpg"];
    //now we need to parse images from NSDictionary
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.photo = photo;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photo = self.photos[indexPath.row];
    
    DetailViewController *viewController = [DetailViewController new];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.photo = photo;
    viewController.transitioningDelegate = self;
    
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

#pragma mark - Transitioning delegate methods

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PresentDetailTransition new];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [dismissDetailTransition new];
}

@end
