using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RippleCamera : MonoBehaviour
{
    [SerializeField]
    RenderTexture rt;

    [SerializeField]
    Transform targetWaterPlane;


    private void Awake()
    {
        Shader.SetGlobalTexture("_GlobalRippleRT", rt);
        Shader.SetGlobalFloat("_OrthographicCamSize", GetComponent<Camera>().orthographicSize);
    }


    // Update is called once per frame
    void Update()
    {
        transform.position = targetWaterPlane.position + Vector3.up * 0.5f;
        Shader.SetGlobalVector("_WaterCenterPosition", targetWaterPlane.position);
    }
}
