Shader "PostEffect/Distortion"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Cull Off ZWrite Off ZTest Always
		Tags{ "RenderPipeline" = "UniversalPipeline" }
		Pass
		{
			CGPROGRAM
			#pragma vertex Vert
			#pragma fragment Frag

			sampler2D _MainTex;
			sampler2D _GlobalDistortionTex;
			float4 _MainTex_TexelSize;
			float _Magnitude;


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f Vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 Frag(v2f i) : SV_Target
			{
				float2 mag = _Magnitude * _MainTex_TexelSize.xy;
				float2 distortion = tex2D(_GlobalDistortionTex, i.uv).xy * mag;
				float4 color = tex2D(_MainTex, i.uv + distortion);
				return color;
			}
			ENDCG
		}
	}
}
