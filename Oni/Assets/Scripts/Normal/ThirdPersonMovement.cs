using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.VFX;
using UnityEngine.Animations.Rigging;
using UnityEngine.UI;
using UnityEngine.InputSystem;

public class ThirdPersonMovement : MonoBehaviour
{
    //ControlInput controlInput;
    [Tooltip("角色控制器")]
    public CharacterController characterController;
    [Tooltip("移動速度")]
    public float moveSpeed = 6.0f;
    [Tooltip("轉身速度")]
    public float turnSpeed = 5.0f;
    [Tooltip("轉身的Smooth時間")]
    public float turnSmoothTime = 0.1f;
    [Tooltip("跳躍高度")]
    public float jumpHeight = 2.5f;

    float currentVelocity;
    [Tooltip("是否使用重力")]
    public bool useGravity = true;
    Transform cam;
    Damegeable playerDamageable;

    [Tooltip("往上跳時的重力")]
    public float upGravity = -5.0f;
    [Tooltip("掉落時的重力")]
    public float downGravity = -9.81f;
    Vector3 velocity;
    [Tooltip("被怪物推動所使用的Collider")]
    public Collider RigidBodyCollider;
    [Tooltip("觸發魔女時間所使用的Collider")]
    public Collider WitchCollider;

    [Header("Ground")]
    [Tooltip("判斷著地的標的物")]
    public Transform groundCheck;
    [Tooltip("判斷著地的範圍")]
    public float groundCheckDistance = 0.4f;
    [Tooltip("判斷著地的Layer")]
    public LayerMask groundMask;
    bool isGrounded = false;

    [Header("Material")]
    [Tooltip("需要設定Forward參數的材質球，用來控制Shadow顯示的程度，面向陽光就不產生陰影")]
    public Material bodyMaterial;

    [Header("Hit Materials")]
    [Tooltip("被擊中的發光特效顏色")]
    [ColorUsage(true, true)]
    public Color hitColor = new Color(16, 16, 16, 1);
    [Tooltip("被擊中發光會影響的材質球群")]
    public Material[] hitMaterials;

    [Header("Camera")]
    [Tooltip("主攝影機")]
    public CinemachineFreeLook cinemachineFree;
    [Tooltip("攝影機的敏感度")]
    [Range(0f, 10f)] public float LookSpeed = 1f;
    [Tooltip("攝影機Y軸是否反向")]
    public bool InvertY = false;
    //public float wheelSpeed = 0.5f;
    //public Vector2 TopMinMax = new Vector2(2.5f, 5.5f);
    //public Vector2 MiddleMinMax = new Vector2(3.5f, 6.0f);
    //public Vector2 BottomMinMax = new Vector2(1.5f, 2.5f);

    [Header("Lock")]
    [Tooltip("鎖定敵人時所使用的攝影機")]
    public CinemachineVirtualCamera lockCam;
    CinemachineTransposer locakTransposer;
    [Tooltip("鎖定敵人時攝影機的偏移值")]
    public CinemachineCameraOffset locakCamOffset;
    [Tooltip("能鎖定到敵人的範圍")]
    public float lockRange = 15.0f;
    [Tooltip("能鎖定到敵人的面向角度")]
    public float lockAngle = 180;
    Transform lockTarget;
    bool isLock = false;
    
    Animator anim;

    [Header("Lock UI")]
    [Tooltip("鎖定敵人的UI 1")]
    public Image targetAim;
    [Tooltip("鎖定敵人的UI 2")]
    public Image targetLockAim;
    [Tooltip("鎖定敵人UI的偏移值")]
    public Vector2 TargetUI_Offset = new Vector2(0, 1);

    [Header("Magic")]
    public float startDuration = 0.3f;
    public float endDuration = 0.3f;
    public float MagicMaxSpeed = 0.5f;
    public ParticleSystem flamePS;
    public Rig magicRig;
    bool InMagic = false;
    float directSpeed = 0;
    float magicSpeed = 0;
    Coroutine magicCoroutine;

    [Header("Weapon")]
    public Weapon_Attack_Group[] weapon_Attack_Groups;
    int attackIndex = 0;

    //Coroutine coroutine_animationMove;
    Vector3 move;
    float h = 0;
    float v = 0;
    Transform climbPos;
    bool hasClimbPos = false;
    bool doClimbing = false;
    ClimbState climbState = ClimbState.None;

    SkinnedMeshRenderer[] skinnedMeshRenderers;
    SobelEffect[] sobelEffects;
    Coroutine targetUI_Coroutine;

    // Start is called before the first frame update
    void Start()
    {
        //Cursor.visible = false;
        //controlInput = new ControlInput();
        //controlInput.SetPlayerNum(1);
        cam = Camera.main.transform;
        anim = GetComponent<Animator>();
        playerDamageable = GetComponent<Damegeable>();
        flamePS.Stop();
        magicRig.weight = 0.0f;
        locakTransposer = lockCam.GetCinemachineComponent<CinemachineTransposer>();
        skinnedMeshRenderers = GetComponentsInChildren<SkinnedMeshRenderer>();
        sobelEffects = GetComponentsInChildren<SobelEffect>();

        SetWitchCollider(false);

        for (int i = 0; i < weapon_Attack_Groups.Length; i++)
        {
            for (int j = 0; j < weapon_Attack_Groups[i].weapon_Attack_Datas.Length; j++)
            {
                Weapon_Attack_Data weapon_Attack_Data = weapon_Attack_Groups[i].weapon_Attack_Datas[j];

                weapon_Attack_Data.weapon_materials = weapon_Attack_Data.weapon.GetComponent<Renderer>().sharedMaterials;
                weapon_Attack_Data.weapon_start_localPosition = weapon_Attack_Data.weapon.localPosition;
                weapon_Attack_Data.weapon_start_localScale = weapon_Attack_Data.weapon.localScale;
                weapon_Attack_Data.weapon_start_localRotation = weapon_Attack_Data.weapon.localRotation;
                weapon_Attack_Data.weapon_ghost_material = new Material[weapon_Attack_Data.weapon_materials.Length];
                for (int k = 0; k < weapon_Attack_Data.weapon_materials.Length; k++)
                {
                    weapon_Attack_Data.weapon_ghost_material[k] = weapon_Attack_Data.ghost_material;
                }
            }
        }
        for (int i = 0; i < weapon_Attack_Groups.Length; i++)
        {
            for (int j = 0; j < weapon_Attack_Groups[i].weapon_Attack_Datas.Length; j++)
            {
                Weapon_FadeOut(0.1f, i + 1, j);
            }
        }
        attackIndex = 0;
    }
     
