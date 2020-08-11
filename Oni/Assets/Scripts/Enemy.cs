using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;

public class Enemy : Damegeable
{
    protected Transform playerGO;
    public bool useEnemyManager = false;
    protected Player player;
    
    
    public bool useGravity = true;
    //protected Rigidbody rb;
    
    protected Vector3 mDir;
    protected Material material;


    [Header("Move and Search")]
    public float MoveSpeed = 2.0f;
    public float forward_offsetAngle = 0.0f;
    public float searchRange = 3.0f;
    public float searchAngle = 90.0f;
    public float trackRange = 5.0f;
    public float attackRange = 1.5f;
    public float reachRange = 0.2f;
    public float searchDurationTime = 3.0f;
    public float actionDurationTime = 2.0f;
    float searchOldTime, actionOldTime;
    protected bool hasTarget = false;
    float xSpeed = 0;
    float animationCurveSpeed = 1.0f;

    [Header("Ground")]
    public Transform groundCheck;
    public float groundCheckDistance = 0.1f;
    public LayerMask groundMask;
    protected bool isGrounded = false;

    [Header("Idle Walk Path")]
    public bool walkStraight = false;
    public IdlePath idleWalkPath;
    public bool directionForward = true;
    public bool cycle = false;
    float pointNextTime = 0;
    public float endPointWaitTime = 1.5f;
    int pointIndex = 0;
    Transform nextPoint;

    [Header("Jump")]
    public bool hasJumpAction = false;
    public float jumpPercent = 0.3f;
    //public float jumpForce = 300.0f;
    public float jumpHeight = 2.5f;

    [Header("Actions Setting")]
    public AnimationClip replaceAttackClip;
    public AttackAnimationSet[] attackAnimationSets;
    protected AnimatorOverrideController overrideController;

    [Header("Enemy Effect")]
    public GhostEffect ghostEffect;
    public EnemyEffect[] enemyEffects;
    protected Dictionary<string, EnemyEffect> enemyEffectsDictionary = new Dictionary<string, EnemyEffect>();
    protected string nowEnemyEffectName;
    protected string nowEnemyAudioName;

    [Header("UI")]
    public GameObject UI_HP;
    public Image UI_HPbar;
    public Image UI_HPgreen;
    Animator UI_Anim;

    Vector3 moveDir;
    Vector3 dir;

    // Start is called before the first frame update
    protected override void Start()
    {
        base.Start();
        if (UI_HP)
        {
            UI_HP.GetComponent<Canvas>().worldCamera = Camera.main;
            UI_Anim = UI_HP.GetComponent<Animator>();
        }
        player = FindObjectOfType<Player>();
        playerGO = player.transform;
        //rb = GetComponent<Rigidbody>();
        //actionOldTime = Time.time + actionDurationTime;
        //searchOldTime = Time.time + searchDurationTime;
        

        if (idleWalkPath != null)
            nextPoint = idleWalkPath.GetPoint(0);

        if(useEnemyManager)
            EnemyManager.Instance.AddEnemy(this);

        if(replaceAttackClip != null)
            StartCoroutine(Setting(0.1f));

        for (int i = 0; i < enemyEffects.Length; i++)
        {
            if (!enemyEffectsDictionary.ContainsKey(enemyEffects[i].enemyEffectName))
            {
                enemyEffectsDictionary.Add(enemyEffects[i].enemyEffectName, enemyEffects[i]);
            }
        }

        if (ghostEffect != null)
            OnDamege += CloseGhostEffect;

        OnDamege += OnDamegeSetHasTarget;
    }

    public void OnDamegeSetHasTarget()
    {
        hasTarget = true;
    }

    public void SetIdleWalkPath(IdlePath idlePath)
    {
        idleWalkPath = idlePath;
        nextPoint = idleWalkPath.GetPoint(0);
    }

