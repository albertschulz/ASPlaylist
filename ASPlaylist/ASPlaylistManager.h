//
//  ASPlaylist.h
//  ASPlaylist
//
//  Created by Albert on 28.02.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPlaylist.h"
#import "ASPlaylistItem.h"

@interface ASPlaylistManager : NSObject

+ (ASPlaylistManager *)sharedInstance;

@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, assign) NSInteger numberOfPlaylists;
@property (nonatomic, readonly) NSArray *playlists;

- (ASPlaylist *)addPlaylistWithName:(NSString *)name;
- (BOOL)removePlaylist:(ASPlaylist *)playlist;
- (BOOL)removeAllPlaylists;
- (ASPlaylist *)playlistForName:(NSString *)name;
- (BOOL)addItemToPlaylist:(ASPlaylist *)playlist itemName:(NSString *)name filePath:(NSString *)filePath;
- (BOOL)updateNameForPlaylist:(ASPlaylist *)playlist name:(NSString *)name;
- (BOOL)removeItem:(ASPlaylistItem *)item fromPlaylist:(ASPlaylist *)playlist;
- (BOOL)removeAllItemsFromPlaylist:(ASPlaylist *)playlist;
- (BOOL)deleteFileAndPlaylistItemsForPath:(NSString *)path;

- (BOOL)changeFilePathOfItems:(NSString *)filePath withFilePath:(NSString *)currentFilePath;

- (NSArray *)searchPlaylistItems:(NSString *)term;
- (BOOL)changeNameForItem:(ASPlaylistItem *)item name:(NSString *)name;

@end
