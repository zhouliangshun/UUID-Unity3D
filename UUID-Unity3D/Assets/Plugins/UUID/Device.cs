using UnityEngine;
using System.Collections;

public class Device
{

	public static string UUID
	{
		get{
# if  UNITY_EDITOR
			return SystemInfo.deviceUniqueIdentifier;

#elif UNITY_IPHONE
			return IOSUUID.GetDeviceUUID();
#else
			return SystemInfo.deviceUniqueIdentifier;
#endif

		}
	}
		
}

