// Copyright 2010-2014 Mineus. All rights reserved.

#import <sys/sysctl.h>
#import <sys/socket.h>
#import <sys/utsname.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <ifaddrs.h>

#import "MINDeviceInfo.h"

NSString *MINDeviceSystemVersion(void) {
    
    return [[UIDevice currentDevice] systemVersion];
}


int MINDeviceSystemVersionMajor( void ) {

    return [[[UIDevice currentDevice] systemVersion] integerValue];
}


NSString *MINDeviceModel(void) {

    return [UIDevice currentDevice].model;
}

NSString *MINDeviceModelId(void) {
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	
    char *machine = (char*) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString *result = [NSString stringWithCString: machine encoding:[NSString defaultCStringEncoding]];
    
    free(machine);
    
    return result;
}

NSString *MINDeviceUserInterfaceIdiom(void) {

    UIUserInterfaceIdiom idiom = [UIDevice currentDevice].userInterfaceIdiom;

    switch(idiom) {
        case UIUserInterfaceIdiomPhone:

            return @"Phone";

        case UIUserInterfaceIdiomPad:

            return @"Pad";

        default:

            return [NSString stringWithFormat: @"Unknown (%d)", idiom];
    }
}

static NSString *MINDeviceFilesystemInfo( NSString *key ) {
    
    NSError *error = nil;  

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  

    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath: [paths lastObject] error: &error];

    if (dictionary) {

        NSNumber *resultBytes = dictionary[key];
        return [resultBytes stringValue];
    } else {  

        return [NSString stringWithFormat: @"Unknown (error: %@)", [error description]];
    }
}

uint64_t MINDeviceDiskSpaceFreeBytesInt(void) {
    NSError *error = nil;
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath: [paths lastObject] error: &error];
	
    if (dictionary) {
		
        NSNumber *resultBytes = dictionary[NSFileSystemFreeSize];
        return [resultBytes unsignedLongLongValue];
    } else {
		
		return UINT64_MAX;
    }
	
}

NSString *MINDeviceDiskSpaceFreeBytes(void) {
    
    return MINDeviceFilesystemInfo( NSFileSystemFreeSize );
}

NSString *MINDeviceDiskSpaceTotalBytes(void) {
    
    return MINDeviceFilesystemInfo( NSFileSystemSize );
}

NSString *MINDeviceCurrentLocale(void) {

    NSLocale *locale = [NSLocale currentLocale];
    
    return [locale displayNameForKey: NSLocaleIdentifier value: [locale localeIdentifier]];
}

NSString *MINDevicePreferredLanguage(void) {

    NSLocale *locale = [NSLocale currentLocale];

    NSString *preferredLanguageCode = [NSLocale preferredLanguages][0]; // "en"
    
    return [locale displayNameForKey: NSLocaleLanguageCode value: preferredLanguageCode];
}

NSString *MINDeviceSystemTimezone(void) {
    
    return [[NSTimeZone systemTimeZone] description];
}

NSString *MINDeviceCurrentTime(void) {
    
    return [[NSDate date] description];
}

NSString *MINDeviceCurrentTimeLocal(void) {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterLongStyle];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *currentTime = [formatter stringFromDate: [NSDate date]];
    
#if !__has_feature(objc_arc)
    [formatter release];
#endif
        
    return currentTime;
}

// From http://stackoverflow.com/a/10803584/35440
NSString *MINDeviceIPAddress(void) {
	
	struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
	
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
		
        // Loop through linked list of interfaces
        temp_addr = interfaces;
		
        while(temp_addr != NULL) {
			
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
				
                NSString *name = @(temp_addr->ifa_name);
                NSString *addr = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)); // pdp_ip0     
				
                if([name isEqualToString:@"en0"]) {
					
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;    
                } else {
					if([name isEqualToString:@"pdp_ip0"]) {
						
						// Interface is the cell connection on the iPhone
						cellAddress = addr;    
					}
				}
            }
			
            temp_addr = temp_addr->ifa_next;
        }
		
        // Free memory
        freeifaddrs(interfaces);
    }
	
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

NSString *MINDeviceMacAddress(void) {
	
	static NSString *result = nil;
	
	if ( result == nil ) {
		
		result = @"";
		
		int mib[6];
		
		size_t len;
		
		char *buf = NULL;
		
		unsigned char *ptr = NULL;
		
		struct if_msghdr *ifm;
		struct sockaddr_dl *sdl;
		
		mib[0] = CTL_NET;
		mib[1] = AF_ROUTE;
		mib[2] = 0;
		mib[3] = AF_LINK;
		mib[4] = NET_RT_IFLIST;
		mib[5] = if_nametoindex("en0");
		
		if(mib[5] == 0) {
			//printf("Error: if_nametoindex error\n");
			return result;
		}
		
		if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
			//printf("Error: sysctl, take 1\n");
			return result;
		}
		
		buf = malloc(len);
		
		if(buf == NULL) {
			//printf("Could not allocate memory. error!\n");
			return result;
		}
		
		if(sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
			
			//printf("Error: sysctl, take 2");
			
			free(buf);
			
			return result;
		}
		
		ifm = (struct if_msghdr *)buf;
		sdl = (struct sockaddr_dl *)(ifm + 1);
		ptr = (unsigned char *)LLADDR(sdl);
		
		result = [NSString stringWithFormat: @"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];

		free(buf);
	}
	
	return result;
}

BOOL MINDeviceJailbroken(void) {

#if TARGET_IPHONE_SIMULATOR
	
	return NO;
#else
	
	static BOOL isSet = NO;
	static BOOL isJailbroken;

	if ( !isSet ) {
		isJailbroken = [[NSFileManager defaultManager] fileExistsAtPath: @"/bin/bash"];
		isSet = YES;
	}
		
	return isJailbroken;
#endif
}


BOOL MINIsPad(void) {
	
	static BOOL isSet = NO;
	static BOOL isPad;
	if ( ! isSet ) {
		isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
		isSet = YES;
	}
	return isPad;
}


BOOL MINIsRetina(void) {

	static BOOL isSet = NO;
	static BOOL isRetina;
	if ( ! isSet ) {
		isRetina = [UIScreen mainScreen].scale == 2.0f;
		isSet = YES;
	}
	return isRetina;
}

BOOL MINIsTallScreen(void) {
	
	static BOOL isTallSet = NO;
	static BOOL isTall;
	if ( ! isTallSet ) {
		isTall = [UIScreen mainScreen].bounds.size.height == 568 && !MINIsPad();
		isTallSet = YES;
	}
	return isTall;
}
