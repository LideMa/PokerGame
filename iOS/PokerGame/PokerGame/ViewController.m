//
//  ViewController.m
//  PokerGame
//
//  Created by Lide on 2020/3/31.
//  Copyright © 2020 Lide. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    UIButton *_connectButton;
    UIButton *_sendButton;
    NSURLSessionWebSocketTask *_task;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _connectButton.frame = CGRectMake(100, 100, 100, 40);
    _connectButton.backgroundColor = [UIColor whiteColor];
    _connectButton.layer.borderWidth = 1;
    _connectButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    [_connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_connectButton addTarget:self action:@selector(clickConnectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectButton];

    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(100, 180, 100, 40);
    _sendButton.backgroundColor = [UIColor whiteColor];
    _sendButton.layer.borderWidth = 1;
    _sendButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendButton];
}

- (void)clickSendButton:(id)sender {
    NSString *text = [NSString stringWithFormat:@"random_%i", arc4random() % 1000];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[text] forKeys:@[@"text"]];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    [_task sendMessage:[[NSURLSessionWebSocketMessage alloc] initWithData:data] completionHandler:^(NSError * _Nullable error) {
        NSLog(@"send message success!");
    }];
}

- (void)clickConnectButton:(id)sender {
    _task = [[NSURLSession sharedSession] webSocketTaskWithURL:[NSURL URLWithString:@"ws://192.168.9.224:8080/ws"]];
    [_task resume];
//    [_task sendPingWithPongReceiveHandler:^(NSError * _Nullable error) {
//
//    }];
    [self readMessage];
    NSLog(@"connect succeed");
}

- (void)readMessage {
    [_task receiveMessageWithCompletionHandler:^(NSURLSessionWebSocketMessage * _Nullable message, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"message is: %@", message.string);
            [self readMessage];
        }
    }];
}

@end
