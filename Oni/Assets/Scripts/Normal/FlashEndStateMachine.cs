using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlashEndStateMachine : StateMachineBehaviour
{
    FlashCollider flashCollider;
    ThirdPersonMovement thirdPerson;

    public int weaponIndex = 11;
    public float fadeIn = 0.05f;
    public float fadeOut = 0.15f;

    bool done = false;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        thirdPerson = animator.GetComponent<ThirdPersonMovement>();
        flashCollider = animator.GetComponentInChildren<FlashCollider>();
        flashCollider.CancelLock();
        animator.SetBool(IDManager.Flashing_ID, false);

        thirdPerson.SetPlayerCanMove(false);
        thirdPerson.Weapon_FadeIn(fadeIn, weaponIndex, 0);
        thirdPerson.SetWeaponCollider(false, weaponIndex, 0);

        GameManager.Instance.StopTimeScaleCoroutine();
        GameManager.Instance.SetTimeScale(Time.timeScale, 1.0f, stateInfo.length, false);

        done = false;
        if(FlashManager.Instance.DoFlashTimeline)
        {
            done = true;
            flashCollider.EndFlash();
            //thirdPerson.Weapon_FadeOut(fadeOut, weaponIndex, 0);
            //thirdPerson.SetPlayerCanMove(true);
        }
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    //override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (!done)
        {
            flashCollider.EndFlash();
            thirdPerson.Weapon_FadeOut(fadeOut, weaponIndex, 0);
            thirdPerson.SetPlayerCanMove(true);
        }
        //Time.timeScale = 1.0f;
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
