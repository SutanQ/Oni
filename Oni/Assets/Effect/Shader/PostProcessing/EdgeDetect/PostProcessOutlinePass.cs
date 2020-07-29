using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class PostProcessOutlinePass : ScriptableRenderPass
{
    static readonly string p_RenderTag = "Render Outline Effects";
    static readonly int MainTexId = Shader.PropertyToID("_MainTex");
    static readonly int TempTargetId = Shader.PropertyToID("_TempTargetOutline");
    static readonly int _globalSobelTexID = Shader.PropertyToID("_GlobalSobelTex");
    static readonly int _globalSobelDepthTexID = Shader.PropertyToID("_GlobalSobelDepthTex");

    PostProcessOutline postProcessOutline;
    private Material material;
    private RenderTargetIdentifier currentTarget;


    public void Setup(RenderTargetIdentifier currentTarget)
    {
        this.currentTarget = currentTarget;
    }

    public PostProcessOutlinePass(RenderPassEvent evt)
    {
        renderPassEvent = evt;
        var shader = Shader.Find("PostEffect/PostProcessOutline");

        if (shader == null)
        {
            Debug.LogError("PostProcessOutline Shader Not found.");
            return; 
        }
        material = CoreUtils.CreateEngineMaterial(shader);
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        if (material == null)
        {
            Debug.LogError("PostProcessOutline Shader Not found.");
            return;
        }
         
        if (!renderingData.cameraData.postProcessEnabled) { return; }

        var stack = VolumeManager.instance.stack;
        postProcessOutline = stack.GetComponent<PostProcessOutline>();
        if (postProcessOutline == null) { return; }
        if (!postProcessOutline.IsActive()) { return; }

        CommandBuffer cmd = CommandBufferPool.Get(p_RenderTag);
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

        material.SetFloat("_SobelRange", postProcessOutline.sobelRange.value);
        material.SetFloat("_SobelPower", postProcessOutline.sobelPower.value);
        material.SetFloat("_SobelTranshold", postProcessOutline.sobelTranshold.value);
        material.SetFloat("_Scale", postProcessOutline.scale.value);
        material.SetFloat("_DepthScale", postProcessOutline.depthScale.value);
        material.SetColor("_Color", postProcessOutline.color.value);
        material.SetFloat("_DepthThreshold", postProcessOutline.depthThreshold.value);
        material.SetFloat("_DepthNormalThreshold", postProcessOutline.depthNormalThreshold.value);
        material.SetFloat("_DepthNormalThresholdScale", postProcessOutline.depthNormalThresholdScale.value);
        material.SetFloat("_NormalThreshold", postProcessOutline.normalThreshold.value);
        material.SetInt("_OnlyUseSobel", ((postProcessOutline.onlyUseSobel.value == true) ? 0 : 1));

        Matrix4x4 clipToView = GL.GetGPUProjectionMatrix(cameraData.camera.projectionMatrix, true).inverse;
        material.SetMatrix("_ClipToView", clipToView);
        //Sobel線條
        if (postProcessOutline.useSobel.value)
        {
            cmd.GetTemporaryRT(_globalSobelTexID, width, height, 24, FilterMode.Point, RenderTextureFormat.ARGBFloat);
            cmd.GetTemporaryRT(_globalSobelDepthTexID, width, height, 24, FilterMode.Point, RenderTextureFormat.Depth);
            cmd.SetRenderTarget(_globalSobelTexID, UnityEngine.Rendering.RenderBufferLoadAction.DontCare, UnityEngine.Rendering.RenderBufferStoreAction.DontCare,
                _globalSobelDepthTexID, UnityEngine.Rendering.RenderBufferLoadAction.DontCare, UnityEngine.Rendering.RenderBufferStoreAction.DontCare);
            cmd.ClearRenderTarget(true, true, Color.clear, 1.0f);
            SobelManager.Instance.PopulateCommandBuffer(cmd);
        }
     

        cmd.SetGlobalTexture(MainTexId, source);
        cmd.GetTemporaryRT(destination, width, height, 24, FilterMode.Point, RenderTextureFormat.ARGBFloat);
        cmd.Blit(source, destination);
        cmd.Blit(destination, source, material, 0);
    }

    /*
    void Render(CommandBuffer cmd, ref RenderingData renderingData)
    {
        ref var cameraData = ref renderingData.cameraData;
        var source = currentTarget;

        var width = cameraData.camera.scaledPixelWidth;
        var height = cameraData.camera.scaledPixelHeight;

        material.SetFloat("_SobelRange", postProcessOutline.sobelRange.value);
        material.SetFloat("_SobelPower", postProcessOutline.sobelPower.value);
        material.SetFloat("_SobelTranshold", postProcessOutline.sobelTranshold.value);
        material.SetFloat("_Scale", postProcessOutline.scale.value);
        material.SetFloat("_DepthScale", postProcessOutline.depthScale.value);
        material.SetColor("_Color", postProcessOutline.color.value);
        material.SetFloat("_DepthThreshold", postProcessOutline.depthThreshold.value);
        material.SetFloat("_DepthNormalThreshold", postProcessOutline.depthNormalThreshold.value);
        material.SetFloat("_DepthNormalThresholdScale", postProcessOutline.depthNormalThresholdScale.value);
        material.SetFloat("_NormalThreshold", postProcessOutline.normalThreshold.value);

        Matrix4x4 clipToView = GL.GetGPUProjectionMatrix(cameraData.camera.projectionMatrix, true).inverse;
        material.SetMatrix("_ClipToView", clipToView);
        //Sobel線條
        if (postProcessOutline.useSobel.value)
        {
            Debug.Log("Sobel");
            cmd.GetTemporaryRT(_globalSobelTexID, width, height, 24, FilterMode.Point, RenderTextureFormat.ARGBFloat);
            cmd.GetTemporaryRT(_globalSobelDepthTexID, width, height, 24, FilterMode.Point, RenderTextureFormat.Depth);
            cmd.SetRenderTarget(_globalSobelTexID, UnityEngine.Rendering.RenderBufferLoadAction.DontCare, UnityEngine.Rendering.RenderBufferStoreAction.DontCare,
                _globalSobelDepthTexID, UnityEngine.Rendering.RenderBufferLoadAction.DontCare, UnityEngine.Rendering.RenderBufferStoreAction.DontCare);
            cmd.ClearRenderTarget(true, true, Color.clear, 1.0f);
            SobelManager.Instance.PopulateCommandBuffer(cmd);
        }
        //context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        cmd.SetGlobalTexture(MainTexId, source);
        cmd.Blit(source, source, material, 0);
    }
    */
}