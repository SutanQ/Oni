Shader "PostEffect/PostProcessOutline"
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

			sampler2D _GlobalSobelTex;
			sampler2D _GlobalSobelDepthTex;
			float4 _MainTex_TexelSize;
			float4 _GlobalSobelTex_TexelSize;

			sampler2D _CameraNormalsTexture;
			sampler2D _CameraDepthTexture;
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

			int _OnlyUseSobel;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 viewSpaceDir : TEXCOORD2;
				float2 uvSobel[9] : TEXCOORD3;
			};

			float4 alphaBlend(float4 top, float4 bottom)
			{
				float3 color = (top.rgb * top.a) + (bottom.rgb * (1 - top.a));
				float alpha = top.a + bottom.a * (1 - top.a);
				return float4(color, alpha);
			}

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

			void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
			{
				Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
			}

			float Sobel(v2f i)
			{
				float edgex = 0;
				float edgey = 0;
				//float avgG = 0;
				for (int j = 0; j < 9; j++)
				{
					fixed4 col = tex2D(_GlobalSobelTex, i.uvSobel[j]);
					float lum = Luminance(col.rgb);
					edgex += lum * Gx[j];
					edgey += lum * Gy[j];
					//avgG += col.g;
				}
				//avgG = avgG / 9;
				return (1 - abs(edgex) - abs(edgey));// *saturate(1 - avgG + 0.01f);
			}

			v2f Vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				o.viewSpaceDir = mul(_ClipToView, o.vertex).xyz;

				o.uvSobel[0] = o.uv + float2(-1, -1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[1] = o.uv + float2(0, -1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[2] = o.uv + float2(1, -1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[3] = o.uv + float2(-1, 0) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[4] = o.uv + float2(0, 0) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[5] = o.uv + float2(1, 0) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[6] = o.uv + float2(-1, 1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[7] = o.uv + float2(0, 1) * _GlobalSobelTex_TexelSize * _SobelRange;
				o.uvSobel[8] = o.uv + float2(1, 1) * _GlobalSobelTex_TexelSize * _SobelRange;

				return o;
			}

			float4 Frag(v2f i) : SV_Target
			{
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv).r;

				if (_OnlyUseSobel > 0)
				{
					float halfScaleFloor = floor(_Scale * 0.5 * depth * _DepthScale);
					float halfScaleCeil = ceil(_Scale * 0.5 * depth * _DepthScale);

					float2 bottomLeftUV = i.uv - float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y) * halfScaleFloor;
					float2 topRightUV = i.uv + float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y) * halfScaleCeil;
					float2 bottomRightUV = i.uv + float2(_MainTex_TexelSize.x * halfScaleCeil, -_MainTex_TexelSize.y * halfScaleFloor);
					float2 topLeftUV = i.uv + float2(-_MainTex_TexelSize.x * halfScaleFloor, _MainTex_TexelSize.y * halfScaleCeil);

					float3 normal0 = tex2D(_CameraNormalsTexture, bottomLeftUV).rgb;
					float3 normal1 = tex2D(_CameraNormalsTexture, topRightUV).rgb;
					float3 normal2 = tex2D(_CameraNormalsTexture, bottomRightUV).rgb;
					float3 normal3 = tex2D(_CameraNormalsTexture, topLeftUV).rgb;

					float depth0 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, bottomLeftUV).r;
					float depth1 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, topRightUV).r;
					float depth2 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, bottomRightUV).r;
					float depth3 = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, topLeftUV).r;


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

					float4 color = tex2D(_MainTex, i.uv);

					//Sobel線條偵測
					float sobel_depth = SAMPLE_DEPTH_TEXTURE(_GlobalSobelDepthTex, i.uv).r;
					float g = Sobel(i);
					g = pow(g, _SobelPower);

					//顯示Sobel線條           線條顏色
					float4 sobel_edge = lerp(_Color, color, step(_SobelTranshold, g));

					//return alphaBlend(edgeColor, color);
					return alphaBlend(edgeColor, lerp(color, sobel_edge, depth <= sobel_depth));
				}
				else
				{
					float4 color = tex2D(_MainTex, i.uv);

					//Sobel線條偵測
					float sobel_depth = SAMPLE_DEPTH_TEXTURE(_GlobalSobelDepthTex, i.uv).r;
					float g = Sobel(i); 
					//float linearDepth = (_ZBufferParams.x * sobel_depth * 0.001);
					float Out;
					//Unity_Remap_float(sobel_depth * 10, float2(0.05, 0.5), float2(0.5, 10), Out);
					//Unity_Remap_float(linearDepth, float2(0.05, 2), float2(0.5, 6), Out);
					Unity_Remap_float((1 - (1.0 / (_ZBufferParams.x * sobel_depth + _ZBufferParams.y))), float2(0.97, 1.0), float2(0.5, 2), Out);
					g = pow(g, _SobelPower * Out) ;

					
					//return Out;
					//return clamp(sobel_depth * 10, 0.02, 1);

					//顯示Sobel線條           線條顏色
					float4 sobel_edge = lerp(_Color, color, step(_SobelTranshold, g));


					return lerp(color, sobel_edge, depth <= sobel_depth);
				}
			}
			ENDCG
		}
	}
}
