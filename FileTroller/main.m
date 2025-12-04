#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <stdio.h>
#import <objc/runtime.h>
#import <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <dirent.h>
#include <netinet/in.h>
#include <netinet/ip_icmp.h>
#include <errno.h>
#include <sys/select.h>
#include <grp.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/sysctl.h>
#include <fcntl.h>
#include <string.h>
#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>
#import <spawn.h>
#include "TSUtil.h"

void createDirectory(NSString *path) {
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

BOOL removeDirectory(NSString *path) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:path error:&error];
    
    if (success) {
        NSLog(@"Directory removed successfully");
    } else {
        NSLog(@"Error removing directory: %@", [error localizedDescription]);
    }
    
    return success;
}

BOOL moveFile(NSString *sourcePath, NSString *destinationPath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    BOOL success = [fileManager moveItemAtPath:sourcePath toPath:destinationPath error:&error];
    
    if (success) {
        NSLog(@"File moved successfully");
    } else {
        NSLog(@"Error moving file: %@", [error localizedDescription]);
    }
    
    return success;
}

BOOL copyFile(NSString *sourcePath, NSString *destinationPath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    BOOL success = [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    
    if (success) {
        NSLog(@"File copied successfully");
    } else {
        NSLog(@"Error copying file: %@", [error localizedDescription]);
    }
    
    return success;
}


BOOL removeExecutePermission(NSString *filePath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        NSLog(@"Error: File does not exist at %@", filePath);
        return NO;
    }

    NSError *error;
    NSMutableDictionary *attributes = [[fileManager attributesOfItemAtPath:filePath error:&error] mutableCopy];
    
    if (attributes) {
        NSNumber *currentPermissions = attributes[NSFilePosixPermissions];
        
        if (currentPermissions != nil) {
            NSUInteger newPermissions = [currentPermissions unsignedIntegerValue] & ~(S_IXUSR | S_IXGRP | S_IXOTH);
    
            [attributes setObject:@(newPermissions) forKey:NSFilePosixPermissions];
            
            if ([fileManager setAttributes:attributes ofItemAtPath:filePath error:&error]) {
                NSLog(@"Execute bit removed successfully from %@", filePath);
                return YES;
            } else {
                NSLog(@"Error updating file attributes: %@", [error localizedDescription]);
            }
        } else {
            NSLog(@"Error: Unable to retrieve file permissions for %@", filePath);
        }
    } else {
        NSLog(@"Error retrieving file attributes: %@", [error localizedDescription]);
    }
    
    return NO;
}

BOOL setUserAndGroup(NSString *filePath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        NSLog(@"Error: File does not exist at %@", filePath);
        return NO;
    }

    NSError *error;
    
    NSMutableDictionary *attributes = [[fileManager attributesOfItemAtPath:filePath error:&error] mutableCopy];
    
    if (attributes) {
        [attributes setObject:@(33) forKey:NSFileOwnerAccountID];
        [attributes setObject:@(33) forKey:NSFileGroupOwnerAccountID];

        if ([fileManager setAttributes:attributes ofItemAtPath:filePath error:&error]) {
            NSLog(@"User and group set successfully for %@", filePath);
            return YES;
        } else {
            NSLog(@"Error updating file attributes: %@", [error localizedDescription]);
        }
    } else {
        NSLog(@"Error retrieving file attributes: %@", [error localizedDescription]);
    }
    
    return NO;
}

NSString* appPath(void)
{
    NSError* mcmError;
    MCMAppContainer* appContainer = [MCMAppContainer containerWithIdentifier:@"com.garena.game.kgth" createIfNecessary:NO existed:NULL error:&mcmError];
    if(!appContainer) return nil;
    return appContainer.url.path;
}

NSString* kgth_aws(void)
{
    return [appPath() stringByAppendingPathComponent:@"kgth.app"];
}

NSString* backupFilename(void) {
    return @"kgth.bak";
}

NSString* backupPath(void) {
    return [@"/var/mobile/Documents" stringByAppendingPathComponent:backupFilename()];
}


void checkAndExitIfFileExists(NSString *filePath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"File %@ exists. Exiting.", filePath);
        exit(0);
    }
}

void checkAndExitIfFiledontExists(NSString *filePath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:filePath]) {
        NSLog(@"File %@ dont exist. Exiting.", filePath);
        exit(0);
    }
}

BOOL removeFileAtPath(NSString *filePath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    if ([fileManager fileExistsAtPath:filePath]) {
        if ([fileManager removeItemAtPath:filePath error:&error]) {
            NSLog(@"File removed successfully: %@", filePath);
            return YES;
        } else {
            NSLog(@"Error removing file at %@: %@", filePath, [error localizedDescription]);
        }
    } else {
        NSLog(@"File does not exist at %@", filePath);
    }

    return NO;
}

