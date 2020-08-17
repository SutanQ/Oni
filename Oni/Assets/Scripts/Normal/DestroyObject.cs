using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyObject : MonoBehaviour
{
    public float DestroyTime = 0.0f;

    // Start is called before the first frame update
    void Start()
    {
        Destroy(gameObject, DestroyTime);
    }

}
