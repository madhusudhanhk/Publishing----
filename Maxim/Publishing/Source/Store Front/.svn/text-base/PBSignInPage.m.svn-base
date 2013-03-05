//
//  PBSignInPage.m
//  Publishing
//
//  Created by Nithin Abraham on 19/10/11.
//  Copyright 2011 Picsean Media. All rights reserved.
//

#import "PBSignInPage.h"
#import <QuartzCore/QuartzCore.h>

#define kSignInButtonTag 342

@implementation PBSignInPage
@synthesize  signView, username, password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    UIButton * button = (UIButton *)[self.view viewWithTag: kSignInButtonTag];
    UIImage * signInBg = [[UIImage imageNamed: @"Store-Button-BG.png"] stretchableImageWithLeftCapWidth: 45.0f  topCapHeight: 14.0f];
    
    [button setBackgroundImage: signInBg forState: UIControlStateNormal];
    [button setBackgroundImage: signInBg forState: UIControlStateSelected];
    [button setBackgroundImage: signInBg forState: UIControlStateHighlighted];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) presentLoginScreen; {
    
    signView.hidden = NO;

    CGFloat duration = 0.4f;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.85f],
                    [NSNumber numberWithFloat:1.f],
                    nil];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = duration * .4f;
    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeIn.fillMode = kCAFillModeForwards;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:scale, fadeIn, nil];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = NO;
    [group setValue:@"PopInAnimation" forKey: @"animation"];
        
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [signView.layer addAnimation: group forKey: @"PopInAnimation"];
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.2f];
    self.view.backgroundColor = [UIColor colorWithWhite: 0.0f alpha: 0.2f];
    [UIView commitAnimations];
    [signView setNeedsLayout];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
    PBLog(@"called");
    if(_loginScreenDidPopOut) {
        [self.view performSelector: @selector(removeFromSuperview) withObject: nil afterDelay: 0.2f]; 
    }
    
}


- (void) dismissSignInView {
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat duration = 0.4f;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.removedOnCompletion = NO;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.75f],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration = duration * .4f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeOut.beginTime = duration * .6f;
    fadeOut.fillMode = kCAFillModeBoth;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
  //  group.animations = [NSArray arrayWithObjects:scale, fadeOut, nil];
    group.delegate = self;
    //group.duration = duration;
    group.removedOnCompletion = YES;
    
    //[group setValue:@"PopOutAnimation" forKey: @"animation"];
   // group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [signView.layer addAnimation: group forKey: @"PopOutAnimation"];
   signView.layer.opacity = 0;
}

-(IBAction)signInCloseFunc {
    
    
    
    _loginScreenDidPopOut = 1;
    [self dismissSignInView];
}

-(IBAction)signInFunc{
    
    _loginScreenDidPopOut = 1;

    if(![username.text isEqualToString:@""] && ![password.text isEqualToString:@""])
    {
        
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        //Valid email address
        if ([emailTest evaluateWithObject:username.text] == YES) 
        {
            NSLog(@"activity indicator");
            
            myact=
            [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            myact.center=CGPointMake(374, 245);
            myact.hidesWhenStopped=YES;
            [signView addSubview:myact];
            [myact bringSubviewToFront:self.view];
            [myact startAnimating];
            signView.userInteractionEnabled = NO;
            
            
            
            [NSTimer scheduledTimerWithTimeInterval:5
                                             target:self 
                                           selector:@selector(stopTurning) 
                                           userInfo:nil 
                                            repeats:NO];
            
        }
        else
        {
            //not valid email address
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" 
                                                         message:@"Not a valid email address" 
                                                        delegate:self 
                                               cancelButtonTitle:@"Okay" 
                                               otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
    }
    
    
    else
    {
        //any of the text field is empty
        PBLog(@"in signInFunc");
        
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" 
                                                     message:@"Enter the Required Field" 
													delegate:self 
                                           cancelButtonTitle:@"Okay" 
                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    
    /*    
     
     
     if ([username.text isEqualToString:@""]  || [password.text isEqualToString:@""])	
     {	
     NSLog(@"in signInFunc");
     
     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" 
     message:@"Enter the Required Field" 
     delegate:self 
     cancelButtonTitle:@"Okay" 
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     }
     
     else {
     NSLog(@"activity indicator");
     
     myact=
     [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
     myact.center=CGPointMake(332, 295);
     myact.hidesWhenStopped=YES;
     [signView addSubview:myact];
     [myact bringSubviewToFront:self.view];
     [myact startAnimating];
     username.enabled = NO;
     password.enabled = NO;
     signInClose.enabled = NO;
     
     [NSTimer scheduledTimerWithTimeInterval:20
     target:self 
     selector:@selector(stopTurning) 
     userInfo:nil 
     repeats:NO];
     
     }*/
}

-(void)stopTurning
{
    [myact stopAnimating];
    [myact release];
    _loginScreenDidPopOut = 1;
    [self dismissSignInView];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == username) {
		[textField resignFirstResponder];
		[password becomeFirstResponder];
	}
	else if (textField == password) {
		[textField resignFirstResponder];
	}
	return YES;
}


@end
