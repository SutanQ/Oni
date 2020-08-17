using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation : MonoBehaviour
{
    public float rotationSpeed = 50.0f;
    public float autoRotationSpeed = 50.0f;
    public bool auto = false;

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKey(KeyCode.A))
        {
            transform.eulerAngles += Vector3.up * rotationSpeed * Time.deltaTime;
        }

        if (Input.GetKey(KeyCode.D))
        {
            transform.eulerAngles -= Vector3.up * rotationSpeed * Time.deltaTime;
        }

        if(Input.GetKeyDown(KeyCode.Space))
        {
            auto = !auto;
        }

        if(auto == true)
        {
            transform.eulerAngles += Vector3.up * autoRotationSpeed * Time.deltaTime;
        }
    }
}
