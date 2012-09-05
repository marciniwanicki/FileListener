/* Copyright (c) 2012 Marcin Iwanicki.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FileChecker.h"

@interface FileChecker ()

- (BOOL) saveUrlToFile: (NSURL *) url error: (NSError **) error;
- (NSString *) getUrlFileLocation;
- (NSString *) getCacheFileLocation;
@end

@implementation FileChecker

@synthesize cachedRemoteFile;

/**
 Download remote file and equal with local (use NSData).
 */
- (BOOL) isFileChanged: (NSError **) error {
    NSURL *fileUrl = [self loadUrlFromFile: error];
    if (fileUrl == nil) {
        return NO;
    }
    NSData *remoteData = [NSData dataWithContentsOfURL:fileUrl options:NSDataReadingUncached error: error];
    if (remoteData == nil) {
        return NO;
    }    
    NSData *localData = [NSData dataWithContentsOfFile: [self getCacheFileLocation]];
    if (localData == nil) {
        [remoteData writeToFile: [self getCacheFileLocation] atomically: YES];
        return NO;
    }
    if ([localData hash] != [remoteData hash]) {
        [remoteData writeToFile: [self getCacheFileLocation] atomically: YES];
        return YES;
    }
    return NO;
}

/**
 Persist remote file's url.
 */
- (void) setRemoteFileUrl: (NSURL *) aRemoteFileUrl {
    NSError *error;
    if ([self saveUrlToFile: aRemoteFileUrl error: &error]) {
        // success
        
    } else {
        // failure
        
    }
}

/**
 Get URL from local file (url.txt).
 */
- (NSURL *) loadUrlFromFile: (NSError **) error {
    NSString *urlString = [NSString stringWithContentsOfFile: [self getUrlFileLocation] encoding: NSUTF8StringEncoding error: error];
    if (urlString == nil) {
        return nil;
    }
    return [NSURL URLWithString: urlString];
}

#pragma mark - Private methods
/**
 Save URL as local file (url.txt).
 */
- (BOOL) saveUrlToFile: (NSURL *) url error: (NSError **) error {    
    NSString *path = [url absoluteString];
    return [path writeToFile: [self getUrlFileLocation] atomically:YES encoding:NSUTF8StringEncoding error:error];
}

/**
 Get filepath of URL (from url.txt)
 */
- (NSString *) getUrlFileLocation {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"url.txt"];
    return filePath;
}

/**
 Get filepath of cache (from cache.txt)
 */
- (NSString *) getCacheFileLocation {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"cache.txt"];
    return filePath;
}
@end
