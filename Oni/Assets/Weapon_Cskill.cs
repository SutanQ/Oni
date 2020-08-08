using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon_Cskill : MonoBehaviour
{
    public System.Action<float, int, int> OnActionEnd;

    protected Vector3 centerPos;
    protected float fadeOut_t;
    protected int fadeOut_attackIndex;
    protected int fadeOut_secondIndex;

    public void PlayAction(ActionIndex actionIndex, float duration, float t, int _attackIndex, int _secondIndex, Vector3 _centerPos)
    {
        centerPos = _centerPos;
        fadeOut_t = t;
        fadeOut_attackIndex = _attackIndex;
        fadeOut_secondIndex = _secondIndex;

        switch(actionIndex)
        {
            case ActionIndex.None: return;
            case ActionIndex.C1: StartCoroutine(ActionC1(duration)); break;
            case ActionIndex.C2: StartCoroutine(ActionC2(duration)); break;
            case ActionIndex.C3: StartCoroutine(ActionC3(duration)); break;
            case ActionIndex.J1: StartCoroutine(ActionJ1(duration)); break;
            case ActionIndex.LockAtk1: StartCoroutine(ActionLock1(duration)); break;
        }
        /*
        if (actionIndex == ActionIndex.None)
            return;

        if (actionIndex == ActionIndex.C1)
            StartCoroutine(ActionC1(duration));

        if (actionIndex == ActionIndex.C2)
            StartCoroutine(ActionC2(duration));

        if (actionIndex == ActionIndex.C3)
            StartCoroutine(ActionC3(duration));

        if(actionIndex == ActionIndex.J1)
            StartCoroutine(ActionJ1(duration));
            */
    }

    protected virtual IEnumerator ActionC1(float t)
    {
        float tt = 0;
        transform.SetParent(null);
        while (tt < t)
        {
            transform.position += transform.forward * 2.0f * Time.deltaTime;
            tt += Time.deltaTime;
            yield return null;
        }

        if (OnActionEnd != null)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }
    }

    protected virtual IEnumerator ActionC2(float t)
    {
        float tt = 0;
        transform.SetParent(null);
        while (tt < t)
        {
            transform.position += transform.forward * 2.0f * Time.deltaTime;
            tt += Time.deltaTime;
            yield return null;
        }

        if (OnActionEnd != null)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }
    }

    protected virtual IEnumerator ActionC3(float t)
    {
        float tt = 0;
        transform.SetParent(null);
        while (tt < t)
        {
            transform.position += transform.forward * 2.0f * Time.deltaTime;
            tt += Time.deltaTime;
            yield return null;
        }

        if (OnActionEnd != null)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }
    }

    protected virtual IEnumerator ActionJ1(float t)
    {
        float tt = 0;
        transform.SetParent(null);
        while (tt < t)
        {
            transform.position += transform.forward * 2.0f * Time.deltaTime;
            tt += Time.deltaTime;
            yield return null;
        }

        if (OnActionEnd != null)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }
    }

    protected virtual IEnumerator ActionLock1(float t)
    {
        float tt = 0;
        transform.SetParent(null);
        while (tt < t)
        {
            transform.position += transform.forward * 2.0f * Time.deltaTime;
            tt += Time.deltaTime;
            yield return null;
        }

        if (OnActionEnd != null)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }
    }

}

public enum ActionIndex { C1, C2, C3, J1, LockAtk1, None};