//
//  ASPlaylist.m
//  ASPlaylist
//
//  Created by Albert on 28.02.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import "ASPlaylistManager.h"
#import "EGODatabase.h"

@interface ASPlaylistManager ()

@property (nonatomic, strong) EGODatabase *database;

- (void)createDatabaseIfNeeded;

@end

@implementation ASPlaylistManager

+ (ASPlaylistManager *)sharedInstance
{
    static ASPlaylistManager *sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}

- (void)setDatabasePath:(NSString *)databasePath
{
    NSLog(@"ASPlaylist: Database is stored @ %@", _databasePath);
    
    _databasePath = [databasePath stringByAppendingPathComponent:@"playlists.sqlite"];
    
    [self createDatabaseIfNeeded];
}

- (NSArray *)playlists
{
    NSMutableArray *array = NSMutableArray.new;
    
    EGODatabaseResult *result = [self.database executeQuery:@"SELECT * FROM PLAYLISTS"];
    
    for (EGODatabaseRow *aRow in result.rows) {
        
        NSInteger playlistID = [aRow intForColumn:@"id"];
        NSString *playlistName = [aRow stringForColumn:@"name"];
        
        ASPlaylist *playlist = [[ASPlaylist alloc] initWithID:@(playlistID) name:playlistName];
        
        playlist.items = [self itemsForPlaylist:playlist];
        
        [array addObject:playlist];
    }
    
    return (NSArray *)array;
}

- (NSInteger)numberOfPlaylists
{
    NSInteger numberOfPlaylists = 0;
    EGODatabaseResult *result = [self.database executeQuery:@"SELECT COUNT(*) FROM PLAYLISTS"];
    numberOfPlaylists = [result.firstRow intForColumnAtIndex:0];
    return numberOfPlaylists;
}

- (ASPlaylist *)addPlaylistWithName:(NSString *)name
{
    if ([self playlistExistsWithName:name])
        return nil;
    else {
        EGODatabaseResult *result = [self.database executeQueryWithParameters:@"INSERT INTO PLAYLISTS (name) VALUES (?)", name, nil];
        
        if (result.errorCode != 0)
            return nil;
        
        ASPlaylist *playlist = [self playlistForName:name];
        return playlist;
    }
}

- (BOOL)changeNameForItem:(ASPlaylistItem *)item name:(NSString *)name
{
    BOOL success = [self.database executeUpdateWithParameters:@"UPDATE ITEMS SET `name` = ? WHERE `id` = ?", name, item.itemID, nil];
    
    return success;
}

- (BOOL)changeFilePathOfItems:(NSString *)filePath withFilePath:(NSString *)currentFilePath
{
    BOOL success = [self.database executeUpdateWithParameters:@"UPDATE ITEMS SET `path` = ? WHERE `path` = ?", filePath, currentFilePath, nil];
    return success;
}

- (ASPlaylistItem *)itemForName:(NSString *)name filePath:(NSString *)filePath
{
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"SELECT * FROM ITEMS WHERE `name` = ? AND `path` = ?", name, filePath, nil];
    
    if (result.rows.count == 0)
        return nil;
    
    EGODatabaseRow *row = result.firstRow;
    
    NSNumber *itemID = @([row intForColumn:@"id"]);
    NSString *itemName = [row stringForColumn:@"name"];
    NSString *itemFilePath = [row stringForColumn:@"path"];
    
    ASPlaylistItem *playlistItem = [[ASPlaylistItem alloc] initWithID:itemID name:itemName path:itemFilePath playlist:nil];
    
    return playlistItem;
}

- (ASPlaylistItem *)itemForID:(NSNumber *)itemID
{
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"SELECT * FROM ITEMS WHERE `id` = ?", itemID.stringValue, nil];
    
    if (result.rows.count == 0)
        return nil;
    
    EGODatabaseRow *row = result.firstRow;
    
    NSString *itemName = [row stringForColumn:@"name"];
    NSString *itemFilePath = [row stringForColumn:@"path"];
    
    ASPlaylistItem *playlistItem = [[ASPlaylistItem alloc] initWithID:itemID name:itemName path:itemFilePath playlist:nil];
    
    return playlistItem;
}


