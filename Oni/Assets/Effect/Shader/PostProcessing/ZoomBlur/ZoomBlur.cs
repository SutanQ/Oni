﻿using System;

namespace UnityEngine.Rendering.Universal
{
    [Serializable, VolumeComponentMenu("Custom/ZoomBlur")]
    public class ZoomBlur : VolumeComponent, IPostProcessComponent
    {
        [Range(0f, 100f), Tooltip("強くすることで強いBlurがかかります。")]
        public FloatParameter focusPower = new FloatParameter(0f);

        [Range(0, 10), Tooltip("値が大きいほど綺麗にでますが負荷が高まるので注意してください。")]
        public IntParameter focusDetail = new IntParameter(5);

        [Tooltip("ブラーの中心座標。スクリーンの中心を(0,0)としています。")]
        public Vector2Parameter focusScreenPosition = new Vector2Parameter(Vector2.zero);

        public bool IsActive() => focusPower.value > 0f;

        public bool IsTileCompatible() => false;
    }
}