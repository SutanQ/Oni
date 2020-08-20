using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.InputSystem;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    [Tooltip("玩家的輸入系統")]
    public PlayerInput playerInput;
    [Tooltip("目前遊戲的狀態")]
    public GameState gameState;

    Coroutine timeScaleCoroutine;
    Coroutine witchTimeScaleCoroutine;
    [Tooltip("是否在魔女時間狀態裡")]
    public bool inWitchTime = false;
    [Tooltip("魔女時間使用的後處理特效")]
    public Volume witchVolume;
    [Tooltip("其他特定使用的後處理特效(AttackStateMachine->useVolume會使用)")]
    public Volume[] volumes;
    Coroutine volumeCoroutine;

    [Header("Ground Impact")]
    [Tooltip("落地的傷害值")]
    public int GroundDamage = 5;
    [Tooltip("落地彈跳的幅度")]
    public float GroundBoundForce = 3;
    [Tooltip("產生落地傷害的門檻值(Y軸速度)")]
    public float GroundImpact_ForceTrashold = -4.0f;
    [Tooltip("落地產生的攝影機晃動")]
    public float GroundCameraShakeStrength = 1.0f;
    [Tooltip("落地攻擊的擊中特效")]
    public GameObject VFX_ImpactHitPrefab;
    [Tooltip("落地攻擊的落地特效")]
    public GameObject VFX_GroundImpactPrefab;

    [Header("UI")]
    [Tooltip("血量UI顯示的持續時間")]
    public float UI_HP_Time = 3.0f;     //UI顯示時間
    [Tooltip("血量UI扣血變化的速度")]
    public float UI_HP_duration = 0.2f; //血條變化速度

    [Header("Motor")]
    [Tooltip("玩家被攻擊時要產生震動的傷害門檻值")]
    public int PlayerTakeDmgMotorThreshold = 3;
    [Tooltip("玩家被攻擊時要產生震動的震幅")]
    public Vector2 PlayerTakeDmgMotor = new Vector2(0.3f, 0.3f);
    [Tooltip("玩家攻擊怪物時要產生震動的傷害門檻值")]
    public int EnemyTakeDmgMotorThreshold = 3;
    [Tooltip("玩家攻擊怪物時要產生震動的震幅")]
    public Vector2 EnemyTakeDmgMotor = new Vector2(0.2f, 0.2f);
    int MotorThreshold = 3;
    Coroutine motorCoroutine;

    private void Awake()
    {
        if (Instance == null)
            Instance = this;
        else
            Destroy(this);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    /// <summary>
    /// 玩家被攻擊時的手把震動
    /// </summary>
    /// <param name="dmg">傷害值會影響震幅</param>
    public void PlayerTakeDamageMotor(int dmg)
    {
        float m = Mathf.Clamp((float)dmg / MotorThreshold, 1.0f, 2.0f);
        SetGamePadMotor(0.1f, PlayerTakeDmgMotor.x * m, PlayerTakeDmgMotor.y * m);
    }

    /// <summary>
    /// 怪物被玩家攻擊時的手把震動
    /// </summary>
    /// <param name="dmg">傷害值會影響震幅</param>
    public void EnemyTakeDamageMotor(int dmg)
    {
        float m = Mathf.Clamp((float)dmg / MotorThreshold, 1.0f, 2.0f);
        SetGamePadMotor(0.1f, EnemyTakeDmgMotor.x * m, EnemyTakeDmgMotor.y * m);
    }

    /// <summary>
    /// 手把震動
    /// </summary>
    /// <param name="duration">持續時間</param>
    /// <param name="low">低頻率震幅</param>
    /// <param name="high">高頻率震幅</param>
    public void SetGamePadMotor(float duration, float low, float high)
    {
        if (motorCoroutine != null)
            StopCoroutine(motorCoroutine);
        motorCoroutine = StartCoroutine(DoGamePadMotor(duration, low, high));
    }

    IEnumerator DoGamePadMotor(float duration, float low, float hight)
    {
        float t = 0;
        Gamepad.current.SetMotorSpeeds(low, hight);
        while (t < duration)
        {
            float p = t / duration;
            float l = Mathf.Lerp(low, 0, p);
            float h = Mathf.Lerp(hight, 0, p);
            Gamepad.current.SetMotorSpeeds(l, h);
            t += Time.deltaTime;
            yield return null;
        }
        Gamepad.current.SetMotorSpeeds(0, 0);
    }

    // Update is called once per frame
    void Update()
    {
        //Command();

        //Debug.Log("Real Time:" + Time.realtimeSinceStartup + " TimeScale:" + Time.timeScale + " Delta:" + Time.deltaTime);
    }
    /*
    public void Command()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            GamePause();
        }
    }
    */

    public void GamePause()
    {
        if(gameState == GameState.GamePause)
        {
            Time.timeScale = 1.0f;
            gameState = GameState.GamePlaying;
        }
        else
        {
            Time.timeScale = 0.0f;
            gameState = GameState.GamePause;
        }
    }

    /// <summary>
    /// 擊中產生時間停頓的效果
    /// </summary>
    /// <param name="startTimeScale">擊中時的初始TimeScale</param>
    /// <param name="hitDuration">持續時間</param>
    public void DoHitTimeScale(float startTimeScale, float hitDuration)
    {
        SetTimeScale(startTimeScale, 1.0f, hitDuration, false);
    }

    /// <summary>
    /// 設定TimeScale
    /// </summary>
    /// <param name="startScale">初始TimeScale</param>
    /// <param name="endScale">結束TimeScale</param>
    /// <param name="duration">持續時間</param>
    /// <param name="witchTime">是否為魔女時間</param>
    public void SetTimeScale(float startScale, float endScale, float duration, bool witchTime = false)
    {
        //Witch Time
        if (witchTime && !inWitchTime)
        {
            inWitchTime = true;
            //if (witchTimeScaleCoroutine != null)
            //    StopCoroutine(witchTimeScaleCoroutine);
            witchTimeScaleCoroutine = StartCoroutine(DoVolume(0.0f, 1.0f, 0.25f, 0));

            //if (timeScaleCoroutine != null)
            //    StopCoroutine(timeScaleCoroutine);
            timeScaleCoroutine = StartCoroutine(DoTimeScale(startScale, endScale, duration, true));
        }
        else
        {
            //if (timeScaleCoroutine != null)
            //    StopCoroutine(timeScaleCoroutine);
            timeScaleCoroutine = StartCoroutine(DoTimeScale(startScale, endScale, duration, false));
        }
    }

    IEnumerator DoTimeScale(float startScale, float endScale, float duration, bool witchTime = false)
    {
        float startTime = Time.realtimeSinceStartup;
        float nextTime = startTime + duration;
        //Debug.Log(startTime + " " + nextTime);

        Time.timeScale = startScale;
        while (Time.realtimeSinceStartup < nextTime)
        {
            //Debug.Log(Time.realtimeSinceStartup);
            Time.timeScale = Mathf.Lerp(startScale, endScale, (Time.realtimeSinceStartup - startTime) / (nextTime - startTime));
            yield return null;
        }

        Time.timeScale = endScale;

        if (witchTime)
        {
            inWitchTime = false;
            StartCoroutine(DoVolume(1.0f, 0.0f, 0.25f, 0));
        }
    }

    /// <summary>
    /// 執行特定的後處理特效(在GameManager裡新增)
    /// </summary>
    /// <param name="startWeight">初始權重</param>
    /// <param name="endWeight">結束權重</param>
    /// <param name="duration">持續時間</param>
    /// <param name="index">在GameManager設定，使用的後處理特效index</param>
    public void PlayVolume(float startWeight, float endWeight, float duration, int index)
    {
        if (volumeCoroutine != null)
            StopCoroutine(volumeCoroutine);
        volumeCoroutine = StartCoroutine(DoVolume(startWeight, endWeight, duration, index));
    }

    IEnumerator DoVolume(float startWeight, float endWeight, float duration, int index)
    {
        float startTime = Time.realtimeSinceStartup;
        float nextTime = startTime + duration;

        volumes[index].weight = startWeight;
        while (Time.realtimeSinceStartup < nextTime)
        {
            volumes[index].weight = Mathf.Lerp(startWeight, endWeight, (Time.realtimeSinceStartup - startTime) / (nextTime - startTime));
            yield return null;
        }
        volumes[index].weight = endWeight;
    }

    /// <summary>
    /// 停止所有的timeScaleCoroutine
    /// </summary>
    public void StopTimeScaleCoroutine()
    {
        if(timeScaleCoroutine != null)
            StopCoroutine(timeScaleCoroutine);
    }

    /// <summary>
    /// 直接設定TimeScale，並將停止先前執行的timeScaleCoroutine
    /// </summary>
    /// <param name="scale"></param>
    public void SetTimeScale(float scale)
    {
        StopTimeScaleCoroutine();
        Time.timeScale = scale;
    }

    /// <summary>
    /// 設定目前遊戲的狀態
    /// </summary>
    /// <param name="index">index請參照GameManager裡的enum GameState</param>
    public void SetGameState(int index)
    {
        switch(index)
        {
            case (int)GameState.GamePlaying: gameState = GameState.GamePlaying; break;
            case (int)GameState.GamePause: gameState = GameState.GamePause; break;
            case (int)GameState.GameFlash: gameState = GameState.GameFlash; break;
            default: gameState = GameState.GamePlaying; break;
        }
    }
}

public enum GameState { GamePlaying, GamePause, GameFlash};