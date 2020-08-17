using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Playables;

public class FlashManager : MonoBehaviour
{
    public static FlashManager Instance;

    [Header("Status")]
    public Damegeable playerStatus;
    public int FlashCount = 0;
    public int FlashBaseAttack = 50;
    public int FlashAttack
    {
        get {
            if (playerStatus != null)
                return FlashBaseAttack + playerStatus.status.atk;
            else
                return FlashBaseAttack;
        }
    }

    [Header("VFX")]
    public GameObject VFX_Hit_Prefab;
    public GameObject VFX_Blood_Prefab;
    [ColorUsage(true, true)]
    public Color FlashHitColor = new Color(16, 16, 16, 1);
    [ColorUsage(true, true)]
    public Color FlashEndColor = new Color(16, 16, 16, 1);

    [Header("Time Scale")]
    public float timeScaleBaseMagnification = 1.1f;
    public float startScale = 0.05f;
    public float endScale = 0.2f;

    [Header("UI")]
    public Text UI_FlashCount;
    public Text UI_FlashDmg;
    public FlashCountUIData[] flashCountUIDatas;

    [Header("Movement")]
    public float movementDuration = 0.2f;
    public float movementDistance = 3.0f;

    [Header("Ghost Effect")]
    public int ghostEffectModCnt = 6;
    //[ColorUsage(true, true)]
    //public Color GhostEffectColor = new Color(16, 16, 16, 1);

    [Header("Timeline")]
    public int TimelineCount = 3;
    public PlayableDirector timeline;

    [Header("Other")]
    public float hitMaterialDuration = 0.15f;
    public float cameraShakeStrength = 1.5f;


    List<Enemy> flashEnemies = new List<Enemy>();
    List<GameObject> destroyList = new List<GameObject>();

    private void Awake()
    {
        if (Instance == null)
            Instance = this;
        else
            Destroy(this);

        
    }

    private void Start()
    {
        if (playerStatus == null)
            playerStatus = GameObject.FindGameObjectWithTag("Player").GetComponent<Damegeable>();

        UI_FlashCount.color = Color.clear;
        UI_FlashCount.text = FlashCount.ToString();
        UI_FlashDmg.color = Color.clear;
        UI_FlashDmg.text = FlashCount.ToString();
    }

    public void AddFlashList(Enemy enemy, Transform hitTransform)
    {
        //Debug.Log("Add List " + enemy.name);
        flashEnemies.Add(enemy);
        FlashCount++;
        UI_FlashCount.color = GetUIColor();
        UI_FlashCount.text = FlashCount.ToString();
        UI_FlashDmg.color = GetUIColor();
        UI_FlashDmg.text = (FlashAttack * FlashCount).ToString();

        //掛上噴血的特效
        GameObject blood = Instantiate(VFX_Blood_Prefab, enemy.transform.position, Quaternion.identity);
        blood.transform.parent = enemy.transform;

        //擊中特效A
        Collider collider = enemy.GetComponent<Collider>();
        Vector3 closestPoint = collider.ClosestPoint(hitTransform.position);
        Vector3 objectPos = hitTransform.worldToLocalMatrix.MultiplyPoint(closestPoint);
        enemy.hitMaterial.SetColor(IDManager.hitColorID, FlashHitColor);
        enemy.hitMaterial.SetVector(IDManager.hitPosID, new Vector4(objectPos.x, objectPos.y, objectPos.z, 0.0f)); //擊中的部位座標(object position)
        enemy.hitMaterial.SetFloat(IDManager.hitStrengthID, 0.25f);  //擊中抖動的Strength
        enemy.PlayHitColorAmount(0.8f);   //擊中發光的特效顯示時間

        //擊中特效B
        GameObject hit = Instantiate(VFX_Hit_Prefab, closestPoint, Quaternion.identity);
        hit.transform.parent = enemy.transform;

        //儲存List
        destroyList.Add(blood);
        destroyList.Add(hit);
    }

    public void FlashFinishDirector()
    {
        timeline.Play();
    }

    public void FlashFinish()
    {
        for(int i = 0; i < flashEnemies.Count; i++)
        {
            flashEnemies[i].SetFlash(false);
            flashEnemies[i].TakeDamege(FlashAttack * FlashCount, DamageType.None, Vector3.zero, true, false);

            flashEnemies[i].hitMaterial.SetColor(IDManager.hitColorID, FlashEndColor);
            //flashEnemies[i].hitMaterial.SetVector(IDManager.hitPosID, new Vector4(objectPos.x, objectPos.y, objectPos.z, 0.0f)); //擊中的部位座標(object position)
            //flashEnemies[i].hitMaterial.SetFloat(IDManager.hitStrengthID, 0.15f);  //擊中抖動的Strength
            flashEnemies[i].PlayHitColorAmount(0.8f);   //擊中發光的特效顯示時間
        }

        flashEnemies.Clear();
        DestroyList();
        FlashCount = 0;
        UI_FlashCount.color = Color.clear;
        UI_FlashCount.text = FlashCount.ToString();
        UI_FlashDmg.color = Color.clear;
        UI_FlashDmg.text = FlashCount.ToString();
    }

    public void DestroyList()
    {
        for(int i = 0; i < destroyList.Count; i++)
        {
            if (destroyList[i] != null)
                Destroy(destroyList[i]);
        }

        destroyList.Clear();
    }

    public Color GetUIColor()
    {
        Color c = flashCountUIDatas[0].color;
        for (int i = 1; i < flashCountUIDatas.Length; i++)
        {
            if (FlashCount >= flashCountUIDatas[i].cnt)
                c = flashCountUIDatas[i].color;
            else
                break;
        }

        return c;
    }
}


[System.Serializable]
public class FlashCountUIData
{
    public int cnt;
    public Color color;
}