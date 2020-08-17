using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraShake : MonoBehaviour
{
    public float ShakeStrength = 1.0f;
    public CameraImpulseIndex cameraImpulseIndex;

    // Start is called before the first frame update
    void Start()
    {
        CameraShakeManager.Instance.AddCameraShake(ShakeStrength, cameraImpulseIndex);
    }
}
