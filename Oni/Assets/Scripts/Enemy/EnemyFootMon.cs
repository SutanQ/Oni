using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnemyFootMon : Damegeable
{
    [Header("UI")]
    public GameObject UI_HP;
    public Image UI_HPbar;
    public Image UI_HPgreen;
    Animator UI_Anim;

    protected override void Start()
    {
        base.Start();
        if (UI_HP)
        {
            UI_HP.GetComponent<Canvas>().worldCamera = Camera.main;
            UI_Anim = UI_HP.GetComponent<Animator>();
        }
    }

    private void Update()
    {
        UpdateUI();
    }

    protected override void die()
    {
        if (UI_HP)
        {
            UpdateUI();
            UI_Anim.SetBool(IDManager.FadeIn_ID, false);
        }

        base.die();
    }

    void UpdateUI()
    {
        if (UI_HP == null) return;

        if (Time.time > UI_Timer)
        {
            UI_Anim.SetBool(IDManager.FadeIn_ID, false);
            return;
        }

        if (!UI_Anim.GetBool(IDManager.FadeIn_ID))
            UI_Anim.SetBool(IDManager.FadeIn_ID, true);

        //面向攝影機
        Vector3 v = Camera.main.transform.transform.position - UI_HP.transform.position;
        v.x = v.z = 0.0f;
        UI_HP.transform.LookAt(Camera.main.transform.position - v);
        UI_HP.transform.Rotate(0, 180, 0);

        //更新HP顯示
        float amount = (float)status.hp / status.maxHp;
        //深血
        if (!anim.GetBool(IDManager.damage_ID))
            UI_HPbar.fillAmount = Mathf.Lerp(UI_HPbar.fillAmount, amount, GameManager.Instance.UI_HP_duration);
        //綠血
        UI_HPgreen.fillAmount = amount;
    }
}
