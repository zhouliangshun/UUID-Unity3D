1.You must to add Security.framework to your  this unity3d export iOS project Frameworks.
2.if can't build. just trying remove libIOSUUID.a from Frameworks with iOS project and Add souce files(socue file is UUID.m in Souces.zip) to Frameworks.
3.if you want to cole monodevlop unsafe error,plz checkable “Allow ‘unsafe’ code”(Project Options/Build->General).
4.Device.UUID int iOS5.0 or lower is uniqueIdentifier 、5.0-6.0 is MAC Address and 7.0 or Higher is custome uuid(uuid key is “com.mdnt.api.open.uid”).