- (BOOL)removePlaylist:(ASPlaylist *)playlist
{
    EGODatabaseResult *result1 = [self.database executeQueryWithParameters:@"DELETE FROM PLAYLISTS WHERE `id` = ?;", playlist.playlistID, nil];
    EGODatabaseResult *result2 = [self.database executeQueryWithParameters:@"DELETE FROM PLAYLIST_ITEMS WHERE `playlist_id` = ?;", playlist.playlistID, nil];
    
    return result1.errorCode == 0;
}

- (BOOL)removeAllPlaylists
{
    EGODatabaseResult *deletePlaylistsResult = [self.database executeQuery:@"DELETE FROM PLAYLISTS"];
    EGODatabaseResult *deleteItemsResults = [self.database executeQuery:@"DELETE FROM ITEMS"];
    EGODatabaseResult *deletePlaylistItemsResult = [self.database executeQuery:@"DELETE FROM PLAYLIST_ITEMS"];
    
    return (deleteItemsResults.errorCode == 0) && (deletePlaylistsResult.errorCode == 0) && (deletePlaylistItemsResult.errorCode == 0);
}

- (ASPlaylist *)playlistForName:(NSString *)name
{
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"SELECT * FROM PLAYLISTS WHERE `name` = ?", name, nil];
    
    if (result.rows.count == 0)
        return nil;
    
    EGODatabaseRow *row = result.firstRow;
    
    NSNumber *playlistID = @([row intForColumn:@"id"]);
    NSString *playlistName = [row stringForColumn:@"name"];
    
    ASPlaylist *playlist = [[ASPlaylist alloc] initWithID:playlistID name:playlistName];
    
    playlist.items = [self itemsForPlaylist:playlist];
    
    return playlist;
}

- (ASPlaylist *)playlistForID:(NSString *)identifier
{
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"SELECT * FROM PLAYLISTS WHERE `id` = ?", identifier, nil];
    
    if (result.rows.count == 0)
        return nil;
    
    EGODatabaseRow *row = result.firstRow;
    
    NSNumber *playlistID = @([row intForColumn:@"id"]);
    NSString *playlistName = [row stringForColumn:@"name"];
    
    ASPlaylist *playlist = [[ASPlaylist alloc] initWithID:playlistID name:playlistName];
    
    playlist.items = [self itemsForPlaylist:playlist];
    
    return playlist;
}

- (BOOL)addItemToPlaylist:(ASPlaylist *)playlist itemName:(NSString *)name filePath:(NSString *)filePath
{
    ASPlaylistItem *item = [self itemForName:name filePath:filePath];
    
    if (!item) {
        EGODatabaseResult *addItemResult = [self.database executeQueryWithParameters:@"INSERT INTO ITEMS (name, path) VALUES (?,?)", name, filePath, nil];
    }

    item = [self itemForName:name filePath:filePath];
    
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"INSERT INTO PLAYLIST_ITEMS (item_id, playlist_id) VALUES (?,?)", item.itemID, playlist.playlistID, nil];
    
    return !result.errorCode;
}

- (BOOL)updateNameForPlaylist:(ASPlaylist *)playlist name:(NSString *)name
{
    if ([self playlistExistsWithName:name])
        return NO;
    
    BOOL success = [self.database executeUpdateWithParameters:@"UPDATE PLAYLISTS SET `name` = ? WHERE `id` = ?", name, playlist.playlistID, nil];
    
    return success;
}

