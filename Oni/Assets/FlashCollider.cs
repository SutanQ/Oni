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

    private void Start()
    {
        anim = thirdPerson.GetComponent<Animator>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Damage") && !anim.GetBool(IDManager.damage_ID) && !anim.GetBool(IDManager.Flashing_ID))
        {
            anim.SetBool(IDManager.Flashing_ID, true);
            target = other.transform.root;
            //不與Enemy碰撞
            Physics.IgnoreLayerCollision(9, 10, true);    //忽略Layer9與Layer10的碰撞
            characterController.detectCollisions = false; //此CharacterController不會被其他的物體碰撞  
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
            StartCoroutine(MoveAndSearchNext(0.15f));
            
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
        thirdPerson.SetHitMaterial(FlashManager.Instance.hitMaterialDuration / timeScaleCount);

        //將角色移動到敵人後方 3.0 的位置
        Vector3 dir = target.position - mainTransform.position;
        dir.y = 0;
        ghostEffect.IsActive = true;
        Vector3 moveLength = (dir + dir.normalized * 3.0f) / duration;

        float startTime = Time.realtimeSinceStartup;
        float nextTime = startTime + duration;
        while (Time.realtimeSinceStartup < nextTime)
        {
            characterController.Move(moveLength * Time.unscaledDeltaTime);
            yield return null;
        }
        ghostEffect.IsActive = false;

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
        Physics.IgnoreLayerCollision(9, 10, false);  //不忽略Layer9與Layer10的碰撞
        characterController.detectCollisions = true; //此CharacterController會被其他的物體碰撞

        FlashManager.Instance.FlashFinish();
        //anim.SetBool(IDManager.Flashing_ID, false);
    }
}
