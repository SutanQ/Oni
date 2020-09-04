Shader "Hidden/Roystan/Outline Post Process"
{
	Properties
	{
		[HideInInspector]_MainTex("Base (RGB)", 2D) = "white" {}
		_Scale("_Scale", Range(0.0005, 0.0025)) = 0.001
		_DepthScale("_DepthScale", Range(0, 1)) = 0.5
			_DepthThreshold("_DepthThreshold", Range(0, 1)) = 0.5
			_DepthNormalThreshold("_DepthNormalThreshold", Range(0, 1)) = 0.5
			_DepthNormalThresholdScale("_DepthNormalThresholdScale", Range(0, 1)) = 0.5
			_NormalThreshold("_NormalThreshold", Range(0, 1)) = 0.5
			_SobelRange("_SobelRange", Range(0, 1)) = 0.5
			_SobelPower("_SobelPower", Range(0, 1)) = 0.5
			_SobelTranshold("_SobelTranshold", Range(0, 1)) = 0.5

		//[Toggle(RAW_OUTLINE)]_Raw("Outline Only", Float) = 0
		//[Toggle(POSTERIZE)]_Poseterize("Posterize", Float) = 0
		//_PosterizationCount("Count", int) = 8
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			// Custom post processing effects are written in HLSL blocks,
			// with lots of macros to aid with platform differences.
			// https://github.com/Unity-Technologies/PostProcessing/wiki/Writing-Custom-Effects#shader
			HLSLPROGRAM
			#pragma vertex Vert
			#pragma fragment Frag
			#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

			TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
			TEXTURE2D_SAMPLER2D(_GlobalSobelTex, sampler_GlobalSobelTex);
			TEXTURE2D_SAMPLER2D(_GlobalSobelDepthTex, sampler_GlobalSobelDepthTex);
	
			// _CameraNormalsTexture contains the view space normals transformed
			// to be in the 0...1 range.
			TEXTURE2D_SAMPLER2D(_CameraNormalsTexture, sampler_CameraNormalsTexture);
			TEXTURE2D_SAMPLER2D(_CameraDepthTexture, sampler_CameraDepthTexture);

			// Data pertaining to _MainTex's dimensions.
			// https://docs.unity3d.com/Manual/SL-PropertiesInPrograms.html
			float4 _MainTex_TexelSize;
			float4 _GlobalSobelTex_TexelSize;
			float _Scale;
			float4 _Color;
			float _DepthScale;
			float _DepthThreshold;
			float _DepthNormalThreshold;
			float _DepthNormalThresholdScale;

			float _NormalThreshold;
			float _SobelRange;
			float _SobelPower;
			float _SobelTranshold;
			// This matrix is populated in PostProcessOutline.cs.
			float4x4 _ClipToView;

			

			// Combines the top and bottom colors using normal blending.
			// https://en.wikipedia.org/wiki/Blend_modes#Normal_blend_mode
			// This performs the same operation as Blend SrcAlpha OneMinusSrcAlpha.
			float4 alphaBlend(float4 top, float4 bottom)
			{
				float3 color = (top.rgb * top.a) + (bottom.rgb * (1 - top.a));
				float alpha = top.a + bottom.a * (1 - top.a);

				return float4(color, alpha);
			}

			// Both the Varyings struct and the Vert shader are copied
			// from StdLib.hlsl included above, with some modifications.
			struct Varyings
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
				float3 viewSpaceDir : TEXCOORD2;
				float2 uvSobel[9] : TEXCOORD3;
				#if STEREO_INSTANCING_ENABLED
					uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
				#endif
			};

			///Sobel
			
			static const float Gx[9] =
			{ 
				-1,  0,  1,
				-2,  0,  2,
				-1,  0,  1 
			};

			static const float Gy[9] =
			{ 
				-1, -2, -1,
				 0,  0,  0,
				 1,  2,  1 
			};

			float Luminance(float3 color)
			{
				return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
			}

			float Sobel(Varyings i)
			{
				float edgex = 0;
				float edgey = 0;
				for (int j = 0; j < 9; j++)
				{
					//fixed4 col = tex2D(_MainTex, i.uvSobel[j]);
					float4 col = SAMPLE_TEXTURE2D(_GlobalSobelTex, sampler_GlobalSobelTex, i.uvSobel[j]);
					float lum = Luminance(col.rgb);
					edgex += lum * Gx[j];
					edgey += lum * Gy[j];
				}

				return 1 - abs(edgex) - abs(edgey);
			}
			
			///Sobel

			Varyings Vert(AttributesDefault v)
			{
				Varyings o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV(v.vertex.xy);
				// Transform our point first from clip to view space,
				// taking the xyz to interpret it as a direction.
				o.viewSpaceDir = mul(_ClipToView, o.vertex).xyz;

				#if UNITY_UV_STARTS_AT_TOP
					o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
				#endif

				o.texcoordStereo = TransformStereoScreenSpaceTex(o.texcoord, 1.0);
				
				o.uvSobel[0] = o.texcoord + float2(-1, -1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[1] = o.texcoord + float2(0, -1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[2] = o.texcoord + float2(1, -1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[3] = o.texcoord + float2(-1, 0) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[4] = o.texcoord + float2(0, 0) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[5] = o.texcoord + float2(1, 0) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[6] = o.texcoord + float2(-1, 1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[7] = o.texcoord + float2(0, 1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[8] = o.texcoord + float2(1, 1) * _GlobalSobelTex_TexelSize * _SobelRange;
				

				return o;
			}

			float4 Frag(Varyings i) : SV_Target
			{
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, i.texcoord).r ;
				//return float4(depth.xxx, 1) * 0.2f;
				float halfScaleFloor = floor(_Scale * 0.5 * depth * _DepthScale);
				float halfScaleCeil = ceil(_Scale * 0.5 * depth * _DepthScale);
				 
				// Sample the pixels in an X shape, roughly centered around i.texcoord.
				// As the _CameraDepthTexture and _CameraNormalsTexture default samplers
				// use point filtering, we use the above variables to ensure we offset
				// exactly one pixel at a time.
				float2 bottomLeftUV = i.texcoord - float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y) * halfScaleFloor;
				float2 topRightUV = i.texcoord + float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y) * halfScaleCeil;
				float2 bottomRightUV = i.texcoord + float2(_MainTex_TexelSize.x * halfScaleCeil, -_MainTex_TexelSize.y * halfScaleFloor);
				float2 topLeftUV = i.texcoord + float2(-_MainTex_TexelSize.x * halfScaleFloor, _MainTex_TexelSize.y * halfScaleCeil);

				float3 normal0 = SAMPLE_TEXTURE2D(_CameraNormalsTexture, sampler_CameraNormalsTexture, bottomLeftUV).rgb;
				float3 normal1 = SAMPLE_TEXTURE2D(_CameraNormalsTexture, sampler_CameraNormalsTexture, topRightUV).rgb;
				float3 normal2 = SAMPLE_TEXTURE2D(_CameraNormalsTexture, sampler_CameraNormalsTexture, bottomRightUV).rgb;
				float3 normal3 = SAMPLE_TEXTURE2D(_CameraNormalsTexture, sampler_CameraNormalsTexture, topLeftUV).rgb;

				
				float depth0 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, bottomLeftUV).r;
				float depth1 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, topRightUV).r;
				float depth2 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, bottomRightUV).r;
				float depth3 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, sampler_CameraDepthTexture, topLeftUV).r;

				// Transform the view normal from the 0...1 range to the -1...1 range.
				float3 viewNormal = normal0 * 2 - 1;
				float NdotV = 1 - dot(viewNormal, -i.viewSpaceDir);

				// Return a value in the 0...1 range depending on where NdotV lies 
				// between _DepthNormalThreshold and 1.
				float normalThreshold01 = saturate((NdotV - _DepthNormalThreshold) / (1 - _DepthNormalThreshold));
				// Scale the threshold, and add 1 so that it is in the range of 1..._NormalThresholdScale + 1.
				float normalThreshold = normalThreshold01 * _DepthNormalThresholdScale + 1;

				// Modulate the threshold by the existing depth value;
				// pixels further from the screen will require smaller differences
				// to draw an edge.
				float depthThreshold = _DepthThreshold * depth0 * normalThreshold;

				float depthFiniteDifference0 = depth1 - depth0;
				float depthFiniteDifference1 = depth3 - depth2;
				// edgeDepth is calculated using the Roberts cross operator.
				// The same operation is applied to the normal below.
				// https://en.wikipedia.org/wiki/Roberts_cross
				float edgeDepth = sqrt(pow(depthFiniteDifference0, 2) + pow(depthFiniteDifference1, 2)) * 100;
				edgeDepth = edgeDepth > depthThreshold ? 1 : 0;

				float3 normalFiniteDifference0 = normal1 - normal0;
				float3 normalFiniteDifference1 = normal3 - normal2;
				// Dot the finite differences with themselves to transform the 
				// three-dimensional values to scalars.
				float edgeNormal = sqrt(dot(normalFiniteDifference0, normalFiniteDifference0) + dot(normalFiniteDifference1, normalFiniteDifference1));
				edgeNormal = edgeNormal > _NormalThreshold ? 1 : 0;

				float edge = max(edgeDepth, edgeNormal);

				float4 edgeColor = float4(_Color.rgb, _Color.a * edge);

				float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
				//float4 sobel = SAMPLE_TEXTURE2D(_GlobalSobelTex, sampler_GlobalSobelTex, i.texcoord);

				//Sobelê¸?í„ë™
				float sobel_depth = SAMPLE_DEPTH_TEXTURE(_GlobalSobelDepthTex, sampler_GlobalSobelDepthTex, i.texcoord).r;
				float g = Sobel(i);
				g = pow(g, _SobelPower);

				//Ë˚é¶Sobelê¸?           ê¸?Ë¯êF
				float4 sobel_edge = lerp(float4(0,0,0,1), color, step(_SobelTranshold, g));

				//return alphaBlend(edgeColor, color);
				return alphaBlend(edgeColor, lerp(color, sobel_edge, depth <= sobel_depth));
			}
			ENDHLSL
		}
	}
}