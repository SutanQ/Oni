using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Damegeable : MonoBehaviour
{
    public Status status;
    public AudioClip damageClip;
    public AudioClip walkClip;
    public AudioClip jumpClip;
    public event System.Action OnDeath;
    public event System.Action OnDamege;
    //protected bool canMove = true;

    protected Animator anim;
    protected Rigidbody rb;
    protected CharacterController characterController;
    protected float gravityY;
    public float drag = 0.5f;
    public Vector3 addForceVity;
    //    Coroutine coroutine;
    bool doTimer = false;
    float takeInvincibleTimer;
    public bool makeGroundImpact = false;

    [Header("Hit Materials")]
    public bool UseHitMaterial = false;
    public Renderer hitRenderer;
    public Transform hitTransform;
    public Material hitMaterial;
    
    Coroutine hitCoroutine;
    protected float UI_Timer;
    protected bool isGrounded = false;

    public void SetCanMove(int _b)
    {
        status.canMove = (_b == 1) ? true : false;
    }

    public bool GetCanMove()
    {
        return status.canMove;
    }

    public void DeadDestroy()
    {
        Destroy(gameObject);
    }

    protected virtual void Start()
    {
        anim = GetComponent<Animator>();
        rb = GetComponent<Rigidbody>();
        characterController = GetComponent<CharacterController>();

        if (UseHitMaterial)
        {
            if (hitRenderer != null)
            {
                hitMaterial = hitRenderer.material;
                hitTransform = hitRenderer.transform;
                if (hitMaterial == null)
                    UseHitMaterial = false;
            }
            else
                UseHitMaterial = false;
        }
    }

    /*
    IEnumerator InvincibleTime(float _time)
    {
        status.canTakeDamage = false;
        yield return new WaitForSeconds(_time);
        status.canTakeDamage = true;
    }
    */

    public virtual void SetForce(Vector3 f)
    {
        gravityY = f.y;
        addForceVity.x = f.x;
        addForceVity.z = f.z;

        //如果向下的衝擊超過-4.0f就會在著地時產生衝擊波
        if (f.y <= GameManager.Instance.GroundImpact_ForceTrashold && !isGrounded)
        {
            makeGroundImpact = true;
            Instantiate(GameManager.Instance.VFX_ImpactHitPrefab, transform.position, Quaternion.identity);
        }
    }

    public virtual void TakeDamege(int dmg, DamageType damageType, Vector3 force, bool takeDamageTrigger, bool takeInvincibleTime = true)
    {
        if (status.isDead) return;

        UI_Timer = Time.time + GameManager.Instance.UI_HP_Time;

        if (doTimer && Time.time >= takeInvincibleTimer)
        {
            doTimer = false;
            status.canTakeDamage = true;
        }

        if (status.canTakeDamage == false) return;

        switch(damageType)
        {
            case DamageType.Physic:
                status.hp -= (dmg - status.def) >= 0 ? (dmg - status.def) : 0;
                break;
            case DamageType.Magic:
                status.hp -= (dmg - status.mdef) >= 0 ? (dmg - status.mdef) : 0;
                break;
            case DamageType.None:
                status.hp -= dmg;
                break;
        }

        if (!status.superArmor)
        {
            if (anim != null && takeDamageTrigger)
            {
                anim.SetTrigger(IDManager.damageTrigger_ID);
                anim.SetBool(IDManager.damage_ID, true);
            }
        }

        /*
        if (rb != null && force != Vector3.zero)
        {
            rb.AddForce(force);
        }
        */
        
        //外力
        if (force != Vector3.zero)
        {
            SetForce(force);
        }
        

        if (damageClip != null)
            AudioManager.instance.PlaySound(damageClip, transform.position);

        if (OnDamege != null)
            OnDamege();

        //Debug.Log(transform.name + " taken " + ((dmg - status.def) >= 0 ? (dmg - status.def) : 0) + " damege");
        if (status.hp <= 0)
            die();

        //無敵時間
        if(takeInvincibleTime)
        {
            doTimer = true;
            takeInvincibleTimer = Time.time + status.InvincibleTime;
            status.canTakeDamage = false;
        }
        //if (takeInvincibleTime)
        //    coroutine = StartCoroutine(InvincibleTime(status.InvincibleTime));
    }

    protected void UpdateHitMaterial()
    {
        if (UseHitMaterial)
        {
            float hitStrength = hitMaterial.GetFloat(IDManager.hitStrengthID);
            hitStrength = Mathf.Clamp(hitStrength - 0.08f * Time.deltaTime, 0.0f, 10.0f);
            hitMaterial.SetFloat(IDManager.hitStrengthID, hitStrength);
            
        }
    }

    protected virtual void die()
    {
        status.canTakeDamage = false;
        status.canMove = false;
        status.isDead = true;
        //if (coroutine != null)
        //    StopCoroutine(coroutine);

        if (anim != null)
        {
            anim.SetBool(IDManager.die_ID, true);
            anim.ResetTrigger(IDManager.damage_ID);
            //anim.SetTrigger("die");
        }

        if (OnDeath != null)
            OnDeath();
        Destroy(gameObject, status.deadTime);
    }

    public void SetCanBeTakeDamage(int _b)
    {
        status.canTakeDamage = (_b == 1) ? true : false;
    }

    public void PlayWalkSound()
    {
        if(walkClip != null)
            AudioManager.instance.PlaySound(walkClip, transform.position);
    }

    public void PlayJumpSound()
    {
        if (walkClip != null)
            AudioManager.instance.PlaySound(jumpClip, transform.position);
    }

    public void SetCanTakeDamage(bool b)
    {
        status.canTakeDamage = b;
    }

    public void PlayHitColorAmount(float duration)
    {
        if (!UseHitMaterial) return;

        if (hitCoroutine != null)
            StopCoroutine(hitCoroutine);
        StartCoroutine(DoHitColorAmount(duration));
    }

    IEnumerator DoHitColorAmount(float duration)
    {
        float t = 0;
        float durationBy2 = duration * 0.5f;
        hitMaterial.SetFloat(IDManager.hitColorAmountID, 0.0f);
        while(t < durationBy2)
        {
            hitMaterial.SetFloat(IDManager.hitColorAmountID, Mathf.Lerp(0.0f, 1.0f, t / durationBy2));
            t += Time.deltaTime;
            yield return null;
        }
        hitMaterial.SetFloat(IDManager.hitColorAmountID, 1.0f);
        t = 0;
        while (t < durationBy2)
        {
            hitMaterial.SetFloat(IDManager.hitColorAmountID, Mathf.Lerp(1.0f, 0.0f, t / durationBy2));
            t += Time.deltaTime;
            yield return null;
        }
        hitMaterial.SetFloat(IDManager.hitColorAmountID, 0.0f);
    }

    public void UpdateAddForce()
    {
        float forceTranshold = 0.1f;

        //計算外力(受drag而逐漸歸零)
        int sign = addForceVity.x >= 0 ? 1 : -1;
        //addForceVity.x = (Mathf.Abs(addForceVity.x) - drag * Time.deltaTime);
        addForceVity.x = Mathf.Abs(addForceVity.x) * (1 - Time.deltaTime * drag);
        //if (addForceVity.x <= 0) addForceVity.x = 0;
        if (addForceVity.x <= forceTranshold) addForceVity.x = 0;
        else addForceVity.x *= sign;

        sign = addForceVity.z >= 0 ? 1 : -1;
        //addForceVity.z = (Mathf.Abs(addForceVity.z) - drag * Time.deltaTime);
        addForceVity.z = Mathf.Abs(addForceVity.z) * (1 - Time.deltaTime * drag);
        //if (addForceVity.z <= 0) addForceVity.z = 0;
        if (addForceVity.z <= forceTranshold) addForceVity.z = 0;
        else addForceVity.z *= sign;
    }

    public virtual void AnimatorAction()
    {
        ;
    }
}

[System.Serializable]
public class Status
{
    public int hp = 1;
    public int maxHp = 10;
    public int atk = 1;
    public int matk = 0;
    public int def = 0;
    public int mdef = 0;
    public int exp = 0;
    public bool canTakeDamage = true;    //是否會受到攻擊
    public float InvincibleTime = 0.5f;  //無敵持續時間
    public float deadTime = 4.0f;        //死掉到消失的間隔時間
    public bool superArmor = false;      //霸體
    public bool canMove = true;
    public bool isDead = false;
}

