using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Player : Damegeable
{
    ThirdPersonMovement thirdPerson;

    [Header("UI")]
    public float hp_duration = 0.2f; 
    public Image UI_HP;

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
        base.TakeDamege(dmg, damageType, force, takeDamageTrigger, takeInvincibleTime);
        //UpdateUI();
    }

    private void Update()
    {
        //更新HP顯示
        UI_HP.fillAmount = Mathf.Lerp(UI_HP.fillAmount, (float)status.hp / status.maxHp, hp_duration);
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