    IEnumerator MagicAnimationWeight(float targetWeight, float duration)
    {
        float t = 0;
        //float startWeight = 1 - targetWeight;
        float startWeight = magicRig.weight;
        float startMagicSpeed = magicSpeed;
        if (targetWeight == 0.0f)
        {
            flamePS.Stop();
        }

        while(t < duration)
        {
            if (magicSpeed > MagicMaxSpeed)
                magicSpeed = Mathf.Lerp(startMagicSpeed, MagicMaxSpeed, t / duration);
            magicRig.weight = Mathf.Lerp(startWeight, targetWeight, t / duration);
            t += Time.deltaTime;
            yield return null;
        }
        magicRig.weight = targetWeight;
        if (targetWeight == 1.0f)
        {
            flamePS.Play();
        }
        yield return null;
    }

    // Update is called once per frame
    void Update()
    {
        if (playerDamageable.status.isDead)
            return;

        Movement();
        //Command();
        //AdjustCameraDistance();
        StateMachine();
        Lock_Update();
    }

    void Lock_Update()
    {
        if(isLock && lockTarget != null)
        {
            targetAim.transform.position = Camera.main.WorldToScreenPoint(lockTarget.position + (Vector3)TargetUI_Offset);

            float distance = Vector3.Distance(transform.position, lockTarget.position);
            float normal = Mathf.InverseLerp(2.0f, 8.0f, distance);
            locakCamOffset.m_Offset.y = Mathf.Lerp(0.8f, 0.2f, normal);
            locakTransposer.m_FollowOffset.z = Mathf.Lerp(-4.0f, -2.0f, normal);
        }
    }

    public void OnMove(InputAction.CallbackContext context)
    {
        Vector2 inputMovement = context.ReadValue<Vector2>();
        h = inputMovement.x;
        v = inputMovement.y;
    }

    public void OnLook(InputAction.CallbackContext context)
    {
        //Normalize the vector to have an uniform vector in whichever form it came from (I.E Gamepad, mouse, etc)
        Vector2 lookMovement = context.ReadValue<Vector2>().normalized;
        lookMovement.y = InvertY ? -lookMovement.y : lookMovement.y;

        // This is because X axis is only contains between -180 and 180 instead of 0 and 1 like the Y axis
        lookMovement.x = lookMovement.x * 180f;

        //Ajust axis values using look speed and Time.deltaTime so the look doesn't go faster if there is more FPS
        cinemachineFree.m_XAxis.Value += lookMovement.x * LookSpeed * Time.deltaTime;
        cinemachineFree.m_YAxis.Value += lookMovement.y * LookSpeed * Time.deltaTime;
        
    }

