using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackStateMachine : StateMachineBehaviour
{
    public enum FadeUnit { Sec, Frame, Percent };

    CharacterController characterController;
    ThirdPersonMovement thirdPerson;
    [Tooltip("是否忽略角色碰撞")]
    public bool NoCollision = false;
    [Tooltip("角色是否有霸體(受到傷害時不會觸發damage動作)")]
    public bool superArmor = false;
    [Tooltip("是否在進入動作時取消Lock敵人")]
    public bool cancelLockWhenEnter = false;
    [Tooltip("是否在離開動作時取消Lock敵人")]
    public bool cancelLockWhenExit = false;

    [Header("Hit Material")]
    [Tooltip("是否在擊中敵人時產生發光特效")]
    public bool useHitMaterial = false;
    [Tooltip("發光特效的持續時間")]
    public float hitMaterialDuration = 0.5f;
    [Tooltip("是否使用設定的發光特效顏色")]
    public bool useHitColor = false;
    [Tooltip("設定發光特效的顏色")]
    [ColorUsage(true, true)]
    public Color hitColor = new Color(16, 16, 16, 1);

    [Header("Movement")]
    [Tooltip("攻擊是否會自動追尾敵人")]
    public bool useLockTargetDirection = false;
    [Tooltip("攻擊的位移")]
    public Vector3 XYZ_Length;
    [Tooltip("攻擊位移的倍率")]
    public float lengthMultiplier = 1.0f;
    [Tooltip("攻擊位移的X曲線")]
    public AnimationCurve animationCurveX;
    [Tooltip("攻擊位移的Y曲線")]
    public AnimationCurve animationCurveY;
    [Tooltip("攻擊位移的Z曲線")]
    public AnimationCurve animationCurveZ;
    Vector3 targetDirection;
    Transform lockTarget;
    Vector3 dir;

    [Header("Animation Transhold")]
    [Tooltip("攻擊Index，對應ThirdPersonMovement中weapon_Attack_Groups的index")]
    public int thisAttackIndex = 1;
    [Tooltip("接收下一段攻擊指定的門檻時間值")]
    [Range(0.0f,1.0f)]
    public float NextAttackTranshold = 0.5f;
    [Tooltip("時間單位計算所使用的每秒Frame")]
    public int Frame = 24;
    [Tooltip("攻擊所使用的資料")]
    public Weapon_Data[] weapon_Datas;

    [Header("Particle")]
    [Tooltip("攻擊過程中是否會使用粒子特效，對應ThirdPersonMovement中Weapon_Attack_Data的weapon_particles")]
    public bool playAttackParticle = false;
    [Tooltip("觸發粒子特效時的Frame")]
    public int playParticleFrame;
    bool playedParticle = false;
    float playParticleNomalize = 0.0f;


    [Header("Special Attack")]
    [Tooltip("特殊攻擊時是否保留武器顯示")]
    public bool specialWeaponAppear = true;
    [Tooltip("特殊攻擊的index(對應Weapon_Skill)")]
    public ActionIndex specialAttackIndex = ActionIndex.None;
    [Tooltip("特殊攻擊的持續時間")]
    public float specialAttackDuration = 2.0f;
    int specialAttack = 0; //0代表未動作， > 0 代表成功， < 0 代表失敗
    [Tooltip("能產生特殊攻擊的指令輸入區間(最小值)")]
    [Range(0.0f, 1.0f)]
    public float special_min = 0.3f;
    [Tooltip("能產生特殊攻擊的指令輸入區間(最大值)")]
    [Range(0.0f, 1.0f)]
    public float special_max = 0.5f;
    [Tooltip("特殊攻擊所產生的攝影機晃動幅度")]
    public float specialShakeStrength = 0.0f;
    [Tooltip("特殊攻擊所產生的音效")]
    public AudioClip special_clip;
    [Tooltip("特殊攻擊所產生的音效大小")]
    public float special_clip_volume = 1.0f;
    [Tooltip("特殊攻擊所產生的攝影機晃動Impulse(CameraShakeManager)")]
    public CameraImpulseIndex cameraImpulseIndex = CameraImpulseIndex.None;

    [Header("PostProcess Volume")]
    [Tooltip("是否使用後處理特效")]
    public bool useVolume = false;
    [Tooltip("使用的後處理特效index(參照GameManager的volumes)")]
    public int volumeIndex = 0;
    [Tooltip("後處理特效FadeIn的時間")]
    public float volumeFadeInDuration = 0.3f;
    [Tooltip("後處理特效FadeOut的時間")]
    public float volumeFadeOutDuration = 0.3f;


    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        //animator.ResetTrigger("Cskill");
        specialAttack = 0;
        animator.SetInteger(IDManager.Cskill_ID, 0);
        animator.SetBool(IDManager.Attacking_ID, true);
        animator.SetInteger(IDManager.Attack_ID, thisAttackIndex);
        characterController = animator.GetComponent<CharacterController>();
        thirdPerson = animator.GetComponent<ThirdPersonMovement>();

        if (cancelLockWhenEnter)
            thirdPerson.CancelLock();

        //不與Enemy碰撞
        if (NoCollision)
        {
            Physics.IgnoreLayerCollision(9, 10, true);    //忽略Layer9與Layer10的碰撞
            characterController.detectCollisions = false; //此CharacterController不會被其他的物體碰撞
        }
        //霸體
        if(superArmor)
        {
            thirdPerson.SetSuperArmor(true);
        }

        //鎖定追尾功能
        if (useLockTargetDirection)
        {
            lockTarget = thirdPerson.GetLockTarget();
            if (lockTarget != null)
            {
                targetDirection = (lockTarget.position - thirdPerson.transform.position).normalized;
            }
        }

        for (int i = 0; i < weapon_Datas.Length; i++)
        {
            //顯示武器
            switch (weapon_Datas[i].fadeUnit)
            {
                case FadeUnit.Sec: thirdPerson.Weapon_FadeIn(weapon_Datas[i].FadeIn, thisAttackIndex, i); break;
                case FadeUnit.Percent: thirdPerson.Weapon_FadeIn(weapon_Datas[i].FadeIn * stateInfo.length, thisAttackIndex, i); break;
                case FadeUnit.Frame: thirdPerson.Weapon_FadeIn(weapon_Datas[i].FadeIn / Frame, thisAttackIndex, i); break;
            }

            //計算拿起武器的時間點
            weapon_Datas[i].catched = false;
            weapon_Datas[i].catchPercent = ((float)weapon_Datas[i].catchFrame / Frame) / stateInfo.length;

            //設定武器初始位置 = 該武器在特定Frame數的位置(ex.Attack1_004)加上 初始時間到抓取武器時間的位移
            Vector3 offsetCurve = new Vector3(AreaOfCurve(animationCurveX, stateInfo.normalizedTime, weapon_Datas[i].catchPercent, stateInfo.length / stateInfo.speed) * XYZ_Length.x,
                AreaOfCurve(animationCurveY, stateInfo.normalizedTime, weapon_Datas[i].catchPercent, stateInfo.length / stateInfo.speed) * XYZ_Length.y,
                AreaOfCurve(animationCurveZ, stateInfo.normalizedTime, weapon_Datas[i].catchPercent, stateInfo.length / stateInfo.speed) * XYZ_Length.z);
 

            //float gravityY = AreaOfCurveGravity(0, weapon_Datas[i].catchPercent, stateInfo.length, thirdPerson.GetVelocity().y, thirdPerson.upGravity, thirdPerson.downGravity);
            thirdPerson.weaponCatchToHolder(thisAttackIndex, thisAttackIndex, offsetCurve * lengthMultiplier * Time.deltaTime, i);

            //設定武器的能力數值及Collider
            if (weapon_Datas[i].useWeaponStatus)
            {
                thirdPerson.SetWeaponStatus(weapon_Datas[i].attack, weapon_Datas[i].force, weapon_Datas[i].damageType, thisAttackIndex, i);
                if(weapon_Datas[i].turnOnColWhenCatch)
                    thirdPerson.SetWeaponCollider(false, thisAttackIndex, i);
            }
        }

        if (playAttackParticle)
        {
            playParticleNomalize = (float)playParticleFrame / Frame;
            playedParticle = false;
        }


        //後結果特效
        if(useVolume)
        {
            GameManager.Instance.PlayVolume(0.0f, 1.0f, volumeFadeInDuration, volumeIndex);
        }

        if (useHitMaterial)
        {
            if (useHitColor)
                thirdPerson.SetHitColor(hitColor);
            thirdPerson.SetHitMaterial(hitMaterialDuration);
        }

    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        //移動角色
        if (useLockTargetDirection && lockTarget != null)
        {
            dir = targetDirection * XYZ_Length.z * animationCurveZ.Evaluate(stateInfo.normalizedTime);
        }
        else
        {
            dir = animator.transform.forward * XYZ_Length.z * animationCurveZ.Evaluate(stateInfo.normalizedTime)
                + animator.transform.right * XYZ_Length.x * animationCurveX.Evaluate(stateInfo.normalizedTime)
                + animator.transform.up * XYZ_Length.y * animationCurveY.Evaluate(stateInfo.normalizedTime);
        }
        
        characterController.Move(dir * Time.deltaTime * lengthMultiplier);

        if (specialAttack == 0)
        {
            if (stateInfo.normalizedTime < special_min && animator.GetInteger(IDManager.Cskill_ID) > 0)
            {
                specialAttack = -1;
            }
            else if (stateInfo.normalizedTime >= special_min && stateInfo.normalizedTime <= special_max && animator.GetInteger(IDManager.Cskill_ID) == 1)
            {
                specialAttack = 1;
                for (int i = 0; i < weapon_Datas.Length; i++)
                {
                    Transform weapon = thirdPerson.GetWeapon(thisAttackIndex, i);
                    Weapon_Cskill weapon_Cskill = weapon.GetComponent<Weapon_Cskill>();
                    if (weapon_Cskill != null)
                    {
                        weapon_Cskill.OnActionEnd = null;
                        weapon_Cskill.OnActionEnd += thirdPerson.Weapon_FadeOut;
                        switch (weapon_Datas[i].fadeUnit)
                        {
                            case FadeUnit.Sec: weapon_Cskill.PlayAction(specialAttackIndex, specialAttackDuration, weapon_Datas[i].FadeOut, thisAttackIndex, i, characterController.transform.position); break;
                            case FadeUnit.Percent: weapon_Cskill.PlayAction(specialAttackIndex, specialAttackDuration, weapon_Datas[i].FadeOut * stateInfo.length, thisAttackIndex, i, characterController.transform.position); break;
                            case FadeUnit.Frame: weapon_Cskill.PlayAction(specialAttackIndex, specialAttackDuration, weapon_Datas[i].FadeOut / Frame, thisAttackIndex, i, characterController.transform.position); break;
                        }
                        
                    }
                }
                CameraShakeManager.Instance.AddCameraShake(specialShakeStrength, cameraImpulseIndex);
                if (special_clip != null)
                    AudioManager.instance.PlaySound(special_clip, thirdPerson.transform.position, special_clip_volume);
                //AudioManager.instance.PlaySound(special_clip, weapon.position, special_clip_volume);
            }
        }

        //禁止太快進入下一段攻擊
        if (stateInfo.normalizedTime < NextAttackTranshold)
        {
            animator.SetInteger(IDManager.Attack_ID, thisAttackIndex);
            animator.SetInteger(IDManager.Cskill_ID, 0);
            animator.ResetTrigger(IDManager.Jump_ID);
        }

        for (int i = 0; i < weapon_Datas.Length; i++)
        {
            //拿起武器
            if (stateInfo.normalizedTime >= weapon_Datas[i].catchPercent && !weapon_Datas[i].catched)
            {
                weapon_Datas[i].catched = true;
                switch (weapon_Datas[i].handType)
                {
                    case HandType.Right: thirdPerson.RightHandGrip(1); break;
                    case HandType.Left: thirdPerson.LeftHandGrip(1); break;
                    case HandType.None: break;
                }
                thirdPerson.weaponCatchToHolder(0, thisAttackIndex, Vector3.zero, i);

                //設定武器的Collider
                if (weapon_Datas[i].useWeaponStatus && weapon_Datas[i].turnOnColWhenCatch)
                {
                    thirdPerson.SetWeaponCollider(true, thisAttackIndex, i);
                }
            }
        }

        if(playAttackParticle && !playedParticle)
        {
            if (stateInfo.normalizedTime >= playParticleNomalize)
            {
                playedParticle = true;
                for (int i = 0; i < weapon_Datas.Length; i++)
                {
                    thirdPerson.PlayWeaponParticles(thisAttackIndex, i);
                }
            }
        }

        if(stateInfo.normalizedTime >= 0.90f)
        {
            animator.SetBool(IDManager.Attacking_ID, false);
        }
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.SetBool(IDManager.Attacking_ID, false);
        if (specialAttack > 0 && !specialWeaponAppear)
        {
            ;
        }
        else
        {
            if (cancelLockWhenExit)
                thirdPerson.CancelLock();

            //thirdPerson.weapon_Attack_Datas[0].weapon.transform.position
            for (int i = 0; i < weapon_Datas.Length; i++)
            {
                //關閉武器顯示
                switch (weapon_Datas[i].fadeUnit)
                {
                    case FadeUnit.Sec: thirdPerson.Weapon_FadeOut(weapon_Datas[i].FadeOut, thisAttackIndex, i); break;
                    case FadeUnit.Percent: thirdPerson.Weapon_FadeOut(weapon_Datas[i].FadeOut * stateInfo.length, thisAttackIndex, i); break;
                    case FadeUnit.Frame: thirdPerson.Weapon_FadeOut(weapon_Datas[i].FadeOut / Frame, thisAttackIndex, i); break;
                }

                switch (weapon_Datas[i].handType)
                {
                    case HandType.Right: thirdPerson.RightHandGrip(0); break;
                    case HandType.Left: thirdPerson.LeftHandGrip(0); break;
                    case HandType.None: break;
                }

                //設定武器的能力數值及Collider
                if (weapon_Datas[i].useWeaponStatus && weapon_Datas[i].turnOnColWhenCatch)
                {
                    thirdPerson.SetWeaponCollider(true, thisAttackIndex, i);
                }
            }
            /*
            if (playAttackParticle)
            {
                if (stateInfo.normalizedTime >= playParticleNomalize)
                {
                    playedParticle = true;
                    for (int i = 0; i < weapon_Datas.Length; i++)
                    {
                        thirdPerson.StopWeaponParticles(thisAttackIndex, i);
                    }
                }
            }
            */
        }
        //animator.ResetTrigger("Cskill");

        //重設與Enemy碰撞
        if (NoCollision)
        {
            Physics.IgnoreLayerCollision(9, 10, false);  //不忽略Layer9與Layer10的碰撞
            characterController.detectCollisions = true; //此CharacterController會被其他的物體碰撞
        }
        //霸體
        if (superArmor)
        {
            thirdPerson.SetSuperArmor(false);
        }
        animator.SetInteger(IDManager.Cskill_ID, 0);

        //後結果特效
        if (useVolume)
        {
            GameManager.Instance.PlayVolume(1.0f, 0.0f, volumeFadeOutDuration, volumeIndex);
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

    public static float AreaOfCurve(AnimationCurve curve, float startTime, float endTime, float duration)
    {
        float area = 0;
        float t = startTime;
        float delta = Time.deltaTime / duration;
        
        while (t < endTime)
        {
            area += curve.Evaluate(t);
            t += delta;
        }
        return area;
    }

    public static float AreaOfCurveGravity(float startTime, float endTime, float duration, float velocityY, float upGravity, float downGravity)
    {
        float area = 0;
        float t = startTime;
        float delta = Time.deltaTime / duration;
        float g;
        int cnt = 0;
        while (t < endTime)
        {
            if (velocityY > 0)  //上升時所受到的重力
            {
                g = upGravity * Time.deltaTime;
                velocityY += g;
            }
            else                 //下降時所受到的重力
            {
                g = downGravity * Time.deltaTime;
                velocityY += g;
            }
            area += g* Time.deltaTime;
            t += delta;
            cnt++;
        }
        Debug.Log(cnt + " Vy:" + velocityY + " " + upGravity + " " + downGravity);
        return area;
    }

    //計算在startTime至endTime之間的曲線下面積
    public static float IntegrateCurve(AnimationCurve curve, float startTime, float endTime, int steps)
    {
        float h = (endTime - startTime) / steps;
        float res = (curve.Evaluate(startTime) + curve.Evaluate(endTime)) / 2;
        for (int i = 1; i < steps; i++)
        {
            res += curve.Evaluate(startTime + i * h);
        }
        return h * res;
    }

    public enum HandType { Right, Left, None};

    [System.Serializable]
    public class Weapon_Data
    {
        [Tooltip("使用的左手或右手")]
        public HandType handType;

        [Header("Weapon Fade")]
        [Tooltip("使用時間單位")]
        public FadeUnit fadeUnit;
        [Tooltip("FadeIn的時間")]
        public float FadeIn;
        [Tooltip("FadeOut的時間")]
        public float FadeOut;

        [Header("Catch Weapon")]
        [Tooltip("拿到武器的Frame")]
        public int catchFrame;
        protected internal bool catched;
        protected internal float catchPercent;

        [Header("Weapon Status")]
        [Tooltip("是否將以下數據設定為武器的狀態值")]
        public bool useWeaponStatus = false;
        [Tooltip("武器的攻擊力")]
        public int attack = 0;
        [Tooltip("武器的外力")]
        public Vector3 force;
        [Tooltip("武器傷害的類型")]
        public DamageType damageType;
        [Tooltip("是否在Catch到武器之後才開啟武器的Collider")]
        public bool turnOnColWhenCatch = true;
    }
}
