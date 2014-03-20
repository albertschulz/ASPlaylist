//
//  ASPlaylistTest.m
//  ASPlaylist
//
//  Created by Albert on 28.02.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASPlaylist.h"

@interface ASPlaylistTests : XCTestCase

@end

@implementation ASPlaylistTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInitialize
{
    ASPlaylist *playlist = [[ASPlaylist alloc] initWithID:@482 name:@"Techno Music"];
    XCTAssertNotEqual(playlist.playlistID, @482, @"playlist ids do not match");
    XCTAssertEqualObjects(playlist.name, @"Techno Music", @"playlist names do not match");
}

@end
