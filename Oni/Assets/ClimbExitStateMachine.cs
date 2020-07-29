using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClimbExitStateMachine : StateMachineBehaviour
{
    ThirdPersonMovement thirdPerson;
    Transform parentTransform;
    public bool turnRotation = false;
    public Vector3 offsetPosition;
    public bool useSetLongWhenEnter = false;
    public bool useSetDefaultWhenExit = false;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        thirdPerson = animator.GetComponent<ThirdPersonMovement>();
        parentTransform = animator.GetComponent<Transform>();
        thirdPerson.useGravity = false;
        thirdPerson.SetPlayerCanMove(false);

        if (useSetLongWhenEnter)
            CameraShakeManager.Instance.SetLongRadius(1.0f);

        CameraShakeManager.Instance.ClimbCameraYAxis(true);
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    //override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        parentTransform.position += Vector3.up * offsetPosition.y + parentTransform.forward * offsetPosition.z;

        if (turnRotation)
            parentTransform.Rotate(new Vector3(0, 180, 0));
        thirdPerson.ResetGravityAndCanMove(0.1f);

        if (useSetDefaultWhenExit)
            CameraShakeManager.Instance.SetDefaultRadius(1.0f);

        CameraShakeManager.Instance.ClimbCameraYAxis(false);
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
