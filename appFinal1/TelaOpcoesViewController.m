//
//  TelaOpcoesViewController.m
//  appFinal1
//
//  Created by Rafael Cardoso on 01/08/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "TelaOpcoesViewController.h"

#import "LocalStore.h"
#import "LoginStore.h"

@interface TelaOpcoesViewController ()

@end

@implementation TelaOpcoesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Opções"];
    
    _fbpv = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(150, 200, 100, 100)];
    [self.view addSubview:self.fbpv];
    
    FBLoginView* loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    CGRect frame = loginView.frame;
    
    loginView.delegate = self;
    frame.origin.y = 400;
    loginView.frame = frame;
    //    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 150);
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnAlterarFoto:(id)sender {
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaCadastroFoto] animated:YES];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    [self.fbpv setProfileID:[user id]];
}

- (IBAction)btnEcontrarAmigos:(id)sender {
    //    [FBRequestConnection startForMyFriendsWithCompletionHandler:
    //     ^(FBRequestConnection *connection, id<FBGraphUser> friends, NSError *error)
    //     {
    //         if(!error){
    //             NSLog(@"%@", friends);
    //         }
    //         else{
    //             NSLog(@"%@", error);
    //         }
    //     }];
    
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error)
     {
         NSMutableArray* friendsArray = [result objectForKey:@"data"];
         NSLog(@"%@", result);
         NSObject *friend =  [friendsArray objectAtIndex:0];
         NSLog(@"%@", [friend valueForKey:@"name"]);
         
     }];
    
    FBFriendPickerViewController* fbvc = [[FBFriendPickerViewController alloc] init];
    [fbvc loadData];
    
    [fbvc presentModallyFromViewController:self animated:YES handler:^(FBViewController* innerSender, BOOL donePressed)
     {
         if(!donePressed){
             return;
         }
     }];
}

- (IBAction)btnSair:(id)sender {
    [LoginStore deslogar];
    
    if ([LocalStore verificaSeViewJaEstaNaPilha:[[self navigationController] viewControllers] proximaTela:[[LocalStore sharedStore] TelaLogin]]) {
        [[self navigationController] popToViewController:[[LocalStore sharedStore] TelaLogin] animated:YES];
    }
    else{
        [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaLogin] animated:YES];
    }
}
@end
