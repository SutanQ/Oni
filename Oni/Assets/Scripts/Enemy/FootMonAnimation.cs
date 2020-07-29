using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootMonAnimation : MonoBehaviour
{
    public Transform boyFoot;    //男腳
    public Transform girlFoot;   //女腳
    Animator boyAnim;            //男腳動畫
    Animator girlAnim;           //女腳動畫
    public Transform originPos;  //相對原點
    Coroutine boyCoroutine;
    Coroutine boyFadeCoroutine;
    Coroutine girlCoroutine;
    Coroutine girlFadeCoroutine;
    public SkinnedMeshRenderer boyRenderer;
    public SkinnedMeshRenderer girlRenderer;
    Material boyMaterial;
    Material girlMaterial;
    public GhostEffect boyGhostEffect;
    public GhostEffect girlGhostEffect;
    string boyActionName;             //現在這個動作的名字(用於被攻擊而中斷後，還原)
    string boyNextTriggerActionName;  //下個要進行Trigger動作的名字
    string girlActionName;            //現在這個動作的名字(用於被攻擊而中斷後，還原)
    string girlNextTriggerActionName; //下個要進行Trigger動作的名字
    bool boyLife = true;
    bool girlLife = true;
    Collider boyCollider;
    Collider girlCollider;
    Status boyStatus;
    Status girlStatus;
//    public event System.Action<Transform> BoyNextAction;
    public event System.Action BoyNextTriggerAction;
//    public event System.Action<Transform> GirlNextAction;
    public event System.Action GirlNextTriggerAction;
    public float idleMinTime = 2.0f;
    public float idleMaxTime = 5.0f;
    public float walkMinTime = 2.0f;
    public float walkMaxTime = 5.0f;
    public float actionCoolDownMinTime = 1.0f;
    public float actionCoolDownMaxTime = 3.0f;
    FootMonAnimationType boyFootMonAnimationType;
    FootMonAnimationType girlFootMonAnimationType;

    public float MaxRange = 15.0f;

    [Header("COOP")]
    public ParticleSystem COOP_particleSystem;
    bool COOP_Activity = false;
    bool COOP_flag = false;
    bool boy_COOP_activity = false;
    bool girl_COOP_activity = false;
    float COOP_particleHeight;
    Coroutine COOPcoroutine;

    [Header("Damege")]
    public Collider[] boyDamegeColliders;
    public Collider[] girlDamegeColliders;

    [Header("Walk")]
    public float WalkSpeed = 3.0f;
    public AnimationCurve walkCurve;

    [Header("Jump")]
    public float JumpHeight = 5;                 //跳躍高度
    public bool useJumpGhostEffect = true;       //是否使用跳躍殘影
    public float JumpGhostEffectRate = 0.2f;     //跳躍殘影的顯示頻率(數值越大，殘影越少)
    public float JumpGhostEffectLifeTime = 1.0f; //每個殘影的存活時間

    [Header("Circle")]
    public float duration = 5.0f;      //持續時間
    public float radius = 3.0f;        //最大半徑
    public AnimationCurve radiusCurve; //半徑曲線
    public float speed = 0.1f;         //最快速度
    public AnimationCurve speedCurve;  //速度曲線
    public bool useCircleGhostEffect = true;           //是否使用殘影
    public float circleGhostEffectRate = 0.08f;        //殘影的顯示頻率(數值越大，殘影越少)
    public float circleGhostEffectLifeTime = 0.5f;     //每個殘影的存活時間
    public ParticleSystem[] boyCircleParticleSystems;
    public ParticleSystem[] girlCircleParticleSystems;

    [Header("Straight")]
    public int RandomCount = 5;             //隨機點位的數量
    Transform[] randomPos;
    public Vector3 PositionRange;           //隨機生成的範圍
    public float straightWaitTime1 = 1.0f;  //起步的等待時間
    public float straightWaitTime2 = 0.3f;  //到定點後的等待時間 
    public float straightTime = 1.5f;       //走直線所花費的時間(秒)
    public float AlphaFadeTime = 0.5f;      //透明化所花費的時間(秒)
    public AnimationCurve straightCurve;    //直線行走速度的曲線
    public bool useStraightGhostEffect = true;           //是否使用殘影
    public float straightGhostEffectRate = 0.12f;        //殘影的顯示頻率(數值越大，殘影越少)
    public float straightGhostEffectLifeTime = 0.8f;     //每個殘影的存活時間
    public ParticleSystem[] boyStraightParticleSystems;
    public ParticleSystem[] girlStraightParticleSystems;

    [Header("Heart")]
    public float heart_duration = 5.0f;      //持續時間
    public float heart_size = 1.0f;          //愛心大小
    //public AnimationCurve radiusCurve; //半徑曲線
    public float heart_speed = 0.1f;         //最快速度
    public AnimationCurve heart_speedCurve;  //速度曲線
    public bool useHeartGhostEffect = true;           //是否使用殘影
    public float heartGhostEffectRate = 0.08f;        //殘影的顯示頻率(數值越大，殘影越少)
    public float heartGhostEffectLifeTime = 0.5f;     //每個殘影的存活時間
    public ParticleSystem[] boyHeartParticleSystems;
    public ParticleSystem[] girlHeartParticleSystems;

    float searchRange = 10.0f;
    float searchAngle = 160.0f;
    bool hasTarget = false;
    Transform playerGO;

    private void Awake()
    {
        randomPos = new Transform[RandomCount];
        for (int i = 0; i < randomPos.Length; i++)
        {
            GameObject g = new GameObject("Random" + i);
            g.transform.parent = transform;
            randomPos[i] = g.transform;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        playerGO = FindObjectOfType<Player>().transform;
        boyAnim = boyFoot.GetComponent<Animator>();
        girlAnim = girlFoot.GetComponent<Animator>();
        boyMaterial = boyRenderer.material;
        girlMaterial = girlRenderer.material;
        boyCollider = boyFoot.GetComponent<Collider>();
        girlCollider = girlFoot.GetComponent<Collider>();

        boyFoot.GetComponent<Damegeable>().OnDeath += OnBoyFootMonDie;
        girlFoot.GetComponent<Damegeable>().OnDeath += OnGirlFootMonDie;

        boyStatus = boyFoot.GetComponent<EnemyFootMon>().status;
        girlStatus = girlFoot.GetComponent<EnemyFootMon>().status;

        COOP_particleHeight = COOP_particleSystem.gameObject.transform.localPosition.y;

        //if(GameData.TimelineEventIsPlaying == TimelineState.End)
        StartAction();
    }
    /*
    private void OnEnable()
    {
        if(GameData.TimelineEventIsPlaying == TimelineState.Playing)
        {
            StartCoroutine(AfterTimeline());
        }
    }

    IEnumerator AfterTimeline()
    {
        while(GameData.TimelineEventIsPlaying != TimelineState.End)
        {
            yield return null;
        }
        Debug.Log("Start Action"); 
        StartAction();
        boyFoot.GetComponent<EnemyFootMon>().SetBossUI();
        girlFoot.GetComponent<EnemyFootMon>().SetBossUI();
    }
    */
    public void StartAction()
    {
        FootMonAnimationType footMonAnimationType = (FootMonAnimationType)Random.Range(0, System.Enum.GetValues(typeof(FootMonAnimationType)).Length - 1);
        //PlayFootMonAnimation(FootMonType.GirlFoot, footMonAnimationType, originPos);
        footMonAnimationType = (FootMonAnimationType)Random.Range(0, System.Enum.GetValues(typeof(FootMonAnimationType)).Length - 1);
        //PlayFootMonAnimation(FootMonType.BoyFoot, footMonAnimationType, originPos);

        PlayFootMonAnimation(FootMonType.GirlFoot, FootMonAnimationType.Heart, originPos);
        PlayFootMonAnimation(FootMonType.BoyFoot, FootMonAnimationType.Circle, originPos);

        //boyFoot.GetComponent<EnemyFootMon>().SetBossUI();
        //girlFoot.GetComponent<EnemyFootMon>().SetBossUI();
    }

    /// <summary>
    /// 執行行動
    /// </summary>
    /// <param name="footType">執行物件的類型(男腳或女腳)</param>
    /// <param name="footAnimationType">執行的動作</param>
    /// <param name="pos">目標物(Jump使用)</param>
    /// <param name="footMonAnimationTypeNext">下一個動作</param>
    public void PlayFootMonAnimation(FootMonType footType, FootMonAnimationType footAnimationType, Transform pos, FootMonAnimationType footMonAnimationTypeNext = FootMonAnimationType.Random)
    {
        //如果是合體技的話
        if (footAnimationType == FootMonAnimationType.COOP)
        {
            //如果有一方死亡，那麼就重新修正動作
            if (boyLife == false || girlLife == false)
                footAnimationType = (FootMonAnimationType)Random.Range(0, System.Enum.GetValues(typeof(FootMonAnimationType)).Length - 2);
        }

        //如果男女腳的動作相同則啟動合體特效。
        if (COOP_flag == true)
        {
            if (footType == FootMonType.BoyFoot)
            {
                if (footAnimationType == FootMonAnimationType.Heart || footAnimationType == FootMonAnimationType.Circle)
                    boy_COOP_activity = true;
            }
            else
            {
                if (footAnimationType == FootMonAnimationType.Heart || footAnimationType == FootMonAnimationType.Circle)
                    girl_COOP_activity = true;
            }

            if (boy_COOP_activity && girl_COOP_activity)
                StartCOOPParticle();
        }
        else
        {
            StopCOOPParticle();
        }

        if (footType == FootMonType.BoyFoot)
        {
            boyFootMonAnimationType = footAnimationType;
            if (boyCoroutine != null)
                StopCoroutine(boyCoroutine);
            if (Vector3.Distance(boyFoot.position, pos.position) > MaxRange)
                footAnimationType = FootMonAnimationType.JumpToTargetPos;

            switch (footAnimationType)
            {
                case FootMonAnimationType.Circle: boyCoroutine = StartCoroutine(CircleMovement(boyFoot, duration, boyAnim, boyCircleParticleSystems, boyGhostEffect, boyFoot.localPosition, true, footMonAnimationTypeNext)); break;
                case FootMonAnimationType.Heart: boyCoroutine = StartCoroutine(HeartMovement(boyFoot, heart_duration, boyAnim, boyHeartParticleSystems, boyGhostEffect, boyFoot.localPosition, true, footMonAnimationTypeNext)); break;
                case FootMonAnimationType.Straight: boyCoroutine = StartCoroutine(StraightMovement(boyFoot, boyMaterial, boyAnim, boyStraightParticleSystems, boyGhostEffect, true, footMonAnimationTypeNext)); break;
                case FootMonAnimationType.JumpToTargetPos: boyCoroutine = StartCoroutine(JumpToTargetPos(boyFoot, boyAnim, boyGhostEffect, pos.localPosition, pos.eulerAngles, true, footMonAnimationTypeNext)); break;
                case FootMonAnimationType.Idle: boyCoroutine = StartCoroutine(Idle(boyFoot, boyAnim, Random.Range(idleMinTime, idleMaxTime), footMonAnimationTypeNext)); break;
                case FootMonAnimationType.Walk: boyCoroutine = StartCoroutine(Walk(boyFoot, boyAnim, Random.Range(walkMinTime, walkMaxTime), SearchPlayer(), footMonAnimationTypeNext)); break;
                case FootMonAnimationType.COOP: StartCoroutine(COOP_Jump()); break;
                default: boyCoroutine = StartCoroutine(Walk(boyFoot, boyAnim, Random.Range(walkMinTime, walkMaxTime), SearchPlayer(), footMonAnimationTypeNext)); break;
            }
        }
        else
        {
            girlFootMonAnimationType = footAnimationType;
            if (girlCoroutine != null)
                StopCoroutine(girlCoroutine);
            if (Vector3.Distance(girlFoot.position, pos.position) > MaxRange)
                footAnimationType = FootMonAnimationType.JumpToTargetPos;
            switch (footAnimationType)
            {
                case FootMonAnimationType.Circle: girlCoroutine = StartCoroutine(CircleMovement(girlFoot, duration, girlAnim, girlCircleParticleSystems, girlGhostEffect, girlFoot.localPosition, true, footMonAnimationTypeNext)); break;
                case FootMonAnimationType.Heart: girlCoroutine = StartCoroutine(HeartMovement(girlFoot, heart_duration, girlAnim, girlHeartParticleSystems, girlGhostEffect, girlFoot.localPosition, true, footMonAnimationTypeNext)); break;
                case FootMonAnimationType.Straight: girlCoroutine = StartCoroutine(StraightMovement(girlFoot, girlMaterial, girlAnim, girlStraightParticleSystems, girlGhostEffect, true, footMonAnimationTypeNext)); break;
                case FootMonAnimationType.JumpToTargetPos: girlCoroutine = StartCoroutine(JumpToTargetPos(girlFoot, girlAnim, girlGhostEffect, pos.localPosition, pos.eulerAngles, true, footMonAnimationTypeNext)); break;
                case FootMonAnimationType.Idle: girlCoroutine = StartCoroutine(Idle(girlFoot, girlAnim, Random.Range(idleMinTime, idleMaxTime), footMonAnimationTypeNext)); break;
                case FootMonAnimationType.Walk: girlCoroutine = StartCoroutine(Walk(girlFoot, girlAnim, Random.Range(walkMinTime, walkMaxTime), SearchPlayer(), footMonAnimationTypeNext)); break;
                case FootMonAnimationType.COOP: StartCoroutine(COOP_Jump()); break;
                default: girlCoroutine = StartCoroutine(Walk(girlFoot, girlAnim, Random.Range(walkMinTime, walkMaxTime), SearchPlayer(), footMonAnimationTypeNext)); break;
            }
        }
    }

    /// <summary>
    /// 沿著目標初始位置的方向走(並非跟著目標)
    /// </summary>
    /// <param name="trans">啟動物</param>
    /// <param name="animator">啟動的animator</param>
    /// <param name="t">行走時間(秒)</param>
    /// <param name="target">目標物</param>
    /// <param name="footMonAnimationType">下一個動作</param>
    /// <returns></returns>
    IEnumerator Walk(Transform trans, Animator animator, float t, Transform target, FootMonAnimationType footMonAnimationType = FootMonAnimationType.Random)
    {
        PlayAnimation(animator, "ground");
        if (target != null)
        {
            float tt = 0;
            Vector3 dir = (new Vector3(target.position.x, 0, target.position.z) - new Vector3(trans.position.x, 0, trans.position.z)).normalized;
            float lerp = 0;
            trans.rotation = Quaternion.LookRotation(dir);
            while (tt < t)
            {
                lerp = walkCurve.Evaluate(tt / t);
                animator.SetFloat("Speed", lerp);

                trans.position += dir * lerp * WalkSpeed * Time.deltaTime;

                tt += Time.deltaTime;
                yield return null;
            }
        }

        PlayNextTriggerAction(trans, footMonAnimationType);
    }

    /// <summary>
    /// 朝著目標走
    /// </summary>
    /// <param name="trans">啟動物</param>
    /// <param name="animator">啟動的animator</param>
    /// <param name="t">為行走時間(秒)</param>
    /// <param name="target">目標物</param>
    /// <param name="turnToTargetRotation">是否在到達定點後旋轉同目標角度</param>
    /// <param name="footMonAnimationType">下一個動作</param>
    /// <returns></returns>
    IEnumerator WalkToTarget(Transform trans, Animator animator, float t, Transform target, bool turnToTargetRotation = false, FootMonAnimationType footMonAnimationType = FootMonAnimationType.Random)
    {
        PlayAnimation(animator, "ground");
        if (target != null)
        {
            float tt = 0;
            Vector3 startPos = trans.position;
            float lerp = 0;
            while (tt < t)
            {
                lerp = walkCurve.Evaluate(tt / t);
                animator.SetFloat("Speed", lerp);

                trans.position = Vector3.Lerp(startPos, target.position, tt / t);
                trans.rotation = Quaternion.LookRotation((target.position - trans.position).normalized);

                tt += Time.deltaTime;
                yield return null;
            }
            trans.position = target.position;
            //套用目標的面向
            if (turnToTargetRotation)
            {
                tt = 0;
                Vector3 startRotation = trans.eulerAngles;
                while (tt < 1.5f)
                {
                    trans.eulerAngles = Vector3.Lerp(startRotation, target.eulerAngles, tt / 1.5f);
                    tt += Time.deltaTime;
                    yield return null;
                }
                trans.eulerAngles = target.eulerAngles;
            }
        }

        PlayNextTriggerAction(trans, footMonAnimationType);
    }

    /// <summary>
    /// 為了使用合體技的跳躍(跳躍至原點後執行圓圈或直線攻擊)
    /// </summary>
    /// <returns></returns>
    IEnumerator COOP_Jump()
    {
        //隨機重設原點
        float r = Random.Range(0, 8);
        if (r <= 3)
            originPos.localPosition = Vector3.zero;
        else
        {
            originPos.localPosition = new Vector3(Random.Range(-r, r), 0, Random.Range(-r, r));
        }


        //初始化
        if (boyCoroutine != null)
            StopCoroutine(boyCoroutine);
        if (girlCoroutine != null)
            StopCoroutine(girlCoroutine);

        //初始化透明度
        if (boyMaterial.color.a < 1)
            StartCoroutine(AlphaUp(boyMaterial, 0.5f));
        if (girlMaterial.color.a < 1)
            StartCoroutine(AlphaUp(girlMaterial, 0.5f));

        //初始化粒子特效
        for (int i = 0; i < boyCircleParticleSystems.Length; i++)
            boyCircleParticleSystems[i].Stop();
        for (int i = 0; i < boyStraightParticleSystems.Length; i++)
            boyStraightParticleSystems[i].Stop();
        for (int i = 0; i < boyHeartParticleSystems.Length; i++)
            boyHeartParticleSystems[i].Stop();
        for (int i = 0; i < girlCircleParticleSystems.Length; i++)
            girlCircleParticleSystems[i].Stop();
        for (int i = 0; i < girlStraightParticleSystems.Length; i++)
            girlStraightParticleSystems[i].Stop();
        for (int i = 0; i < girlHeartParticleSystems.Length; i++)
            girlHeartParticleSystems[i].Stop();

        //初始化動畫
        PlayAnimation(boyAnim, "ground");
        PlayAnimation(girlAnim, "ground");
        COOP_flag = true;
        boy_COOP_activity = false;
        girl_COOP_activity = false;
        int rnd = ((int)Random.Range(0, 2));

        if (rnd == 1)
        {
            PlayFootMonAnimation(FootMonType.BoyFoot, FootMonAnimationType.JumpToTargetPos, originPos, FootMonAnimationType.Circle);
            PlayFootMonAnimation(FootMonType.GirlFoot, FootMonAnimationType.JumpToTargetPos, originPos, FootMonAnimationType.Circle);
        }
        else
        {
            PlayFootMonAnimation(FootMonType.BoyFoot, FootMonAnimationType.JumpToTargetPos, originPos, FootMonAnimationType.Heart);
            PlayFootMonAnimation(FootMonType.GirlFoot, FootMonAnimationType.JumpToTargetPos, originPos, FootMonAnimationType.Heart);
        }

        yield return null;
    }

    /// <summary>
    /// 搜尋玩家
    /// </summary>
    /// <returns></returns>
    public Transform SearchPlayer()
    {
        if (playerGO == null)
            return null;

        Vector3 dir = (playerGO.position - transform.position).normalized;

        if (Vector3.Distance(transform.position, playerGO.position) < searchRange)
        {
            float angle = Mathf.Acos(Vector3.Dot(dir, transform.forward) / (dir.sqrMagnitude * transform.forward.sqrMagnitude)) * 180 / Mathf.PI;

            if (Mathf.Abs(angle) <= searchAngle * 0.5f)
            {
                hasTarget = true;
                return playerGO;
            }
        }

        return null;
    }

    /// <summary>
    /// 行動:停留
    /// </summary>
    /// <param name="trans">停留物件</param>
    /// <param name="animator">停留物件的Animator</param>
    /// <param name="t">停留時間</param>
    /// <param name="footMonAnimationType">下一個動作</param>
    /// <returns></returns>
    IEnumerator Idle(Transform trans, Animator animator, float t, FootMonAnimationType footMonAnimationType = FootMonAnimationType.Random)
    {
        PlayAnimation(animator, "ground");

        float tt = 0;
        while (tt < t)
        {
            tt += Time.deltaTime;
            yield return null;
        }

        PlayNextTriggerAction(trans, footMonAnimationType);
    }

    /// <summary>
    /// 材質淡出或淡入
    /// </summary>
    /// <param name="material">材質</param>
    /// <param name="fadeType">淡出或淡入</param>
    /// <returns></returns>
    IEnumerator Fade(Material material, FadeType fadeType)
    {
        float t = 0;
        Color color = material.color;
        while(t < AlphaFadeTime)
        {
            if (fadeType == FadeType.FadeIn)
                material.color = new Color(color.r, color.g, color.b, t / AlphaFadeTime);
            else
                material.color = new Color(color.r, color.g, color.b, 1 - (t / AlphaFadeTime));

            t += Time.deltaTime;
            yield return null;
        }
        if(fadeType == FadeType.FadeIn)
            material.color = new Color(color.r, color.g, color.b, 1);
        else
            material.color = new Color(color.r, color.g, color.b, 0);
    }

    /// <summary>
    /// 隨機設定點位
    /// </summary>
    public void SetRandomPos()
    {
        Vector3 pos;
        for (int i = 0; i < randomPos.Length; i++)
        {
            pos = new Vector3(Random.Range(-PositionRange.x, PositionRange.x), Random.Range(-PositionRange.y, PositionRange.y), Random.Range(-PositionRange.z, PositionRange.z));
            randomPos[i].localPosition = pos;
        }
    }

    /// <summary>
    /// 行動:圓圈攻擊
    /// </summary>
    /// <param name="trans">啟動物件</param>
    /// <param name="t">攻擊持續時間</param>
    /// <param name="anim">啟動物件的Animator</param>
    /// <param name="particleSystems">粒子特效</param>
    /// <param name="ghostEffect">殘影特效</param>
    /// <param name="oPos">圓圈中心點位置</param>
    /// <param name="useWaitTime">行動前是否有等待時間</param>
    /// <param name="footMonAnimationType">下一個動作</param>
    /// <returns></returns>
    IEnumerator CircleMovement(Transform trans, float t, Animator anim, ParticleSystem[] particleSystems, GhostEffect ghostEffect, Vector3 oPos, bool useWaitTime = true, FootMonAnimationType footMonAnimationType = FootMonAnimationType.Random)
    {
        float tt = 0;   //目前時間
        float x = 0;    //X座標
        float z = 0;    //Z座標
        float r = 0;    //半徑
        float s = 0;    //速度值
        float p = 0;    //時間百分比
        float deg = 0;  //旋轉角度

        //前置等待時間
        if (useWaitTime)
        {
            float waitTime = Random.Range(actionCoolDownMinTime, actionCoolDownMaxTime);
            tt = 0;
            while (tt < waitTime)
            {
                tt += Time.deltaTime;
                yield return null;
            }
        }

        tt = 0;
        //添加受傷函式
        EnemyFootMon enemyFootMon = trans.GetComponent<EnemyFootMon>();
        if(trans == boyFoot)
            enemyFootMon.OnDamege += OnBoyDamegeWhenCircle;
        else
            enemyFootMon.OnDamege += OnGirlDamegeWhenCircle;
        PlayAnimation(anim, "kick");

        //啟動粒子特效
        for (int i = 0; i < particleSystems.Length; i++)
            particleSystems[i].Play();
        yield return new WaitForSeconds(1.0f);
        //啟動殘影
        if(useCircleGhostEffect)
        {
            ghostEffect.IsActive = true;
            ghostEffect.rate = circleGhostEffectRate;
            ghostEffect.lifeTime = circleGhostEffectLifeTime;
        }

        while (tt < t)
        {
            //計算基本數據
            p = tt / t;
            r = radiusCurve.Evaluate(p);
            s = speedCurve.Evaluate(p);
            deg += Mathf.Rad2Deg * speed * s * Time.deltaTime;

            //計算位置座標
            x = oPos.x + r * radius * Mathf.Cos(deg);
            z = oPos.z + r * radius * Mathf.Sin(deg);

            //更新Local座標及方向
            trans.localPosition = new Vector3(x, oPos.y, z);
            trans.rotation = Quaternion.LookRotation((oPos - trans.localPosition).normalized);
            trans.localEulerAngles = new Vector3(trans.eulerAngles.x, trans.eulerAngles.y + 90.0f, trans.eulerAngles.z);

            tt += Time.deltaTime;
            yield return null;
        }
        PlayAnimation(anim, "ground");
        //關閉殘影
        if (useCircleGhostEffect)
            ghostEffect.IsActive = false;
        //關閉粒子特效
        for (int i = 0; i < particleSystems.Length; i++)
            particleSystems[i].Stop();
        //減去受傷函式
        if (trans == boyFoot)
            enemyFootMon.OnDamege -= OnBoyDamegeWhenCircle;
        else
            enemyFootMon.OnDamege -= OnGirlDamegeWhenCircle;

        //執行下個動作
        PlayNextTriggerAction(trans, footMonAnimationType);
    }

    /// <summary>
    /// 行動:愛心攻擊
    /// </summary>
    /// <param name="trans">啟動物件</param>
    /// <param name="t">攻擊持續時間</param>
    /// <param name="anim">啟動物件的Animator</param>
    /// <param name="particleSystems">粒子特效</param>
    /// <param name="ghostEffect">殘影特效</param>
    /// <param name="oPos">圓圈中心點位置</param>
    /// <param name="useWaitTime">行動前是否有等待時間</param>
    /// <param name="footMonAnimationType">下一個動作</param>
    /// <returns></returns>
    IEnumerator HeartMovement(Transform trans, float t, Animator anim, ParticleSystem[] particleSystems, GhostEffect ghostEffect, Vector3 oPos, bool useWaitTime = true, FootMonAnimationType footMonAnimationType = FootMonAnimationType.Random)
    {
        float tt = 0;   //目前時間
        float x = 0;    //X座標
        float z = 0;    //Z座標
        float p = 0;    //時間百分比

        //前置等待時間
        if (useWaitTime)
        {
            float waitTime = Random.Range(actionCoolDownMinTime, actionCoolDownMaxTime);
            tt = 0;
            while (tt < waitTime)
            {
                tt += Time.deltaTime;
                yield return null;
            }
        }

        tt = 0;
        //添加受傷函式
        EnemyFootMon enemyFootMon = trans.GetComponent<EnemyFootMon>();
        if (trans == boyFoot)
            enemyFootMon.OnDamege += OnBoyDamegeWhenCircle;
        else
            enemyFootMon.OnDamege += OnGirlDamegeWhenCircle;
        PlayAnimation(anim, "kick");

        //啟動粒子特效
        for (int i = 0; i < particleSystems.Length; i++)
            particleSystems[i].Play();
        yield return new WaitForSeconds(1.0f);
        //啟動殘影
        if (useHeartGhostEffect)
        {
            ghostEffect.IsActive = true;
            ghostEffect.rate = heartGhostEffectRate;
            ghostEffect.lifeTime = heartGhostEffectLifeTime;
        }

        //先走到愛心的起點
        tt = 0;
        Vector3 startPos = trans.localPosition;
        Vector3 targetPos = new Vector3(oPos.x + 16 * Mathf.Pow(Mathf.Sin(0), 3) * heart_size, oPos.y, oPos.z - (13 * Mathf.Cos(0) - 5 * Mathf.Cos(0) - 2 * Mathf.Cos(0) - Mathf.Cos(0)) * heart_size);
        trans.rotation = Quaternion.LookRotation((targetPos - startPos).normalized);
        Vector3 startRotation = trans.localEulerAngles;
        Vector3 targetRotation = new Vector3(trans.eulerAngles.x, trans.eulerAngles.y, trans.eulerAngles.z);
        //trans.localEulerAngles = new Vector3(trans.eulerAngles.x, trans.eulerAngles.y, trans.eulerAngles.z);
        while (tt < 1.0f)
        {
            trans.localPosition = Vector3.Lerp(startPos, targetPos, tt / 1.0f);
            trans.localEulerAngles = Vector3.Lerp(startRotation, targetRotation, tt / 1.0f);
            tt += Time.deltaTime;
            yield return null;
        }

        tt = 0;
        float ttt = 0;
        while (tt < t)
        {
            //計算基本數據
            p = tt / t;
            //r = radiusCurve.Evaluate(p);
            //s = speedCurve.Evaluate(p);
            //deg += Mathf.Rad2Deg * speed * s * Time.deltaTime;
            ttt += tt * heart_speed * heart_speedCurve.Evaluate(p) * Time.deltaTime;

            //計算位置座標
            x = oPos.x + 16 * Mathf.Pow(Mathf.Sin(ttt), 3) * heart_size;
            z = oPos.z - (13 * Mathf.Cos(ttt) - 5 * Mathf.Cos(2 * ttt) - 2 * Mathf.Cos(3 * ttt) - Mathf.Cos(4 * ttt)) * heart_size;

            //更新Local座標及方向
            trans.localPosition = new Vector3(x, oPos.y, z);
            trans.rotation = Quaternion.LookRotation((oPos - trans.localPosition).normalized);
            trans.localEulerAngles = new Vector3(trans.eulerAngles.x, trans.eulerAngles.y + 180, trans.eulerAngles.z);

            tt += Time.deltaTime;
            yield return null;
        }
        PlayAnimation(anim, "ground");
        //關閉殘影
        if (useHeartGhostEffect)
            ghostEffect.IsActive = false;
        //關閉粒子特效
        for (int i = 0; i < particleSystems.Length; i++)
            particleSystems[i].Stop();
        //減去受傷函式
        if (trans == boyFoot)
            enemyFootMon.OnDamege -= OnBoyDamegeWhenCircle;
        else
            enemyFootMon.OnDamege -= OnGirlDamegeWhenCircle;

        //執行下個動作
        PlayNextTriggerAction(trans, footMonAnimationType);
    }

    /// <summary>
    /// 行動:直線攻擊
    /// </summary>
    /// <param name="trans">啟動物件</param>
    /// <param name="material">材質</param>
    /// <param name="anim">啟動物件的Animator</param>
    /// <param name="particleSystems">粒子特效</param>
    /// <param name="ghostEffect">殘影特效</param>
    /// <param name="useWaitTime">行動前是否有等待時間</param>
    /// <param name="footMonAnimationType">下一個動作</param>
    /// <returns></returns>
    IEnumerator StraightMovement(Transform trans, Material material, Animator anim, ParticleSystem[] particleSystems, GhostEffect ghostEffect, bool useWaitTime = true, FootMonAnimationType footMonAnimationType = FootMonAnimationType.Random)
    {
        //是否有前置等待時間
        if(useWaitTime)
        {
            float waitTime = Random.Range(actionCoolDownMinTime, actionCoolDownMaxTime);
            float t = 0;
            while (t < waitTime)
            {
                t += Time.deltaTime;
                yield return null;
            }
        }

        //隨機設定點位
        SetRandomPos();

        float alphaTime = 0;
        Color color = material.color;
        float tt = 0;
        Vector3 pos;
        Vector3 targetPos;
        for (int i = 0; i < randomPos.Length; i++)
        {
            PlayAnimation(anim, "ground");

            ////FadeOut
            alphaTime = 0;
            if (trans == boyFoot)
                boyCollider.enabled = false;
            else
                girlCollider.enabled = false;
            while (alphaTime < AlphaFadeTime)
            {
                material.color = new Color(color.r, color.g, color.b, 1 - (alphaTime / AlphaFadeTime));
                alphaTime += Time.deltaTime;
                yield return null;
            }
            material.color = new Color(color.r, color.g, color.b, 0);

            yield return new WaitForSeconds(straightWaitTime1);
            PlayAnimation(anim, "kick");

            //新位置並朝向下一個點位
            trans.position = randomPos[i].position;
            if((i + 2) < randomPos.Length)
                targetPos = randomPos[i + 2].position;
            else
                targetPos = randomPos[0].position;
            trans.rotation = Quaternion.LookRotation((targetPos - trans.position).normalized);

            ////FadeIn
            alphaTime = 0;
            while (alphaTime < AlphaFadeTime)
            {
                material.color = new Color(color.r, color.g, color.b, alphaTime / AlphaFadeTime);
                alphaTime += Time.deltaTime;
                yield return null;
            }
            material.color = new Color(color.r, color.g, color.b, 1);
            if (trans == boyFoot)
                boyCollider.enabled = true;
            else
                girlCollider.enabled = true;

            yield return new WaitForSeconds(straightWaitTime2);
            //啟動粒子特效
            for (int j = 0; j < particleSystems.Length; j++)
                particleSystems[j].Play();
            //啟動殘影
            if (useStraightGhostEffect)
            {
                ghostEffect.IsActive = true;
                ghostEffect.rate = straightGhostEffectRate;
                ghostEffect.lifeTime = straightGhostEffectLifeTime;
            }

            //直線移動
            tt = 0;
            pos = trans.position;
            while (tt < straightTime)
            {
                trans.position = Vector3.Lerp(pos, targetPos, straightCurve.Evaluate(tt / straightTime));
                tt += Time.deltaTime;
                yield return null;
            }

            //關閉殘影
            if (useStraightGhostEffect)
                ghostEffect.IsActive = false;
            //關閉粒子特效
            for (int j = 0; j < particleSystems.Length; j++)
                particleSystems[j].Stop();
            trans.position = targetPos;
            PlayAnimation(anim, "ground");
        }
        
        //執行下個動作
        PlayNextTriggerAction(trans, footMonAnimationType);
    }

    /// <summary>
    /// 行動:跳躍至定點
    /// </summary>
    /// <param name="trans">啟動物件</param>
    /// <param name="anim">啟動物件的Animator</param>
    /// <param name="ghostEffect">殘影</param>
    /// <param name="targetPos">目標物位置</param>
    /// <param name="targetRotation">目標物角度</param>
    /// <param name="useWaitTime">行動前是否有等待時間</param>
    /// <param name="footMonAnimationType">下一個動作</param>
    /// <returns></returns>
    IEnumerator JumpToTargetPos(Transform trans, Animator anim, GhostEffect ghostEffect, Vector3 targetPos, Vector3 targetRotation, bool useWaitTime = true, FootMonAnimationType footMonAnimationType = FootMonAnimationType.Random)
    {
        float t = 0;
        //行動前的等待時間
        if (useWaitTime)
        {
            //與下個動作的間隔時間
            float waitTime = Random.Range(actionCoolDownMinTime, actionCoolDownMaxTime);
            t = 0;
            while (t < waitTime)
            {
                t += Time.deltaTime;
                yield return null;
            }
        }
        t = 0;
        yield return new WaitForSeconds(0.01f);
        //起跳動作
        PlayAnimation(anim, "jump");
        //計算跳躍至原點的初速及時間
        LaunchData launchData = CalculateVelocity(trans, targetPos);
        
        Vector3 pos = trans.localPosition;
        yield return new WaitForSeconds(0.2f);
        //使用殘影
        if (useJumpGhostEffect)
        {
            ghostEffect.IsActive = true;
            ghostEffect.rate = JumpGhostEffectRate;
            ghostEffect.lifeTime = JumpGhostEffectLifeTime;
        }
        //跳躍軌跡
        while (t < launchData.timeToTarget)
        {
            Vector3 displacement = launchData.initialVelocity * t + Physics.gravity * t * t / 2f;
            trans.localPosition = pos + displacement;
            trans.localEulerAngles = Vector3.Lerp(trans.localEulerAngles, targetRotation, t / launchData.timeToTarget);
            t += Time.deltaTime;
            yield return null;
        }
        //關閉殘影
        if(useJumpGhostEffect)
            ghostEffect.IsActive = false;
        trans.localPosition = targetPos;
        trans.localEulerAngles = targetRotation;
        //落地動作
        PlayAnimation(anim, "jumpLand");

        //執行下個動作
        PlayNextTriggerAction(trans, footMonAnimationType);
    }

    /// <summary>
    /// 計算跳躍使用的初速及花費時間
    /// </summary>
    /// <param name="trans">起點</param>
    /// <param name="originPos">目標點</param>
    /// <returns>初速及花費時間</returns>
    LaunchData CalculateVelocity(Transform trans, Vector3 originPos)
    {
        float dY = originPos.y - trans.localPosition.y;
        Vector3 dXZ = new Vector3(originPos.x - trans.localPosition.x, 0, originPos.z - trans.localPosition.z);
        float time = Mathf.Sqrt(-2 * JumpHeight / Physics.gravity.y) + Mathf.Sqrt(2 * (dY - JumpHeight) / Physics.gravity.y);
        Vector3 velocityY = Vector3.up * Mathf.Sqrt(-2 * Physics.gravity.y * JumpHeight);
        Vector3 velocityXZ = dXZ / time;
        return new LaunchData(velocityY + velocityXZ, time);
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireCube(transform.position, new Vector3(PositionRange.x * transform.localScale.x, PositionRange.y * transform.localScale.y, PositionRange.z * transform.localScale.z) * 2);
    }


    /// <summary>
    /// 執行下個動作
    /// </summary>
    /// <param name="trans">啟動物件</param>
    /// <param name="footMonAnimationType">下個動作</param>
    public void PlayNextTriggerAction(Transform trans, FootMonAnimationType footMonAnimationType = FootMonAnimationType.Random)
    {
        if (trans == boyFoot)
        {
            //如果有已經預定要執行的動作
            if (BoyNextTriggerAction != null)
            {
                BoyNextTriggerAction();
            }
            else if(footMonAnimationType == FootMonAnimationType.Random)
            {
                //隨機執行下個動作
                FootMonAnimationType footMonAnimationType2 = (FootMonAnimationType)Random.Range(0, System.Enum.GetValues(typeof(FootMonAnimationType)).Length - 1);
                PlayFootMonAnimation(FootMonType.BoyFoot, footMonAnimationType2, originPos);
            }
            else
            {
                PlayFootMonAnimation(FootMonType.BoyFoot, footMonAnimationType, originPos);
            }
        }
        else
        {
            //如果有已經預定要執行的動作
            if (GirlNextTriggerAction != null)
            {
                GirlNextTriggerAction();
            }
            else if (footMonAnimationType == FootMonAnimationType.Random)
            {
                //隨機執行下個動作
                FootMonAnimationType footMonAnimationType2 = (FootMonAnimationType)Random.Range(0, System.Enum.GetValues(typeof(FootMonAnimationType)).Length - 1);
                PlayFootMonAnimation(FootMonType.GirlFoot, footMonAnimationType2, originPos);
            }
            else
            {
                PlayFootMonAnimation(FootMonType.GirlFoot, footMonAnimationType, originPos);
            }
        }
    }

    /// <summary>
    /// 當男腳死亡所執行的函式
    /// </summary>
    public void OnBoyFootMonDie()
    {
        //停止男腳的Coroutine
        if (boyCoroutine != null)
            StopCoroutine(boyCoroutine);
        boyGhostEffect.IsActive = false;  //關閉殘影
        boyLife = false;                  //設為死亡
        boyCollider.enabled = false;      //關閉Collider
        //如果是透明的話就重設至不透明
        if (boyMaterial.color.a < 1)
            StartCoroutine(AlphaUp(boyMaterial, 0.5f));
        //如果女腳先死亡
        if (!boyLife && !girlLife)
        {
            //先將死亡動畫改為非死亡
            PlayAnimation(boyAnim, "undie");
            //設定下一個要執行的動作(死亡動畫)
            boyNextTriggerActionName = "die";
            BoyNextTriggerAction += OnBoyNextTriggerAction;
            //跳躍至女腳旁，爾後便執行上方的動作(死亡動畫)
            boyCoroutine = StartCoroutine(JumpToTargetPos(boyFoot, boyAnim, boyGhostEffect, girlFoot.localPosition, girlFoot.localEulerAngles, false));
            //StartCoroutine(PlayTimeline(5.5f));
        }
    }

    /// <summary>
    /// 當女腳死亡所執行的函式
    /// </summary>
    public void OnGirlFootMonDie()
    {
        //停止女腳的Coroutine
        if (girlCoroutine != null)
            StopCoroutine(girlCoroutine);
        girlGhostEffect.IsActive = false;  //關閉殘影
        girlLife = false;                  //設為死亡
        girlCollider.enabled = false;      //關閉Collider
        //如果是透明的話就重設至不透明
        if (girlMaterial.color.a < 1)
            StartCoroutine(AlphaUp(girlMaterial, 0.5f));
        //如果男腳先死亡
        if (!boyLife && !girlLife)
        {
            //先將死亡動畫改為非死亡
            PlayAnimation(girlAnim, "undie");
            //設定下一個要執行的動作(死亡動畫)
            girlNextTriggerActionName = "die";
            GirlNextTriggerAction += OnGirlNextTriggerAction;
            //走路至男腳旁，爾後便執行上方的動作(死亡動畫)
            girlCoroutine = StartCoroutine(WalkToTarget(girlFoot, girlAnim, 3.5f, boyFoot, true));
            //StartCoroutine(PlayTimeline(5.5f));
        }
    }

    /*
    IEnumerator PlayTimeline(float f)
    {
        yield return new WaitForSeconds(f);

        if (timelineTrigger != null)
            timelineTrigger.Play();
        else if (GameData.endTimelineTrigger != null)
            GameData.endTimelineTrigger.Play();
    }
    */

    /// <summary>
    /// 提升材質透明度至1.0
    /// </summary>
    /// <param name="material">材質</param>
    /// <param name="t">花費時間</param>
    /// <returns></returns>
    IEnumerator AlphaUp(Material material, float t)
    {
        float tt = 0;
        Color alpha = material.color;
        Color target = new Color(alpha.r, alpha.g, alpha.b, 1);
        while (tt < t)
        {
            material.color = Color.Lerp(alpha, target, tt / t);
            tt += Time.deltaTime;
            yield return null;
        }
        material.color = target;
    }

    /// <summary>
    /// 設定Animator的Trigger
    /// </summary>
    /// <param name="animator">啟動物的Animator</param>
    /// <param name="actionName">Trigger Name</param>
    public void PlayAnimation(Animator animator, string actionName)
    {
        animator.SetTrigger(actionName);

        //設定物件的Damege Collider是否開啟
        if (animator == boyAnim)
        {
            //將現在執行的動作名稱記錄下來，當受到傷害而啟動OnBoyDamegeWhenCircle時會重新執行該動作
            boyActionName = actionName;  
            //如果是kick動作則開啟
            if (actionName == "kick")
                SetDamegeEnable(boyFoot, true);
            else
                SetDamegeEnable(boyFoot, false);
        }
        else
        {
            //將現在執行的動作名稱記錄下來，當受到傷害而啟動OnGirlDamegeWhenCircle時會重新執行該動作
            girlActionName = actionName;
            //如果是kick動作則開啟
            if (actionName == "kick")
                SetDamegeEnable(girlFoot, true);
            else
                SetDamegeEnable(girlFoot, false);
        }

        //如果男女腳的動作相同則啟動合體特效。
        //if (boyActionName == girlActionName)
        //if (COOP_flag == true && boyFootMonAnimationType == girlFootMonAnimationType && (boyFootMonAnimationType == FootMonAnimationType.Heart || boyFootMonAnimationType == FootMonAnimationType.Circle || boyFootMonAnimationType == FootMonAnimationType.Straight))
        /*
        if (COOP_flag == true)
        {
            if (animator == boyAnim)
            {
                if (boyFootMonAnimationType == FootMonAnimationType.Heart || boyFootMonAnimationType == FootMonAnimationType.Circle || boyFootMonAnimationType == FootMonAnimationType.Straight)
                    boy_COOP_activity = true;
            }
            else
            {
                if(girlFootMonAnimationType == FootMonAnimationType.Heart || girlFootMonAnimationType == FootMonAnimationType.Circle || girlFootMonAnimationType == FootMonAnimationType.Straight)
                    girl_COOP_activity = true;
            }

            if (boy_COOP_activity && girl_COOP_activity)
                StartCOOPParticle();
        }
        else
        {
            StopCOOPParticle();
        }
        */
    }

    void StartCOOPParticle()
    {
        COOP_Activity = true;
        COOP_flag = false;
        if (COOPcoroutine != null)
            StopCoroutine(COOPcoroutine);
        COOP_particleSystem.Play();
        COOPcoroutine = StartCoroutine(COOP());
    }

    void StopCOOPParticle()
    {
        COOP_Activity = false;
        boy_COOP_activity = false;
        girl_COOP_activity = false;
        COOP_particleSystem.Stop();
    }

    IEnumerator COOP()
    {
        while(COOP_Activity)
        {
            COOP_particleSystem.transform.position = (boyFoot.position + girlFoot.position) * 0.5f + COOP_particleHeight * Vector3.up;
            yield return null;
        }
    }

    /// <summary>
    /// 男腳受傷函式
    /// </summary>
    public void OnBoyDamegeWhenCircle()
    {
        boyAnim.SetTrigger(boyActionName);
    }

    /// <summary>
    /// 女腳受傷函式
    /// </summary>
    public void OnGirlDamegeWhenCircle()
    {
        girlAnim.SetTrigger(girlActionName);
    }

    public void OnBoyNextTriggerAction()
    {
        BoyNextTriggerAction -= OnBoyNextTriggerAction;
        PlayAnimation(boyAnim, boyNextTriggerActionName);
    }

    public void OnGirlNextTriggerAction()
    {
        GirlNextTriggerAction -= OnGirlNextTriggerAction;
        PlayAnimation(girlAnim, girlNextTriggerActionName);
    }

    /// <summary>
    /// 設定Damege Collider
    /// </summary>
    /// <param name="trans">啟動物(男腳或女腳)</param>
    /// <param name="b">啟動或關閉</param>
    public void SetDamegeEnable(Transform trans, bool b)
    {
        if(trans == boyFoot)
        {
            for (int i = 0; i < boyDamegeColliders.Length; i++)
                boyDamegeColliders[i].enabled = b;
        }
        else
        {
            
            for (int i = 0; i < girlDamegeColliders.Length; i++)
                girlDamegeColliders[i].enabled = b;
        }
    }

    struct LaunchData
    {
        public readonly Vector3 initialVelocity;
        public readonly float timeToTarget;

        public LaunchData(Vector3 i, float t)
        {
            this.initialVelocity = i;
            this.timeToTarget = t;
        }
    }  
}
public enum FootMonType { BoyFoot, GirlFoot};
public enum FootMonAnimationType { Circle , Straight, JumpToTargetPos, Idle, Walk, Heart, COOP, Random};
public enum FadeType { FadeOut, FadeIn};