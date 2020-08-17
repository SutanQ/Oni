using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetStateMachine : StateMachineBehaviour
{
    public bool resetCskill = false;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.SetInteger(IDManager.Attack_ID, 0);
        if(resetCskill)
            animator.SetInteger(IDManager.Cskill_ID, 0);
        animator.SetBool(IDManager.damage_ID, false);
        animator.ResetTrigger(IDManager.dodgeForward_ID);
        animator.ResetTrigger(IDManager.dodgeBack_ID);
        animator.ResetTrigger(IDManager.dodgeSide_ID);
        animator.SetBool(IDManager.Flashing_ID, false);
        animator.SetBool(IDManager.InFlash_ID, false);
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        if (resetCskill)
            animator.SetInteger(IDManager.Cskill_ID, 0);
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    //override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

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
