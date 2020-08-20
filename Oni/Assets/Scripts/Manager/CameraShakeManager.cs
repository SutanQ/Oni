using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class CameraShakeManager : MonoBehaviour
{
    public static CameraShakeManager Instance;
    [Tooltip("主要的Cinemachine攝影機")]
    public CinemachineFreeLook cinemachineFree;
    [Tooltip("攝影機晃動冷卻的速度")]
    public float clamDownSpeed = 4.0f;
    CinemachineBasicMultiChannelPerlin cinemachineBasic1;
    CinemachineBasicMultiChannelPerlin cinemachineBasic2;
    CinemachineBasicMultiChannelPerlin cinemachineBasic3;
    [Tooltip("晃動所使用的Impulse群組")]
    public CinemachineImpulseSource[] cinemachineImpulses;

    float defaultRadius1;
    float defaultRadius2;
    float defaultRadius3;
    float defaultY;

    private List<CameraShakeData> cameraShakeDataList = new List<CameraShakeData>();

    int UseTimeScale = 1;

    private void Awake()
    {
        if (Instance == null)
            Instance = this;
        else
            Destroy(this);

        cinemachineBasic1 = cinemachineFree.GetRig(0).GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
        cinemachineBasic2 = cinemachineFree.GetRig(1).GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
        cinemachineBasic3 = cinemachineFree.GetRig(2).GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();

        defaultRadius1 = cinemachineFree.m_Orbits[0].m_Radius;
        defaultRadius2 = cinemachineFree.m_Orbits[1].m_Radius;
        defaultRadius3 = cinemachineFree.m_Orbits[2].m_Radius;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        cinemachineBasic1.m_AmplitudeGain = Mathf.Clamp(cinemachineBasic1.m_AmplitudeGain - clamDownSpeed * (Time.deltaTime * UseTimeScale + Time.unscaledDeltaTime *(1 - UseTimeScale)), 0, 10);
        cinemachineBasic3.m_AmplitudeGain = cinemachineBasic2.m_AmplitudeGain = cinemachineBasic1.m_AmplitudeGain;

        //指定時間的晃動
        for(int i = 0; i < cameraShakeDataList.Count; i++)
        {
            if(Time.time >= cameraShakeDataList[i]._shakeTime)
            {
                AddCameraShake(cameraShakeDataList[i]._shakeStrength, cameraShakeDataList[i]._cameraImpulseIndex);
                cameraShakeDataList.Remove(cameraShakeDataList[i]);
            }
        }
    }

    public void AddCameraShakeDataList(float _time, float strength, CameraImpulseIndex impulseIndex = CameraImpulseIndex.None)
    {
        CameraShakeData cameraShakeData = new CameraShakeData(_time, strength, impulseIndex);
        cameraShakeDataList.Add(cameraShakeData);
    }

    public void AddCameraShake(float strength, CameraImpulseIndex impulseIndex = CameraImpulseIndex.None)
    {
        cinemachineBasic1.m_AmplitudeGain += strength;
        cinemachineBasic2.m_AmplitudeGain = cinemachineBasic3.m_AmplitudeGain = cinemachineBasic1.m_AmplitudeGain;

        if(((int)impulseIndex) < (int)CameraImpulseIndex.None)
            cinemachineImpulses[(int)impulseIndex].GenerateImpulse(Camera.main.transform.forward);

        GameManager.Instance.SetGamePadMotor(0.1f, strength * 0.4f, strength * 0.4f);
    }

    public void ClimbCameraYAxis(bool cameraIn)
    {
        if(cameraIn)
        {
            defaultY = cinemachineFree.m_YAxis.Value;
            cinemachineFree.m_YAxis.Value = 1.0f;
        }
        else
        {
            cinemachineFree.m_YAxis.Value = defaultY;
        }
    }

    public void SetLongRadius(float duration)
    {
        StartCoroutine(DoRadius(duration, 5.5f, 5.0f, 5.0f));
    }

    public void SetDefaultRadius(float duration)
    {
        StartCoroutine(DoRadius(duration, defaultRadius1, defaultRadius2, defaultRadius3));
    }

    public void SetShortRadius(float duration)
    {
        StartCoroutine(DoRadius(duration, 3.0f, 2.5f, 2.0f));
    }

    IEnumerator DoRadius(float duration, float r1, float r2, float r3)
    {
        float t = 0;

        float startR1 = cinemachineFree.m_Orbits[0].m_Radius;
        float startR2 = cinemachineFree.m_Orbits[1].m_Radius;
        float startR3 = cinemachineFree.m_Orbits[2].m_Radius;

        while (t < duration)
        {
            cinemachineFree.m_Orbits[0].m_Radius = Mathf.Lerp(startR1, r1, t / duration);
            cinemachineFree.m_Orbits[1].m_Radius = Mathf.Lerp(startR2, r2, t / duration);
            cinemachineFree.m_Orbits[2].m_Radius = Mathf.Lerp(startR3, r3, t / duration);
            t += Time.deltaTime;
            yield return null;
        }

        cinemachineFree.m_Orbits[0].m_Radius = r1;
        cinemachineFree.m_Orbits[1].m_Radius = r2;
        cinemachineFree.m_Orbits[2].m_Radius = r3;
    }

    public void SetTimeScaleType(bool b)
    {
        if (b)
            UseTimeScale = 1;
        else
            UseTimeScale = 0;
    }
}

public enum CameraImpulseIndex { C1, C2, C3, J1, LockAtk1, GroundImpact, None};

[System.Serializable]
public class CameraShakeData
{
    public float _shakeTime;
    public float _shakeStrength;
    public CameraImpulseIndex _cameraImpulseIndex;

    public CameraShakeData(float _time, float _strength, CameraImpulseIndex _index)
    {
        _shakeTime = _time;
        _shakeStrength = _strength;
        _cameraImpulseIndex = _index;
    }
}