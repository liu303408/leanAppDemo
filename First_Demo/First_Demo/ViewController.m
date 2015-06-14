//
//  ViewController.m
//  First_Demo
//
//  Created by 刘丹 on 15/6/14.
//  Copyright (c) 2015年 刘丹. All rights reserved.
//

#import "ViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self runCloudFunction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryObject {

    AVQuery *query = [AVQuery  queryWithClassName:@"JobApplication"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *jobApplication = [objects objectAtIndex:0];
            AVFile *applicantResume = [jobApplication objectForKey:@"applicantResumeFile"];
            NSData *resumeData = [applicantResume getData];
            NSString *result = [[NSString alloc] initWithData:resumeData  encoding:NSUTF8StringEncoding];
            NSLog(@"result---%@",result);
            // ...
        }
    }];
}

- (void)uploadFile {
    
    NSData *data = [@"Working with LeanCloud is great!" dataUsingEncoding:NSUTF8StringEncoding];
    AVFile *file = [AVFile fileWithName:@"resume.txt" data:data];
    [file saveInBackground];
    AVObject *jobApplication = [AVObject objectWithClassName:@"JobApplication"];
    [jobApplication setObject:@"Joe Smith" forKey:@"applicantName"];
    [jobApplication setObject:file         forKey:@"applicantResumeFile"];
    [jobApplication saveInBackground];
    AVFile *applicantResume = [jobApplication objectForKey:@"applicantResumeFile"];
    NSData *resumeData = [applicantResume getData];
    NSString *result = [[NSString alloc] initWithData:resumeData  encoding:NSUTF8StringEncoding];
    NSLog(@"result---%@",result);
}

- (void)queryFile {
    [AVFile getFileWithObjectId:@"557d5e5ae4b007f322ab6e5f" withBlock:^(AVFile *file, NSError *error) {
        NSData *resumeData = [file getData];
        NSString *errorDesc = nil;
        
        NSPropertyListFormat format;
        NSMutableDictionary *dic = (NSMutableDictionary *)[NSPropertyListSerialization  propertyListWithData:resumeData options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorDesc];
        NSLog(@"result---%@",dic );
        
    }];
}

- (void)runCloudFunction {
    [AVCloud callFunctionInBackground:@"hello" withParameters:nil block:^(id object, NSError *error) {
        NSLog(@"result---%@",object);
    }];
}


@end
