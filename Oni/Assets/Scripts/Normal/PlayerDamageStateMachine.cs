using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDamageStateMachine : StateMachineBehaviour
{
    Damegeable damegeable;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        damegeable = animator.GetComponent<Damegeable>();
        damegeable.SetCanMove(0);
        animator.SetBool(IDManager.damage_ID, true);  //在Damegeable.cs的TakeDamege就會先改為true，以避免受到傷害後還來不及將damage改為true就讓dodge可以執行。
        animator.GetComponent<ThirdPersonMovement>().useGravity = true;
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    //override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.SetBool(IDManager.damage_ID, false);
        animator.ResetTrigger(IDManager.damageTrigger_ID);
        animator.ResetTrigger(IDManager.dodgeForward_ID);
        animator.ResetTrigger(IDManager.dodgeBack_ID);
        animator.ResetTrigger(IDManager.dodgeSide_ID);
        damegeable.SetCanMove(1);
        
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
