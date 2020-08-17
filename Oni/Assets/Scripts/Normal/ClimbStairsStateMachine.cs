using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClimbStairsStateMachine : StateMachineBehaviour
{
    ThirdPersonMovement thirdPerson;
    Transform parentTransform;
    public Vector3 offsetPosition;
    bool doSpecialAction = false;

    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        thirdPerson = animator.GetComponent<ThirdPersonMovement>();
        parentTransform = animator.GetComponent<Transform>();
        doSpecialAction = false;
        SpecialAction(animator);
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        //Debug.Log(stateInfo.normalizedTime);    
        SpecialAction(animator);
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        //如果沒有離開樓梯的話就在動作完成後進行位移
        if(!doSpecialAction)
            parentTransform.position += Vector3.up * offsetPosition.y + parentTransform.forward * offsetPosition.z;
    }

    void SpecialAction(Animator animator)
    {
        ClimbState climbState = thirdPerson.GetClimbState();

        //往上爬且碰到樓梯最頂部就直接離開樓梯
        if (offsetPosition.y > 0 && climbState == ClimbState.Top)
        {
            animator.SetBool(IDManager.Climb_ID, false);
            doSpecialAction = true;
        }
        else if (offsetPosition.y < 0 && climbState == ClimbState.Bottom) //往下爬且碰到樓梯最低處就離開樓梯
        {
            //thirdPerson.DoExitClimbStairs();
            animator.SetBool(IDManager.Climb_ID, false);
            doSpecialAction = true;
            CameraShakeManager.Instance.SetDefaultRadius(0.7f);
        }
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
