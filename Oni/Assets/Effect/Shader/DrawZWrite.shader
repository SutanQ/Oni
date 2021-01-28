Shader "Custom/DrawZWrite"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        Pass{
            ZWrite Off
        }
    }
}
