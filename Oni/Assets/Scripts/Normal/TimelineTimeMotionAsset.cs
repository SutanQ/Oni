using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

public class TimelineTimeMotionAsset : PlayableAsset
{
    public float timeScale = 1.0f;
    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        //throw new System.NotImplementedException();

        TimelineTimeMotion timelineTimeMotion = new TimelineTimeMotion();
        timelineTimeMotion.timeScale = timeScale;
        return ScriptPlayable<TimelineTimeMotion>.Create(graph, timelineTimeMotion);
    }
}
