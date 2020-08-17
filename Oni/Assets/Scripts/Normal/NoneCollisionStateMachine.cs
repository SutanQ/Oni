using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoneCollisionStateMachine : StateMachineBehaviour
{
    CharacterController characterController;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        characterController = animator.GetComponent<CharacterController>();
        Physics.IgnoreLayerCollision(9, 10, true);    //忽略Layer9與Layer10的碰撞
        characterController.detectCollisions = false; //此CharacterController不會被其他的物體碰撞
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    //override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        Physics.IgnoreLayerCollision(9, 10, false);  //不忽略Layer9與Layer10的碰撞
        characterController.detectCollisions = true; //此CharacterController會被其他的物體碰撞
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