    public void SearchTarget()
    {
        if(Time.time >= searchOldTime )
        {
            searchOldTime = Time.time + searchDurationTime;

            if (playerGO == null)
                return;

            dir = (playerGO.position - transform.position).normalized;

            if (Vector3.Distance(transform.position, playerGO.position) < searchRange)
            {
                float angle = Mathf.Acos(Vector3.Dot(dir, transform.forward) / (dir.sqrMagnitude * transform.forward.sqrMagnitude)) * 180 / Mathf.PI - forward_offsetAngle;

                if (Mathf.Abs(angle) <= searchAngle * 0.5f)
                {
                    hasTarget = true;
                }
            }

        }
    }

    protected void IdleWalk()
    {
        if (idleWalkPath == null || Time.time < pointNextTime || !isGrounded)
            return;

        if (Vector3.Distance(transform.position, nextPoint.position) < reachRange)
        {
            if ((pointIndex == 0 || pointIndex == idleWalkPath.GetLength() - 1) && cycle == false)
            {
                pointNextTime = Time.time + endPointWaitTime;
                nextPoint = idleWalkPath.GetNextPoint(ref pointIndex, ref directionForward, cycle);
                return;
            }
            else
                nextPoint = idleWalkPath.GetNextPoint(ref pointIndex, ref directionForward, cycle);
        }

        ChangeFace(nextPoint.position);
        MoveToTarget(nextPoint.position, reachRange);
    }

    public void TrackandAttackTarget()
    {
        if (playerGO == null)
        {
            hasTarget = false;
            return;
        }

        ChangeFace(playerGO.position);

        float distance = Vector3.Distance(playerGO.position, transform.position);
        if (distance <= trackRange || walkStraight)
        {
            if (distance <= attackRange && !walkStraight)
            {
                if (Time.time >= actionOldTime)
                {
                    actionOldTime = Time.time + actionDurationTime;
                    if (hasJumpAction)
                    {
                        if (Random.Range(0.0f, 1.0f) <= jumpPercent)
                            Jump();
                        else
                            Attack();
                    }
                    else
                    {
                        Attack();
                    }
                }
            }
            else
                MoveToTarget(playerGO.position, attackRange);
        }
        else
            hasTarget = false;
    }

    protected virtual void Jump()
    {
        anim.SetTrigger(IDManager.Jump_ID);
        //Vector3 dir = ((Quaternion.AngleAxis(forward_offsetAngle, Vector3.up) * transform.forward).normalized + Vector3.up * 2.0f).normalized;
        //rb.AddForce(dir * jumpForce);
        //gravityY = dir.y * jumpForce;
        //addForceVity.x = dir.x * jumpForce;
        //addForceVity.z = dir.z * jumpForce;
        dir = (Quaternion.AngleAxis(forward_offsetAngle, Vector3.up) * transform.forward).normalized;
        gravityY = Mathf.Sqrt(jumpHeight * Physics.gravity.y * -2f);
        addForceVity.x = dir.x * jumpHeight;
        addForceVity.z = dir.z * jumpHeight;
    }

    protected void MoveToTarget(Vector3 targetPos, float range)
    {
        //Debug.Log("Move " + canMove);
        moveDir = (targetPos - transform.position).normalized;

        //xSpeed = Mathf.Clamp01((Vector3.Distance(targetPos, transform.position) - reachRange)) / attackRange;
        //依照與目標的距離及範圍長度來設定xSpeed值
        float d = Vector3.Distance(targetPos, transform.position);
        if ((d - 2 * range) >= 0)
            xSpeed = 1.0f;
        else
            xSpeed = Mathf.Clamp01(d - range) / range;

        anim.SetFloat(IDManager.XSpeed_ID, xSpeed);

        //若是只能直走的情況下就不變更xSpeed及方向
        if (walkStraight)
        {
            xSpeed = 1.0f;
            moveDir = (Quaternion.AngleAxis(forward_offsetAngle, Vector3.up) * transform.forward).normalized;// (transform.eulerAngles - forward_offsetAngle * Vector3.up).normalized; //transform.forward;
        }
        else
            xSpeed = Mathf.Clamp01(xSpeed + 0.1f);

        //                     方向      移動速度                  靠近速度    整體速度
        //transform.position += moveDir * MoveSpeed * Time.deltaTime * xSpeed * animationCurveSpeed;
        mDir = moveDir * MoveSpeed * Time.deltaTime * xSpeed * animationCurveSpeed;
        //characterController.Move(mDir);
    }

