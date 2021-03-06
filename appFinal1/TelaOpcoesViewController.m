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

#import "CadastroStore.h"

@interface TelaOpcoesViewController ()

@end

@implementation TelaOpcoesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Navigation Controller
        [[self navigationItem] setTitle:@"Opções"];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    _fbpv = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(150, 200, 100, 100)];
//    [self.view addSubview:self.fbpv];
//    
//    FBLoginView* loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
//    CGRect frame = loginView.frame;
//    
//    loginView.delegate = self;
//    frame.origin.y = 400;
//    loginView.frame = frame;
//    [self.view addSubview:loginView];
    
    [self carregaLayout];
}


//-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
//    [self.fbpv setProfileID:[user id]];
//}

-(void)viewWillAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)carregaLayout{
    
    [_btnSair setTitleColor:[[LocalStore sharedStore] FONTECOR] forState:UIControlStateNormal];
    [_btnAlterarFoto setTitleColor:[[LocalStore sharedStore] FONTECOR] forState:UIControlStateNormal];
    [_btnEncontrarAmigos setTitleColor:[[LocalStore sharedStore] FONTECOR] forState:UIControlStateNormal];
}

- (IBAction)btnAlterarFoto:(id)sender {
    
    //Está no cadastro?
    [[CadastroStore sharedStore] setCadastro:NO];
    
    [[self navigationController] pushViewController:[[LocalStore sharedStore] TelaCadastroFoto] animated:YES];
}

- (IBAction)btnEcontrarAmigos:(id)sender {
    
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
    
    [fbvc presentModallyFromViewController:self animated:YES handler:^(FBViewController* innerSender, BOOL donePressed){
         if(!donePressed){
             return;
         }
     }];
}

- (IBAction)btnSair:(id)sender{
    [LoginStore deslogar];
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}
@end
