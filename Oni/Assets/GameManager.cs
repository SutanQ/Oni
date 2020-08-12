using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    GameState gameState;

    Coroutine timeScaleCoroutine;
    Coroutine witchTimeScaleCoroutine;
    public bool inWitchTime = false;
    public Volume witchVolume;
    public Volume[] volumes;
    Coroutine volumeCoroutine;

    [Header("Ground Impact")]
    public int GroundDamage = 5;
    public float GroundBoundForce = 3;
    public float GroundImpact_ForceTrashold = -4.0f;
    public GameObject VFX_ImpactHitPrefab;
    public GameObject VFX_GroundImpactPrefab;

    [Header("UI")]
    public float UI_HP_Time = 3.0f;     //UI顯示時間
    public float UI_HP_duration = 0.2f; //血條變化速度


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

    public void DoHitTimeScale(float startTimeScale, float hitDuration)
    {
        SetTimeScale(startTimeScale, 1.0f, hitDuration, false);
    }

    public void SetTimeScale(float startScale, float endScale, float duration, bool witchTime = false)
    {
        if (witchTime)
        {
            inWitchTime = true;
            if (witchTimeScaleCoroutine != null)
                StopCoroutine(witchTimeScaleCoroutine);
            witchTimeScaleCoroutine = StartCoroutine(DoVolume(0.0f, 1.0f, 0.25f, 0));
        }

        if (timeScaleCoroutine != null)
            StopCoroutine(timeScaleCoroutine);
        timeScaleCoroutine = StartCoroutine(DoTimeScale(startScale, endScale, duration, witchTime));
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
}

public enum GameState { GamePlaying, GamePause};