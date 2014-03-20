//
//  ASPlaylist.m
//  ASPlaylist
//
//  Created by Albert on 28.02.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import "ASPlaylist.h"
#import "ASPlaylistManager.h"

@implementation ASPlaylist

- (id)initWithID:(NSNumber *)playlistID name:(NSString *)name
{
    self = [super init];
    if (self) {
        _playlistID = playlistID;
        _name = name;
    }
    return self;
}

- (BOOL)addPlaylistItemWithName:(NSString *)name filePath:(NSString *)filePath
{
    BOOL success = [[ASPlaylistManager sharedInstance] addItemToPlaylist:self itemName:name filePath:filePath];
    
    if (success)
        self.items = [[NSArray alloc] initWithArray:[(ASPlaylist *)[[ASPlaylistManager sharedInstance] playlistForName:_name] items]];
    
    return success;
}

- (BOOL)changeName:(NSString *)name
{
    BOOL success = [[ASPlaylistManager sharedInstance] updateNameForPlaylist:self name:name];
    
    if (success) _name = name;
    
    return success;
}

- (BOOL)removeItem:(ASPlaylistItem *)item
{
    BOOL success = [[ASPlaylistManager sharedInstance] removeItem:item fromPlaylist:self];
    
    if (success)
        self.items = [[NSArray alloc] initWithArray:[(ASPlaylist *)[[ASPlaylistManager sharedInstance] playlistForName:_name] items]];
    
    return success;
}

- (BOOL)removeAllItems
{
    BOOL success = [[ASPlaylistManager sharedInstance] removeAllItemsFromPlaylist:self];
    
    if (success)
        self.items = [[NSArray alloc] initWithArray:[(ASPlaylist *)[[ASPlaylistManager sharedInstance] playlistForName:_name] items]];
    
    return success;
}

@end
