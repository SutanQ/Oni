using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class PostProcessOutlineRenderFeature : ScriptableRendererFeature
{
    PostProcessOutlinePass pass;

    public override void Create()
    {
        pass = new PostProcessOutlinePass(RenderPassEvent.BeforeRenderingTransparents);
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        pass.Setup(renderer.cameraColorTarget);
        renderer.EnqueuePass(pass);
    }
}

