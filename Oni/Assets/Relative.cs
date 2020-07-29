using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Relative : MonoBehaviour
{
    public Transform target;

    public Transform relativeO;
    public Transform relativeTarget;

    // Start is called before the first frame update
    void Start()
    {
        Debug.Log(transform.localToWorldMatrix);
        Debug.Log(target.worldToLocalMatrix * transform.localToWorldMatrix);
        Debug.Log(relativeTarget.localToWorldMatrix * target.worldToLocalMatrix * transform.localToWorldMatrix);
    }

    // Update is called once per frame
    void Update()
    {
        Matrix4x4 m = relativeTarget.localToWorldMatrix * target.worldToLocalMatrix * transform.localToWorldMatrix;
        relativeO.SetPositionAndRotation(m.GetColumn(3), m.rotation);
    }
}
