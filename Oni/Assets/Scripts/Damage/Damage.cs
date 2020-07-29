using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum DamageType { Physic, Magic, None };

public class Damage : MonoBehaviour
{
    public int damage = 1;
    public Damegeable status;
    public enum DamageTarget { Player, Enemy, All };
    public DamageType damageType;
    public DamageTarget damageTarget;
    public bool takeDamageTrigger = true;   //攻擊後是否會觸發受傷動作 (但目標若有霸體則一樣不會有受傷動作)
    public bool takeInvincibleTime = true;  //攻擊後是否讓敵人產生無敵時間 (True:會產生無敵時間，False:不會產生無敵時間)
    public Vector3 Force;
    public Transform forceCenter;

    public GameObject hitEffectPrefab;
    public GameObject endEffectPrefab;

    [Header("Hit Time Scale")]
    public bool useHitTimeScale = false;
    [Range(0.0f, 1.0f)]
    public float startHitTimeScale = 0.1f;
    public float hitTimeDuration = 0.1f;
    
    protected virtual void Start()
    {
        ParticleSystem ps = GetComponent<ParticleSystem>();
        if(ps != null)
        {
            ParticleSystem.CollisionModule collisionModule = ps.collision;
            switch (damageTarget)
            {
                case DamageTarget.Player:
                    collisionModule.collidesWith = (1 << 9);
                    break;
                case DamageTarget.Enemy:
                    collisionModule.collidesWith = (1 << 10);
                    break;
                case DamageTarget.All:
                    collisionModule.collidesWith = (1 << 9 | 1 << 10);
                    break;
            }
        }
    }

    protected virtual void OnTriggerEnter(Collider other)
    {
        TakeDamage(other);
    }

    private void OnParticleCollision(GameObject other)
    {
        Collider collider = other.GetComponent<Collider>();
        if (collider != null)
            TakeDamage(collider);
    }

    protected virtual void TakeDamage(Collider collider)
    {
        if (!CheckDamageType(collider))
            return;

        CauseDamage(collider);
    }

    protected bool CheckDamageType(Collider collider)
    {
        switch (damageTarget)
        {
            case DamageTarget.Player:
                if (!collider.CompareTag("Player"))
                {
                    return false;
                }
                break;
            case DamageTarget.Enemy:
                if (!collider.CompareTag("Enemy"))
                {
                    return false;
                }
                break;
            case DamageTarget.All:
                if (!(collider.CompareTag("Player") || collider.CompareTag("Enemy")))
                {
                    return false;
                }
                break;
        }
        return true;
    }

    protected void CauseDamage(Collider collider)
    {
        Damegeable damegeable = collider.GetComponent<Damegeable>();

        if (damegeable == null)
            return;

        if (hitEffectPrefab != null)
            Instantiate(hitEffectPrefab, collider.ClosestPoint(transform.position), Quaternion.identity);

        int dmg = damage;
        if (status != null)
        {
            switch (damageType)
            {
                case DamageType.Physic:
                    dmg += status.status.atk; break;
                case DamageType.Magic:
                    dmg += status.status.matk; break;
            }
        }

        if (damegeable.UseHitMaterial)
        {
            Vector3 closestPoint = collider.ClosestPoint(transform.position);
            Vector3 objectPos = damegeable.hitTransform.worldToLocalMatrix.MultiplyPoint(closestPoint);

            damegeable.hitMaterial.SetVector(IDManager.hitPosID, new Vector4(objectPos.x, objectPos.y, objectPos.z, 0.0f)); //擊中的部位座標(object position)
            damegeable.hitMaterial.SetFloat(IDManager.hitStrengthID, 0.15f);  //擊中抖動的Strength
            damegeable.PlayHitColorAmount(0.8f);   //擊中發光的特效顯示時間
        }

        Vector3 dir;
        if (forceCenter)
            dir = collider.transform.position - forceCenter.position;
        else
            dir = collider.transform.position - transform.position;
        dir.y = 0;
        dir = dir.normalized;

        damegeable.TakeDamege(dmg, damageType, new Vector3(dir.x * Force.z, Force.y, dir.z * Force.z), takeDamageTrigger, takeInvincibleTime);
        //CameraShakeManager.Instance.AddCameraShake(dmg * 1.0f);

        if(useHitTimeScale)
            GameManager.Instance.DoHitTimeScale(startHitTimeScale, hitTimeDuration);
    }
}
