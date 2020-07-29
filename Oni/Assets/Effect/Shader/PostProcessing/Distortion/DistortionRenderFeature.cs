using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class DistortionRenderFeature : ScriptableRendererFeature
{
    DistortionPass distortionPass;

    public override void Create()
    {
        distortionPass = new DistortionPass(RenderPassEvent.AfterRenderingTransparents);
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        distortionPass.Setup(renderer.cameraColorTarget);
        renderer.EnqueuePass(distortionPass);
    }
}