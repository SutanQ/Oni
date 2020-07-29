using System;

namespace UnityEngine.Rendering.Universal
{
    [Serializable, VolumeComponentMenu("Custom/PostProcessOutline")]
    public sealed class PostProcessOutline : VolumeComponent, IPostProcessComponent
    {
        public BoolParameter Activity = new BoolParameter(true);
        public BoolParameter useSobel = new BoolParameter(false);
        [Tooltip("只使用Sobel畫線條")]
        public BoolParameter onlyUseSobel = new BoolParameter(false);
        [Tooltip("Sobel檢測範圍")]
        public MinFloatParameter sobelRange = new MinFloatParameter(1.0f, 0) ;
        [Tooltip("Sobel顏色Power")]
        public MinFloatParameter sobelPower = new MinFloatParameter(1.0f, 0);
        [Tooltip("Sobel檢測門檻")]
        public MinFloatParameter sobelTranshold = new MinFloatParameter(0.3f, 0);


        [Tooltip("Number of pixels between samples that are tested for an edge. When this value is 1, tested samples are adjacent.")]
        public FloatParameter scale = new FloatParameter(1);
        [Tooltip("因深度距離而調整線寬的比例")]
        public FloatParameter depthScale = new FloatParameter(30);
        public ColorParameter color = new ColorParameter(Color.white);
        [Tooltip("Difference between depth values, scaled by the current depth, required to draw an edge.")]
        public FloatParameter depthThreshold = new FloatParameter(1.5f);
        [Range(0, 1), Tooltip("The value at which the dot product between the surface normal and the view direction will affect " +
            "the depth threshold. This ensures that surfaces at right angles to the camera require a larger depth threshold to draw " +
            "an edge, avoiding edges being drawn along slopes.")]
        public FloatParameter depthNormalThreshold = new FloatParameter(0.5f);
        [Tooltip("Scale the strength of how much the depthNormalThreshold affects the depth threshold.")]
        public FloatParameter depthNormalThresholdScale = new FloatParameter(7);
        [Range(0, 1), Tooltip("Larger values will require the difference between normals to be greater to draw an edge.")]
        public FloatParameter normalThreshold = new FloatParameter(0.4f);


        public bool IsActive() => Activity.value == true;

        public bool IsTileCompatible() => false;
        
    }
}