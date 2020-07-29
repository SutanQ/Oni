using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DodgeStateMachine : StateMachineBehaviour
{
    CharacterController characterController;
    ThirdPersonMovement thirdPerson;
    GhostEffect ghostEffect;
    Damegeable damegeable;

    int attackIndex;
    float h;

    public bool side = false;
    [Range(0.0f, 1.0f)]
    public float GhostEffectThreshold = 0.3f;

    [Header("Movement")]
    public Vector3 XYZ_Length;
    public float lengthMultiplier = 1.0f;
    public AnimationCurve animationCurveX;
    public AnimationCurve animationCurveY;
    public AnimationCurve animationCurveZ;

    //Animator ID
    public static int H_ID = Animator.StringToHash("H");
    public static int Attack_ID = Animator.StringToHash("Attack");
    public static int dodgeForward_ID = Animator.StringToHash("dodgeForward");
    public static int dodgeBack_ID = Animator.StringToHash("dodgeBack");
    public static int dodgeSide_ID = Animator.StringToHash("dodgeSide");


    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        characterController = animator.GetComponent<CharacterController>();
        thirdPerson = animator.GetComponent<ThirdPersonMovement>();
        ghostEffect = animator.GetComponent<GhostEffect>();
        damegeable = animator.GetComponent<Damegeable>();

        //不與Enemy碰撞
        Physics.IgnoreLayerCollision(9, 10, true);    //忽略Layer9與Layer10的碰撞
        characterController.detectCollisions = false; //此CharacterController不會被其他的物體碰撞    

        thirdPerson.SetWitchCollider(true);
        damegeable.SetCanTakeDamage(false);
        //ghostEffect.IsActive = true;
        attackIndex = animator.GetInteger(Attack_ID);
        h = animator.GetFloat(H_ID);
        animator.SetInteger(Attack_ID, -1);
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        //移動角色
        Vector3 dir = animator.transform.forward * XYZ_Length.z * animationCurveZ.Evaluate(stateInfo.normalizedTime)
            + animator.transform.right * XYZ_Length.x * animationCurveX.Evaluate(stateInfo.normalizedTime) * h
            + animator.transform.up * XYZ_Length.y * animationCurveY.Evaluate(stateInfo.normalizedTime);

        characterController.Move(dir * Time.deltaTime * lengthMultiplier);

        if(side)
            ghostEffect.IsActive = (animationCurveX.Evaluate(stateInfo.normalizedTime) >= GhostEffectThreshold) ? true : false;
        else
            ghostEffect.IsActive = (animationCurveZ.Evaluate(stateInfo.normalizedTime) >= GhostEffectThreshold) ? true : false;

        if (animationCurveZ.Evaluate(stateInfo.normalizedTime) >= GhostEffectThreshold)
            thirdPerson.SetWitchCollider(false);
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        Physics.IgnoreLayerCollision(9, 10, false);  //不忽略Layer9與Layer10的碰撞
        characterController.detectCollisions = true; //此CharacterController會被其他的物體碰撞

        thirdPerson.SetWitchCollider(false);
        //ghostEffect.IsActive = false;
        damegeable.SetCanTakeDamage(true);
        animator.ResetTrigger(dodgeForward_ID);
        animator.ResetTrigger(dodgeBack_ID);
        animator.ResetTrigger(dodgeSide_ID);
        animator.SetInteger(Attack_ID, attackIndex);
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
