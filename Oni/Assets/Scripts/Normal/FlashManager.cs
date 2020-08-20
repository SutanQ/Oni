using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Playables;
using Cinemachine;

public class FlashManager : MonoBehaviour
{
    
    public static FlashManager Instance;

    [Header("Status")]
    [Tooltip("使用一閃的角色TPM")]
    public ThirdPersonMovement thirdPerson;
    [Tooltip("使用一閃的角色CC")]
    public CharacterController characterController;
    [Tooltip("使用一閃的角色能力值")]
    public Damegeable playerStatus;
    [Tooltip("一閃的次數")]
    public int FlashCount = 0;
    [Tooltip("一閃的基礎攻擊力")]
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

    public bool DoFlashTimeline
    {
        get
        {
            return FlashManager.Instance.FlashCount >= FlashManager.Instance.TimelineCount;
        }
    }

    [Header("VFX")]
    [Tooltip("一閃的擊中特效")]
    public GameObject VFX_Hit_Prefab;
    [Tooltip("一閃的噴血特效")]
    public GameObject VFX_Blood_Prefab;
    [Tooltip("一閃擊中的閃光顏色")]
    [ColorUsage(true, true)]
    public Color FlashHitColor = new Color(16, 16, 16, 1);
    [Tooltip("一閃終結的閃光顏色")]
    [ColorUsage(true, true)]
    public Color FlashEndColor = new Color(16, 16, 16, 1);

    [Header("Time Scale")]
    [Tooltip("每多一次一閃，時間加快的倍率")]
    public float timeScaleBaseMagnification = 1.1f;
    [Tooltip("每次一閃初始的TimeScale，會受timeScaleBaseMagnification影響。")]
    public float startScale = 0.05f;
    [Tooltip("每次一閃結束的TimeScale，會受timeScaleBaseMagnification影響。")]
    public float endScale = 0.2f;

    [Header("UI")]
    [Tooltip("顯示一閃次數的UI")]
    public Text UI_FlashCount;
    [Tooltip("顯示一閃傷害的UI")]
    public Text UI_FlashDmg;
    [Tooltip("依一閃次數來變換一閃UI顏色的對照表，")]
    public FlashCountUIData[] flashCountUIDatas;

    [Header("Movement")]
    [Tooltip("一閃瞬移的時間間隔，數值越小，移動越快")]
    public float movementDuration = 0.2f;
    [Tooltip("一閃移動到目標物後方的距離，數值越大距離越遠")]
    public float movementDistance = 3.0f;

    [Header("Ghost Effect")]
    [Tooltip("一閃瞬移時產生的殘影數，每隔ghostEffectModCnt Frame產生一個殘影")]
    public int ghostEffectModCnt = 6;
    //[ColorUsage(true, true)]
    //public Color GhostEffectColor = new Color(16, 16, 16, 1);

    [Header("Timeline")]
    [Tooltip("進入終結Timeline的一閃次數門檻值(除了達到門檻值之外，還要將在場所有怪物都一閃掉才會進入Timeline)")]
    public int TimelineCount = 3;
    [Tooltip("使用的一閃終結Timeline")]
    public PlayableDirector timeline;

    //目前用不到
    [Tooltip("目前用不到")]
    public CinemachineTargetGroup cinemachineTarget;
    [Tooltip("目前用不到")]
    public Transform playerTarget;

    [Header("Other")]
    [Tooltip("一閃擊中產生發光特效的持續時間")]
    public float hitMaterialDuration = 0.15f;
    [Tooltip("一閃擊中時產生的攝影機晃動程度")]
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

        //重設一閃UI的顏色及文字
        UI_FlashCount.color = Color.clear;
        UI_FlashCount.text = FlashCount.ToString();
        UI_FlashDmg.color = Color.clear;
        UI_FlashDmg.text = FlashCount.ToString();

        //將玩家加入到cinemachineTarget清單中
        cinemachineTarget.AddMember(playerTarget, 1.0f, 0.0f);
    }

    public void AddFlashList(Enemy enemy, Transform hitTransform)
    {
        cinemachineTarget.AddMember(enemy.transform, 0.2f, 0.0f);

        //Debug.Log("Add List " + enemy.name);
        //將Enemy加入到一閃清單中
        flashEnemies.Add(enemy);
        FlashCount++;

        //設定一閃UI
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

        //儲存之後要刪除掉的特效List
        destroyList.Add(blood);
        destroyList.Add(hit);
    }

    /// <summary>
    /// 終結一閃並進入終結的Timeline
    /// </summary>
    public void FlashFinishDirector()
    {
        timeline.Play();
    }

    /// <summary>
    /// 終結一閃
    /// </summary>
    public void FlashFinish()
    {
        for(int i = 0; i < flashEnemies.Count; i++)
        {
            //將怪物身上的Flash印記取消
            flashEnemies[i].SetFlash(false);
            //產生Flash傷害
            flashEnemies[i].TakeDamege(FlashAttack * FlashCount, DamageType.None, Vector3.zero, true, false);

            //產生hit閃光
            flashEnemies[i].hitMaterial.SetColor(IDManager.hitColorID, FlashEndColor);
            //flashEnemies[i].hitMaterial.SetVector(IDManager.hitPosID, new Vector4(objectPos.x, objectPos.y, objectPos.z, 0.0f)); //擊中的部位座標(object position)
            //flashEnemies[i].hitMaterial.SetFloat(IDManager.hitStrengthID, 0.15f);  //擊中抖動的Strength
            flashEnemies[i].PlayHitColorAmount(0.8f);   //擊中發光的特效顯示時間

            //移除在cinemachineTarget的清單(未使用)
            cinemachineTarget.RemoveMember(flashEnemies[i].transform);
        }

        flashEnemies.Clear();  //清空敵人清單
        DestroyList();         //刪除所有先前產生的一閃特效
        FlashCount = 0;

        //重設一閃UI的顏色及文字
        UI_FlashCount.color = Color.clear;
        UI_FlashCount.text = FlashCount.ToString();
        UI_FlashDmg.color = Color.clear;
        UI_FlashDmg.text = FlashCount.ToString();

        //恢復角色的可移動性、武器fadeOut及關閉LockUI
        thirdPerson.SetPlayerCanMove(true);
        thirdPerson.Weapon_FadeOut(0.3f, 11, 0);
        thirdPerson.TargetUI_Cancel();

        //恢復碰撞
        Physics.IgnoreLayerCollision(0, 9, false);  //不忽略Layer0與Layer9的碰撞
        Physics.IgnoreLayerCollision(9, 10, false);  //不忽略Layer9與Layer10的碰撞
        characterController.detectCollisions = true; //此CharacterController會被其他的物體碰撞
    }

    /// <summary>
    /// 刪除所有先前一閃所產生的特效(擊中特效、噴血特效等)
    /// </summary>
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

    public void TargetUI_Cancel()
    {
        thirdPerson.TargetUI_Cancel();
    }
}


[System.Serializable]
public class FlashCountUIData
{
    [Tooltip("一閃的次數門檻值")]
    public int cnt;
    [Tooltip("對應的顏色")]
    public Color color;
}