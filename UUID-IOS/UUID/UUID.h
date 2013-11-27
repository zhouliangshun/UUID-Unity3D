//
//  UUID.h
//  UUID
//
//  Created by liangshun zhou on 11/19/13.
//  Copyright (c) 2013 MT. All rights reserved.
//

#ifndef String
#define String const char*
#endif

#ifndef CSTR
#define CSTR(str) (String)[str cStringUsingEncoding:NSASCIIStringEncoding]
#endif

#ifndef CSTRU
#define CSTRU(str) (String)[str cStringUsingEncoding:NSUTF8StringEncoding]
#endif

#ifndef Bytes
#define Bytes const void*
#endif

#ifndef StringToBytes
#define StringToBytes(str) [str dataUsingEncoding:NSASCIIStringEncoding].bytes
#endif





#ifndef _UUID_
#define _UUID_
#define IsDEBUG 0

#pragma GCC visibility push(default)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern "C"
{

    Bytes  BytesDeviceUUID();
    Bytes  BytesGetUUID(String key);
    String DeviceUUID();
    String GetUUID(String key);
    bool   HasUUID(String key);
    void   SaveUUID(String key,String uuid);
}


@interface UIDevice (uniqueIdentifier)

-(NSString *)uniqueIdentifier;

@end

@interface UUID : NSObject

+(NSString *)getMacAddress;

@end

#endif
