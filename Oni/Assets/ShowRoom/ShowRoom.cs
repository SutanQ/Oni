using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using Cinemachine;

public class ShowRoom : MonoBehaviour
{
    public float RotateSpeed = 2.0f;
    public float AutoRotateSpeed = 0.5f;

    public GameObject[] showRoomObjects;
    int count;
    int index;
    float h, v;

    bool autoRotate = false;

    public GameObject LookPointObject;

    [Tooltip("主攝影機")]
    public CinemachineFreeLook cinemachineFree;
    public CinemachineVirtualCamera vCam;
    [Tooltip("攝影機的敏感度")]
    [Range(0f, 10f)] public float LookSpeed = 1f;
    [Tooltip("攝影機Y軸是否反向")]
    public bool InvertY = false;

    // Start is called before the first frame update
    void Start()
    {
        count = showRoomObjects.Length;
        index = 0;
        SetObjectActive(index);

        vCam.Priority = 50;
        cinemachineFree.Priority = 10;
    }

    // Update is called once per frame
    void Update()
    {
        if (autoRotate)
            transform.eulerAngles = new Vector3(0, transform.eulerAngles.y - AutoRotateSpeed, 0);
        else
            transform.eulerAngles = new Vector3(0, transform.eulerAngles.y - h * RotateSpeed, 0);

        LookPointObject.transform.localPosition += new Vector3(0, v * Time.deltaTime, 0);
        if (LookPointObject.transform.localPosition.y > 2.0f)
            LookPointObject.transform.localPosition = new Vector3(LookPointObject.transform.localPosition.x, 2.0f, LookPointObject.transform.localPosition.z);
        else if (LookPointObject.transform.localPosition.y < 0.0f)
            LookPointObject.transform.localPosition = new Vector3(LookPointObject.transform.localPosition.x, 0.0f, LookPointObject.transform.localPosition.z);
    }

    public void OnMove(InputAction.CallbackContext context)
    {
        Vector2 inputMovement = context.ReadValue<Vector2>();
        h = inputMovement.x;
        v = inputMovement.y;
    }

    public void OnAutoRotate(InputAction.CallbackContext context)
    {
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                autoRotate = !autoRotate;
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    public void OnPre(InputAction.CallbackContext context)
    {
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                index--;
                if (index < 0)
                    index = count - 1;
                SetObjectActive(index);
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    public void OnPost(InputAction.CallbackContext context)
    {
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                index++;
                if (index >= count)
                    index = 0;
                SetObjectActive(index);
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    void SetObjectActive(int _index)
    {
        for (int i = 0; i < count; i++)
            showRoomObjects[i].SetActive(false);
        showRoomObjects[_index].SetActive(true);
    }

    public void OnLook(InputAction.CallbackContext context)
    {
        //Normalize the vector to have an uniform vector in whichever form it came from (I.E Gamepad, mouse, etc)
        Vector2 lookMovement = context.ReadValue<Vector2>().normalized;
        lookMovement.y = InvertY ? -lookMovement.y : lookMovement.y;

        // This is because X axis is only contains between -180 and 180 instead of 0 and 1 like the Y axis
        lookMovement.x = lookMovement.x * 180f;

        //Ajust axis values using look speed and Time.deltaTime so the look doesn't go faster if there is more FPS
        cinemachineFree.m_XAxis.Value += lookMovement.x * LookSpeed * Time.deltaTime;
        cinemachineFree.m_YAxis.Value += lookMovement.y * LookSpeed * Time.deltaTime;

    }

    public void OnChangeCam(InputAction.CallbackContext context)
    {
        switch (context.phase)
        {
            case InputActionPhase.Performed:
                break;

            case InputActionPhase.Started:
                ChangeCam();
                break;

            case InputActionPhase.Canceled:
                break;
        }
    }

    public void ChangeCam()
    {
        if (vCam.Priority > 30)
        {
            vCam.Priority = 10;
            cinemachineFree.Priority = 50;
        }
        else
        {
            vCam.Priority = 50;
            cinemachineFree.Priority = 10;
        }
    }
}
