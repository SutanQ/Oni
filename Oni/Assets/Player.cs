using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : Damegeable
{
    ThirdPersonMovement thirdPerson;

    protected override void Start()
    {
        base.Start();
        thirdPerson = GetComponent<ThirdPersonMovement>();
    }

    public override void SetForce(Vector3 f)
    {
        thirdPerson.SetVelocity(Vector3.up * f.y);
        addForceVity.x += f.x;
        addForceVity.z += f.z;
    }
}