    //依照目標的位置轉頭
    protected void ChangeFace(Vector3 targetPos)
    {
        //若是只能直走的情況下就不變更方向
        if (walkStraight)
            return;

        dir = targetPos - transform.position;
        //dir = new Vector3(dir.x, 0, dir.z);
        dir.y = 0;
        dir = dir.normalized;
        Quaternion rotation = Quaternion.LookRotation(dir, Vector3.up);
        transform.rotation = rotation;
        transform.eulerAngles = transform.eulerAngles - forward_offsetAngle * Vector3.up; //若怪物本身的三軸有誤，可藉由設定AddRotationToForward做修正
    }

    protected virtual void Attack()
    {
        if (replaceAttackClip != null)
        {
            int index = 0;        //剩餘血量動作組的INDEX
            int attackIndex = 0;  //實際動作的INDEX
            float life = (float)status.hp / status.maxHp;   //剩餘血量
            float attackPercent = Random.Range(0, 1.0f);     //動作的隨機值

            //找出剩餘血量的INDEX
            for (int i = 0; i < attackAnimationSets.Length; i++)
            {
                if (life <= attackAnimationSets[i].lifePercent)
                {
                    index = i;
                }
                else
                {
                    break;
                }
            }

            //找到本次動作的INDEX
            for (int i = 0; i < attackAnimationSets[index].animationSets.Length; i++)
            {
                if (attackPercent <= attackAnimationSets[index].animationSets[i].percent)
                {
                    attackIndex = i;
                    break;
                }
            }

            //替換動作
            overrideController[replaceAttackClip.name] = attackAnimationSets[index].animationSets[attackIndex].animation;
        }
        //執行Attack動作
        anim.SetTrigger(IDManager.Attack_ID);
    }
    /*
    protected virtual void Update()
    {
        UpdateAction();
    }
    */
    protected override void die()
    {
        if(useEnemyManager)
            EnemyManager.Instance.RemoveEnemy(this);
        if (UI_HP)
        {
            UpdateUI();
            UI_Anim.SetBool(IDManager.FadeIn_ID, false);
        }
        base.die();
    }

    
    public virtual void UpdateAction()
    {
        mDir = Vector3.zero;
        //死亡就不再進行任何計算
        if (status.isDead) return;

        //受傷時會停滯一段受傷動畫時間再進行運動計算， 註解掉這一行則可以移除停滯時間
        //if (anim.GetBool("damage")) return; 

        //判斷是否在地上
        if (groundCheck)
        {
            isGrounded = Physics.CheckSphere(groundCheck.position, groundCheckDistance, groundMask);
            anim.SetBool(IDManager.Ground_ID, isGrounded);

            //產生衝擊波
            if(isGrounded && makeGroundImpact)
            {
                makeGroundImpact = false;
                Instantiate(GameManager.Instance.VFX_GroundImpactPrefab, groundCheck.position, Quaternion.identity);
            }

            if(isGrounded && gravityY < 0)
                gravityY = -2.0f;
        }

        //若沒有找到目標就進行搜尋
        if (!hasTarget)
            SearchTarget();

        //若可以移動
        if (status.canMove)
        {
            //若擁有目標則進行移動並攻擊
            if (hasTarget)
                TrackandAttackTarget();
            else  //若沒有目標則進行閒逛(且有設定IdleWalkPath)
                IdleWalk();
        }

        UpdateAddForce();
        /*
        //計算外力(受drag而逐漸歸零)
        int sign = addForceVity.x >= 0 ? 1 : -1;
        addForceVity.x = (Mathf.Abs(addForceVity.x) - drag * Time.deltaTime);
        if (addForceVity.x <= 0)  addForceVity.x = 0;
        else                      addForceVity.x *= sign;
        sign = addForceVity.z >= 0 ? 1 : -1;
        addForceVity.z = (Mathf.Abs(addForceVity.z) - drag * Time.deltaTime);
        if (addForceVity.z <= 0)  addForceVity.z = 0;
        else                      addForceVity.z *= sign;
        */

        //重力、移動及外力的位移 (mDir為移動、addForceVity為外力)
        if (useGravity)
        {
            gravityY += Physics.gravity.y * Time.deltaTime;
            characterController.Move(Vector3.up * gravityY * Time.deltaTime + mDir + addForceVity * Time.deltaTime);
        }
        else
            characterController.Move(mDir + addForceVity * Time.deltaTime);

        

        animationCurveSpeed = 1.0f;

        //更新材質球的被擊中效果(位移及變亮)
        UpdateHitMaterial();

        UpdateUI();
    }

    