    public void OnAttack(InputAction.CallbackContext context)
    {
        if (playerDamageable.status.isDead)  return;
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                //if (isGrounded)
                //{
                    attackIndex = anim.GetInteger(IDManager.Attack_ID);
                    attackIndex++;
                    anim.SetInteger(IDManager.Attack_ID, attackIndex);
                //}
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    public void OnCAttack(InputAction.CallbackContext context)
    {
        if (playerDamageable.status.isDead) return;
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                int skill = anim.GetInteger(IDManager.Cskill_ID);
                anim.SetInteger(IDManager.Cskill_ID, ++skill);

                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    public void OnJump(InputAction.CallbackContext context)
    {
        if (playerDamageable.status.isDead) return;
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                if (isGrounded && playerDamageable.GetCanMove())
                {
                    anim.SetTrigger(IDManager.Jump_ID);
                }
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    public void OnClimb(InputAction.CallbackContext context)
    {
        if (playerDamageable.status.isDead) return;
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                //if (isGrounded && playerDamageable.GetCanMove())
                if(hasClimbPos == true && isGrounded)
                {
                    bool b = anim.GetBool(IDManager.Climb_ID);
                    switch(climbState)
                    {
                        case ClimbState.Bottom:
                            if (!b) DoBottomClimbStairs();
                            else DoExitBottomClimbStairs();
                            break;
                        case ClimbState.Top:
                            if (!b) DoTopClimbStairs();
                            else    DoExitTopClimbStairs();
                            break;
                    }
                }
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    public ClimbState GetClimbState()
    {
        return climbState;
    }

    public void DoBottomClimbStairs()
    {
        if (doClimbing) return;
        StartCoroutine(bottomClimbStaires());
    }

    IEnumerator bottomClimbStaires()
    {
        doClimbing = true;
        float t = 0;
        playerDamageable.SetCanMove(0);
        transform.SetParent(climbPos);

        Vector3 startPos = transform.localPosition;
        Quaternion startRotation = transform.rotation;
        Quaternion lookRotation = Quaternion.LookRotation(climbPos.forward, Vector3.up);
        
        float distance = Vector3.Distance(transform.position, climbPos.position);
        float duration = Mathf.Clamp(distance, 0.0f, 0.3f);
        anim.SetFloat(IDManager.Speed_ID, Mathf.Clamp(distance, 0.0f, 0.3f));

        while (t < duration)
        {
            transform.localPosition = Vector3.Lerp(startPos, Vector3.zero, t / duration);
            transform.rotation = Quaternion.Lerp(startRotation, lookRotation, t / duration);
            distance = Vector3.Distance(transform.position, climbPos.position);
            anim.SetFloat(IDManager.Speed_ID, Mathf.Clamp(distance, 0.0f, 0.3f));
            t += Time.deltaTime;
            yield return null;
        }
        
        transform.localPosition = Vector3.zero;
        transform.rotation = lookRotation;
        transform.SetParent(null);
        playerDamageable.SetCanMove(1);
        anim.SetBool(IDManager.Climb_ID, true);
        anim.SetFloat(IDManager.Speed_ID, 0.0f);
        doClimbing = false;
        CameraShakeManager.Instance.SetLongRadius(0.7f);
    }

    public void DoTopClimbStairs()
    {
        if (doClimbing) return;
        StartCoroutine(topClimbStaires());
    }

    IEnumerator topClimbStaires()
    {
        doClimbing = true;
        float t = 0;
        playerDamageable.SetCanMove(0);
        transform.SetParent(climbPos);

        Vector3 startPos = transform.localPosition;
        Quaternion startRotation = transform.rotation;
        Quaternion lookRotation = Quaternion.LookRotation(climbPos.forward, Vector3.up);

        float distance = Vector3.Distance(transform.position, climbPos.position);
        float duration = Mathf.Clamp(distance, 0.0f, 0.3f);
        anim.SetFloat(IDManager.Speed_ID, Mathf.Clamp(distance, 0.0f, 0.3f));

        while (t < duration)
        {
            transform.localPosition = Vector3.Lerp(startPos, Vector3.zero, t / duration);
            transform.rotation = Quaternion.Lerp(startRotation, lookRotation, t / duration);
            distance = Vector3.Distance(transform.position, climbPos.position);
            anim.SetFloat(IDManager.Speed_ID, Mathf.Clamp(distance, 0.0f, 0.3f));
            t += Time.deltaTime;
            yield return null;
        }

        transform.localPosition = Vector3.zero;
        transform.rotation = lookRotation;
        transform.SetParent(null);
        playerDamageable.SetCanMove(1);
        anim.SetTrigger(IDManager.ClimbDown_ID);
        anim.SetBool(IDManager.Climb_ID, true);
        anim.SetFloat(IDManager.Speed_ID, 0.0f);
        doClimbing = false;
    }

    public void DoExitBottomClimbStairs()
    {
        anim.SetBool(IDManager.Climb_ID, false);
        CameraShakeManager.Instance.SetDefaultRadius(0.7f);
    }

    public void DoExitTopClimbStairs()
    {
        anim.SetTrigger(IDManager.ClimbUp_ID);
        anim.SetBool(IDManager.Climb_ID, false);
        CameraShakeManager.Instance.SetDefaultRadius(0.7f);
    }

    public void OnDodge(InputAction.CallbackContext context)
    {
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                //閃躲
                if ((anim.GetBool(IDManager.damage_ID) == false))
                {
                    if (isLock)
                    {
                        if (Mathf.Abs(anim.GetFloat(IDManager.H_ID)) <= 0.1f)
                        {
                            if (anim.GetFloat(IDManager.V_ID) >= 0.1f)
                                anim.SetTrigger(IDManager.dodgeForward_ID);
                            else
                                anim.SetTrigger(IDManager.dodgeBack_ID);
                        }
                        else
                        {
                            anim.SetTrigger(IDManager.dodgeSide_ID);
                        }
                    }
                    else
                    {
                        if (anim.GetFloat(IDManager.V_ID) == 0.0f && anim.GetFloat(IDManager.H_ID) == 0.0f)
                            anim.SetTrigger(IDManager.dodgeBack_ID);
                        else
                            anim.SetTrigger(IDManager.dodgeForward_ID);
                    }
                }
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    public void OnLock(InputAction.CallbackContext context)
    {
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                if(!anim.GetBool(IDManager.InFlash_ID))
                    StartLock();
                break;

            case InputActionPhase.Canceled:
                if (!anim.GetBool(IDManager.InFlash_ID))
                    CancelLock();
                break;
        }
    }

    public void StartLock(Transform _target = null)
    {
        anim.SetBool(IDManager.Lock_ID, true);
        if(_target == null)
            lockTarget = GetClostEnemy();
        else
            lockTarget = _target;

        if (lockTarget != null)
        {
            lockTarget.GetComponent<Damegeable>().OnDeath += Do_TargetUI_FadeOut;
            lockCam.m_LookAt = lockTarget;
            lockCam.Priority = 25;

            targetAim.transform.position = Camera.main.WorldToScreenPoint(lockTarget.position + (Vector3)TargetUI_Offset);
            Do_TargetUI_FadeIn();
        }
    }

    public Transform GetClostEnemy()
    {
        return EnemyManager.Instance.GetClostEnemy(transform.position, lockRange, lockAngle, cam.position, cam.forward);
    }

    public Transform GetClostEnemyWithoutFlash()
    {
        return EnemyManager.Instance.GetClostEnemyWithoutFlash(transform.position, lockRange, lockAngle, cam.position, cam.forward);
    }

    public void CancelLock()
    {
        anim.SetBool(IDManager.Lock_ID, false);
        lockCam.Priority = 10;
        if (lockTarget)
        {
            cinemachineFree.m_YAxis.Value = 0.55f;
            cinemachineFree.m_XAxis.Value = transform.eulerAngles.y;
            lockTarget.GetComponent<Damegeable>().OnDeath -= Do_TargetUI_FadeOut;
            Do_TargetUI_FadeOut();
        }
        lockTarget = null;
    }

    void Movement()
    {
        move = Vector3.zero;
        //輸入
        //float h = Input.GetAxis("Horizontal");
        //float v = Input.GetAxis("Vertical");
        anim.SetFloat(IDManager.H_ID, h);
        anim.SetFloat(IDManager.V_ID, v);
        isLock = anim.GetBool(IDManager.Lock_ID);

        Vector3 direction = new Vector3(h, 0, v);
        directSpeed = direction.magnitude;
        anim.SetFloat(IDManager.Speed_ID, directSpeed);

        //若在施法動作中則將速度調整為施法速度
        if (InMagic && directSpeed > MagicMaxSpeed)
        {
            directSpeed = magicSpeed;
        }
        else
            magicSpeed = directSpeed;
        //anim.SetFloat("Speed", directSpeed);



        //判斷是否在地上
        isGrounded = Physics.CheckSphere(transform.position, groundCheckDistance, groundMask);
        anim.SetBool(IDManager.Ground_ID, isGrounded);
        if (isGrounded && velocity.y < 0)
        {
            velocity.y = -2f;
        }

        //移動
        if (directSpeed >= 0.1f && playerDamageable.GetCanMove() && !anim.GetBool(IDManager.Climb_ID))
        {
            direction = direction.normalized;

            if (isLock)
            {
                if (anim.GetBool(IDManager.Attacking_ID) == false)
                {
                    //轉頭
                    //Vector3 moveDir = (Quaternion.AngleAxis(cam.eulerAngles.y, Vector3.up) * direction).normalized;
                    Vector3 moveDir = (Quaternion.AngleAxis(transform.eulerAngles.y, Vector3.up) * direction).normalized;
                    move = moveDir * moveSpeed * Time.deltaTime * directSpeed * (0.5f - Mathf.Abs(h) * 0.2f + v * 0.1f);
                    characterController.Move(move);
                }
            }
            else
            {
                float targetAngle = 0;
                if (anim.GetBool(IDManager.Attacking_ID) == false)
                {
                    //轉頭
                    targetAngle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg + cam.eulerAngles.y;
                    float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref currentVelocity, turnSmoothTime);
                    transform.rotation = Quaternion.Euler(Vector3.up * angle);
                }

                //轉向後的移動方向
                if (anim.GetInteger(IDManager.Attack_ID) == 0)
                {
                    Vector3 moveDir = Quaternion.Euler(0, targetAngle, 0) * Vector3.forward;
                    move = moveDir * moveSpeed * Time.deltaTime * directSpeed;
                    characterController.Move(move);
                }
            }
        }

        //鎖定後會跟著對象轉向
        if (lockTarget != null && isLock)
        {
            Vector3 dir = lockTarget.position - transform.position;
            dir = new Vector3(dir.x, 0, dir.z);
            dir = dir.normalized;
            Quaternion rotation = Quaternion.LookRotation(dir, Vector3.up);
            transform.rotation = rotation;
        }

        //鎖定
        /*
        if(Input.GetKeyDown(KeyCode.LeftShift))
        {
            anim.SetBool(IDManager.Lock_ID, true);
            lockTarget = EnemyManager.Instance.GetClostEnemy(transform.position, lockRange, lockAngle, cam.position, cam.forward);
            if (lockTarget != null)
            {
                lockTarget.GetComponent<Damegeable>().OnDeath += Do_TargetUI_FadeOut;
                lockCam.m_LookAt = lockTarget;
                lockCam.Priority = 25;

                targetAim.transform.position = Camera.main.WorldToScreenPoint(lockTarget.position + (Vector3)TargetUI_Offset);
                Do_TargetUI_FadeIn();
            }
        }
        if (Input.GetKeyUp(KeyCode.LeftShift))
        {
            anim.SetBool(IDManager.Lock_ID, false);
            lockCam.Priority = 10;
            if (lockTarget)
            {
                lockTarget.GetComponent<Damegeable>().OnDeath -= Do_TargetUI_FadeOut;
                Do_TargetUI_FadeOut();
            }
            lockTarget = null;
        }
        */

        playerDamageable.UpdateAddForce();
        /*
        //計算外力(受drag而逐漸歸零)
        int sign = playerDamageable.addForceVity.x >= 0 ? 1 : -1;
        playerDamageable.addForceVity.x = (Mathf.Abs(playerDamageable.addForceVity.x) - playerDamageable.drag * Time.deltaTime);
        if (playerDamageable.addForceVity.x <= 0)
            playerDamageable.addForceVity.x = 0;
        else
            playerDamageable.addForceVity.x *= sign;

        sign = playerDamageable.addForceVity.z >= 0 ? 1 : -1;
        playerDamageable.addForceVity.z = (Mathf.Abs(playerDamageable.addForceVity.z) - playerDamageable.drag * Time.deltaTime);
        if (playerDamageable.addForceVity.z <= 0)
            playerDamageable.addForceVity.z = 0;
        else
            playerDamageable.addForceVity.z *= sign;
        */
        //重力
        if (useGravity && !anim.GetBool(IDManager.Climb_ID))
        {
            if (velocity.y > 0)  //上升時所受到的重力
            {
                velocity.y += upGravity * Time.deltaTime;
            }
            else                 //下降時所受到的重力
            {
                velocity.y += downGravity * Time.deltaTime;
            }
            characterController.Move(velocity * Time.deltaTime + playerDamageable.addForceVity * Time.deltaTime);
        }
    }

    

    public void Do_TargetUI_FadeIn()
    {
        if (targetUI_Coroutine != null)
            StopCoroutine(targetUI_Coroutine);
        targetUI_Coroutine = StartCoroutine(TargetUI_FadeIn(0.2f, 90.0f));
    }

    public void Do_TargetUI_FadeOut()
    {
        if (targetUI_Coroutine != null)
            StopCoroutine(targetUI_Coroutine);
        targetUI_Coroutine = StartCoroutine(TargetUI_FadeOut(0.2f, 90.0f));
    }

    IEnumerator TargetUI_FadeIn(float t, float rotateAngle)
    {
        float tt = 0;
        Color c = Color.white;
        Vector3 targetEularAngles = targetAim.transform.eulerAngles + Vector3.forward * rotateAngle;
        while(tt < t)
        {
            c.a = Mathf.Lerp(0, 1.0f, tt / t);
            targetAim.color = c;
            targetAim.transform.Rotate(new Vector3(0, 0, (rotateAngle * Time.deltaTime / t)));
            targetAim.transform.localScale = Vector3.Lerp(new Vector3(2, 2, 2), Vector3.one, tt / t);
            targetLockAim.color = c;

            tt += Time.deltaTime;
            yield return null;
        }
        targetAim.transform.localScale = Vector3.one;
        targetAim.transform.eulerAngles = targetEularAngles;
        targetLockAim.color = targetAim.color = Color.white;
    }

    IEnumerator TargetUI_FadeOut(float t, float rotateAngle)
    {
        float tt = 0;
        Color c = Color.white;
        Vector3 targetEularAngles = targetAim.transform.eulerAngles + Vector3.forward * rotateAngle;
        while (tt < t)
        {
            c.a = Mathf.Lerp(1.0f, 0.0f, tt / t);
            targetAim.color = c;
            targetAim.transform.Rotate(new Vector3(0, 0, (rotateAngle * Time.deltaTime / t)));
            targetAim.transform.localScale = Vector3.Lerp(Vector3.one, new Vector3(2, 2, 2), tt / t);
            targetLockAim.color = c;
            tt += Time.deltaTime;
            yield return null;
        }
        targetAim.transform.localScale = new Vector3(2, 2, 2);
        targetAim.transform.eulerAngles = targetEularAngles;
        targetLockAim.color = targetAim.color = Color.clear;
    }

    public void TargetUI_Cancel()
    {
        if (targetUI_Coroutine != null)
            StopCoroutine(targetUI_Coroutine);
        Vector3 targetEularAngles = targetAim.transform.eulerAngles + Vector3.forward * 90.0f;
        targetAim.transform.localScale = new Vector3(2, 2, 2);
        targetAim.transform.eulerAngles = targetEularAngles;
        targetLockAim.color = targetAim.color = Color.clear;
    }

    /*
    void Command()
    {
        //Magic
        if ((Input.GetMouseButtonDown(1) || Input.GetButtonDown(controlInput.CancelButton)) && playerDamageable.GetCanMove())
        {
            InMagic = true;
            magicSpeed = directSpeed;
            if (magicCoroutine != null)
                StopCoroutine(magicCoroutine);
            magicCoroutine = StartCoroutine(MagicAnimationWeight(1.0f, startDuration));
        }
        if ((Input.GetMouseButtonUp(1) || Input.GetButtonUp(controlInput.CancelButton)) || (InMagic && !playerDamageable.GetCanMove()))
        {
            InMagic = false;
            if (magicCoroutine != null)
                StopCoroutine(magicCoroutine);
            magicCoroutine = StartCoroutine(MagicAnimationWeight(0.0f, endDuration));
        }

        attackIndex = anim.GetInteger(IDManager.Attack_ID);
        //Attack
        if((Input.GetKeyDown(KeyCode.Z) || Input.GetButtonDown(controlInput.AttackButton)) && isGrounded)
        {
            attackIndex++;
            anim.SetInteger(IDManager.Attack_ID, attackIndex);
        }
        if(Input.GetKeyDown(KeyCode.X))
        {
            int skill = anim.GetInteger(IDManager.Cskill_ID);
            anim.SetInteger(IDManager.Cskill_ID, ++skill);
            //anim.SetTrigger("Cskill");
        }

        //跳躍
        if ((Input.GetButtonDown("Jump") || Input.GetButtonDown(controlInput.ConfirmButton)) && isGrounded && playerDamageable.GetCanMove())
        {
            anim.SetTrigger(IDManager.Jump_ID);
        }

        //閃躲
        if(Input.GetKeyDown(KeyCode.Q) && (anim.GetBool(IDManager.damage_ID) == false))
        {
            if (isLock)
            {
                if (Mathf.Abs(anim.GetFloat(IDManager.H_ID)) <= 0.1f)
                {
                    if (anim.GetFloat(IDManager.V_ID) >= 0.1f)
                        anim.SetTrigger(IDManager.dodgeForward_ID);
                    else
                        anim.SetTrigger(IDManager.dodgeBack_ID);
                }
                else
                {
                    anim.SetTrigger(IDManager.dodgeSide_ID);
                }
            }
            else
            {
                if (anim.GetFloat(IDManager.V_ID) == 0.0f && anim.GetFloat(IDManager.H_ID) == 0.0f)
                    anim.SetTrigger(IDManager.dodgeBack_ID);
                else
                    anim.SetTrigger(IDManager.dodgeForward_ID);
            }
        }
    }
    */
    /*
    void AdjustCameraDistance()
    {
        //滑鼠滾輪來調整攝影機的距離
        if (Input.mouseScrollDelta.y != 0)
        {
            cinemachineFree.m_Orbits[0].m_Radius -= Input.mouseScrollDelta.y * wheelSpeed;
            cinemachineFree.m_Orbits[1].m_Radius -= Input.mouseScrollDelta.y * wheelSpeed;
            cinemachineFree.m_Orbits[2].m_Radius -= Input.mouseScrollDelta.y * wheelSpeed;

            cinemachineFree.m_Orbits[0].m_Radius = Mathf.Clamp(cinemachineFree.m_Orbits[0].m_Radius, TopMinMax.x, TopMinMax.y);
            cinemachineFree.m_Orbits[1].m_Radius = Mathf.Clamp(cinemachineFree.m_Orbits[1].m_Radius, MiddleMinMax.x, MiddleMinMax.y);
            cinemachineFree.m_Orbits[2].m_Radius = Mathf.Clamp(cinemachineFree.m_Orbits[2].m_Radius, BottomMinMax.x, BottomMinMax.y);
        }
    }
    */

    public void RightHandGrip(int b)
    {
        if (b > 0)
            anim.SetBool(IDManager.RightHandGrip_ID, true);
        else
            anim.SetBool(IDManager.RightHandGrip_ID, false);
    }

    public void LeftHandGrip(int b)
    {
        if (b > 0)
            anim.SetBool(IDManager.LeftHandGrip_ID, true);
        else
            anim.SetBool(IDManager.LeftHandGrip_ID, false);
    }

    public void Jump()
    {
        velocity.y = Mathf.Sqrt(jumpHeight * upGravity * -2f);
    }

    void StateMachine()
    {
        anim.SetFloat(IDManager.YSpeed_ID, velocity.y);
        anim.SetBool(IDManager.WitchTime_ID, GameManager.Instance.inWitchTime);

        //設定BODY材質球的Forward參數讓ShadowMask能在背光時無效
        bodyMaterial.SetVector(IDManager.Forward_ID, transform.forward);
    }

    public void Weapon_FadeIn(float t, int _attackIndex, int _secondIndex = 0)
    {
        if (weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex].weapon_coroutine != null)
            StopCoroutine(weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex].weapon_coroutine);
        weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex].weapon_coroutine = StartCoroutine(wFadeIn(t, _attackIndex, _secondIndex));
    }

