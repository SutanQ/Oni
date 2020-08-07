using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IDManager
{
    //Animator ID
    public static int H_ID = Animator.StringToHash("H");
    public static int V_ID = Animator.StringToHash("V");
    public static int Lock_ID = Animator.StringToHash("Lock");
    public static int Speed_ID = Animator.StringToHash("Speed");
    public static int XSpeed_ID = Animator.StringToHash("XSpeed");
    public static int Ground_ID = Animator.StringToHash("Ground");
    public static int LeftHandGrip_ID = Animator.StringToHash("LeftHandGrip");
    public static int RightHandGrip_ID = Animator.StringToHash("RightHandGrip");
    public static int dodgeSide_ID = Animator.StringToHash("dodgeSide");
    public static int dodgeBack_ID = Animator.StringToHash("dodgeBack");
    public static int dodgeForward_ID = Animator.StringToHash("dodgeForward");
    public static int damage_ID = Animator.StringToHash("damage");
    public static int damageTrigger_ID = Animator.StringToHash("damageTrigger");
    public static int die_ID = Animator.StringToHash("die");
    public static int Jump_ID = Animator.StringToHash("Jump");
    public static int Climb_ID = Animator.StringToHash("climb");
    public static int ClimbUp_ID = Animator.StringToHash("climbUp");
    public static int ClimbDown_ID = Animator.StringToHash("climbDown");
    public static int Cskill_ID = Animator.StringToHash("Cskill");
    public static int Attack_ID = Animator.StringToHash("Attack");
    public static int Attacking_ID = Animator.StringToHash("Attacking");

    //Shader ID
    public static int Forward_ID = Shader.PropertyToID("_Forward");
    public static int PosAmount_ID = Shader.PropertyToID("_PosAmount");
    public static int hitStrengthID = Shader.PropertyToID("_HitStrength");
    public static int hitPosID = Shader.PropertyToID("_HitPos");
    public static int hitColorAmountID = Shader.PropertyToID("_HitColorAmount");
    public static int hitColorID = Shader.PropertyToID("_HitColor");
}
