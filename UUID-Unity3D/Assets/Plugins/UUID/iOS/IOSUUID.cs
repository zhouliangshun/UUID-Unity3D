#if UNITY_IPHONE

using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;

public static class IOSUUID {
	
	[DllImport("__Internal",CharSet=CharSet.Ansi)]
	public static extern void SaveUUID(string uuid,string key);

	[DllImport("__Internal",CharSet=CharSet.Ansi)]
	public static extern bool HasUUID (string key);

	[DllImport("__Internal")]
	public static extern string GetUUID (string key);
	
	[DllImport("__Internal")]
	public static extern string DeviceUUID ();
	
	[DllImport("__Internal")]
	private unsafe static extern byte* BytesDeviceUUID();
	public unsafe static string GetDeviceUUID()
	{
		byte * p = BytesDeviceUUID ();
		
		return IOSUUID.GetStringFromCStrP (p);

	}

	[DllImport("__Internal")]
	private unsafe static extern byte* BytesGetUUID (string key);

	public unsafe static string GetUUIDBFromBytes(string key)
	{

		byte* p = BytesGetUUID (key);
		return IOSUUID.GetStringFromCStrP (p);
			
	}

	public unsafe static string GetStringFromCStrP(byte *p)
	{
		byte b = 0;
		int length = 0;
		byte[] bytes = new byte[64];
		while ((b=*p)!='\0') 
		{
			if(length>=bytes.Length)
			{
				byte[] newbytes = new byte[length<<2];
				System.Array.Copy(bytes,newbytes,bytes.Length);
				bytes = newbytes;
			}
			bytes[length++] = b;
			p++;
		}

		return System.Text.ASCIIEncoding.ASCII.GetString (bytes,0,length);
	}


}

#endif