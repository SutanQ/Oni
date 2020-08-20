using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Player : Damegeable
{
    ThirdPersonMovement thirdPerson;

    [Header("UI")]
    [Tooltip("血量UI扣血變化的速度")]
    public float hp_duration = 0.2f;
    [Tooltip("血量UI(深紅血)")]
    public Image UI_HP;
    [Tooltip("血量UI(綠血)")]
    public Image UI_HPgreen;

    protected override void Start()
    {
        base.Start();
        thirdPerson = GetComponent<ThirdPersonMovement>();
        UpdateUI();
    }

    public override void SetForce(Vector3 f)
    {
        thirdPerson.SetVelocity(Vector3.up * f.y);
        addForceVity.x += f.x;
        addForceVity.z += f.z;
    }

    public override void TakeDamege(int dmg, DamageType damageType, Vector3 force, bool takeDamageTrigger, bool takeInvincibleTime = true)
    {
        if (anim.GetBool(IDManager.Flashing_ID)) return;
        if (dmg > GameManager.Instance.PlayerTakeDmgMotorThreshold)
            GameManager.Instance.PlayerTakeDamageMotor(dmg);
        base.TakeDamege(dmg, damageType, force, takeDamageTrigger, takeInvincibleTime);
        //UpdateUI();
    }

    private void Update()
    {
        //更新HP顯示
        float amount = (float)status.hp / status.maxHp;
        //深血
        if (!anim.GetBool(IDManager.damage_ID))
            UI_HP.fillAmount = Mathf.Lerp(UI_HP.fillAmount, amount, hp_duration);
        //綠血
        UI_HPgreen.fillAmount = amount;
    }

    void UpdateUI()
    {
        StartCoroutine(DoUpdateUI(hp_duration));
    }

    IEnumerator DoUpdateUI(float t)
    {
        float tt = 0;
        while(tt < t)
        {
            UI_HP.fillAmount = Mathf.Lerp(UI_HP.fillAmount, (float)status.hp / status.maxHp, 0.2f);
            tt += Time.deltaTime;
            yield return null;
        }
        UI_HP.fillAmount = (float)status.hp / status.maxHp;
    }
}
