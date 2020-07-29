using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageDot : Damage
{
    public enum DotType { TypeA, TypeB};
    [Header("Dot")]
    public DotType dotType;
    [Header("TypeA")]
    public float DOTintervalTime = 1.0f;

    [Header("TypeB")]
    public int DotTimes = 1;
    public float DotDuration = 1.0f;

    private float intervalTime;
    private Dictionary<Collider, float> table = new Dictionary<Collider, float>();

    private void OnTriggerStay(Collider other)
    {
        float timer;
        if (!table.TryGetValue(other, out timer)) return;

        if (Time.time >= timer)
        {
            TakeDamage(other);
            table[other] = Time.time + intervalTime;
        }
    }

    protected override void OnTriggerEnter(Collider other)
    {
        if (!CheckDamageType(other))
            return;

        if(!table.ContainsKey(other))
        {
            table.Add(other, Time.time + intervalTime);
            TakeDamage(other);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (!CheckDamageType(other))
            return;

        if (table.ContainsKey(other))
        {
            table.Remove(other);
        }
    }

    protected override void TakeDamage(Collider collider)
    {
        CauseDamage(collider);
    }

    protected override void Start()
    {
        switch(dotType)
        {
            case DotType.TypeA: intervalTime = DOTintervalTime; break;
            case DotType.TypeB: intervalTime = DotDuration / (float)DotTimes; break;
        }
    }
}
