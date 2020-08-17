using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Stairs : MonoBehaviour
{
    ThirdPersonMovement thirdPerson;
    public ClimbState climbState;

    private void OnTriggerEnter(Collider other)
    {
        thirdPerson = other.GetComponentInParent<ThirdPersonMovement>();
        thirdPerson.SetClimbPos(true, climbState, transform);
    }

    private void OnTriggerExit(Collider other)
    {
        if (thirdPerson != null)
        {
            thirdPerson.SetClimbPos(false, ClimbState.None, transform);
            thirdPerson = null;
        }
    }
}
