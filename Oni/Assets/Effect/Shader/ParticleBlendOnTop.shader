Shader "Shader Graphs/ParticleBlendOnTop"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		Vector2_FB60315F("Tiling", Vector) = (1, 1, 0, 0)
		[NoScaleOffset]Texture2D_90210E7D("MainTex", 2D) = "white" {}
	[NoScaleOffset]_MaskTex("MaskTex", 2D) = "white" {}
	Vector1_FC9BCA76("ColorStrength", Float) = 1
		Vector1_A2984BC("AlphaClip", Range(0, 1)) = 0.1
		Vector1_70FA963C("AddAlpha", Range(-1, 1)) = 0
		Vector1_E514496D("PosterizeSteps", Int) = 4
		Vector1_18CD6163("AddPosterizeColorValue", Float) = 0.05
		Vector2_B02498D3("MoveSpeed", Vector) = (0, 0, 0, 0)
		[Toggle]BOOLEAN_CA9D1AC6("UseUV1", Float) = 0
		[Toggle]BOOLEAN_15B78E78("UsePosterize", Float) = 0
		[Toggle]BOOLEAN_214BDA66("UseMoveUV", Float) = 0
	}
		SubShader
	{
		Tags
	{
		"RenderPipeline" = "UniversalPipeline"
		"RenderType" = "Opaque"
		"Queue" = "Geometry+0"
	}

		Pass
	{
		Name "Pass"
		Tags
	{
		// LightMode: <None>
	}

	// Render State
		Blend One Zero, One Zero
		Cull Off
		ZTest Always
		ZWrite On
		// ColorMask: <None>


		HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		// Pragmas
#pragma prefer_hlslcc gles
#pragma exclude_renderers d3d11_9x
#pragma target 2.0
#pragma multi_compile_fog
#pragma multi_compile_instancing

		// Keywords
#pragma multi_compile _ LIGHTMAP_ON
#pragma multi_compile _ DIRLIGHTMAP_COMBINED
#pragma shader_feature _ _SAMPLE_GI
#pragma shader_feature_local _ BOOLEAN_CA9D1AC6_ON
#pragma shader_feature_local _ BOOLEAN_15B78E78_ON
#pragma shader_feature_local _ BOOLEAN_214BDA66_ON

#if defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_15B78E78_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_0
#elif defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_15B78E78_ON)
#define KEYWORD_PERMUTATION_1
#elif defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_2
#elif defined(BOOLEAN_CA9D1AC6_ON)
#define KEYWORD_PERMUTATION_3
#elif defined(BOOLEAN_15B78E78_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_4
#elif defined(BOOLEAN_15B78E78_ON)
#define KEYWORD_PERMUTATION_5
#elif defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


		// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define _AlphaClip 1
#endif





#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_COLOR
#endif




#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define VARYINGS_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
#define VARYINGS_NEED_TEXCOORD1
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define VARYINGS_NEED_COLOR
#endif






#pragma multi_compile_instancing
#define SHADERPASS_UNLIT


		// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

		// --------------------------------------------------
		// Graph

		// Graph Properties
		CBUFFER_START(UnityPerMaterial)
		float4 _Color;
	float2 Vector2_FB60315F;
	float Vector1_FC9BCA76;
	float Vector1_A2984BC;
	float Vector1_70FA963C;
	float Vector1_E514496D;
	float Vector1_18CD6163;
	float2 Vector2_B02498D3;
	CBUFFER_END
		TEXTURE2D(Texture2D_90210E7D); SAMPLER(samplerTexture2D_90210E7D); float4 Texture2D_90210E7D_TexelSize;
	TEXTURE2D(_MaskTex); SAMPLER(sampler_MaskTex); float4 _MaskTex_TexelSize;
	SAMPLER(_SampleTexture2D_57212518_Sampler_3_Linear_Repeat);
	SAMPLER(_SampleTexture2D_CB05E05_Sampler_3_Linear_Repeat);

	// Graph Functions

	void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
	{
		Out = A * B;
	}

	void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
	{
		Out = UV * Tiling + Offset;
	}

	void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
	{
		Out = A * B;
	}

	void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
	{
		Out = floor(In / (1 / Steps)) * (1 / Steps);
	}

	void Unity_Add_float(float A, float B, out float Out)
	{
		Out = A + B;
	}

	void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
	{
		RGBA = float4(R, G, B, A);
		RGB = float3(R, G, B);
		RG = float2(R, G);
	}

	void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
	{
		Out = clamp(In, Min, Max);
	}

	void Unity_Multiply_float(float A, float B, out float Out)
	{
		Out = A * B;
	}

	void Unity_Clamp_float(float In, float Min, float Max, out float Out)
	{
		Out = clamp(In, Min, Max);
	}

	// Graph Vertex
	// GraphVertex: <None>

	// Graph Pixel
	struct SurfaceDescriptionInputs
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 uv0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float3 TimeParameters;
#endif
	};

	struct SurfaceDescription
	{
		float3 Color;
		float Alpha;
		float AlphaClipThreshold;
	};

	SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
	{
		SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Property_49B32D75_Out_0 = Vector1_FC9BCA76;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 _UV_4379F8B5_Out_0 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Property_570C4BE7_Out_0 = _Color;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float2 _Property_7A5EFC19_Out_0 = Vector2_FB60315F;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float2 _Property_E8516304_Out_0 = Vector2_B02498D3;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float2 _Multiply_D647BD6B_Out_2;
		Unity_Multiply_float(_Property_E8516304_Out_0, (IN.TimeParameters.x.xx), _Multiply_D647BD6B_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_214BDA66_ON)
		float2 _UseMoveUV_EAE9C53A_Out_0 = _Multiply_D647BD6B_Out_2;
#else
		float2 _UseMoveUV_EAE9C53A_Out_0 = float2(0, 0);
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float2 _TilingAndOffset_7AF60D8E_Out_3;
		Unity_TilingAndOffset_float(IN.uv0.xy, _Property_7A5EFC19_Out_0, _UseMoveUV_EAE9C53A_Out_0, _TilingAndOffset_7AF60D8E_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _SampleTexture2D_57212518_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_7AF60D8E_Out_3);
		float _SampleTexture2D_57212518_R_4 = _SampleTexture2D_57212518_RGBA_0.r;
		float _SampleTexture2D_57212518_G_5 = _SampleTexture2D_57212518_RGBA_0.g;
		float _SampleTexture2D_57212518_B_6 = _SampleTexture2D_57212518_RGBA_0.b;
		float _SampleTexture2D_57212518_A_7 = _SampleTexture2D_57212518_RGBA_0.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Multiply_B79A2486_Out_2;
		Unity_Multiply_float(_Property_570C4BE7_Out_0, _SampleTexture2D_57212518_RGBA_0, _Multiply_B79A2486_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Property_38B4DEC_Out_0 = Vector1_E514496D;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Posterize_A92A9503_Out_2;
		Unity_Posterize_float4(_Multiply_B79A2486_Out_2, (_Property_38B4DEC_Out_0.xxxx), _Posterize_A92A9503_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Split_AFE4781_R_1 = _Posterize_A92A9503_Out_2[0];
		float _Split_AFE4781_G_2 = _Posterize_A92A9503_Out_2[1];
		float _Split_AFE4781_B_3 = _Posterize_A92A9503_Out_2[2];
		float _Split_AFE4781_A_4 = _Posterize_A92A9503_Out_2[3];
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Property_9A83006B_Out_0 = Vector1_18CD6163;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_51A7B183_Out_2;
		Unity_Add_float(_Split_AFE4781_R_1, _Property_9A83006B_Out_0, _Add_51A7B183_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_E72E272D_Out_2;
		Unity_Add_float(_Split_AFE4781_G_2, _Property_9A83006B_Out_0, _Add_E72E272D_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_A5EB3FBE_Out_2;
		Unity_Add_float(_Split_AFE4781_B_3, _Property_9A83006B_Out_0, _Add_A5EB3FBE_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Combine_6A623F4B_RGBA_4;
		float3 _Combine_6A623F4B_RGB_5;
		float2 _Combine_6A623F4B_RG_6;
		Unity_Combine_float(_Add_51A7B183_Out_2, _Add_E72E272D_Out_2, _Add_A5EB3FBE_Out_2, _SampleTexture2D_57212518_A_7, _Combine_6A623F4B_RGBA_4, _Combine_6A623F4B_RGB_5, _Combine_6A623F4B_RG_6);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Clamp_94592A02_Out_3;
		Unity_Clamp_float4(_Combine_6A623F4B_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_94592A02_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_15B78E78_ON)
		float4 _UsePosterize_5C6315D3_Out_0 = _Clamp_94592A02_Out_3;
#else
		float4 _UsePosterize_5C6315D3_Out_0 = _Multiply_B79A2486_Out_2;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Multiply_6AE4C267_Out_2;
		Unity_Multiply_float(IN.VertexColor, _UsePosterize_5C6315D3_Out_0, _Multiply_6AE4C267_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 _Multiply_2D444A7F_Out_2;
		Unity_Multiply_float(_UV_4379F8B5_Out_0, _Multiply_6AE4C267_Out_2, _Multiply_2D444A7F_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_CA9D1AC6_ON)
		float4 _UseUV1_2E26BE39_Out_0 = _Multiply_2D444A7F_Out_2;
#else
		float4 _UseUV1_2E26BE39_Out_0 = _Multiply_6AE4C267_Out_2;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Multiply_C84F5509_Out_2;
		Unity_Multiply_float((_Property_49B32D75_Out_0.xxxx), _UseUV1_2E26BE39_Out_0, _Multiply_C84F5509_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Split_D470DD57_R_1 = _Multiply_C84F5509_Out_2[0];
		float _Split_D470DD57_G_2 = _Multiply_C84F5509_Out_2[1];
		float _Split_D470DD57_B_3 = _Multiply_C84F5509_Out_2[2];
		float _Split_D470DD57_A_4 = _Multiply_C84F5509_Out_2[3];
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Combine_256EDD9_RGBA_4;
		float3 _Combine_256EDD9_RGB_5;
		float2 _Combine_256EDD9_RG_6;
		Unity_Combine_float(_Split_D470DD57_R_1, _Split_D470DD57_G_2, _Split_D470DD57_B_3, 0, _Combine_256EDD9_RGBA_4, _Combine_256EDD9_RGB_5, _Combine_256EDD9_RG_6);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Split_AAA8C749_R_1 = _UseUV1_2E26BE39_Out_0[0];
		float _Split_AAA8C749_G_2 = _UseUV1_2E26BE39_Out_0[1];
		float _Split_AAA8C749_B_3 = _UseUV1_2E26BE39_Out_0[2];
		float _Split_AAA8C749_A_4 = _UseUV1_2E26BE39_Out_0[3];
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Property_A1761D39_Out_0 = Vector1_70FA963C;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Add_792E777D_Out_2;
		Unity_Add_float(_Split_AAA8C749_A_4, _Property_A1761D39_Out_0, _Add_792E777D_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _SampleTexture2D_CB05E05_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
		float _SampleTexture2D_CB05E05_R_4 = _SampleTexture2D_CB05E05_RGBA_0.r;
		float _SampleTexture2D_CB05E05_G_5 = _SampleTexture2D_CB05E05_RGBA_0.g;
		float _SampleTexture2D_CB05E05_B_6 = _SampleTexture2D_CB05E05_RGBA_0.b;
		float _SampleTexture2D_CB05E05_A_7 = _SampleTexture2D_CB05E05_RGBA_0.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Multiply_BEA7C04B_Out_2;
		Unity_Multiply_float(_Add_792E777D_Out_2, _SampleTexture2D_CB05E05_R_4, _Multiply_BEA7C04B_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Clamp_F3AB31D9_Out_3;
		Unity_Clamp_float(_Multiply_BEA7C04B_Out_2, 0, 1, _Clamp_F3AB31D9_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Property_92B50B5_Out_0 = Vector1_A2984BC;
#endif
		surface.Color = _Combine_256EDD9_RGB_5;
		surface.Alpha = _Clamp_F3AB31D9_Out_3;
		surface.AlphaClipThreshold = _Property_92B50B5_Out_0;
		return surface;
	}

	// --------------------------------------------------
	// Structs and Packing

	// Generated Type: Attributes
	struct Attributes
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
	};

	// Generated Type: Varyings
	struct Varyings
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 texCoord0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 texCoord1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 color;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
	};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
	// Generated Type: PackedVaryings
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
		float4 interp00 : TEXCOORD0;
		float4 interp01 : TEXCOORD1;
		float4 interp02 : TEXCOORD2;
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
	};

	// Packed Type: Varyings
	PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output = (PackedVaryings)0;
		output.positionCS = input.positionCS;
		output.interp00.xyzw = input.texCoord0;
		output.interp01.xyzw = input.texCoord1;
		output.interp02.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}

	// Unpacked Type: Varyings
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output = (Varyings)0;
		output.positionCS = input.positionCS;
		output.texCoord0 = input.interp00.xyzw;
		output.texCoord1 = input.interp01.xyzw;
		output.color = input.interp02.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}
#elif defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
	// Generated Type: PackedVaryings
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
		float4 interp00 : TEXCOORD0;
		float4 interp01 : TEXCOORD1;
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
	};

	// Packed Type: Varyings
	PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output = (PackedVaryings)0;
		output.positionCS = input.positionCS;
		output.interp00.xyzw = input.texCoord0;
		output.interp01.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}

	// Unpacked Type: Varyings
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output = (Varyings)0;
		output.positionCS = input.positionCS;
		output.texCoord0 = input.interp00.xyzw;
		output.color = input.interp01.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}
#endif

	// --------------------------------------------------
	// Build Graph Inputs

	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
	{
		SurfaceDescriptionInputs output;
		ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





































#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		output.uv0 = input.texCoord0;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		output.uv1 = input.texCoord1;
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		output.VertexColor = input.color;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
#endif

#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif

#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

		return output;
	}


	// --------------------------------------------------
	// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

	ENDHLSL
	}

		Pass
	{
		Name "ShadowCaster"
		Tags
	{
		"LightMode" = "ShadowCaster"
	}

		// Render State
		Blend One Zero, One Zero
		Cull Off
		ZTest LEqual
		ZWrite On
		// ColorMask: <None>


		HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		// Pragmas
#pragma prefer_hlslcc gles
#pragma exclude_renderers d3d11_9x
#pragma target 2.0
#pragma multi_compile_instancing

		// Keywords
#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
#pragma shader_feature_local _ BOOLEAN_CA9D1AC6_ON
#pragma shader_feature_local _ BOOLEAN_15B78E78_ON
#pragma shader_feature_local _ BOOLEAN_214BDA66_ON

#if defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_15B78E78_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_0
#elif defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_15B78E78_ON)
#define KEYWORD_PERMUTATION_1
#elif defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_2
#elif defined(BOOLEAN_CA9D1AC6_ON)
#define KEYWORD_PERMUTATION_3
#elif defined(BOOLEAN_15B78E78_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_4
#elif defined(BOOLEAN_15B78E78_ON)
#define KEYWORD_PERMUTATION_5
#elif defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


		// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define _AlphaClip 1
#endif





#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_COLOR
#endif




#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define VARYINGS_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
#define VARYINGS_NEED_TEXCOORD1
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define VARYINGS_NEED_COLOR
#endif






#pragma multi_compile_instancing
#define SHADERPASS_SHADOWCASTER


		// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

		// --------------------------------------------------
		// Graph

		// Graph Properties
		CBUFFER_START(UnityPerMaterial)
		float4 _Color;
	float2 Vector2_FB60315F;
	float Vector1_FC9BCA76;
	float Vector1_A2984BC;
	float Vector1_70FA963C;
	float Vector1_E514496D;
	float Vector1_18CD6163;
	float2 Vector2_B02498D3;
	CBUFFER_END
		TEXTURE2D(Texture2D_90210E7D); SAMPLER(samplerTexture2D_90210E7D); float4 Texture2D_90210E7D_TexelSize;
	TEXTURE2D(_MaskTex); SAMPLER(sampler_MaskTex); float4 _MaskTex_TexelSize;
	SAMPLER(_SampleTexture2D_57212518_Sampler_3_Linear_Repeat);
	SAMPLER(_SampleTexture2D_CB05E05_Sampler_3_Linear_Repeat);

	// Graph Functions

	void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
	{
		Out = A * B;
	}

	void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
	{
		Out = UV * Tiling + Offset;
	}

	void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
	{
		Out = A * B;
	}

	void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
	{
		Out = floor(In / (1 / Steps)) * (1 / Steps);
	}

	void Unity_Add_float(float A, float B, out float Out)
	{
		Out = A + B;
	}

	void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
	{
		RGBA = float4(R, G, B, A);
		RGB = float3(R, G, B);
		RG = float2(R, G);
	}

	void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
	{
		Out = clamp(In, Min, Max);
	}

	void Unity_Multiply_float(float A, float B, out float Out)
	{
		Out = A * B;
	}

	void Unity_Clamp_float(float In, float Min, float Max, out float Out)
	{
		Out = clamp(In, Min, Max);
	}

	// Graph Vertex
	// GraphVertex: <None>

	// Graph Pixel
	struct SurfaceDescriptionInputs
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 uv0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float3 TimeParameters;
#endif
	};

	struct SurfaceDescription
	{
		float Alpha;
		float AlphaClipThreshold;
	};

	SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
	{
		SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 _UV_4379F8B5_Out_0 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Property_570C4BE7_Out_0 = _Color;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float2 _Property_7A5EFC19_Out_0 = Vector2_FB60315F;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float2 _Property_E8516304_Out_0 = Vector2_B02498D3;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float2 _Multiply_D647BD6B_Out_2;
		Unity_Multiply_float(_Property_E8516304_Out_0, (IN.TimeParameters.x.xx), _Multiply_D647BD6B_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_214BDA66_ON)
		float2 _UseMoveUV_EAE9C53A_Out_0 = _Multiply_D647BD6B_Out_2;
#else
		float2 _UseMoveUV_EAE9C53A_Out_0 = float2(0, 0);
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float2 _TilingAndOffset_7AF60D8E_Out_3;
		Unity_TilingAndOffset_float(IN.uv0.xy, _Property_7A5EFC19_Out_0, _UseMoveUV_EAE9C53A_Out_0, _TilingAndOffset_7AF60D8E_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _SampleTexture2D_57212518_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_7AF60D8E_Out_3);
		float _SampleTexture2D_57212518_R_4 = _SampleTexture2D_57212518_RGBA_0.r;
		float _SampleTexture2D_57212518_G_5 = _SampleTexture2D_57212518_RGBA_0.g;
		float _SampleTexture2D_57212518_B_6 = _SampleTexture2D_57212518_RGBA_0.b;
		float _SampleTexture2D_57212518_A_7 = _SampleTexture2D_57212518_RGBA_0.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Multiply_B79A2486_Out_2;
		Unity_Multiply_float(_Property_570C4BE7_Out_0, _SampleTexture2D_57212518_RGBA_0, _Multiply_B79A2486_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Property_38B4DEC_Out_0 = Vector1_E514496D;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Posterize_A92A9503_Out_2;
		Unity_Posterize_float4(_Multiply_B79A2486_Out_2, (_Property_38B4DEC_Out_0.xxxx), _Posterize_A92A9503_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Split_AFE4781_R_1 = _Posterize_A92A9503_Out_2[0];
		float _Split_AFE4781_G_2 = _Posterize_A92A9503_Out_2[1];
		float _Split_AFE4781_B_3 = _Posterize_A92A9503_Out_2[2];
		float _Split_AFE4781_A_4 = _Posterize_A92A9503_Out_2[3];
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Property_9A83006B_Out_0 = Vector1_18CD6163;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_51A7B183_Out_2;
		Unity_Add_float(_Split_AFE4781_R_1, _Property_9A83006B_Out_0, _Add_51A7B183_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_E72E272D_Out_2;
		Unity_Add_float(_Split_AFE4781_G_2, _Property_9A83006B_Out_0, _Add_E72E272D_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_A5EB3FBE_Out_2;
		Unity_Add_float(_Split_AFE4781_B_3, _Property_9A83006B_Out_0, _Add_A5EB3FBE_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Combine_6A623F4B_RGBA_4;
		float3 _Combine_6A623F4B_RGB_5;
		float2 _Combine_6A623F4B_RG_6;
		Unity_Combine_float(_Add_51A7B183_Out_2, _Add_E72E272D_Out_2, _Add_A5EB3FBE_Out_2, _SampleTexture2D_57212518_A_7, _Combine_6A623F4B_RGBA_4, _Combine_6A623F4B_RGB_5, _Combine_6A623F4B_RG_6);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Clamp_94592A02_Out_3;
		Unity_Clamp_float4(_Combine_6A623F4B_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_94592A02_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_15B78E78_ON)
		float4 _UsePosterize_5C6315D3_Out_0 = _Clamp_94592A02_Out_3;
#else
		float4 _UsePosterize_5C6315D3_Out_0 = _Multiply_B79A2486_Out_2;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Multiply_6AE4C267_Out_2;
		Unity_Multiply_float(IN.VertexColor, _UsePosterize_5C6315D3_Out_0, _Multiply_6AE4C267_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 _Multiply_2D444A7F_Out_2;
		Unity_Multiply_float(_UV_4379F8B5_Out_0, _Multiply_6AE4C267_Out_2, _Multiply_2D444A7F_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_CA9D1AC6_ON)
		float4 _UseUV1_2E26BE39_Out_0 = _Multiply_2D444A7F_Out_2;
#else
		float4 _UseUV1_2E26BE39_Out_0 = _Multiply_6AE4C267_Out_2;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Split_AAA8C749_R_1 = _UseUV1_2E26BE39_Out_0[0];
		float _Split_AAA8C749_G_2 = _UseUV1_2E26BE39_Out_0[1];
		float _Split_AAA8C749_B_3 = _UseUV1_2E26BE39_Out_0[2];
		float _Split_AAA8C749_A_4 = _UseUV1_2E26BE39_Out_0[3];
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Property_A1761D39_Out_0 = Vector1_70FA963C;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Add_792E777D_Out_2;
		Unity_Add_float(_Split_AAA8C749_A_4, _Property_A1761D39_Out_0, _Add_792E777D_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _SampleTexture2D_CB05E05_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
		float _SampleTexture2D_CB05E05_R_4 = _SampleTexture2D_CB05E05_RGBA_0.r;
		float _SampleTexture2D_CB05E05_G_5 = _SampleTexture2D_CB05E05_RGBA_0.g;
		float _SampleTexture2D_CB05E05_B_6 = _SampleTexture2D_CB05E05_RGBA_0.b;
		float _SampleTexture2D_CB05E05_A_7 = _SampleTexture2D_CB05E05_RGBA_0.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Multiply_BEA7C04B_Out_2;
		Unity_Multiply_float(_Add_792E777D_Out_2, _SampleTexture2D_CB05E05_R_4, _Multiply_BEA7C04B_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Clamp_F3AB31D9_Out_3;
		Unity_Clamp_float(_Multiply_BEA7C04B_Out_2, 0, 1, _Clamp_F3AB31D9_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Property_92B50B5_Out_0 = Vector1_A2984BC;
#endif
		surface.Alpha = _Clamp_F3AB31D9_Out_3;
		surface.AlphaClipThreshold = _Property_92B50B5_Out_0;
		return surface;
	}

	// --------------------------------------------------
	// Structs and Packing

	// Generated Type: Attributes
	struct Attributes
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
	};

	// Generated Type: Varyings
	struct Varyings
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 texCoord0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 texCoord1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 color;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
	};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
	// Generated Type: PackedVaryings
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
		float4 interp00 : TEXCOORD0;
		float4 interp01 : TEXCOORD1;
		float4 interp02 : TEXCOORD2;
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
	};

	// Packed Type: Varyings
	PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output = (PackedVaryings)0;
		output.positionCS = input.positionCS;
		output.interp00.xyzw = input.texCoord0;
		output.interp01.xyzw = input.texCoord1;
		output.interp02.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}

	// Unpacked Type: Varyings
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output = (Varyings)0;
		output.positionCS = input.positionCS;
		output.texCoord0 = input.interp00.xyzw;
		output.texCoord1 = input.interp01.xyzw;
		output.color = input.interp02.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}
#elif defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
	// Generated Type: PackedVaryings
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
		float4 interp00 : TEXCOORD0;
		float4 interp01 : TEXCOORD1;
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
	};

	// Packed Type: Varyings
	PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output = (PackedVaryings)0;
		output.positionCS = input.positionCS;
		output.interp00.xyzw = input.texCoord0;
		output.interp01.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}

	// Unpacked Type: Varyings
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output = (Varyings)0;
		output.positionCS = input.positionCS;
		output.texCoord0 = input.interp00.xyzw;
		output.color = input.interp01.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}
#endif

	// --------------------------------------------------
	// Build Graph Inputs

	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
	{
		SurfaceDescriptionInputs output;
		ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





































#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		output.uv0 = input.texCoord0;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		output.uv1 = input.texCoord1;
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		output.VertexColor = input.color;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
#endif

#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif

#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

		return output;
	}


	// --------------------------------------------------
	// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

	ENDHLSL
	}

		Pass
	{
		Name "DepthOnly"
		Tags
	{
		"LightMode" = "DepthOnly"
	}

		// Render State
		Blend One Zero, One Zero
		Cull Off
		ZTest LEqual
		ZWrite On
		ColorMask 0


		HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

		// Debug
		// <None>

		// --------------------------------------------------
		// Pass

		// Pragmas
#pragma prefer_hlslcc gles
#pragma exclude_renderers d3d11_9x
#pragma target 2.0
#pragma multi_compile_instancing

		// Keywords
		// PassKeywords: <None>
#pragma shader_feature_local _ BOOLEAN_CA9D1AC6_ON
#pragma shader_feature_local _ BOOLEAN_15B78E78_ON
#pragma shader_feature_local _ BOOLEAN_214BDA66_ON

#if defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_15B78E78_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_0
#elif defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_15B78E78_ON)
#define KEYWORD_PERMUTATION_1
#elif defined(BOOLEAN_CA9D1AC6_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_2
#elif defined(BOOLEAN_CA9D1AC6_ON)
#define KEYWORD_PERMUTATION_3
#elif defined(BOOLEAN_15B78E78_ON) && defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_4
#elif defined(BOOLEAN_15B78E78_ON)
#define KEYWORD_PERMUTATION_5
#elif defined(BOOLEAN_214BDA66_ON)
#define KEYWORD_PERMUTATION_6
#else
#define KEYWORD_PERMUTATION_7
#endif


		// Defines

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define _AlphaClip 1
#endif





#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_NORMAL
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_TANGENT
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
#define ATTRIBUTES_NEED_TEXCOORD1
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define ATTRIBUTES_NEED_COLOR
#endif




#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define VARYINGS_NEED_TEXCOORD0
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
#define VARYINGS_NEED_TEXCOORD1
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#define VARYINGS_NEED_COLOR
#endif






#pragma multi_compile_instancing
#define SHADERPASS_DEPTHONLY


		// Includes
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

		// --------------------------------------------------
		// Graph

		// Graph Properties
		CBUFFER_START(UnityPerMaterial)
		float4 _Color;
	float2 Vector2_FB60315F;
	float Vector1_FC9BCA76;
	float Vector1_A2984BC;
	float Vector1_70FA963C;
	float Vector1_E514496D;
	float Vector1_18CD6163;
	float2 Vector2_B02498D3;
	CBUFFER_END
		TEXTURE2D(Texture2D_90210E7D); SAMPLER(samplerTexture2D_90210E7D); float4 Texture2D_90210E7D_TexelSize;
	TEXTURE2D(_MaskTex); SAMPLER(sampler_MaskTex); float4 _MaskTex_TexelSize;
	SAMPLER(_SampleTexture2D_57212518_Sampler_3_Linear_Repeat);
	SAMPLER(_SampleTexture2D_CB05E05_Sampler_3_Linear_Repeat);

	// Graph Functions

	void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
	{
		Out = A * B;
	}

	void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
	{
		Out = UV * Tiling + Offset;
	}

	void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
	{
		Out = A * B;
	}

	void Unity_Posterize_float4(float4 In, float4 Steps, out float4 Out)
	{
		Out = floor(In / (1 / Steps)) * (1 / Steps);
	}

	void Unity_Add_float(float A, float B, out float Out)
	{
		Out = A + B;
	}

	void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
	{
		RGBA = float4(R, G, B, A);
		RGB = float3(R, G, B);
		RG = float2(R, G);
	}

	void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
	{
		Out = clamp(In, Min, Max);
	}

	void Unity_Multiply_float(float A, float B, out float Out)
	{
		Out = A * B;
	}

	void Unity_Clamp_float(float In, float Min, float Max, out float Out)
	{
		Out = clamp(In, Min, Max);
	}

	// Graph Vertex
	// GraphVertex: <None>

	// Graph Pixel
	struct SurfaceDescriptionInputs
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 uv0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 VertexColor;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float3 TimeParameters;
#endif
	};

	struct SurfaceDescription
	{
		float Alpha;
		float AlphaClipThreshold;
	};

	SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
	{
		SurfaceDescription surface = (SurfaceDescription)0;
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 _UV_4379F8B5_Out_0 = IN.uv1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Property_570C4BE7_Out_0 = _Color;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float2 _Property_7A5EFC19_Out_0 = Vector2_FB60315F;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float2 _Property_E8516304_Out_0 = Vector2_B02498D3;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		float2 _Multiply_D647BD6B_Out_2;
		Unity_Multiply_float(_Property_E8516304_Out_0, (IN.TimeParameters.x.xx), _Multiply_D647BD6B_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_214BDA66_ON)
		float2 _UseMoveUV_EAE9C53A_Out_0 = _Multiply_D647BD6B_Out_2;
#else
		float2 _UseMoveUV_EAE9C53A_Out_0 = float2(0, 0);
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float2 _TilingAndOffset_7AF60D8E_Out_3;
		Unity_TilingAndOffset_float(IN.uv0.xy, _Property_7A5EFC19_Out_0, _UseMoveUV_EAE9C53A_Out_0, _TilingAndOffset_7AF60D8E_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _SampleTexture2D_57212518_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_7AF60D8E_Out_3);
		float _SampleTexture2D_57212518_R_4 = _SampleTexture2D_57212518_RGBA_0.r;
		float _SampleTexture2D_57212518_G_5 = _SampleTexture2D_57212518_RGBA_0.g;
		float _SampleTexture2D_57212518_B_6 = _SampleTexture2D_57212518_RGBA_0.b;
		float _SampleTexture2D_57212518_A_7 = _SampleTexture2D_57212518_RGBA_0.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Multiply_B79A2486_Out_2;
		Unity_Multiply_float(_Property_570C4BE7_Out_0, _SampleTexture2D_57212518_RGBA_0, _Multiply_B79A2486_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Property_38B4DEC_Out_0 = Vector1_E514496D;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Posterize_A92A9503_Out_2;
		Unity_Posterize_float4(_Multiply_B79A2486_Out_2, (_Property_38B4DEC_Out_0.xxxx), _Posterize_A92A9503_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Split_AFE4781_R_1 = _Posterize_A92A9503_Out_2[0];
		float _Split_AFE4781_G_2 = _Posterize_A92A9503_Out_2[1];
		float _Split_AFE4781_B_3 = _Posterize_A92A9503_Out_2[2];
		float _Split_AFE4781_A_4 = _Posterize_A92A9503_Out_2[3];
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Property_9A83006B_Out_0 = Vector1_18CD6163;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_51A7B183_Out_2;
		Unity_Add_float(_Split_AFE4781_R_1, _Property_9A83006B_Out_0, _Add_51A7B183_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_E72E272D_Out_2;
		Unity_Add_float(_Split_AFE4781_G_2, _Property_9A83006B_Out_0, _Add_E72E272D_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float _Add_A5EB3FBE_Out_2;
		Unity_Add_float(_Split_AFE4781_B_3, _Property_9A83006B_Out_0, _Add_A5EB3FBE_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Combine_6A623F4B_RGBA_4;
		float3 _Combine_6A623F4B_RGB_5;
		float2 _Combine_6A623F4B_RG_6;
		Unity_Combine_float(_Add_51A7B183_Out_2, _Add_E72E272D_Out_2, _Add_A5EB3FBE_Out_2, _SampleTexture2D_57212518_A_7, _Combine_6A623F4B_RGBA_4, _Combine_6A623F4B_RGB_5, _Combine_6A623F4B_RG_6);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5)
		float4 _Clamp_94592A02_Out_3;
		Unity_Clamp_float4(_Combine_6A623F4B_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_94592A02_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_15B78E78_ON)
		float4 _UsePosterize_5C6315D3_Out_0 = _Clamp_94592A02_Out_3;
#else
		float4 _UsePosterize_5C6315D3_Out_0 = _Multiply_B79A2486_Out_2;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _Multiply_6AE4C267_Out_2;
		Unity_Multiply_float(IN.VertexColor, _UsePosterize_5C6315D3_Out_0, _Multiply_6AE4C267_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 _Multiply_2D444A7F_Out_2;
		Unity_Multiply_float(_UV_4379F8B5_Out_0, _Multiply_6AE4C267_Out_2, _Multiply_2D444A7F_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#if defined(BOOLEAN_CA9D1AC6_ON)
		float4 _UseUV1_2E26BE39_Out_0 = _Multiply_2D444A7F_Out_2;
#else
		float4 _UseUV1_2E26BE39_Out_0 = _Multiply_6AE4C267_Out_2;
#endif
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Split_AAA8C749_R_1 = _UseUV1_2E26BE39_Out_0[0];
		float _Split_AAA8C749_G_2 = _UseUV1_2E26BE39_Out_0[1];
		float _Split_AAA8C749_B_3 = _UseUV1_2E26BE39_Out_0[2];
		float _Split_AAA8C749_A_4 = _UseUV1_2E26BE39_Out_0[3];
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Property_A1761D39_Out_0 = Vector1_70FA963C;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Add_792E777D_Out_2;
		Unity_Add_float(_Split_AAA8C749_A_4, _Property_A1761D39_Out_0, _Add_792E777D_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 _SampleTexture2D_CB05E05_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
		float _SampleTexture2D_CB05E05_R_4 = _SampleTexture2D_CB05E05_RGBA_0.r;
		float _SampleTexture2D_CB05E05_G_5 = _SampleTexture2D_CB05E05_RGBA_0.g;
		float _SampleTexture2D_CB05E05_B_6 = _SampleTexture2D_CB05E05_RGBA_0.b;
		float _SampleTexture2D_CB05E05_A_7 = _SampleTexture2D_CB05E05_RGBA_0.a;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Multiply_BEA7C04B_Out_2;
		Unity_Multiply_float(_Add_792E777D_Out_2, _SampleTexture2D_CB05E05_R_4, _Multiply_BEA7C04B_Out_2);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Clamp_F3AB31D9_Out_3;
		Unity_Clamp_float(_Multiply_BEA7C04B_Out_2, 0, 1, _Clamp_F3AB31D9_Out_3);
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float _Property_92B50B5_Out_0 = Vector1_A2984BC;
#endif
		surface.Alpha = _Clamp_F3AB31D9_Out_3;
		surface.AlphaClipThreshold = _Property_92B50B5_Out_0;
		return surface;
	}

	// --------------------------------------------------
	// Structs and Packing

	// Generated Type: Attributes
	struct Attributes
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float3 positionOS : POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float3 normalOS : NORMAL;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 tangentOS : TANGENT;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 uv0 : TEXCOORD0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 uv1 : TEXCOORD1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 color : COLOR;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint instanceID : INSTANCEID_SEMANTIC;
#endif
#endif
	};

	// Generated Type: Varyings
	struct Varyings
	{
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 positionCS : SV_POSITION;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 texCoord0;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		float4 texCoord1;
#endif
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		float4 color;
#endif
#if UNITY_ANY_INSTANCING_ENABLED
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
#endif
	};

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
	// Generated Type: PackedVaryings
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
		float4 interp00 : TEXCOORD0;
		float4 interp01 : TEXCOORD1;
		float4 interp02 : TEXCOORD2;
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
	};

	// Packed Type: Varyings
	PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output = (PackedVaryings)0;
		output.positionCS = input.positionCS;
		output.interp00.xyzw = input.texCoord0;
		output.interp01.xyzw = input.texCoord1;
		output.interp02.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}

	// Unpacked Type: Varyings
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output = (Varyings)0;
		output.positionCS = input.positionCS;
		output.texCoord0 = input.interp00.xyzw;
		output.texCoord1 = input.interp01.xyzw;
		output.color = input.interp02.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}
#elif defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
	// Generated Type: PackedVaryings
	struct PackedVaryings
	{
		float4 positionCS : SV_POSITION;
#if UNITY_ANY_INSTANCING_ENABLED
		uint instanceID : CUSTOM_INSTANCE_ID;
#endif
		float4 interp00 : TEXCOORD0;
		float4 interp01 : TEXCOORD1;
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
#endif
	};

	// Packed Type: Varyings
	PackedVaryings PackVaryings(Varyings input)
	{
		PackedVaryings output = (PackedVaryings)0;
		output.positionCS = input.positionCS;
		output.interp00.xyzw = input.texCoord0;
		output.interp01.xyzw = input.color;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}

	// Unpacked Type: Varyings
	Varyings UnpackVaryings(PackedVaryings input)
	{
		Varyings output = (Varyings)0;
		output.positionCS = input.positionCS;
		output.texCoord0 = input.interp00.xyzw;
		output.color = input.interp01.xyzw;
#if UNITY_ANY_INSTANCING_ENABLED
		output.instanceID = input.instanceID;
#endif
#if (defined(UNITY_STEREO_INSTANCING_ENABLED))
		output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
#endif
#if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
		output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
#endif
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
		output.cullFace = input.cullFace;
#endif
		return output;
	}
#endif

	// --------------------------------------------------
	// Build Graph Inputs

	SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
	{
		SurfaceDescriptionInputs output;
		ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





































#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		output.uv0 = input.texCoord0;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3)
		output.uv1 = input.texCoord1;
#endif



#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
		output.VertexColor = input.color;
#endif

#if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_6)
		output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
#endif

#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif

#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

		return output;
	}


	// --------------------------------------------------
	// Main

#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

	ENDHLSL
	}

	}
		FallBack "Hidden/Shader Graph/FallbackError"
}
