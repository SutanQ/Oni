using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySlime : Enemy
{
    public void AngryFace()
    {
        ResetFaceTrigger();
        anim.SetTrigger("angryFace");
    }

    public void NormalFace()
    {
        ResetFaceTrigger();
        anim.SetTrigger("normalFace");
    }

    public void SmileFace()
    {
        ResetFaceTrigger();
        anim.SetTrigger("smileFace");
    }

    public void DamageFace()
    {
        ResetFaceTrigger();
        anim.SetTrigger("damageFace");
    }

    void ResetFaceTrigger()
    {
        anim.ResetTrigger(IDManager.angryFace_ID);
        anim.ResetTrigger(IDManager.normalFace_ID);
        anim.ResetTrigger(IDManager.smileFace_ID);
        anim.ResetTrigger(IDManager.damageFace_ID);
    }
}
