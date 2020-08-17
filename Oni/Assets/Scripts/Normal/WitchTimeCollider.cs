using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WitchTimeCollider : MonoBehaviour
{
    public float StartTimeScale = 0.2f;
    public float EndTimeScale = 1.0f;
    public float duration = 1.0f;

    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Damage") && !GameManager.Instance.inWitchTime)
        {
            GameManager.Instance.SetTimeScale(StartTimeScale, EndTimeScale, duration, true);
        }
    }
}
