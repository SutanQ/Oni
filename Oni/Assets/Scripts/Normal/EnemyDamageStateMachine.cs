using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyDamageStateMachine : StateMachineBehaviour
{
    //Rigidbody rb;
    //Enemy enemy;
    Damegeable damegeable;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        //enemy = animator.GetComponent<Enemy>();
        //enemy.useGravity = false;
        //rb = animator.GetComponent<Rigidbody>();
        //rb.useGravity = false;
        damegeable = animator.GetComponent<Damegeable>();
        damegeable.SetCanMove(0);
        damegeable.AnimatorAction();
        animator.SetBool(IDManager.damage_ID, true);
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    //override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        //enemy.useGravity = true;
        damegeable.SetCanMove(1);
        animator.SetBool(IDManager.damage_ID, false);
        animator.ResetTrigger(IDManager.damageTrigger_ID);
        //rb.useGravity = true;
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
