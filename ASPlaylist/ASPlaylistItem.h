//
//  ASPlaylistItem.h
//  ASPlaylist
//
//  Created by Albert on 28.02.14.
//  Copyright (c) 2014 Albert Schulz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASPlaylist;

@interface ASPlaylistItem : NSObject

- (id)initWithID:(NSNumber *)itemID name:(NSString *)name path:(NSString *)filePath playlist:(ASPlaylist *)playlist;
- (BOOL)delete;

@property (nonatomic, strong, readonly) NSNumber *itemID;
@property (nonatomic, weak, readonly) ASPlaylist *playlist;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *filePath;

@end
