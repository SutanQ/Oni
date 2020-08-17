using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlashStartStateMachine : StateMachineBehaviour
{
    ThirdPersonMovement thirdPerson;

    [ColorUsage(true, true)]
    public Color hitColor = new Color(16, 16, 16, 1);

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        thirdPerson = animator.GetComponent<ThirdPersonMovement>();
        thirdPerson.SetHitColor(hitColor);

        thirdPerson.SetPlayerCanMove(false);

        //先把武器的Box Collider關掉，以避免造成額外傷害跟Force
        thirdPerson.SetWeaponCollider(false, 1, 0);
        thirdPerson.SetWeaponCollider(false, 3, 0);

        animator.SetBool(IDManager.InFlash_ID, true);
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    //override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        thirdPerson.SetPlayerCanMove(true);
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