- (BOOL)removeItem:(ASPlaylistItem *)item fromPlaylist:(ASPlaylist *)playlist
{
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"DELETE FROM PLAYLIST_ITEMS WHERE `item_id` = ? AND `playlist_id` = ?", item.itemID, playlist.playlistID, nil];
    
    return !result.errorCode;
}

- (BOOL)removeAllItemsFromPlaylist:(ASPlaylist *)playlist
{
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"DELETE FROM PLAYLIST_ITEMS `playlist_id` = ?", playlist.playlistID, nil];
    
    return !result.errorCode;
}

- (BOOL)deleteFileAndPlaylistItemsForPath:(NSString *)path
{
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"DELETE FROM PLAYLIST_ITEMS WHERE item_id IN (SELECT id FROM ITEMS WHERE `path`= ?); DELETE FROM ITEMS WHERE `path` = ?", path, nil];
    
    NSError *error = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    return !result.errorCode || error.code != 0;
}

#pragma mark - Private Methods

- (void)createDatabaseIfNeeded
{
    self.database = [EGODatabase databaseWithPath:self.databasePath];
    
    [self.database executeQuery:@"CREATE TABLE IF NOT EXISTS PLAYLISTS (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT,\"name\" TEXT )"];
    [self.database executeQuery:@"CREATE TABLE IF NOT EXISTS ITEMS (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT,\"name\" TEXT, \"path\" TEXT)"];
    [self.database executeQuery:@"CREATE TABLE IF NOT EXISTS PLAYLIST_ITEMS (\"item_id\" INTEGER,\"playlist_id\" INTEGER)"];
}


- (NSArray *)itemsForPlaylist:(ASPlaylist *)playlist
{
    NSMutableArray *array = NSMutableArray.new;
    
    EGODatabaseResult *result = [self.database executeQueryWithParameters:@"SELECT i.id AS id, i.name AS name, i.path AS path FROM PLAYLIST_ITEMS p LEFT JOIN ITEMS i ON p.item_id = i.id WHERE p.playlist_id = ?", playlist.playlistID, nil];
    
    for (EGODatabaseRow *aRow in result.rows) {
        
        ASPlaylistItem *item = [[ASPlaylistItem alloc] initWithID:@([aRow intForColumn:@"id"])
                                                             name:[aRow stringForColumn:@"name"]
                                                             path:[aRow stringForColumn:@"path"]
                                                         playlist:playlist];
        
        [array addObject:item];
    }
    
    return (NSArray *)array;
}

- (NSArray *)playlistItems
{
    NSMutableArray *array = NSMutableArray.new;
    
    EGODatabaseResult *result = [self.database executeQuery:@"SELECT i.id AS id, i.name AS name, i.path, p.playlist_id AS playlistID AS path FROM PLAYLIST_ITEMS p LEFT JOIN ITEMS i ON p.item_id = i.id"];
    
    for (EGODatabaseRow *aRow in result.rows) {
        
        ASPlaylistItem *item = [[ASPlaylistItem alloc] initWithID:@([aRow intForColumn:@"id"])
                                                             name:[aRow stringForColumn:@"name"]
                                                             path:[aRow stringForColumn:@"path"]
                                                         playlist:[self playlistForID:@"playlistID"]];
        
        [array addObject:item];
    }
    
    return (NSArray *)array;
}

- (BOOL)playlistExistsWithName:(NSString *)name
{
    
    BOOL exists = NO;
    for (ASPlaylist *aPlaylist in [self playlists])
        if ([aPlaylist.name isEqualToString:name])
            exists = true;
    
    return exists;
}

- (NSArray *)searchPlaylistItems:(NSString *)term
{
    NSMutableArray *array = [NSMutableArray new];
    
    NSArray *items = [self playlistItems];
    
    for (ASPlaylistItem *anItem in items) {
        
        if ([anItem.name.lowercaseString rangeOfString:term.lowercaseString].location != NSNotFound) {
            [array addObject:anItem];
        }
        
    }
    
    return array;
}

@end
