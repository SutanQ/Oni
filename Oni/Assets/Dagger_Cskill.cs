using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dagger_Cskill : Weapon_Cskill
{
    public Transform holder;
    Damegeable holderStatus;

    [Header("C1")]
    public bool useDestroyTime = false;
    public float destroyTime = 1.0f;
    public GameObject particlePrefab;
    public Vector3 offsetPos;
    public Vector3 Rotation;

    [Header("C2")]
    public float rotationSpeed = 540.0f;
    public float r_speed = 1.75f;
    public float selfRotationSpeed = 1800.0f;
    public ParticleSystem[] C2_particleSystems;

    [Header("C3")]
    public bool useDestroyTime3 = false;
    public float destroyTime3 = 1.0f;
    public GameObject particlePrefab3;
    public Vector3 offsetPos3;
    public Vector3 Rotation3;

    [Header("J1")]
    public bool useDestroyTimeJ1 = false;
    public float destroyTimeJ1 = 1.0f;
    public GameObject particlePrefabJ1;
    public Vector3 offsetPosJ1;
    public Vector3 RotationJ1;

    private void Start()
    {
        holderStatus = holder.GetComponent<Damegeable>();
    }

    protected override IEnumerator ActionC1(float t)
    {
        //float tt = 0;
        //transform.SetParent(null);
        //Vector3 dir = (new Vector3(transform.position.x, 0, transform.position.z) - new Vector3(centerPos.x, 0, centerPos.z));
        //transform.rotation = Quaternion.LookRotation(dir, Vector3.up);

        GameObject g = Instantiate(particlePrefab, holder.position + holder.forward * offsetPos.z + holder.up * offsetPos.y, holder.rotation * Quaternion.Euler(Rotation));
        g.GetComponentInChildren<Damage>().status = holderStatus;
        if (useDestroyTime)
            Destroy(g, destroyTime);
        else
            Destroy(g, g.GetComponent<ParticleSystem>().main.duration);

        if (OnActionEnd != null)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }

        yield return null;
        /*
        if (fadeOut_t > t)
        {
            if (OnActionEnd != null)
            {
                actionEndDone = true;
                OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
            }
        }

        while (tt < t)
        {
            if(tt >= doEndTime && !actionEndDone)
            {
                actionEndDone = true;
                if (OnActionEnd != null)
                {
                    OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
                }
            }

            tt += Time.deltaTime;
            yield return null;
        }

        
        if (OnActionEnd != null && !actionEndDone)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }
        */
    }


    protected override IEnumerator ActionC2(float t)
    {
        bool actionEndDone = false;
        float doEndTime = t - fadeOut_t;

        for (int i = 0; i < C2_particleSystems.Length; i++)
            C2_particleSystems[i].Play();

        float tt = 0;
        transform.SetParent(null);
        Vector3 dir = (new Vector3(transform.position.x, 0, transform.position.z) - new Vector3(centerPos.x, 0, centerPos.z));
        transform.rotation = Quaternion.LookRotation(dir, Vector3.up);


        float angle = Mathf.Atan2(dir.z, dir.x) * 180 / Mathf.PI;
        float r = dir.sqrMagnitude;
        Vector3 newPos;


        if (fadeOut_t > t)
        {
            if (OnActionEnd != null)
            {
                actionEndDone = true;
                OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
            }
        }

        while (tt < t)
        {
            angle -= rotationSpeed * Time.deltaTime;
            r += r_speed * Time.deltaTime;
            newPos = new Vector3(Mathf.Cos(angle * Mathf.Deg2Rad), 0, Mathf.Sin(angle * Mathf.Deg2Rad)) * r + new Vector3(centerPos.x, transform.position.y, centerPos.z);
            transform.position = newPos;
            transform.Rotate(Vector3.up * selfRotationSpeed * Time.deltaTime);
            //transform.position += dir.normalized * 5.0f * Time.deltaTime;

            if (tt >= doEndTime && !actionEndDone)
            {
                actionEndDone = true;
                if (OnActionEnd != null)
                {
                    OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
                }
            }

            tt += Time.deltaTime;
            yield return null;
        }


        if (OnActionEnd != null && !actionEndDone)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }

    }

    protected override IEnumerator ActionC3(float t)
    {
        GameObject g = Instantiate(particlePrefab3, holder.position + holder.forward * offsetPos3.z + holder.up * offsetPos3.y, holder.rotation * Quaternion.Euler(Rotation3));
        g.GetComponentInChildren<Damage>().status = holderStatus;

        if (useDestroyTime3)
            Destroy(g, destroyTime3);
        else
            Destroy(g, g.GetComponent<ParticleSystem>().main.duration);

        if (OnActionEnd != null)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }

        yield return null;
    }

    protected override IEnumerator ActionJ1(float t)
    {
        GameObject g = Instantiate(particlePrefabJ1, holder.position + holder.forward * offsetPosJ1.z + holder.up * offsetPosJ1.y, holder.rotation * Quaternion.Euler(RotationJ1));
        g.GetComponentInChildren<Damage>().status = holderStatus;
        if (useDestroyTimeJ1)
            Destroy(g, destroyTimeJ1);
        else
            Destroy(g, g.GetComponent<ParticleSystem>().main.duration);

        if (OnActionEnd != null)
        {
            OnActionEnd(fadeOut_t, fadeOut_attackIndex, fadeOut_secondIndex);
        }

        yield return null;

    }
}
