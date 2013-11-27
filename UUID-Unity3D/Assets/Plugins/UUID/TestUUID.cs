using UnityEngine;
using System.Collections;

public class TestUUID : MonoBehaviour {

	// Use this for initialization
	void Start () {
		//Debug.Log(Device.UUID);


	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnGUI()
	{
		if(GUI.Button(new Rect((Screen.width-100)/2,(Screen.height-50)/2,100,50),"Test"))
		{

			Debug.Log(Device.UUID);

			#if UNITY_IPHONE
			if(IOSUUID.HasUUID("com.whween.uuid"))
			{
				Debug.Log("has uuid:"+IOSUUID.GetUUIDBFromBytes("com.whween.uuid"));
			}else 
			{
				//550e8400-e29b-41d4-a716-446655440000
				IOSUUID.SaveUUID("com.whween.uuid",System.Guid.NewGuid().ToString());
				
				Debug.Log("new uuid:"+IOSUUID.GetUUIDBFromBytes("com.whween.uuid"));
			}
			#endif
		}
	}
}
