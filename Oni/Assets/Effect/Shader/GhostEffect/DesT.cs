using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DesT : MonoBehaviour
{
    private string skinName;
    private float timer, rate = 0.50f;
    private Material material;
    float startAlpha = 1.0f;

    public void SetSkinNameAndMaterial(string _skinName, Material _material)
    {
        skinName = _skinName;
        material = _material;
    }

    void Update()
    {
        timer += Time.deltaTime;

        //在幻影存活時間內將材質的Alpha值減到0
        //material.color = new Color(material.color.r, material.color.g, material.color.b, material.color.a - (1 / rate) * Time.deltaTime);
        material.color = new Color(material.color.r, material.color.g, material.color.b, Mathf.Lerp(startAlpha, 0, timer / rate));
        //Debug.Log(material.name + " : " + material.color.a);
        //當存活時間結束時則關閉物件並將其回收至pool
        if (timer > rate)
        {
            gameObject.SetActive(false);
            ObjPool.Instance.Add(skinName, gameObject);  //將此物件再回收至pool裡面
        }
    }

    //設定幻影存活時間
    public void SetLifeTime(float t)
    {
        rate = t;
        timer = 0;
        startAlpha = material.color.a;
    }

    private void OnEnable()
    {
        //如果在有設定材質的情況下重啟物件則將其材質Alpha值設為1，並重置計時器
        if(material != null)
            material.color = new Color(material.color.r, material.color.g, material.color.b, 1.0f);
        timer = 0;
    }
}