    void UpdateUI()
    {
        if (UI_HP == null) return;

        if (Time.time > UI_Timer)
        {
            UI_Anim.SetBool(IDManager.FadeIn_ID, false);
            return;
        }

        if(!UI_Anim.GetBool(IDManager.FadeIn_ID))
            UI_Anim.SetBool(IDManager.FadeIn_ID, true);

        //面向攝影機
        Vector3 v = Camera.main.transform.transform.position - UI_HP.transform.position;
        v.x = v.z = 0.0f;
        UI_HP.transform.LookAt(Camera.main.transform.position - v);
        UI_HP.transform.Rotate(0, 180, 0);

        //更新HP顯示
        float amount = (float)status.hp / status.maxHp;
        //深血
        if(!anim.GetBool(IDManager.damage_ID))
            UI_HPbar.fillAmount = Mathf.Lerp(UI_HPbar.fillAmount, amount, GameManager.Instance.UI_HP_duration);
        //綠血
        UI_HPgreen.fillAmount = amount;
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;

        Gizmos.DrawWireSphere(transform.position, trackRange);

        if (playerGO)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawLine(transform.position, (playerGO.position - transform.position).normalized * searchRange);
        }

        if(idleWalkPath != null)
        {
            idleWalkPath.drawGizmos();
        }
    }

    //播放粒子動畫
    public void PlayParticleSystem(string effectName)
    {
        if (enemyEffectsDictionary.ContainsKey(effectName))
        {
            nowEnemyEffectName = effectName;
            for (int i = 0; i < enemyEffectsDictionary[effectName].particleSystems.Length; i++)
                enemyEffectsDictionary[effectName].particleSystems[i].Play();
            OnDamege += OnDamegeParticleFuc;
        }
    }
    //停止粒子動畫
    public void StopParticleSystem(string effectName)
    {
        if (enemyEffectsDictionary.ContainsKey(effectName))
        {
            OnDamege -= OnDamegeParticleFuc;
            for (int i = 0; i < enemyEffectsDictionary[effectName].particleSystems.Length; i++)
                enemyEffectsDictionary[effectName].particleSystems[i].Stop();
        }
    }
    //受傷時停止粒子動畫
    protected void OnDamegeParticleFuc()
    {
        StopParticleSystem(nowEnemyEffectName);
        nowEnemyEffectName = "";
    }
    //播放音效
    public void PlayAudioSource(string effectName)
    {
        if (enemyEffectsDictionary.ContainsKey(effectName))
        {
            enemyEffectsDictionary[effectName].audioSource.volume = AudioManager.instance.sfxVolumePercent * AudioManager.instance.masterVolumePercent * enemyEffectsDictionary[effectName].audioVolume;
            nowEnemyAudioName = effectName;
            enemyEffectsDictionary[effectName].audioSource.Play();
            OnDamege += OnDamegeAudioFuc;
        }
    }
    //停止音效
    public void StopAudioSource(string effectName)
    {
        if (enemyEffectsDictionary.ContainsKey(effectName))
        {
            OnDamege -= OnDamegeAudioFuc;
            StartCoroutine(StopAudioSource(enemyEffectsDictionary[effectName].audioSource, enemyEffectsDictionary[effectName].audioSourceLeaveTime));
        }
    }
    //受傷時停止音效
    protected void OnDamegeAudioFuc()
    {
        StopAudioSource(nowEnemyAudioName);
        nowEnemyAudioName = "";
    }

    protected IEnumerator StopAudioSource(AudioSource audioSource, float t)
    {
        float vol = audioSource.volume / t;
        while (audioSource.volume > 0)
        {
            audioSource.volume -= vol * Time.deltaTime;
            yield return null;
        }
        audioSource.Stop();
        yield return null;
    }

    public void OpenGhostEffect(int _b)
    {
        if (ghostEffect == null)
            return;
        ghostEffect.IsActive = (_b == 1) ? true : false;
    }

    void CloseGhostEffect()
    {
        ghostEffect.IsActive = false;
    }

    IEnumerator Setting(float t)
    {
        yield return new WaitForSeconds(t);
        if (anim != null)
        {
            overrideController = new AnimatorOverrideController(anim.runtimeAnimatorController);
            anim.runtimeAnimatorController = overrideController;
        }

        yield return null;
    }

    public void SetStraight(int _b)
    {
        walkStraight = (_b == 1) ? true : false;
    }

    public void StartCurveSpeed(string effectName)
    {
        if (enemyEffectsDictionary.ContainsKey(effectName))
        {
            StartCoroutine(StartAnimationCurveSpeed(enemyEffectsDictionary[effectName].animationCurveDurationTime, enemyEffectsDictionary[effectName].straight, enemyEffectsDictionary[effectName].animationCurve));
        }   
    }

    IEnumerator StartAnimationCurveSpeed(float d, int straight, AnimationCurve animationCurve)
    {
        float t = 0;
        SetStraight(straight);
        /*
        while (anim.GetCurrentAnimatorStateInfo(0).normalizedTime < 1.0f)
        {
            animationCurveSpeed = animationCurve.Evaluate(anim.GetCurrentAnimatorStateInfo(0).normalizedTime);
            Debug.Log(anim.GetCurrentAnimatorStateInfo(0).normalizedTime + " , " + animationCurveSpeed);
            yield return null;
        }
        animationCurveSpeed = animationCurve.Evaluate(1.0f);
        */
        while (t < d)
        {
            animationCurveSpeed = animationCurve.Evaluate(t / d);
            t += Time.deltaTime;
            yield return null;
        }
        
        SetStraight(0);
    }
    
    
    private void OnControllerColliderHit(ControllerColliderHit hit)
    {
        if(hit.collider.CompareTag("PlayerRigidbody"))
        {
            CharacterController cc = hit.collider.GetComponentInParent<CharacterController>();
            dir = cc.transform.position - transform.position;
            if (Vector3.Dot(dir.normalized, (mDir).normalized) >= 0.15f)
            {
                cc.Move(mDir);
            }

            //if (Vector3.Dot(dir.normalized, (mDir + addForceVity * Time.deltaTime).normalized) >= 0.2f)
            //{
            //    cc.Move(mDir + addForceVity * Time.deltaTime);
            //}
        }
    }

    public override void AnimatorAction()
    {
        base.AnimatorAction();
        walkStraight = false;
    }
}

[System.Serializable]
public class AnimationSet
{
    public AnimationClip animation;
    public float percent;
}

[System.Serializable]
public class AttackAnimationSet
{
    public float lifePercent;
    public AnimationSet[] animationSets;
}

[System.Serializable]
public class EnemyEffect
{
    public string enemyEffectName;
    public ParticleSystem[] particleSystems;
    public AudioSource audioSource;
    public float audioVolume = 1.0f;
    public float audioSourceLeaveTime = 0.3f;
    public int straight = 0;
    public float animationCurveDurationTime = 1.0f;
    public AnimationCurve animationCurve;
}