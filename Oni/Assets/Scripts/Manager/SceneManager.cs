using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using Cinemachine;

public class SceneManager : MonoBehaviour
{
    public scene[] scenes;
    public Transform target;
    int index = 0;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (index >= scenes.Length)
            return;

        if(target.position.x >= scenes[index].triggerLength)
        {
            if(scenes[index].vcam != null)
                scenes[index].vcam.Priority = 15;
            if ((index - 1) >= 0)
            {
                scenes[index - 1].vcam.Priority = 5;
                StartCoroutine(ChangeVolumeRecover(index-1, scenes[index].changeTime));
            }

            StartCoroutine(ChangeVolume(index, scenes[index].changeTime));

            index++;
        }
    }

    IEnumerator ChangeVolume(int _index, float duration)
    {
        float t = 0;

        while(t < duration)
        {
            for (int i = 0; i < scenes[_index].volumes.Length; i++)
            {
                scenes[_index].volumes[i].weight = t / duration;
            }
            t += Time.deltaTime;

            yield return null;
        }

        for (int i = 0; i < scenes[_index].volumes.Length; i++)
        {
            scenes[_index].volumes[i].weight = 1.0f;
        }

    }

    IEnumerator ChangeVolumeRecover(int _index, float duration)
    {
        float t = 1;

        while (t < duration)
        {
            for (int i = 0; i < scenes[_index].volumes.Length; i++)
            {
                scenes[_index].volumes[i].weight = 1 - t / duration;
            }
            t += Time.deltaTime;

            yield return null;
        }

        for (int i = 0; i < scenes[_index].volumes.Length; i++)
        {
            scenes[_index].volumes[i].weight = 0.0f;
        }

    }

    [System.Serializable]
    public class scene
    {
        public float triggerLength = 100.0f;
        public float changeTime = 1.0f;
        public CinemachineVirtualCamera vcam;
        public Volume[] volumes;
    }
}
