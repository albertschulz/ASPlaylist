//
//  ASPlaylist.h
//  ASPlaylist
//
//  Created by Albert on 28.02.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPlaylistItem.h"

@interface ASPlaylist : NSObject

- (id)initWithID:(NSNumber *)playlistID name:(NSString *)name;
- (BOOL)addPlaylistItemWithName:(NSString *)name filePath:(NSString *)filePath;
- (BOOL)changeName:(NSString *)name;
- (BOOL)removeItem:(ASPlaylistItem *)item;
- (BOOL)removeAllItems;
- (void)reloadItems;

@property (nonatomic, strong, readonly) NSNumber *playlistID;
@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong) NSArray *items;

@end