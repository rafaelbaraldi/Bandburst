//
//  TelaChatViewController.h
//  Bandburst
//
//  Created by RAFAEL CARDOSO DA SILVA on 19/09/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalStore.h"
#import "TPUsuario.h"

#import "HPGrowingTextView.h"

@interface TelaChatViewController : UIViewController <HPGrowingTextViewDelegate>{
	UIView *containerView;
    HPGrowingTextView *textView;
    
    
}

@property TPUsuario *usuarioContato;
@property TPUsuario *usuarioAtual;

@property UIScrollView *scrollView;

-(id)initWithUsuario:(TPUsuario*)usuario;

-(void)resignTextView;

@end
