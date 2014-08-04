//
//  ASPlaylistItem.m
//  ASPlaylist
//
//  Created by Albert on 28.02.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import "ASPlaylistItem.h"
#import "ASPlaylist.h"
#import "ASPlaylistManager.h"

@implementation ASPlaylistItem

- (id)initWithID:(NSNumber *)itemID name:(NSString *)name path:(NSString *)filePath playlist:(ASPlaylist *)playlist;
{
    self = [super init];
    if (self) {
        _itemID = itemID;
        _name = name;
        _filePath = filePath;
        _playlist = playlist;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        @throw [NSException
                exceptionWithName:@"NotAllowedException"
                reason:@"*** don't call (init) on playlist item! use (initWithID:name:path:playlist:) instead"
                userInfo:nil];
    }
    return self;
}

- (BOOL)delete
{
    return [self.playlist removeItem:self];
}

- (BOOL)changeName:(NSString *)name
{
    BOOL success = [[ASPlaylistManager sharedInstance] changeNameForItem:self name:name];
    
    if (success) {
        _name = name;
    }
    
    return success;
}

@end