void deleteFolderAtPath(NSString *folderPath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    if ([fileManager fileExistsAtPath:folderPath]) {
        if ([fileManager removeItemAtPath:folderPath error:&error]) {
            NSLog(@"Folder deleted successfully: %@", folderPath);
        } else {
            NSLog(@"Error deleting folder at %@: %@", folderPath, [error localizedDescription]);
        }
    } else {
        NSLog(@"Folder does not exist at %@", folderPath);
    }
}

void setOwnershipForFolder(NSString *folderPath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    NSDictionary *attributes = @{
        NSFileOwnerAccountID: @(33),
        NSFileGroupOwnerAccountID: @(33)
    };

    if ([fileManager setAttributes:attributes ofItemAtPath:folderPath error:&error]) {
        NSLog(@"Ownership changed successfully for %@", folderPath);

        NSArray *contents = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
        for (NSString *item in contents) {
            NSString *itemPath = [folderPath stringByAppendingPathComponent:item];
            setOwnershipForFolder(itemPath);
        }
    } else {
        NSLog(@"Error changing ownership for %@: %@", folderPath, [error localizedDescription]);
    }
}

void deleteAllDylibsInFolder(NSString *folderPath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:folderPath error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return;
    }
    
    for (NSString *fileName in contents) {
        if ([fileName.pathExtension isEqualToString:@"dylib"]) {
            NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
            NSError *deleteError = nil;
            [fileManager removeItemAtPath:filePath error:&deleteError];
            
            if (deleteError) {
                NSLog(@"Error deleting file %@: %@", fileName, deleteError.localizedDescription);
            } else {
                NSLog(@"Deleted file: %@", fileName);
            }
        }
    }
}

void setAllOwnersForDylibsInFolder(NSString *folderPath) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:folderPath error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return;
    }
    
    for (NSString *fileName in contents) {
        if ([fileName.pathExtension isEqualToString:@"dylib"]) {
            NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
            NSMutableDictionary *attributes = [[fileManager attributesOfItemAtPath:filePath error:&error] mutableCopy];
            
            if (attributes) {
                [attributes setObject:@(33) forKey:NSFileOwnerAccountID];
                [attributes setObject:@(33) forKey:NSFileGroupOwnerAccountID];

                if ([fileManager setAttributes:attributes ofItemAtPath:filePath error:&error]) {
                    NSLog(@"User and group set successfully for %@", filePath);
                } else {
                    NSLog(@"Error updating file attributes: %@", [error localizedDescription]);
                }
            } else {
                NSLog(@"Error retrieving file attributes: %@", [error localizedDescription]);
            }
        }
    }
}



int main(int argc, char *argv[]) {
    NSString * appDelegateClassName;
    if (argc == 2 && strcmp(argv[1], "--patch") == 0) {
        @autoreleasepool {
            NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
            NSString *appBundlePath = kgth_aws();

            NSString *bakPath = backupPath();   // <-- Dùng biến chung

            // Nếu file backup đã tồn tại → thoát
            checkAndExitIfFileExists(bakPath);

            // Sao lưu file gốc
            copyFile(
                [appBundlePath stringByAppendingString:@"/Frameworks/AWSCognito.framework/AWSCognito"],
                bakPath
            );

            // Xóa file gốc để thay file mới
            removeFileAtPath([appBundlePath stringByAppendingString:@"/Frameworks/AWSCognito.framework/AWSCognito"]);

            // Giải nén file mới
            NSString *binaryPath3 = [bundlePath stringByAppendingPathComponent:@"unzip"];
            NSMutableArray *args3 = [NSMutableArray new];
            [args3 addObject:[bundlePath stringByAppendingString:@"/dylibs/dylibs.zip"]];
            [args3 addObject:@"-d"];
            [args3 addObject:[appBundlePath stringByAppendingString:@"/Frameworks/AWSCognito.framework/"]];
            spawnRoot(binaryPath3, args3, nil, nil);

            // Fix permission
            NSString *patchedFile = [appBundlePath stringByAppendingString:@"/Frameworks/AWSCognito.framework/AWSCognito"];
            removeExecutePermission(patchedFile);
            setUserAndGroup(patchedFile);

            // Set owner cho tất cả .dylib
            setAllOwnersForDylibsInFolder([appBundlePath stringByAppendingPathComponent:@"Frameworks/"]);

            killall(@"kgth", true);
        }
    }
    else if (argc == 2 && strcmp(argv[1], "--unpatch") == 0) {
        NSString *appBundlePath = kgth_aws();
        NSString *bakPath = backupPath();

        if ([[NSFileManager defaultManager] fileExistsAtPath:bakPath]) {

            // Xóa file đã patch
            removeFileAtPath([appBundlePath stringByAppendingString:@"/Frameworks/AWSCognito.framework/AWSCognito"]);

            // Restore file backup
            moveFile(
                bakPath,
                [appBundlePath stringByAppendingString:@"/Frameworks/AWSCognito.framework/AWSCognito"]
            );

            killall(@"kgth", true);
        }
    }
    else {
        @autoreleasepool {
            appDelegateClassName = NSStringFromClass([AppDelegate class]);
        }
        return UIApplicationMain(argc, argv, nil, appDelegateClassName);
    }
}
