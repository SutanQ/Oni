using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;

public class FPS_Display : MonoBehaviour
{
    public Text fps_text;

    public float updateSrecond = 1.0f;
    float nextTime;
    float frame;
    float totalTime = 0;
    float frame_cnt = 0;

    bool origin = true;
    public GameObject[] origin_objects;
    public GameObject[] new_objects;

    private void Start()
    {
        nextTime = Time.time + updateSrecond;
    }

    // Update is called once per frame
    void Update()
    {
        frame_cnt++;
        totalTime += Time.unscaledDeltaTime;
        if (Time.time >= nextTime)
        {
            //frame = (1f / Time.unscaledDeltaTime);
            frame = frame_cnt / totalTime;
            fps_text.text = Screen.width + "x" + Screen.height + "\nFPS:" + frame.ToString();
            nextTime = Time.time + updateSrecond;
            totalTime = 0;
            frame_cnt = 0;
        }
    }

    public void OnJump(InputAction.CallbackContext context)
    {
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                if(origin == true)
                {
                    origin = false;
                    for (int i = 0; i < new_objects.Length; i++)
                        new_objects[i].SetActive(true);
                    for (int i = 0; i < origin_objects.Length; i++)
                        origin_objects[i].SetActive(false);
                }
                else
                {
                    origin = true;
                    for (int i = 0; i < origin_objects.Length; i++)
                        origin_objects[i].SetActive(true);
                    for (int i = 0; i < new_objects.Length; i++)
                        new_objects[i].SetActive(false);
                }
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }
}
