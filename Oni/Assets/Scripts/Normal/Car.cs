using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Car : MonoBehaviour
{
    public Wheel[] wheels;
    public float maxSteerAngle = 20.0f;
    public float toque = 30;

    Vector3 wPos;
    Quaternion wRot;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        for(int i = 0; i < wheels.Length; i++)
        {
            wheels[i].wheelCollider.GetWorldPose(out wPos, out wRot);
            wheels[i].trans.position = wPos;
            wheels[i].trans.rotation = wRot;
        }
    }

    private void FixedUpdate()
    {
        for(int i = 0; i < wheels.Length; i++)
        {
            if(wheels[i].steer)
            {
                wheels[i].wheelCollider.steerAngle = Input.GetAxis("Horizontal") * maxSteerAngle;
            }

            if(wheels[i].power)
            {
                wheels[i].wheelCollider.motorTorque = Input.GetAxis("Vertical") * toque;
            }
        }
    }

    [System.Serializable]
    public class Wheel
    {
        public bool steer;
        public bool power;
        public Transform trans;
        public WheelCollider wheelCollider;
    }
}