    public void Weapon_FadeOut(float t, int _attackIndex, int _secondIndex = 0)
    {
        if (weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex].weapon_coroutine != null)
            StopCoroutine(weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex].weapon_coroutine);
        weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex].weapon_coroutine = StartCoroutine(wFadeOut(t, _attackIndex, _secondIndex));
    }

    public Transform GetWeapon(int _attackIndex, int _secondIndex)
    {
        return weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex].weapon;
    }

    public void weaponCatchToHolder(int _b, int _attackIndex, Vector3 offset, int _secondIndex = 0)
    {
        Weapon_Attack_Data weapon_Attack_Data = weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex];

        //接到武器初始出現位置
        if (_b > 0)
        {
            useGravity = false;
            if (weapon_Attack_Data.attack_catchPos != null)
            {
                weapon_Attack_Data.weapon.SetParent(weapon_Attack_Data.attack_catchPos);
            }

        }
        else //回到手上Holder
        {
            useGravity = true;
            weapon_Attack_Data.weapon.SetParent(weapon_Attack_Data.weapon_holder);
        }

        //歸零
        weapon_Attack_Data.weapon.localPosition = weapon_Attack_Data.weapon_start_localPosition;
        weapon_Attack_Data.weapon.localRotation = weapon_Attack_Data.weapon_start_localRotation;
        weapon_Attack_Data.weapon.localScale = weapon_Attack_Data.weapon_start_localScale;

        //加上位移後的預計位置
        if (_b > 0)
        {
            Vector3 newOffset = offset.z * transform.forward + offset.x * transform.right + offset.y * transform.up;

            /*
            RaycastHit hit;
            float origin_offsetY = 0;
            float new_offsetY = 0;
            if (Physics.Raycast(weapon_Attack_Data.weapon.position + (newOffset).y * Vector3.up, Vector3.down, out hit, 10.0f, groundMask))
            {
                origin_offsetY = (weapon_Attack_Data.weapon.position.y + newOffset.y) - hit.point.y;
            }

            if (Physics.Raycast(weapon_Attack_Data.weapon.position + newOffset, Vector3.down, out hit, 10.0f, groundMask))
            {
                new_offsetY = (weapon_Attack_Data.weapon.position.y + newOffset.y) - hit.point.y;
            }

            if (new_offsetY < origin_offsetY)
                newOffset.y = hit.point.y + new_offsetY;
            */
            
            weapon_Attack_Data.weapon.transform.SetParent(null);
            weapon_Attack_Data.weapon.position += newOffset;

            //weapon_Attack_Data.weapon.position += offset;
        }
    }


    IEnumerator wFadeIn(float t, int _attackIndex, int _secondIndex = 0)
    {
        float tt = 0;
        Weapon_Attack_Data weapon_Attack_Data = weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex];

        //武器歸零
        weapon_Attack_Data.weapon.SetParent(weapon_Attack_Data.weapon_holder);
        weapon_Attack_Data.weapon.localPosition = weapon_Attack_Data.weapon_start_localPosition;
        weapon_Attack_Data.weapon.localRotation = weapon_Attack_Data.weapon_start_localRotation;
        weapon_Attack_Data.weapon.localScale = weapon_Attack_Data.weapon_start_localScale;

        //顯示武器及初始粒子特效
        weapon_Attack_Data.weapon.gameObject.SetActive(true);
        for (int i = 0; i < weapon_Attack_Data.weapon_start_particles.Length; i++)
            weapon_Attack_Data.weapon_start_particles[i].Play();
        weapon_Attack_Data.weapon.GetComponent<Renderer>().materials = weapon_Attack_Data.weapon_ghost_material;

        weapon_Attack_Data.ghost_material.SetFloat(IDManager.PosAmount_ID, 1.0f);

        while (tt < t)
        {
            float alpha = Mathf.Lerp(0, 1.0f, tt / t);
            weapon_Attack_Data.ghost_material.color = new Color(weapon_Attack_Data.ghost_material.color.r, weapon_Attack_Data.ghost_material.color.g, weapon_Attack_Data.ghost_material.color.b, alpha);
            weapon_Attack_Data.ghost_material.SetFloat(IDManager.PosAmount_ID, 1.0f - tt / t);
            tt += Time.deltaTime;
            yield return null;
        }

        weapon_Attack_Data.ghost_material.SetFloat(IDManager.PosAmount_ID, 0.0f);

        weapon_Attack_Data.ghost_material.color = new Color(weapon_Attack_Data.ghost_material.color.r, weapon_Attack_Data.ghost_material.color.g, weapon_Attack_Data.ghost_material.color.b, 1.0f);
        weapon_Attack_Data.weapon.GetComponent<Renderer>().materials = weapon_Attack_Data.weapon_materials;
        
        yield return null;
    }

    
    IEnumerator wFadeOut(float t, int _attackIndex, int _secondIndex = 0)
    {
        float tt = 0;

        Weapon_Attack_Data weapon_Attack_Data = weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex];

        //關閉武器及顯示結束粒子特效
        weapon_Attack_Data.weapon.SetParent(null);
        for(int i = 0; i < weapon_Attack_Data.weapon_end_particles.Length; i++)
            weapon_Attack_Data.weapon_end_particles[i].Play();
        weapon_Attack_Data.weapon.GetComponent<Renderer>().materials = weapon_Attack_Data.weapon_ghost_material;

        while (tt < t)
        {
            float alpha = Mathf.Lerp(1.0f, 0.0f, tt / t);
            weapon_Attack_Data.ghost_material.color = new Color(weapon_Attack_Data.ghost_material.color.r, weapon_Attack_Data.ghost_material.color.g, weapon_Attack_Data.ghost_material.color.b, alpha);
            tt += Time.deltaTime;
            yield return null;
        }

        //重置武器位置
        weapon_Attack_Data.ghost_material.color = new Color(weapon_Attack_Data.ghost_material.color.r, weapon_Attack_Data.ghost_material.color.g, weapon_Attack_Data.ghost_material.color.b, 0.0f);
        weapon_Attack_Data.weapon.GetComponent<Renderer>().materials = weapon_Attack_Data.weapon_materials;
        weapon_Attack_Data.weapon.gameObject.SetActive(false);
        weapon_Attack_Data.weapon.SetParent(weapon_Attack_Data.weapon_holder);
        weapon_Attack_Data.weapon.localPosition = weapon_Attack_Data.weapon_start_localPosition;
        weapon_Attack_Data.weapon.localRotation = weapon_Attack_Data.weapon_start_localRotation;
        weapon_Attack_Data.weapon.localScale = weapon_Attack_Data.weapon_start_localScale;
        yield return null;
    }

    public void PlayWeaponParticles(int _attackIndex, int _secondIndex = 0)
    {
        Weapon_Attack_Data weapon_Attack_Data = weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex];

        //顯示粒子特效
        for (int i = 0; i < weapon_Attack_Data.weapon_particles.Length; i++)
            weapon_Attack_Data.weapon_particles[i].Play();
    }

    public void StopWeaponParticles(int _attackIndex, int _secondIndex = 0)
    {
        Weapon_Attack_Data weapon_Attack_Data = weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex];

        //顯示粒子特效
        for (int i = 0; i < weapon_Attack_Data.weapon_particles.Length; i++)
            weapon_Attack_Data.weapon_particles[i].Stop();
    }

    public void Weapon_Cskill(float t, int _attackIndex, int _secondIndex = 0)
    {
        StartCoroutine(wCskill(t, _attackIndex, _secondIndex));
    }

    IEnumerator wCskill(float t, int _attackIndex, int _secondIndex = 0)
    {

        yield return null;
    }

    public void SetWitchCollider(bool b)
    {
        WitchCollider.enabled = b;
        RigidBodyCollider.enabled = !b;
    }

    public void SetWeaponStatus(int atk, Vector3 force, DamageType damageType, int _attackIndex, int _secondIndex = 0)
    {
        Weapon_Attack_Data weapon_Attack_Data = weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex];
        Damage dmg = weapon_Attack_Data.weapon.GetComponent<Damage>();
        dmg.Force = force;
        dmg.damage = atk;
        dmg.damageType = damageType;
    }

    public void SetWeaponCollider(bool turnOn, int _attackIndex, int _secondIndex = 0)
    {
        Weapon_Attack_Data weapon_Attack_Data = weapon_Attack_Groups[_attackIndex - 1].weapon_Attack_Datas[_secondIndex];
        Collider collider = weapon_Attack_Data.weapon.GetComponent<Collider>();
        collider.enabled = turnOn;
    }

    /*
    void OnControllerColliderHit(ControllerColliderHit hit)
    {
        Rigidbody body = hit.collider.attachedRigidbody;
        Enemy e = hit.collider.GetComponent<Enemy>();
        // no rigidbody
        if (body == null || body.isKinematic)
        {
            return;
        }
        
        // We dont want to push objects below us
        if (hit.moveDirection.y < -0.3)
        {
            return;
        }
        Debug.Log(e.name + " : " + (-move) + " " + e.mDir * 10);
        // Calculate push direction from move direction,
        // we only push objects to the sides never up and down
        Vector3 pushDir = new Vector3(hit.moveDirection.x, 0, hit.moveDirection.z);

        // If you know how fast your character is trying to move,
        // then you can also multiply the push velocity by that.

        // Apply the push
        characterController.Move(-move + e.mDir * 10);
        //body.velocity = pushDir * pushPower;
    }
    */

    private void OnControllerColliderHit(ControllerColliderHit hit)
    {
        //站在怪身上時會自動滑下來
        if(hit.collider.CompareTag("Enemy") )
        {
            Vector3 center = hit.controller.center + hit.transform.position;
            if (transform.position.y > center.y)
            {
                Vector3 dir = (transform.position - center);
                dir.y = 0;
                velocity.y = 0.0f;
                //Debug.Log(dir.normalized + " " + velocity.y);
                characterController.Move(dir.normalized * Time.deltaTime);
            }
        }
    }

    public Vector3 GetVelocity()
    {
        return velocity;
    }

    public void SetVelocity(Vector3 v)
    {
        velocity = v;
    }

    public void SetSuperArmor(bool b)
    {
        playerDamageable.status.superArmor = b;
    }

    public void SetClimbPos(bool b, ClimbState _climbState, Transform t)
    {
        hasClimbPos = b;
        climbState = _climbState;
        climbPos = t;
    }

    public void SetPlayerCanMove(bool b)
    {
        playerDamageable.SetCanMove((b == true) ? 1 : 0);
    }

    public void ResetGravityAndCanMove(float waitTime)
    {
        StartCoroutine(DoResetGravityAndCanMove(waitTime));
    }

    IEnumerator DoResetGravityAndCanMove(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        useGravity = true;
        SetPlayerCanMove(true);
    }

    public Transform GetLockTarget()
    {
        if (isLock && lockTarget != null)
            return lockTarget;
        else
            return null;
    }

    public void SetDetectCollisions(int b)
    {
        if(b > 0)
            characterController.detectCollisions = true; 
        else
            characterController.detectCollisions = false;
    }

    public void SetHitMaterial(float duration)
    {
        for(int i = 0; i < hitMaterials.Length; i++)
        {
            hitMaterials[i].SetColor(IDManager.hitColorID, hitColor);
        }

        StartCoroutine(DoHitColorAmount(duration));
    }

    IEnumerator DoHitColorAmount(float duration)
    {
        float t = 0;
        float durationBy2 = duration * 0.5f;
        for (int i = 0; i < hitMaterials.Length; i++)
        {
            hitMaterials[i].SetFloat(IDManager.hitColorAmountID, 0.0f);
        }
        
        while (t < durationBy2)
        {
            for (int i = 0; i < hitMaterials.Length; i++)
            {
                hitMaterials[i].SetFloat(IDManager.hitColorAmountID, Mathf.Lerp(0.0f, 1.0f, t / durationBy2));
            }
            
            t += Time.deltaTime;
            yield return null;
        }
        for (int i = 0; i < hitMaterials.Length; i++)
        {
            hitMaterials[i].SetFloat(IDManager.hitColorAmountID, 1.0f);
        }
        
        t = 0;
        while (t < durationBy2)
        {
            for (int i = 0; i < hitMaterials.Length; i++)
            {
                hitMaterials[i].SetFloat(IDManager.hitColorAmountID, Mathf.Lerp(1.0f, 0.0f, t / durationBy2));
            }
            
            t += Time.deltaTime;
            yield return null;
        }
        for (int i = 0; i < hitMaterials.Length; i++)
        {
            hitMaterials[i].SetFloat(IDManager.hitColorAmountID, 0.0f);
        }
    }

    public void SetHitColor(Color color)
    {
        hitColor = color;
    }

    public void ChangeSkinnedRenderer(bool b)
    {
        for(int i = 0; i < skinnedMeshRenderers.Length; i++)
        {
            skinnedMeshRenderers[i].enabled = b;
        }

        for(int i = 0; i < sobelEffects.Length; i++)
        {
            sobelEffects[i].enabled = b;
        }
    }
}

