using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public enum AudioChannel { Mater, Sfx, Music };

    public float masterVolumePercent { get; private set; }
    public float sfxVolumePercent { get; private set; }
    public float musicVolumePercent { get; private set; }

    public AudioSource sfx2DSource;
    public static AudioManager instance;
    public AudioSource[] musicSources;
    int activeMusicSourceIndex;

    SoundLibrary soundLibrary;

    // Start is called before the first frame update
    void Awake()
    {
        if (instance != null)
            Destroy(gameObject);
        else
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
            soundLibrary = GetComponent<SoundLibrary>();
            
            musicSources = new AudioSource[2];
            for (int i = 0; i < 2; i++)
            {
                GameObject newMusicSource = new GameObject("Music Source" + (i + 1));
                musicSources[i] = newMusicSource.AddComponent<AudioSource>();
                newMusicSource.transform.parent = transform;
            }

            GameObject newSfx2DSource = new GameObject("2D SfxSource");
            sfx2DSource = newSfx2DSource.AddComponent<AudioSource>();
            newSfx2DSource.transform.parent = transform;
            
        }
        if (PlayerPrefs.HasKey("master vol"))
            masterVolumePercent = PlayerPrefs.GetFloat("master vol", 1);
        if (PlayerPrefs.HasKey("sfx vol"))
            sfxVolumePercent = PlayerPrefs.GetFloat("sfx vol", 1);
        if (PlayerPrefs.HasKey("music vol"))
            musicVolumePercent = PlayerPrefs.GetFloat("music vol", 1);

        //musicSources[0].volume = musicVolumePercent * masterVolumePercent;
        //musicSources[1].volume = musicVolumePercent * masterVolumePercent;
        //sfx2DSource.volume = sfxVolumePercent * masterVolumePercent;
    }

    public void SetVolume(float volumePercent, AudioChannel channel)
    {
        switch (channel)
        {
            case AudioChannel.Mater:
                masterVolumePercent = volumePercent; break;
            case AudioChannel.Sfx:
                sfxVolumePercent = volumePercent; break;
            case AudioChannel.Music:
                musicVolumePercent = volumePercent; break;
        }

        musicSources[0].volume = musicVolumePercent * masterVolumePercent;
        musicSources[1].volume = musicVolumePercent * masterVolumePercent;
        sfx2DSource.volume = sfxVolumePercent * masterVolumePercent;

        PlayerPrefs.SetFloat("master vol", masterVolumePercent);
        PlayerPrefs.SetFloat("sfx vol", sfxVolumePercent);
        PlayerPrefs.SetFloat("music vol", musicVolumePercent);
        PlayerPrefs.Save();
    }

    public void PlayMusic(AudioClip clip, float fadeDuration = 1)
    {
        activeMusicSourceIndex = 1 - activeMusicSourceIndex;
        musicSources[activeMusicSourceIndex].clip = clip;
        musicSources[activeMusicSourceIndex].Play();
        StartCoroutine(AnimateMusicCrossfade(fadeDuration));
    }

    IEnumerator AnimateMusicCrossfade(float duration)
    {
        float percent = 0;

        while (percent < 1)
        {
            percent += Time.deltaTime * 1 / duration;
            musicSources[activeMusicSourceIndex].volume = Mathf.Lerp(0, musicVolumePercent * masterVolumePercent, percent);
            musicSources[1 - activeMusicSourceIndex].volume = Mathf.Lerp(musicVolumePercent * masterVolumePercent, 0, percent);
            yield return null;
        }
    }

    
    public void PlaySound(AudioClip clip, Vector3 pos, float strength = 1.0f)
    {
        if (clip != null)
        {
            AudioSource.PlayClipAtPoint(clip, pos, sfxVolumePercent * masterVolumePercent * strength);
        }
    }

    
    public void PlaySound(string soundName, Vector3 pos)
    {
        PlaySound(soundLibrary.GetClipFromName(soundName), pos);
    }

    public void PlaySound2D(string soundName)
    {
        sfx2DSource.PlayOneShot(soundLibrary.GetClipFromName(soundName), sfxVolumePercent * masterVolumePercent);
    }

    public void PlaySound2D(AudioClip audioClip)
    {
        sfx2DSource.PlayOneShot(audioClip, sfxVolumePercent * masterVolumePercent);
    }
    
    public void SetGlobalVolume(float volume)
    {
        AudioListener.volume = volume;
    }

    public void SetGlobalVolumeAsSfx()
    {
        SetGlobalVolume(sfxVolumePercent * masterVolumePercent);
    }

    public void SetGlobalVolumeAsDefault()
    {
        SetGlobalVolume(1.0f);
    }
}
