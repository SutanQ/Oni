using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraShakeSetting : MonoBehaviour
{
    public CameraShakeData[] cameraShakeDatas;

    // Start is called before the first frame update
    void Start()
    {
        for(int i = 0; i < cameraShakeDatas.Length; i++)
        {
            CameraShakeManager.Instance.AddCameraShakeDataList(Time.time + cameraShakeDatas[i]._shakeTime, cameraShakeDatas[i]._shakeStrength, cameraShakeDatas[i]._cameraImpulseIndex);
        }
        Destroy(this);
    }
}
