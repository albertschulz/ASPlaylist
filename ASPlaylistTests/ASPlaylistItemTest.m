//
//  ASPlaylistItemTest.m
//  ASPlaylist
//
//  Created by Albert on 02.03.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASPlaylistItem.h"

#import "ASPlaylist.h"
#import "ASPlaylistManager.h"

@interface ASPlaylistItemTest : XCTestCase
{
    ASPlaylist *playlist;
}

@end

@implementation ASPlaylistItemTest

- (void)setUp
{
    [super setUp];
    
    if (!playlist) {
        playlist = [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"Love Songs"];
    }
}

- (void)tearDown
{
    [playlist removeAllItems];
    
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testUsualInit
{
    XCTAssertThrows([[ASPlaylistItem alloc] init], @"init should not be allowed");
}

- (void)testRightInit
{
    ASPlaylistItem *item = [[ASPlaylistItem alloc] initWithID:@422 name:@"Super Song" path:@"/abc/def" playlist:playlist];
    
    XCTAssertEqualObjects(item.itemID, @422, @"item ids do not match");
    XCTAssertEqualObjects(item.name, @"Super Song", @"item name is not stored right");
    XCTAssertEqualObjects(item.filePath, @"/abc/def", @"file path is not stored right");
}

@end
