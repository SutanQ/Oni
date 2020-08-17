using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlashCollider : MonoBehaviour
{
    public Transform mainTransform;
    public CharacterController characterController;
    public ThirdPersonMovement thirdPerson;
    public Transform weapon;
    public GhostEffect ghostEffect;
    Animator anim;
    Transform target;
    Color materialColor; //暫存殘影原始顏色
    int triggetCount = 0;

    private void Start()
    {
        anim = thirdPerson.GetComponent<Animator>();
        materialColor = ghostEffect.material.color;  //暫存殘影原始顏色
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Damage") && !anim.GetBool(IDManager.damage_ID) && !anim.GetBool(IDManager.Flashing_ID) && triggetCount == 0)
        {
            triggetCount++;
            anim.SetBool(IDManager.Flashing_ID, true);
            target = other.transform.root;
            //不與Enemy碰撞
            Physics.IgnoreLayerCollision(0, 9, true);    //忽略Layer0與Layer9的碰撞
            Physics.IgnoreLayerCollision(9, 10, true);    //忽略Layer9與Layer10的碰撞
            characterController.detectCollisions = false; //此CharacterController不會被其他的物體碰撞  

            float timeScaleCount = Mathf.Pow(FlashManager.Instance.timeScaleBaseMagnification, FlashManager.Instance.FlashCount);
            float length = (1 - anim.GetCurrentAnimatorStateInfo(0).normalizedTime) * anim.GetCurrentAnimatorStateInfo(0).length / anim.GetCurrentAnimatorStateInfo(0).speed;
            GameManager.Instance.SetTimeScale(FlashManager.Instance.startScale * timeScaleCount, FlashManager.Instance.endScale * timeScaleCount, length, false);
            //ghostEffect.material.color = FlashManager.Instance.GhostEffectColor; //更換殘影使用顏色
            GameManager.Instance.PlayVolume(0.0f, 1.0f, 0.3f, 3);
            DoFlash();
        }
    }

    public void DoFlash()
    {
        if (target != null)
        {
            //thirdPerson.StartLock(target);

            //如果個數大於零就表示這是NextFlash
            if (FlashManager.Instance.FlashCount > 0)
            {
                ;//GameManager.Instance.SetTimeScale(0.4f, 1.0f, 1.0f, false);
            }
            StartCoroutine(MoveAndSearchNext(FlashManager.Instance.movementDuration));
            
        }
        else
        {
            anim.SetBool(IDManager.Flashing_ID, false);
            anim.SetTrigger(IDManager.FlashEndTrigger_ID);
            //EndFlash();
        }
    }

    IEnumerator MoveAndSearchNext(float duration)
    {
        CameraShakeManager.Instance.SetTimeScaleType(false);
        CameraShakeManager.Instance.AddCameraShake(FlashManager.Instance.cameraShakeStrength);

        float timeScaleCount = Mathf.Pow(FlashManager.Instance.timeScaleBaseMagnification, FlashManager.Instance.FlashCount);
        //thirdPerson.SetHitMaterial(FlashManager.Instance.hitMaterialDuration / timeScaleCount);

        
        //ghostEffect.IsActive = true;
        ghostEffect.Plays();                      //顯示殘影
        thirdPerson.ChangeSkinnedRenderer(false); //關閉角色渲染

        //將角色移動到敵人後方 3.0 的位置
        Vector3 dir = target.position - mainTransform.position;
        dir.y = 0;
        Vector3 moveLength = (dir + dir.normalized * FlashManager.Instance.movementDistance) / duration;

        float startTime = Time.realtimeSinceStartup;
        float nextTime = startTime + duration;
        int cnt = 0;
        while (Time.realtimeSinceStartup < nextTime)
        {
            cnt++;
            characterController.Move(moveLength * Time.unscaledDeltaTime);
            if(cnt % FlashManager.Instance.ghostEffectModCnt == 0)
                ghostEffect.Plays();                      //顯示殘影
            yield return null;
        }

        thirdPerson.ChangeSkinnedRenderer(true);  //開啟角色渲染
        thirdPerson.SetHitMaterial(FlashManager.Instance.hitMaterialDuration / timeScaleCount);  //顯示角色發光
        //ghostEffect.IsActive = false;

        //將敵人設定為Flash狀態並加入Flash清單中
        Enemy enemy = target.GetComponentInParent<Enemy>();
        enemy.SetFlash(true);
        FlashManager.Instance.AddFlashList(enemy, weapon);

        //找到周圍最近的敵人
        target = thirdPerson.GetClostEnemyWithoutFlash();

        if (target == null)
        {
            anim.SetTrigger(IDManager.FlashEndTrigger_ID);
            //EndFlash();
        }
        else
        {
            //thirdPerson.CancelLock();
            thirdPerson.StartLock(target);
        }
    }

    public void CancelLock()
    {
        thirdPerson.CancelLock();
    }

    public void EndFlash()
    {
        CameraShakeManager.Instance.SetTimeScaleType(true);
        //恢復碰撞
        Physics.IgnoreLayerCollision(0, 9, false);  //不忽略Layer0與Layer9的碰撞
        Physics.IgnoreLayerCollision(9, 10, false);  //不忽略Layer9與Layer10的碰撞
        characterController.detectCollisions = true; //此CharacterController會被其他的物體碰撞

        //ghostEffect.material.color = materialColor; //恢復殘影原始顏色
        if (FlashManager.Instance.FlashCount >= FlashManager.Instance.TimelineCount)
            FlashManager.Instance.FlashFinishDirector();
        else
            FlashManager.Instance.FlashFinish();
        GameManager.Instance.PlayVolume(1.0f, 0.0f, 0.2f, 3);
        //anim.SetBool(IDManager.Flashing_ID, false);

        triggetCount = 0;
    }
}
