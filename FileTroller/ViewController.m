//
//  ViewController.m
//  FileTroller
//
//  Created by Nathan Senter on 3/7/23.
//

#import "ViewController.h"
#include <sys/mman.h>
#import <UIKit/UIKit.h>
#import <CFNetwork/CFNetwork.h>
#import <spawn.h>
#include "TSUtil.h"

@interface ViewController ()

@end

@implementation ViewController


void showFinishedPopup(NSString* message) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Done"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // Handle OK button tap if needed
                                                     }];

    [alertController addAction:okAction];

    // Get the root view controller from the main window's rootViewController
    UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
    UIWindow *mainWindow = windowScene.windows.firstObject;
    UIViewController *viewController = mainWindow.rootViewController;

    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"funny" ofType:@"JPG"];
    UIImage *backgroundImage = [UIImage imageWithContentsOfFile:imagePath];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    u_int32_t randomNumber = arc4random_uniform(100);
//    if (randomNumber < 10) {
        [self.view addSubview:backgroundImageView];
    //}
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Patch Hack to kgvn" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(patchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 200, 50);
    button.center = self.view.center;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Unpatch Hack kgvn" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(unpatchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(0, 0, 200, 50);
    CGPoint centerForButton2 = CGPointMake(self.view.center.x, self.view.center.y + button.frame.size.height + 20);
    button2.center = centerForButton2;
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"Credits/Tweaks" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(showCreditsPopup) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(0, 0, 200, 50);
    CGPoint centerForButton3 = CGPointMake(self.view.center.x, self.view.center.y + button.frame.size.height - 300);
    button3.center = centerForButton3;
    
    [self.view addSubview:button];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
}

- (void)showCreditsPopup {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Credits/Tweaks"
                                                                             message:@"Creator of this patcher:\nNathan\n\nCheat by:\nLittle 34306\n(Huy Nguyen)"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // Handle OK button tap if needed
                                                     }];

    [alertController addAction:okAction];

    // Get the root view controller from the main window's rootViewController
    UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
    UIWindow *mainWindow = windowScene.windows.firstObject;
    UIViewController *viewController = mainWindow.rootViewController;

    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)patchButtonTapped:(UIButton *)sender {
    @autoreleasepool {
        NSMutableArray* args = [NSMutableArray new];
        [args addObject:@"--patch"];
        
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];

        NSString *binaryPath = [bundlePath stringByAppendingPathComponent:@"patchlq"];
        
        spawnRoot(binaryPath, args, nil, nil);
        showFinishedPopup(@"kgvn has been patched successfully\nEnter the key and using 3 finger double tap to oen menu\nNhập key và dùng 3 ngón chạm 2 lần để mở menu");
    }
}

- (void)unpatchButtonTapped:(UIButton *)sender {
    @autoreleasepool {
        NSMutableArray* args = [NSMutableArray new];
        [args addObject:@"--unpatch"];
        
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];

        NSString *binaryPath = [bundlePath stringByAppendingPathComponent:@"patchlq"];
        
        spawnRoot(binaryPath, args, nil, nil);
        showFinishedPopup(@"kgvn has been unpatched successfully");
    }
}

@end



