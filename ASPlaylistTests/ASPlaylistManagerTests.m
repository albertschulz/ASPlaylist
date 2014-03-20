//
//  ASPlaylistTests.m
//  ASPlaylistTests
//
//  Created by Albert on 28.02.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASPlaylistManager.h"

#define kBundlePath [[NSBundle bundleForClass:[self class]] resourcePath]

@interface ASPlaylistManagerTests : XCTestCase

@end

@implementation ASPlaylistManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[ASPlaylistManager sharedInstance] setDatabasePath:kBundlePath];
}

- (void)tearDown
{
    [[ASPlaylistManager sharedInstance] removeAllPlaylists];
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
    
- (void)testSingleton
{
    ASPlaylistManager *playlistManager = [ASPlaylistManager sharedInstance];
    XCTAssertNotNil(playlistManager, @"singleton should not be nil");
}

- (void)testSetDatabasePath
{
    [[ASPlaylistManager sharedInstance] setDatabasePath:kBundlePath];
    XCTAssertNotEqual([ASPlaylistManager sharedInstance].databasePath, kBundlePath, @"paths do not match");
}

- (void)testAddPlaylist {
    
    ASPlaylist *playlist = [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"Fav Music"];
    
    XCTAssertNotNil(playlist, @"playlist not successfully inserted");
}

- (void)testRemovePlaylist {
    ASPlaylist *playlist = [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"Playlist1"];
    
    [[ASPlaylistManager sharedInstance] removePlaylist:playlist];
    
    XCTAssert([ASPlaylistManager sharedInstance].numberOfPlaylists == 0, @"playlist should be deleted");
}

- (void)testAddPlaylists {
    
    [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"Playlist1"];
    [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"Playlist2"];
    
    XCTAssert([ASPlaylistManager sharedInstance].numberOfPlaylists == 2, @"playlist count should be two");
}

- (void)testAddSameNamedPlaylists {
    [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"SameName"];
    [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"SameName"];
        
    XCTAssert([ASPlaylistManager sharedInstance].numberOfPlaylists == 1, @"playlist with name which already exists should not be added again");
}

- (void)testUpdatePlaylistName {
    ASPlaylist *playlist = [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"PlayList"];
    
    BOOL success = [playlist changeName:@"CoolPlayList"];
    
    ASPlaylist *changedPlaylist = [[ASPlaylistManager sharedInstance] playlistForName:@"CoolPlayList"];
    
    XCTAssert(success, @"update name should succeed");
    XCTAssertNotNil(changedPlaylist, @"update playlist should be there");
}

- (void)testAllPlaylists {
    [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"a"];
    [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"b"];
    [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"c"];
    
    NSArray *playlists = [[ASPlaylistManager sharedInstance] playlists];
    
    XCTAssertNotNil(playlists, @"playlists not loaded");
    XCTAssert(playlists.count == 3, @"number of playlists incorrect");
    XCTAssert([playlists[0] isKindOfClass:[ASPlaylist class]], @"wrong object class found in playlists");
}

- (void)testAddItems {
    ASPlaylist *playlist = [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"Favourite Hits"];
    
    BOOL success = [playlist addPlaylistItemWithName:@"OneDay" filePath:@"/test/test"];
    
    XCTAssert(success, @"add item should succeed");
    XCTAssert(playlist.items.count == 1, @"number of playlist items should be one");
}

- (void)testRemoveItems {
    ASPlaylist *playlist = [[ASPlaylistManager sharedInstance] addPlaylistWithName:@"Favourite Hits"];
    
    [playlist addPlaylistItemWithName:@"OneDay" filePath:@"/test/test"];
    
    ASPlaylistItem *item = playlist.items[0];
    
    [playlist removeItem:item];
    
    XCTAssertFalse(playlist.items.count, @"playlist should not have any items anymore");
}

@end
