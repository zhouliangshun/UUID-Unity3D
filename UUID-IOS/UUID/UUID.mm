//
//  UUID.m
//  UUID
//
//  Created by liangshun zhou on 11/19/13.
//  Copyright (c) 2013 MT. All rights reserved.
//

#include "UUID.h"

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>


@implementation NSString(MD5Addition)


- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}


@end


Bytes string_str_bytes(String str)
{
    int length = strlen(str);
    Bytes bytes = malloc(length+1);
    memset((void *)bytes, '\0', length+1);
    memcpy((void *)bytes, (const void *)str,length);
    return bytes;
}

String new_uuid()
{
    
    CFUUIDRef udid = CFUUIDCreate(NULL);
    NSString *udidString = (__bridge NSString *) CFUUIDCreateString(NULL, udid);
    
  /*  NSString *_uuid = nil;
    
    _uuid =[[NSUUID UUID] UUIDString];
    
    char* uuid = (char *)malloc(_uuid.length);
    
    [_uuid getCString:uuid maxLength:_uuid.length encoding:NSASCIIStringEncoding];*/
    
    return CSTR(udidString);
}

String DeviceUUID()
{
    if([[UIDevice currentDevice].systemVersion floatValue]<5.0)
    {
        //return [UU]
        
        UIDevice *device = [UIDevice currentDevice];
        if([device respondsToSelector:@selector(uniqueIdentifier)])
        {
            return CSTRU([device performSelector:@selector(uniqueIdentifier)]);
        }
        
    }else if([[UIDevice currentDevice].systemVersion floatValue]<7.0)
    {
        return CSTRU([[UUID getMacAddress] stringFromMD5]);
    }
    
    if(HasUUID(CSTR(@"com.mdnt.api.open.uid")))
        return GetUUID(CSTR(@"com.mdnt.api.open.uid"));
    
    String uuid = new_uuid();
    SaveUUID(uuid, CSTR(@"com.mdnt.api.open.uid"));
    return CSTRU([NSString stringWithCString:uuid encoding:NSASCIIStringEncoding]);
}

Bytes BytesDeviceUUID()
{
    if([[UIDevice currentDevice].systemVersion floatValue]<5.0)
    {
        //return [UU]
        
        UIDevice *device = [UIDevice currentDevice];
        if([device respondsToSelector:@selector(uniqueIdentifier)])
        {
            return string_str_bytes(CSTR(([device performSelector:@selector(uniqueIdentifier)])));
        }
        
    }else if([[UIDevice currentDevice].systemVersion floatValue]<7.0)
    {
        return string_str_bytes(CSTR([[UUID getMacAddress] stringFromMD5]));
    }
    
    if(HasUUID(CSTR(@"com.mdnt.api.open.uid")))
        return string_str_bytes(GetUUID(CSTR(@"com.mdnt.api.open.uid")));
    
    String uuid = new_uuid();
    SaveUUID(CSTR(@"com.mdnt.api.open.uid"),uuid);
    return string_str_bytes(uuid);
}

bool  HasUUID(String key)
{
    
    CFTypeRef ref;
    
    NSString *_key = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [query setObject:_key forKey:(__bridge id)kSecAttrApplicationTag];
    [query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query,&ref);
    
    if(status==errSecSuccess)
    {
       // NSLog(@"%@", (__bridge id)ref);
        
        return true;
    }
    
    return false;
}

String GetUUID(String key)
{
    
    CFTypeRef ref;
    
    NSString *_key = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [query setObject:_key forKey:(__bridge id)kSecAttrApplicationTag];
    [query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnData];
    
   OSStatus status =  SecItemCopyMatching((__bridge CFDictionaryRef)query,&ref);
    
    if(status==errSecSuccess)
    {
        NSString *objStr =[NSString stringWithCString:(String)((__bridge NSData *)ref).bytes encoding:NSASCIIStringEncoding];
        
        return CSTRU(objStr);
    }
    
    
    return  nil;
}

Bytes BytesGetUUID(String key)
{
    
    CFTypeRef ref;
    
    NSString *_key = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [query setObject:_key forKey:(__bridge id)kSecAttrApplicationTag];
    [query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnData];
    
    OSStatus status =  SecItemCopyMatching((__bridge CFDictionaryRef)query,&ref);
    
    if(status==errSecSuccess)
    {
        NSString *objStr =[NSString stringWithCString:(String)((__bridge NSData *)ref).bytes encoding:NSASCIIStringEncoding];
        
        return string_str_bytes(CSTR((objStr)));
    }
    
    
    return  nil;
}


void SaveUUID(String key,String uuid)
{
    NSString *_key = [NSString stringWithCString:key encoding:NSASCIIStringEncoding];
    NSString *_uuid = [NSString stringWithCString:uuid encoding:NSASCIIStringEncoding];
    
    NSData *uuidData = [_uuid dataUsingEncoding:NSASCIIStringEncoding];
    
    char bytes[36];
    memset(&bytes, 0, 36);
    memcpy(&bytes, uuidData.bytes,uuidData.length);
    
    CFTypeRef ref;
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [query setObject:_key forKey:(__bridge id)kSecAttrApplicationTag];
    [query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    [query setObject:[NSData dataWithBytes:&bytes length:32] forKey:(__bridge id)kSecValueData];
    
     OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, &ref);
    
    if(status !=errSecSuccess)
    {
        NSLog(@"can't add uuid to keychain status:%ld",status);
    }
}



@implementation UUID

+(NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    NSString            *errorFlag = NULL;
    size_t              length;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        errorFlag = @"sysctl mgmtInfoBase failure";
    // Alloc memory based on above call
    else if ((msgBuffer = (char *)malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
    {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    else
    {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        if(IsDEBUG) NSLog(@"Mac Address: %@", macAddressString);
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    
    // Error...
    if(IsDEBUG) NSLog(@"Error: %@", errorFlag);
    
    return errorFlag;
}

@end