[System.Serializable]
public class Weapon_Attack_Group
{
    [Tooltip("武器攻擊的名稱")]
    public string name = "Attack";
    [Tooltip("武器攻擊的資料集")]
    public Weapon_Attack_Data[] weapon_Attack_Datas;
}

[System.Serializable]
public class Weapon_Attack_Data
{
    [Tooltip("拿取武器的Holder")]
    public Transform weapon_holder;
    [Tooltip("使用的武器")]
    public Transform weapon;
    [Tooltip("武器fadeIn fadeOut所使用的材質球")]
    public Material ghost_material;
    [Tooltip("武器fadeIn時所觸發的粒子特效")]
    public ParticleSystem[] weapon_start_particles;
    [Tooltip("武器fadeOut時所觸發的粒子特效")]
    public ParticleSystem[] weapon_end_particles;
    [Tooltip("武器使用過程中所觸發的粒子特效(由AttackStateMachine所控制)")]
    public ParticleSystem[] weapon_particles;
    [Tooltip("動作中會Catch到武器的位置，用來在AttackStateMachine中預先設定好武器顯示的位置。\n依照在AttackStateMachine中Weapon_Data->catchFrame的Frame數，手動在Animation抓取該Frame weapon_holder位置，並將此位置設定為本參數值。")]
    public Transform attack_catchPos;

    protected internal Material[] weapon_materials;
    protected internal Material[] weapon_ghost_material;
    protected internal Coroutine weapon_coroutine;
    protected internal Vector3 weapon_start_localPosition;
    protected internal Vector3 weapon_start_localScale;
    protected internal Quaternion weapon_start_localRotation;
}

public enum ClimbState { Bottom, Top, None};