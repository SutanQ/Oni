using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Animations.Rigging;

public class EnemyNinja : Enemy
{
    RigBuilder rigBuilder;

    [Header("Air Attack")]
    public float airAttackHeight = 10.0f;
    public float airAttackGravity = 10.0f;

    [Header("Shuriken")]
    public GameObject shuriken_Prefab;
    public Transform shuriken_Pos;

    [Header("Blade")]
    public Transform blade;
    public Collider bladeCollider;
    public GameObject bladeParticle;
    public Transform bladeKeeper;
    public Transform weapon_blade;

    public void AirAttack()
    {
        if (hasTarget)
        {
            transform.position = playerGO.position + Vector3.up * airAttackHeight - playerGO.forward * 1.5f;
            Quaternion rotation = Quaternion.LookRotation(new Vector3(playerGO.position.x, 0, playerGO.position.z) - new Vector3(transform.position.x, 0, transform.position.z));
            transform.rotation = rotation;
            //transform.eulerAngles += Vector3.up * 180;

            anim.SetBool("Ground", false);
            StartCoroutine(GravityUp(airAttackGravity));
        }
    }

    IEnumerator GravityUp(float g)
    {
        //rb.velocity += -Vector3.up * g;
        gravityY += -g;
        while (!anim.GetBool("Ground"))
        {
            yield return null;
        }

        yield return null;
    }

    public void UseShuriken()
    {
        if (shuriken_Prefab && shuriken_Pos)
        {
            Instantiate(shuriken_Prefab, shuriken_Pos.position, shuriken_Pos.rotation);
        }
    }

    public void ChageBladeParent(int i)
    {
        if (i == 1)
        {
            blade.SetParent(weapon_blade);
            bladeCollider.enabled = true;
            bladeParticle.SetActive(true);
        }
        else
        {
            blade.SetParent(bladeKeeper);
            bladeCollider.enabled = false;
            bladeParticle.SetActive(false);
        }

        blade.localPosition = Vector3.zero;
        blade.localRotation = Quaternion.identity;
        blade.localScale = Vector3.one;
    }
}
