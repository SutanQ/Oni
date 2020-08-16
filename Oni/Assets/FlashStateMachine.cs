using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlashStateMachine : StateMachineBehaviour
{
    [Range(0.0f, 1.0f)]
    public float flash_min = 0.3f;
    [Range(0.0f, 1.0f)]
    public float flash_max = 0.8f;

    public int weaponIndex = 1;
    public float fadeIn = 0.15f;
    public float fadeOut = 0.25f;

    bool flashDone = false;
    float timeScaleCount;
    ThirdPersonMovement thirdPerson;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        thirdPerson = animator.GetComponent<ThirdPersonMovement>();
        animator.SetInteger(IDManager.Cskill_ID, 0);
        animator.SetBool(IDManager.Flashing_ID, false);
        flashDone = false;
        GameManager.Instance.StopTimeScaleCoroutine();
        timeScaleCount = Mathf.Pow(FlashManager.Instance.timeScaleBaseMagnification, FlashManager.Instance.FlashCount);
        GameManager.Instance.SetTimeScale(FlashManager.Instance.startScale * timeScaleCount, FlashManager.Instance.endScale * timeScaleCount, stateInfo.length, false);

        thirdPerson.Weapon_FadeIn(fadeIn / timeScaleCount, weaponIndex, 0);
        thirdPerson.SetWeaponCollider(false, weaponIndex, 0);
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if(!flashDone)
        {
            if(animator.GetInteger(IDManager.Cskill_ID) > 0)
            {
                //Flash成功
                if (animator.GetInteger(IDManager.Cskill_ID) == 1 && stateInfo.normalizedTime >= flash_min && stateInfo.normalizedTime <= flash_max)
                {
                    animator.SetBool(IDManager.Flashing_ID, true);
                    FlashCollider flashCollider = animator.GetComponentInChildren<FlashCollider>();
                    flashCollider.DoFlash();
                }

                flashDone = true;
            }
        }

        if(stateInfo.normalizedTime >= 1.0f && !animator.GetBool(IDManager.Flashing_ID))
            animator.SetTrigger(IDManager.FlashEndTrigger_ID);
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        thirdPerson.Weapon_FadeOut(fadeOut / timeScaleCount, weaponIndex, 0);
    }

    // OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that processes and affects root motion
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
