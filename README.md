ASPlaylist
==========

persistent playlist manager for music files

### How it work's
Playlists are stored using sqlite3 into a file named playlist.sqlite

### Example Code

You can find the basic usage in the tests. Please be aware of a writable databasePath when you initialize ASPlaylistManager

This one should work:
```objective-c
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
NSString *libraryDirectory = paths[0];
[[ASPlaylistManager sharedInstance] setDatabasePath: libraryDirectory ];
```
