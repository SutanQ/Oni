using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySlime : Enemy
{
    public void AngryFace()
    {
        anim.SetTrigger("angryFace");
    }

    public void NormalFace()
    {
        anim.SetTrigger("normalFace");
    }

    public void SmileFace()
    {
        anim.SetTrigger("smileFace");
    }

    public void DamageFace()
    {
        anim.SetTrigger("damageFace");
    }
}
