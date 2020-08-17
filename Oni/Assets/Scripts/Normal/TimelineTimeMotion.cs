using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class TimelineTimeMotion : PlayableBehaviour
{
    public float timeScale;
    float originalTimeScale = 1f;

    public override void OnBehaviourPlay(Playable playable, FrameData info)
    {
        originalTimeScale = Time.timeScale;
    }

    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        if (playable.GetTime() <= 0)
            return;

        Time.timeScale = Mathf.Lerp(originalTimeScale, timeScale, (float)(playable.GetTime() / playable.GetDuration()));
    }

}
