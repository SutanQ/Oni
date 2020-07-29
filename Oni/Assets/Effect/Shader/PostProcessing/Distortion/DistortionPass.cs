using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class DistortionPass : ScriptableRenderPass
{
    static readonly string d_RenderTag = "Distortion Effects";
    static readonly int MainTexId = Shader.PropertyToID("_MainTex");
    static readonly int TempTargetId = Shader.PropertyToID("_TempTargetDistortion");
    static readonly int _globalDistortionTexID = Shader.PropertyToID("_GlobalDistortionTex");

    Distortion distortion;
    private Material material;
    private RenderTargetIdentifier currentTarget;


    public void Setup(RenderTargetIdentifier currentTarget)
    {
        this.currentTarget = currentTarget;
    }

    public DistortionPass(RenderPassEvent evt)
    {
        renderPassEvent = evt; 
        var shader = Shader.Find("PostEffect/Distortion");
        if (shader == null)
        {
            Debug.LogError("Distortion Shader Not found.");
            return;
        }
        material = CoreUtils.CreateEngineMaterial(shader);
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        if (material == null)
        {
            Debug.LogError("Distortion Shader Not found.");
            return;
        }

        if (!renderingData.cameraData.postProcessEnabled) { return; }

        var stack = VolumeManager.instance.stack;
        distortion = stack.GetComponent<Distortion>();
        if (distortion == null) { return; }
        if (!distortion.IsActive()) { return; }

        CommandBuffer cmd = CommandBufferPool.Get(d_RenderTag);
        Render(cmd, ref renderingData);
        context.ExecuteCommandBuffer(cmd);
        CommandBufferPool.Release(cmd);
    }

    void Render(CommandBuffer cmd, ref RenderingData renderingData)
    {
        ref var cameraData = ref renderingData.cameraData;
        var source = currentTarget;
        int destination = TempTargetId;

        var width = cameraData.camera.scaledPixelWidth;
        var height = cameraData.camera.scaledPixelHeight;

        material.SetFloat("_Magnitude", distortion.Magnitude.value);

        if (!distortion.DebugView.value)
        {
            cmd.GetTemporaryRT(_globalDistortionTexID,
                width >> distortion.DownScaleFactor.value,
                height >> distortion.DownScaleFactor.value,
                0, FilterMode.Bilinear, RenderTextureFormat.RGFloat);
            cmd.SetRenderTarget(_globalDistortionTexID);
            cmd.ClearRenderTarget(false, true, Color.clear);
        }
        DistortionManager.Instance.PopulateCommandBuffer(cmd, ref cameraData.camera);

        cmd.SetGlobalTexture(MainTexId, source);
        cmd.GetTemporaryRT(destination, width, height, 24, FilterMode.Point, RenderTextureFormat.ARGBFloat);
        cmd.Blit(source, destination);
        cmd.Blit(destination, source, material, 0);

    }
}