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
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
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
                "UniversalMaterialType" = "Unlit"
                "Queue" = "AlphaTest"
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

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
            #pragma only_renderers gles gles3 glcore
            #pragma multi_compile_instancing
            #pragma multi_compile_fog
            #pragma vertex vert
            #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

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

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
        #define VARYINGS_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
        #define VARYINGS_NEED_COLOR
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_UNLIT
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

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
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
            struct Varyings
            {
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 positionCS : SV_POSITION;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 texCoord0;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #endif
            };
            struct SurfaceDescriptionInputs
            {
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 uv0;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 uv1;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 VertexColor;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float3 TimeParameters;
                #endif
            };
            struct VertexDescriptionInputs
            {
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float3 ObjectSpaceNormal;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float3 ObjectSpaceTangent;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float3 ObjectSpacePosition;
                #endif
            };
            struct PackedVaryings
            {
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 positionCS : SV_POSITION;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 interp0 : TEXCOORD0;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 interp1 : TEXCOORD1;
                #endif
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                float4 interp2 : TEXCOORD2;
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #endif
            };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
            PackedVaryings PackVaryings(Varyings input)
                {
                    PackedVaryings output;
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw = input.texCoord0;
                    output.interp1.xyzw = input.texCoord1;
                    output.interp2.xyzw = input.color;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
                Varyings UnpackVaryings(PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
                    output.texCoord1 = input.interp1.xyzw;
                    output.color = input.interp2.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }
            #endif

                // --------------------------------------------------
                // Graph

                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float4 _Color;
                float2 Vector2_FB60315F;
                float4 Texture2D_90210E7D_TexelSize;
                float4 _MaskTex_TexelSize;
                float Vector1_FC9BCA76;
                float Vector1_A2984BC;
                float Vector1_70FA963C;
                float Vector1_E514496D;
                float Vector1_18CD6163;
                float2 Vector2_B02498D3;
                CBUFFER_END

                    // Object and Global properties
                    TEXTURE2D(Texture2D_90210E7D);
                    SAMPLER(samplerTexture2D_90210E7D);
                    TEXTURE2D(_MaskTex);
                    SAMPLER(sampler_MaskTex);
                    SAMPLER(_SampleTexture2D_ce3836c16496338e911d572d6670f405_Sampler_3_Linear_Repeat);
                    SAMPLER(_SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_Sampler_3_Linear_Repeat);

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
                    struct VertexDescription
                    {
                        float3 Position;
                        float3 Normal;
                        float3 Tangent;
                    };

                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        description.Position = IN.ObjectSpacePosition;
                        description.Normal = IN.ObjectSpaceNormal;
                        description.Tangent = IN.ObjectSpaceTangent;
                        return description;
                    }

                    // Graph Pixel
                    struct SurfaceDescription
                    {
                        float3 BaseColor;
                        float Alpha;
                        float AlphaClipThreshold;
                    };

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Property_dd12ec1f616fed8cb142a4983afc6f8f_Out_0 = Vector1_FC9BCA76;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0 = IN.uv1;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Property_81fae46e52acac8e9081d434ee6c42a2_Out_0 = _Color;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float2 _Property_f32dcf59043a0586bef10901340ac50a_Out_0 = Vector2_FB60315F;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float2 _Property_a37180172af4f18692bb811032b8180e_Out_0 = Vector2_B02498D3;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float2 _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                        Unity_Multiply_float(_Property_a37180172af4f18692bb811032b8180e_Out_0, (IN.TimeParameters.x.xx), _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        #if defined(BOOLEAN_214BDA66_ON)
                        float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                        #else
                        float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = float2(0, 0);
                        #endif
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float2 _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3;
                        Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f32dcf59043a0586bef10901340ac50a_Out_0, _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                        float _SampleTexture2D_ce3836c16496338e911d572d6670f405_R_4 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.r;
                        float _SampleTexture2D_ce3836c16496338e911d572d6670f405_G_5 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.g;
                        float _SampleTexture2D_ce3836c16496338e911d572d6670f405_B_6 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.b;
                        float _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.a;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                        Unity_Multiply_float(_Property_81fae46e52acac8e9081d434ee6c42a2_Out_0, _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0, _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0 = Vector1_E514496D;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2;
                        Unity_Posterize_float4(_Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2, (_Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0.xxxx), _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[0];
                        float _Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[1];
                        float _Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[2];
                        float _Split_22ed15914cf4e985a2b9ffc09bb67a08_A_4 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[3];
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0 = Vector1_18CD6163;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Add_3856ff70597d7483983cab57d5ed89d1_Out_2;
                        Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_3856ff70597d7483983cab57d5ed89d1_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Add_7855453f51a0138f8fee886546ac6dc2_Out_2;
                        Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2;
                        Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4;
                        float3 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5;
                        float2 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6;
                        Unity_Combine_float(_Add_3856ff70597d7483983cab57d5ed89d1_Out_2, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2, _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                        Unity_Clamp_float4(_Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        #if defined(BOOLEAN_15B78E78_ON)
                        float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                        #else
                        float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                        #endif
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                        Unity_Multiply_float(IN.VertexColor, _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                        Unity_Multiply_float(_UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2, _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        #if defined(BOOLEAN_CA9D1AC6_ON)
                        float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                        #else
                        float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                        #endif
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Multiply_28c1582d192ec0878aec999651401f5e_Out_2;
                        Unity_Multiply_float((_Property_dd12ec1f616fed8cb142a4983afc6f8f_Out_0.xxxx), _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0, _Multiply_28c1582d192ec0878aec999651401f5e_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Split_16df5a528bfd36858d8d95be2a607c80_R_1 = _Multiply_28c1582d192ec0878aec999651401f5e_Out_2[0];
                        float _Split_16df5a528bfd36858d8d95be2a607c80_G_2 = _Multiply_28c1582d192ec0878aec999651401f5e_Out_2[1];
                        float _Split_16df5a528bfd36858d8d95be2a607c80_B_3 = _Multiply_28c1582d192ec0878aec999651401f5e_Out_2[2];
                        float _Split_16df5a528bfd36858d8d95be2a607c80_A_4 = _Multiply_28c1582d192ec0878aec999651401f5e_Out_2[3];
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _Combine_635499a2c96061819034c07bde6a04cd_RGBA_4;
                        float3 _Combine_635499a2c96061819034c07bde6a04cd_RGB_5;
                        float2 _Combine_635499a2c96061819034c07bde6a04cd_RG_6;
                        Unity_Combine_float(_Split_16df5a528bfd36858d8d95be2a607c80_R_1, _Split_16df5a528bfd36858d8d95be2a607c80_G_2, _Split_16df5a528bfd36858d8d95be2a607c80_B_3, 0, _Combine_635499a2c96061819034c07bde6a04cd_RGBA_4, _Combine_635499a2c96061819034c07bde6a04cd_RGB_5, _Combine_635499a2c96061819034c07bde6a04cd_RG_6);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Split_6f37452d47b49c83a52002dd9ea68a7a_R_1 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[0];
                        float _Split_6f37452d47b49c83a52002dd9ea68a7a_G_2 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[1];
                        float _Split_6f37452d47b49c83a52002dd9ea68a7a_B_3 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[2];
                        float _Split_6f37452d47b49c83a52002dd9ea68a7a_A_4 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[3];
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Property_a004be3064e610829f701db3bb905e19_Out_0 = Vector1_70FA963C;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2;
                        Unity_Add_float(_Split_6f37452d47b49c83a52002dd9ea68a7a_A_4, _Property_a004be3064e610829f701db3bb905e19_Out_0, _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float4 _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
                        float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.r;
                        float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_G_5 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.g;
                        float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_B_6 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.b;
                        float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_A_7 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.a;
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2;
                        Unity_Multiply_float(_Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2, _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4, _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                        Unity_Clamp_float(_Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2, 0, 1, _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3);
                        #endif
                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        float _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0 = Vector1_A2984BC;
                        #endif
                        surface.BaseColor = _Combine_635499a2c96061819034c07bde6a04cd_RGB_5;
                        surface.Alpha = _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                        surface.AlphaClipThreshold = _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0;
                        return surface;
                    }

                    // --------------------------------------------------
                    // Build Graph Inputs

                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                    {
                        VertexDescriptionInputs output;
                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    output.ObjectSpaceNormal = input.normalOS;
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    output.ObjectSpaceTangent = input.tangentOS;
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    output.ObjectSpacePosition = input.positionOS;
                    #endif


                        return output;
                    }

                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                    {
                        SurfaceDescriptionInputs output;
                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    output.uv0 = input.texCoord0;
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    output.uv1 = input.texCoord1;
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    output.VertexColor = input.color;
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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

                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
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
                        Cull Off
                        Blend One Zero
                        ZTest LEqual
                        ZWrite On
                        ColorMask 0

                        // Debug
                        // <None>

                        // --------------------------------------------------
                        // Pass

                        HLSLPROGRAM

                        // Pragmas
                        #pragma target 2.0
                        #pragma only_renderers gles gles3 glcore
                        #pragma multi_compile_instancing
                        #pragma vertex vert
                        #pragma fragment frag

                        // DotsInstancingOptions: <None>
                        // HybridV1InjectedBuiltinProperties: <None>

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

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    #define ATTRIBUTES_NEED_TEXCOORD1
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    #define ATTRIBUTES_NEED_COLOR
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    #define VARYINGS_NEED_TEXCOORD0
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    #define VARYINGS_NEED_TEXCOORD1
                    #endif

                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                    #define VARYINGS_NEED_COLOR
                    #endif

                        #define FEATURES_GRAPH_VERTEX
                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                        #define SHADERPASS SHADERPASS_SHADOWCASTER
                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

                        // Includes
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

                        // --------------------------------------------------
                        // Structs and Packing

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
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                        struct Varyings
                        {
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 positionCS : SV_POSITION;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 texCoord0;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                            #endif
                        };
                        struct SurfaceDescriptionInputs
                        {
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 uv0;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 uv1;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 VertexColor;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float3 TimeParameters;
                            #endif
                        };
                        struct VertexDescriptionInputs
                        {
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float3 ObjectSpaceNormal;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float3 ObjectSpaceTangent;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float3 ObjectSpacePosition;
                            #endif
                        };
                        struct PackedVaryings
                        {
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 positionCS : SV_POSITION;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 interp0 : TEXCOORD0;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 interp1 : TEXCOORD1;
                            #endif
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            float4 interp2 : TEXCOORD2;
                            #endif
                            #if UNITY_ANY_INSTANCING_ENABLED
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                            #endif
                        };

                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                        PackedVaryings PackVaryings(Varyings input)
                            {
                                PackedVaryings output;
                                output.positionCS = input.positionCS;
                                output.interp0.xyzw = input.texCoord0;
                                output.interp1.xyzw = input.texCoord1;
                                output.interp2.xyzw = input.color;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                output.instanceID = input.instanceID;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                output.cullFace = input.cullFace;
                                #endif
                                return output;
                            }
                            Varyings UnpackVaryings(PackedVaryings input)
                            {
                                Varyings output;
                                output.positionCS = input.positionCS;
                                output.texCoord0 = input.interp0.xyzw;
                                output.texCoord1 = input.interp1.xyzw;
                                output.color = input.interp2.xyzw;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                output.instanceID = input.instanceID;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                output.cullFace = input.cullFace;
                                #endif
                                return output;
                            }
                        #endif

                            // --------------------------------------------------
                            // Graph

                            // Graph Properties
                            CBUFFER_START(UnityPerMaterial)
                            float4 _Color;
                            float2 Vector2_FB60315F;
                            float4 Texture2D_90210E7D_TexelSize;
                            float4 _MaskTex_TexelSize;
                            float Vector1_FC9BCA76;
                            float Vector1_A2984BC;
                            float Vector1_70FA963C;
                            float Vector1_E514496D;
                            float Vector1_18CD6163;
                            float2 Vector2_B02498D3;
                            CBUFFER_END

                                // Object and Global properties
                                TEXTURE2D(Texture2D_90210E7D);
                                SAMPLER(samplerTexture2D_90210E7D);
                                TEXTURE2D(_MaskTex);
                                SAMPLER(sampler_MaskTex);
                                SAMPLER(_SampleTexture2D_ce3836c16496338e911d572d6670f405_Sampler_3_Linear_Repeat);
                                SAMPLER(_SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_Sampler_3_Linear_Repeat);

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
                                struct VertexDescription
                                {
                                    float3 Position;
                                    float3 Normal;
                                    float3 Tangent;
                                };

                                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                {
                                    VertexDescription description = (VertexDescription)0;
                                    description.Position = IN.ObjectSpacePosition;
                                    description.Normal = IN.ObjectSpaceNormal;
                                    description.Tangent = IN.ObjectSpaceTangent;
                                    return description;
                                }

                                // Graph Pixel
                                struct SurfaceDescription
                                {
                                    float Alpha;
                                    float AlphaClipThreshold;
                                };

                                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                {
                                    SurfaceDescription surface = (SurfaceDescription)0;
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0 = IN.uv1;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _Property_81fae46e52acac8e9081d434ee6c42a2_Out_0 = _Color;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float2 _Property_f32dcf59043a0586bef10901340ac50a_Out_0 = Vector2_FB60315F;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float2 _Property_a37180172af4f18692bb811032b8180e_Out_0 = Vector2_B02498D3;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float2 _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                    Unity_Multiply_float(_Property_a37180172af4f18692bb811032b8180e_Out_0, (IN.TimeParameters.x.xx), _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    #if defined(BOOLEAN_214BDA66_ON)
                                    float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                    #else
                                    float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = float2(0, 0);
                                    #endif
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float2 _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3;
                                    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f32dcf59043a0586bef10901340ac50a_Out_0, _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                    float _SampleTexture2D_ce3836c16496338e911d572d6670f405_R_4 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.r;
                                    float _SampleTexture2D_ce3836c16496338e911d572d6670f405_G_5 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.g;
                                    float _SampleTexture2D_ce3836c16496338e911d572d6670f405_B_6 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.b;
                                    float _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.a;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                    Unity_Multiply_float(_Property_81fae46e52acac8e9081d434ee6c42a2_Out_0, _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0, _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0 = Vector1_E514496D;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2;
                                    Unity_Posterize_float4(_Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2, (_Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0.xxxx), _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[0];
                                    float _Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[1];
                                    float _Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[2];
                                    float _Split_22ed15914cf4e985a2b9ffc09bb67a08_A_4 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[3];
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0 = Vector1_18CD6163;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Add_3856ff70597d7483983cab57d5ed89d1_Out_2;
                                    Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_3856ff70597d7483983cab57d5ed89d1_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Add_7855453f51a0138f8fee886546ac6dc2_Out_2;
                                    Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2;
                                    Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4;
                                    float3 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5;
                                    float2 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6;
                                    Unity_Combine_float(_Add_3856ff70597d7483983cab57d5ed89d1_Out_2, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2, _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                    Unity_Clamp_float4(_Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    #if defined(BOOLEAN_15B78E78_ON)
                                    float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                    #else
                                    float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                    #endif
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                    Unity_Multiply_float(IN.VertexColor, _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                    Unity_Multiply_float(_UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2, _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    #if defined(BOOLEAN_CA9D1AC6_ON)
                                    float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                    #else
                                    float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                    #endif
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Split_6f37452d47b49c83a52002dd9ea68a7a_R_1 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[0];
                                    float _Split_6f37452d47b49c83a52002dd9ea68a7a_G_2 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[1];
                                    float _Split_6f37452d47b49c83a52002dd9ea68a7a_B_3 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[2];
                                    float _Split_6f37452d47b49c83a52002dd9ea68a7a_A_4 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[3];
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Property_a004be3064e610829f701db3bb905e19_Out_0 = Vector1_70FA963C;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2;
                                    Unity_Add_float(_Split_6f37452d47b49c83a52002dd9ea68a7a_A_4, _Property_a004be3064e610829f701db3bb905e19_Out_0, _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float4 _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
                                    float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.r;
                                    float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_G_5 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.g;
                                    float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_B_6 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.b;
                                    float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_A_7 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.a;
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2;
                                    Unity_Multiply_float(_Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2, _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4, _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                    Unity_Clamp_float(_Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2, 0, 1, _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3);
                                    #endif
                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    float _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0 = Vector1_A2984BC;
                                    #endif
                                    surface.Alpha = _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                    surface.AlphaClipThreshold = _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0;
                                    return surface;
                                }

                                // --------------------------------------------------
                                // Build Graph Inputs

                                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                {
                                    VertexDescriptionInputs output;
                                    ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                output.ObjectSpaceNormal = input.normalOS;
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                output.ObjectSpaceTangent = input.tangentOS;
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                output.ObjectSpacePosition = input.positionOS;
                                #endif


                                    return output;
                                }

                                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                {
                                    SurfaceDescriptionInputs output;
                                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                output.uv0 = input.texCoord0;
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                output.uv1 = input.texCoord1;
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                output.VertexColor = input.color;
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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

                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
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
                                    Cull Off
                                    Blend One Zero
                                    ZTest LEqual
                                    ZWrite On
                                    ColorMask 0

                                    // Debug
                                    // <None>

                                    // --------------------------------------------------
                                    // Pass

                                    HLSLPROGRAM

                                    // Pragmas
                                    #pragma target 2.0
                                    #pragma only_renderers gles gles3 glcore
                                    #pragma multi_compile_instancing
                                    #pragma vertex vert
                                    #pragma fragment frag

                                    // DotsInstancingOptions: <None>
                                    // HybridV1InjectedBuiltinProperties: <None>

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

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                #define ATTRIBUTES_NEED_TEXCOORD1
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                #define ATTRIBUTES_NEED_COLOR
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                #define VARYINGS_NEED_TEXCOORD0
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                #define VARYINGS_NEED_TEXCOORD1
                                #endif

                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                #define VARYINGS_NEED_COLOR
                                #endif

                                    #define FEATURES_GRAPH_VERTEX
                                    /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                    #define SHADERPASS SHADERPASS_DEPTHONLY
                                    /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

                                    // Includes
                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

                                    // --------------------------------------------------
                                    // Structs and Packing

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
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                                    struct Varyings
                                    {
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 positionCS : SV_POSITION;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 texCoord0;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                        #endif
                                        #endif
                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                        #endif
                                        #endif
                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                        #endif
                                        #endif
                                    };
                                    struct SurfaceDescriptionInputs
                                    {
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 uv0;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 uv1;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 VertexColor;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float3 TimeParameters;
                                        #endif
                                    };
                                    struct VertexDescriptionInputs
                                    {
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float3 ObjectSpaceNormal;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float3 ObjectSpaceTangent;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float3 ObjectSpacePosition;
                                        #endif
                                    };
                                    struct PackedVaryings
                                    {
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 positionCS : SV_POSITION;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 interp0 : TEXCOORD0;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 interp1 : TEXCOORD1;
                                        #endif
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        float4 interp2 : TEXCOORD2;
                                        #endif
                                        #if UNITY_ANY_INSTANCING_ENABLED
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        uint instanceID : CUSTOM_INSTANCE_ID;
                                        #endif
                                        #endif
                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                        #endif
                                        #endif
                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                        #endif
                                        #endif
                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                        #endif
                                        #endif
                                    };

                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                    PackedVaryings PackVaryings(Varyings input)
                                        {
                                            PackedVaryings output;
                                            output.positionCS = input.positionCS;
                                            output.interp0.xyzw = input.texCoord0;
                                            output.interp1.xyzw = input.texCoord1;
                                            output.interp2.xyzw = input.color;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                            output.instanceID = input.instanceID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                            output.cullFace = input.cullFace;
                                            #endif
                                            return output;
                                        }
                                        Varyings UnpackVaryings(PackedVaryings input)
                                        {
                                            Varyings output;
                                            output.positionCS = input.positionCS;
                                            output.texCoord0 = input.interp0.xyzw;
                                            output.texCoord1 = input.interp1.xyzw;
                                            output.color = input.interp2.xyzw;
                                            #if UNITY_ANY_INSTANCING_ENABLED
                                            output.instanceID = input.instanceID;
                                            #endif
                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                            #endif
                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                            #endif
                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                            output.cullFace = input.cullFace;
                                            #endif
                                            return output;
                                        }
                                    #endif

                                        // --------------------------------------------------
                                        // Graph

                                        // Graph Properties
                                        CBUFFER_START(UnityPerMaterial)
                                        float4 _Color;
                                        float2 Vector2_FB60315F;
                                        float4 Texture2D_90210E7D_TexelSize;
                                        float4 _MaskTex_TexelSize;
                                        float Vector1_FC9BCA76;
                                        float Vector1_A2984BC;
                                        float Vector1_70FA963C;
                                        float Vector1_E514496D;
                                        float Vector1_18CD6163;
                                        float2 Vector2_B02498D3;
                                        CBUFFER_END

                                            // Object and Global properties
                                            TEXTURE2D(Texture2D_90210E7D);
                                            SAMPLER(samplerTexture2D_90210E7D);
                                            TEXTURE2D(_MaskTex);
                                            SAMPLER(sampler_MaskTex);
                                            SAMPLER(_SampleTexture2D_ce3836c16496338e911d572d6670f405_Sampler_3_Linear_Repeat);
                                            SAMPLER(_SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_Sampler_3_Linear_Repeat);

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
                                            struct VertexDescription
                                            {
                                                float3 Position;
                                                float3 Normal;
                                                float3 Tangent;
                                            };

                                            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                            {
                                                VertexDescription description = (VertexDescription)0;
                                                description.Position = IN.ObjectSpacePosition;
                                                description.Normal = IN.ObjectSpaceNormal;
                                                description.Tangent = IN.ObjectSpaceTangent;
                                                return description;
                                            }

                                            // Graph Pixel
                                            struct SurfaceDescription
                                            {
                                                float Alpha;
                                                float AlphaClipThreshold;
                                            };

                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                            {
                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0 = IN.uv1;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _Property_81fae46e52acac8e9081d434ee6c42a2_Out_0 = _Color;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float2 _Property_f32dcf59043a0586bef10901340ac50a_Out_0 = Vector2_FB60315F;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float2 _Property_a37180172af4f18692bb811032b8180e_Out_0 = Vector2_B02498D3;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float2 _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                                Unity_Multiply_float(_Property_a37180172af4f18692bb811032b8180e_Out_0, (IN.TimeParameters.x.xx), _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                #if defined(BOOLEAN_214BDA66_ON)
                                                float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                                #else
                                                float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = float2(0, 0);
                                                #endif
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float2 _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3;
                                                Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f32dcf59043a0586bef10901340ac50a_Out_0, _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                                float _SampleTexture2D_ce3836c16496338e911d572d6670f405_R_4 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.r;
                                                float _SampleTexture2D_ce3836c16496338e911d572d6670f405_G_5 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.g;
                                                float _SampleTexture2D_ce3836c16496338e911d572d6670f405_B_6 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.b;
                                                float _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.a;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                                Unity_Multiply_float(_Property_81fae46e52acac8e9081d434ee6c42a2_Out_0, _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0, _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0 = Vector1_E514496D;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2;
                                                Unity_Posterize_float4(_Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2, (_Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0.xxxx), _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[0];
                                                float _Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[1];
                                                float _Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[2];
                                                float _Split_22ed15914cf4e985a2b9ffc09bb67a08_A_4 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[3];
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0 = Vector1_18CD6163;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Add_3856ff70597d7483983cab57d5ed89d1_Out_2;
                                                Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_3856ff70597d7483983cab57d5ed89d1_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Add_7855453f51a0138f8fee886546ac6dc2_Out_2;
                                                Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2;
                                                Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4;
                                                float3 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5;
                                                float2 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6;
                                                Unity_Combine_float(_Add_3856ff70597d7483983cab57d5ed89d1_Out_2, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2, _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                                Unity_Clamp_float4(_Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                #if defined(BOOLEAN_15B78E78_ON)
                                                float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                                #else
                                                float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                                #endif
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                                Unity_Multiply_float(IN.VertexColor, _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                                Unity_Multiply_float(_UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2, _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                #if defined(BOOLEAN_CA9D1AC6_ON)
                                                float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                                #else
                                                float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                                #endif
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Split_6f37452d47b49c83a52002dd9ea68a7a_R_1 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[0];
                                                float _Split_6f37452d47b49c83a52002dd9ea68a7a_G_2 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[1];
                                                float _Split_6f37452d47b49c83a52002dd9ea68a7a_B_3 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[2];
                                                float _Split_6f37452d47b49c83a52002dd9ea68a7a_A_4 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[3];
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Property_a004be3064e610829f701db3bb905e19_Out_0 = Vector1_70FA963C;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2;
                                                Unity_Add_float(_Split_6f37452d47b49c83a52002dd9ea68a7a_A_4, _Property_a004be3064e610829f701db3bb905e19_Out_0, _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float4 _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
                                                float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.r;
                                                float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_G_5 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.g;
                                                float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_B_6 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.b;
                                                float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_A_7 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.a;
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2;
                                                Unity_Multiply_float(_Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2, _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4, _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                                Unity_Clamp_float(_Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2, 0, 1, _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3);
                                                #endif
                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                float _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0 = Vector1_A2984BC;
                                                #endif
                                                surface.Alpha = _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                                surface.AlphaClipThreshold = _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0;
                                                return surface;
                                            }

                                            // --------------------------------------------------
                                            // Build Graph Inputs

                                            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                            {
                                                VertexDescriptionInputs output;
                                                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            output.ObjectSpaceNormal = input.normalOS;
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            output.ObjectSpaceTangent = input.tangentOS;
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            output.ObjectSpacePosition = input.positionOS;
                                            #endif


                                                return output;
                                            }

                                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                            {
                                                SurfaceDescriptionInputs output;
                                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            output.uv0 = input.texCoord0;
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            output.uv1 = input.texCoord1;
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            output.VertexColor = input.color;
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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

                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

                                            ENDHLSL
                                        }
        }
            SubShader
                                            {
                                                Tags
                                                {
                                                    "RenderPipeline" = "UniversalPipeline"
                                                    "RenderType" = "Opaque"
                                                    "UniversalMaterialType" = "Unlit"
                                                    "Queue" = "AlphaTest"
                                                }
                                                Pass
                                                {
                                                    Name "Pass"
                                                    Tags
                                                    {
                                                    // LightMode: <None>
                                                }

                                                // Render State
                                                Cull Off
                                                Blend One Zero
                                                ZTest LEqual
                                                ZWrite On

                                                // Debug
                                                // <None>

                                                // --------------------------------------------------
                                                // Pass

                                                HLSLPROGRAM

                                                // Pragmas
                                                #pragma target 4.5
                                                #pragma exclude_renderers gles gles3 glcore
                                                #pragma multi_compile_instancing
                                                #pragma multi_compile_fog
                                                #pragma multi_compile _ DOTS_INSTANCING_ON
                                                #pragma vertex vert
                                                #pragma fragment frag

                                                // DotsInstancingOptions: <None>
                                                // HybridV1InjectedBuiltinProperties: <None>

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

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            #define ATTRIBUTES_NEED_TEXCOORD1
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            #define ATTRIBUTES_NEED_COLOR
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            #define VARYINGS_NEED_TEXCOORD0
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            #define VARYINGS_NEED_TEXCOORD1
                                            #endif

                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                            #define VARYINGS_NEED_COLOR
                                            #endif

                                                #define FEATURES_GRAPH_VERTEX
                                                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                #define SHADERPASS SHADERPASS_UNLIT
                                                /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

                                                // Includes
                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

                                                // --------------------------------------------------
                                                // Structs and Packing

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
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                                                struct Varyings
                                                {
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 positionCS : SV_POSITION;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 texCoord0;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                    #endif
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                    #endif
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                    #endif
                                                    #endif
                                                };
                                                struct SurfaceDescriptionInputs
                                                {
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 uv0;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 uv1;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 VertexColor;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float3 TimeParameters;
                                                    #endif
                                                };
                                                struct VertexDescriptionInputs
                                                {
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float3 ObjectSpaceNormal;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float3 ObjectSpaceTangent;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float3 ObjectSpacePosition;
                                                    #endif
                                                };
                                                struct PackedVaryings
                                                {
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 positionCS : SV_POSITION;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 interp0 : TEXCOORD0;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 interp1 : TEXCOORD1;
                                                    #endif
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    float4 interp2 : TEXCOORD2;
                                                    #endif
                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    uint instanceID : CUSTOM_INSTANCE_ID;
                                                    #endif
                                                    #endif
                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                    #endif
                                                    #endif
                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                    #endif
                                                    #endif
                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                    #endif
                                                    #endif
                                                };

                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                PackedVaryings PackVaryings(Varyings input)
                                                    {
                                                        PackedVaryings output;
                                                        output.positionCS = input.positionCS;
                                                        output.interp0.xyzw = input.texCoord0;
                                                        output.interp1.xyzw = input.texCoord1;
                                                        output.interp2.xyzw = input.color;
                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                        output.instanceID = input.instanceID;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                        #endif
                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                        output.cullFace = input.cullFace;
                                                        #endif
                                                        return output;
                                                    }
                                                    Varyings UnpackVaryings(PackedVaryings input)
                                                    {
                                                        Varyings output;
                                                        output.positionCS = input.positionCS;
                                                        output.texCoord0 = input.interp0.xyzw;
                                                        output.texCoord1 = input.interp1.xyzw;
                                                        output.color = input.interp2.xyzw;
                                                        #if UNITY_ANY_INSTANCING_ENABLED
                                                        output.instanceID = input.instanceID;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                        #endif
                                                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                        #endif
                                                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                        output.cullFace = input.cullFace;
                                                        #endif
                                                        return output;
                                                    }
                                                #endif

                                                    // --------------------------------------------------
                                                    // Graph

                                                    // Graph Properties
                                                    CBUFFER_START(UnityPerMaterial)
                                                    float4 _Color;
                                                    float2 Vector2_FB60315F;
                                                    float4 Texture2D_90210E7D_TexelSize;
                                                    float4 _MaskTex_TexelSize;
                                                    float Vector1_FC9BCA76;
                                                    float Vector1_A2984BC;
                                                    float Vector1_70FA963C;
                                                    float Vector1_E514496D;
                                                    float Vector1_18CD6163;
                                                    float2 Vector2_B02498D3;
                                                    CBUFFER_END

                                                        // Object and Global properties
                                                        TEXTURE2D(Texture2D_90210E7D);
                                                        SAMPLER(samplerTexture2D_90210E7D);
                                                        TEXTURE2D(_MaskTex);
                                                        SAMPLER(sampler_MaskTex);
                                                        SAMPLER(_SampleTexture2D_ce3836c16496338e911d572d6670f405_Sampler_3_Linear_Repeat);
                                                        SAMPLER(_SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_Sampler_3_Linear_Repeat);

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
                                                        struct VertexDescription
                                                        {
                                                            float3 Position;
                                                            float3 Normal;
                                                            float3 Tangent;
                                                        };

                                                        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                        {
                                                            VertexDescription description = (VertexDescription)0;
                                                            description.Position = IN.ObjectSpacePosition;
                                                            description.Normal = IN.ObjectSpaceNormal;
                                                            description.Tangent = IN.ObjectSpaceTangent;
                                                            return description;
                                                        }

                                                        // Graph Pixel
                                                        struct SurfaceDescription
                                                        {
                                                            float3 BaseColor;
                                                            float Alpha;
                                                            float AlphaClipThreshold;
                                                        };

                                                        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                        {
                                                            SurfaceDescription surface = (SurfaceDescription)0;
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Property_dd12ec1f616fed8cb142a4983afc6f8f_Out_0 = Vector1_FC9BCA76;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0 = IN.uv1;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Property_81fae46e52acac8e9081d434ee6c42a2_Out_0 = _Color;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float2 _Property_f32dcf59043a0586bef10901340ac50a_Out_0 = Vector2_FB60315F;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float2 _Property_a37180172af4f18692bb811032b8180e_Out_0 = Vector2_B02498D3;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float2 _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                                            Unity_Multiply_float(_Property_a37180172af4f18692bb811032b8180e_Out_0, (IN.TimeParameters.x.xx), _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            #if defined(BOOLEAN_214BDA66_ON)
                                                            float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                                            #else
                                                            float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = float2(0, 0);
                                                            #endif
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float2 _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3;
                                                            Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f32dcf59043a0586bef10901340ac50a_Out_0, _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                                            float _SampleTexture2D_ce3836c16496338e911d572d6670f405_R_4 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.r;
                                                            float _SampleTexture2D_ce3836c16496338e911d572d6670f405_G_5 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.g;
                                                            float _SampleTexture2D_ce3836c16496338e911d572d6670f405_B_6 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.b;
                                                            float _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.a;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                                            Unity_Multiply_float(_Property_81fae46e52acac8e9081d434ee6c42a2_Out_0, _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0, _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0 = Vector1_E514496D;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2;
                                                            Unity_Posterize_float4(_Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2, (_Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0.xxxx), _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[0];
                                                            float _Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[1];
                                                            float _Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[2];
                                                            float _Split_22ed15914cf4e985a2b9ffc09bb67a08_A_4 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[3];
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0 = Vector1_18CD6163;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Add_3856ff70597d7483983cab57d5ed89d1_Out_2;
                                                            Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_3856ff70597d7483983cab57d5ed89d1_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Add_7855453f51a0138f8fee886546ac6dc2_Out_2;
                                                            Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2;
                                                            Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4;
                                                            float3 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5;
                                                            float2 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6;
                                                            Unity_Combine_float(_Add_3856ff70597d7483983cab57d5ed89d1_Out_2, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2, _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                                            Unity_Clamp_float4(_Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            #if defined(BOOLEAN_15B78E78_ON)
                                                            float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                                            #else
                                                            float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                                            #endif
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                                            Unity_Multiply_float(IN.VertexColor, _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                                            Unity_Multiply_float(_UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2, _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            #if defined(BOOLEAN_CA9D1AC6_ON)
                                                            float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                                            #else
                                                            float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                                            #endif
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Multiply_28c1582d192ec0878aec999651401f5e_Out_2;
                                                            Unity_Multiply_float((_Property_dd12ec1f616fed8cb142a4983afc6f8f_Out_0.xxxx), _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0, _Multiply_28c1582d192ec0878aec999651401f5e_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Split_16df5a528bfd36858d8d95be2a607c80_R_1 = _Multiply_28c1582d192ec0878aec999651401f5e_Out_2[0];
                                                            float _Split_16df5a528bfd36858d8d95be2a607c80_G_2 = _Multiply_28c1582d192ec0878aec999651401f5e_Out_2[1];
                                                            float _Split_16df5a528bfd36858d8d95be2a607c80_B_3 = _Multiply_28c1582d192ec0878aec999651401f5e_Out_2[2];
                                                            float _Split_16df5a528bfd36858d8d95be2a607c80_A_4 = _Multiply_28c1582d192ec0878aec999651401f5e_Out_2[3];
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _Combine_635499a2c96061819034c07bde6a04cd_RGBA_4;
                                                            float3 _Combine_635499a2c96061819034c07bde6a04cd_RGB_5;
                                                            float2 _Combine_635499a2c96061819034c07bde6a04cd_RG_6;
                                                            Unity_Combine_float(_Split_16df5a528bfd36858d8d95be2a607c80_R_1, _Split_16df5a528bfd36858d8d95be2a607c80_G_2, _Split_16df5a528bfd36858d8d95be2a607c80_B_3, 0, _Combine_635499a2c96061819034c07bde6a04cd_RGBA_4, _Combine_635499a2c96061819034c07bde6a04cd_RGB_5, _Combine_635499a2c96061819034c07bde6a04cd_RG_6);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Split_6f37452d47b49c83a52002dd9ea68a7a_R_1 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[0];
                                                            float _Split_6f37452d47b49c83a52002dd9ea68a7a_G_2 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[1];
                                                            float _Split_6f37452d47b49c83a52002dd9ea68a7a_B_3 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[2];
                                                            float _Split_6f37452d47b49c83a52002dd9ea68a7a_A_4 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[3];
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Property_a004be3064e610829f701db3bb905e19_Out_0 = Vector1_70FA963C;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2;
                                                            Unity_Add_float(_Split_6f37452d47b49c83a52002dd9ea68a7a_A_4, _Property_a004be3064e610829f701db3bb905e19_Out_0, _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float4 _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
                                                            float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.r;
                                                            float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_G_5 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.g;
                                                            float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_B_6 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.b;
                                                            float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_A_7 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.a;
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2;
                                                            Unity_Multiply_float(_Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2, _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4, _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                                            Unity_Clamp_float(_Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2, 0, 1, _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3);
                                                            #endif
                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            float _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0 = Vector1_A2984BC;
                                                            #endif
                                                            surface.BaseColor = _Combine_635499a2c96061819034c07bde6a04cd_RGB_5;
                                                            surface.Alpha = _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                                            surface.AlphaClipThreshold = _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0;
                                                            return surface;
                                                        }

                                                        // --------------------------------------------------
                                                        // Build Graph Inputs

                                                        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                        {
                                                            VertexDescriptionInputs output;
                                                            ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        output.ObjectSpaceNormal = input.normalOS;
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        output.ObjectSpaceTangent = input.tangentOS;
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        output.ObjectSpacePosition = input.positionOS;
                                                        #endif


                                                            return output;
                                                        }

                                                        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                        {
                                                            SurfaceDescriptionInputs output;
                                                            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        output.uv0 = input.texCoord0;
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        output.uv1 = input.texCoord1;
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        output.VertexColor = input.color;
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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

                                                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
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
                                                            Cull Off
                                                            Blend One Zero
                                                            ZTest LEqual
                                                            ZWrite On
                                                            ColorMask 0

                                                            // Debug
                                                            // <None>

                                                            // --------------------------------------------------
                                                            // Pass

                                                            HLSLPROGRAM

                                                            // Pragmas
                                                            #pragma target 4.5
                                                            #pragma exclude_renderers gles gles3 glcore
                                                            #pragma multi_compile_instancing
                                                            #pragma multi_compile _ DOTS_INSTANCING_ON
                                                            #pragma vertex vert
                                                            #pragma fragment frag

                                                            // DotsInstancingOptions: <None>
                                                            // HybridV1InjectedBuiltinProperties: <None>

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

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        #define ATTRIBUTES_NEED_TEXCOORD1
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        #define ATTRIBUTES_NEED_COLOR
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        #define VARYINGS_NEED_TEXCOORD0
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        #define VARYINGS_NEED_TEXCOORD1
                                                        #endif

                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                        #define VARYINGS_NEED_COLOR
                                                        #endif

                                                            #define FEATURES_GRAPH_VERTEX
                                                            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                            #define SHADERPASS SHADERPASS_SHADOWCASTER
                                                            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

                                                            // Includes
                                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

                                                            // --------------------------------------------------
                                                            // Structs and Packing

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
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                                                            struct Varyings
                                                            {
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 positionCS : SV_POSITION;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 texCoord0;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                #endif
                                                                #endif
                                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                #endif
                                                                #endif
                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                #endif
                                                                #endif
                                                            };
                                                            struct SurfaceDescriptionInputs
                                                            {
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 uv0;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 uv1;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 VertexColor;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float3 TimeParameters;
                                                                #endif
                                                            };
                                                            struct VertexDescriptionInputs
                                                            {
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float3 ObjectSpaceNormal;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float3 ObjectSpaceTangent;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float3 ObjectSpacePosition;
                                                                #endif
                                                            };
                                                            struct PackedVaryings
                                                            {
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 positionCS : SV_POSITION;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 interp0 : TEXCOORD0;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 interp1 : TEXCOORD1;
                                                                #endif
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                float4 interp2 : TEXCOORD2;
                                                                #endif
                                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                uint instanceID : CUSTOM_INSTANCE_ID;
                                                                #endif
                                                                #endif
                                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                #endif
                                                                #endif
                                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                #endif
                                                                #endif
                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                #endif
                                                                #endif
                                                            };

                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                            PackedVaryings PackVaryings(Varyings input)
                                                                {
                                                                    PackedVaryings output;
                                                                    output.positionCS = input.positionCS;
                                                                    output.interp0.xyzw = input.texCoord0;
                                                                    output.interp1.xyzw = input.texCoord1;
                                                                    output.interp2.xyzw = input.color;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                    output.instanceID = input.instanceID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                    output.cullFace = input.cullFace;
                                                                    #endif
                                                                    return output;
                                                                }
                                                                Varyings UnpackVaryings(PackedVaryings input)
                                                                {
                                                                    Varyings output;
                                                                    output.positionCS = input.positionCS;
                                                                    output.texCoord0 = input.interp0.xyzw;
                                                                    output.texCoord1 = input.interp1.xyzw;
                                                                    output.color = input.interp2.xyzw;
                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                    output.instanceID = input.instanceID;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                    #endif
                                                                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                    #endif
                                                                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                    output.cullFace = input.cullFace;
                                                                    #endif
                                                                    return output;
                                                                }
                                                            #endif

                                                                // --------------------------------------------------
                                                                // Graph

                                                                // Graph Properties
                                                                CBUFFER_START(UnityPerMaterial)
                                                                float4 _Color;
                                                                float2 Vector2_FB60315F;
                                                                float4 Texture2D_90210E7D_TexelSize;
                                                                float4 _MaskTex_TexelSize;
                                                                float Vector1_FC9BCA76;
                                                                float Vector1_A2984BC;
                                                                float Vector1_70FA963C;
                                                                float Vector1_E514496D;
                                                                float Vector1_18CD6163;
                                                                float2 Vector2_B02498D3;
                                                                CBUFFER_END

                                                                    // Object and Global properties
                                                                    TEXTURE2D(Texture2D_90210E7D);
                                                                    SAMPLER(samplerTexture2D_90210E7D);
                                                                    TEXTURE2D(_MaskTex);
                                                                    SAMPLER(sampler_MaskTex);
                                                                    SAMPLER(_SampleTexture2D_ce3836c16496338e911d572d6670f405_Sampler_3_Linear_Repeat);
                                                                    SAMPLER(_SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_Sampler_3_Linear_Repeat);

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
                                                                    struct VertexDescription
                                                                    {
                                                                        float3 Position;
                                                                        float3 Normal;
                                                                        float3 Tangent;
                                                                    };

                                                                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                                    {
                                                                        VertexDescription description = (VertexDescription)0;
                                                                        description.Position = IN.ObjectSpacePosition;
                                                                        description.Normal = IN.ObjectSpaceNormal;
                                                                        description.Tangent = IN.ObjectSpaceTangent;
                                                                        return description;
                                                                    }

                                                                    // Graph Pixel
                                                                    struct SurfaceDescription
                                                                    {
                                                                        float Alpha;
                                                                        float AlphaClipThreshold;
                                                                    };

                                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                    {
                                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0 = IN.uv1;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _Property_81fae46e52acac8e9081d434ee6c42a2_Out_0 = _Color;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float2 _Property_f32dcf59043a0586bef10901340ac50a_Out_0 = Vector2_FB60315F;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float2 _Property_a37180172af4f18692bb811032b8180e_Out_0 = Vector2_B02498D3;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float2 _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                                                        Unity_Multiply_float(_Property_a37180172af4f18692bb811032b8180e_Out_0, (IN.TimeParameters.x.xx), _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        #if defined(BOOLEAN_214BDA66_ON)
                                                                        float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                                                        #else
                                                                        float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = float2(0, 0);
                                                                        #endif
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float2 _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3;
                                                                        Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f32dcf59043a0586bef10901340ac50a_Out_0, _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                                                        float _SampleTexture2D_ce3836c16496338e911d572d6670f405_R_4 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.r;
                                                                        float _SampleTexture2D_ce3836c16496338e911d572d6670f405_G_5 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.g;
                                                                        float _SampleTexture2D_ce3836c16496338e911d572d6670f405_B_6 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.b;
                                                                        float _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.a;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                                                        Unity_Multiply_float(_Property_81fae46e52acac8e9081d434ee6c42a2_Out_0, _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0, _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0 = Vector1_E514496D;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2;
                                                                        Unity_Posterize_float4(_Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2, (_Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0.xxxx), _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[0];
                                                                        float _Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[1];
                                                                        float _Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[2];
                                                                        float _Split_22ed15914cf4e985a2b9ffc09bb67a08_A_4 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[3];
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0 = Vector1_18CD6163;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Add_3856ff70597d7483983cab57d5ed89d1_Out_2;
                                                                        Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_3856ff70597d7483983cab57d5ed89d1_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Add_7855453f51a0138f8fee886546ac6dc2_Out_2;
                                                                        Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2;
                                                                        Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4;
                                                                        float3 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5;
                                                                        float2 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6;
                                                                        Unity_Combine_float(_Add_3856ff70597d7483983cab57d5ed89d1_Out_2, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2, _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                                                        Unity_Clamp_float4(_Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        #if defined(BOOLEAN_15B78E78_ON)
                                                                        float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                                                        #else
                                                                        float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                                                        #endif
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                                                        Unity_Multiply_float(IN.VertexColor, _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                                                        Unity_Multiply_float(_UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2, _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        #if defined(BOOLEAN_CA9D1AC6_ON)
                                                                        float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                                                        #else
                                                                        float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                                                        #endif
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Split_6f37452d47b49c83a52002dd9ea68a7a_R_1 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[0];
                                                                        float _Split_6f37452d47b49c83a52002dd9ea68a7a_G_2 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[1];
                                                                        float _Split_6f37452d47b49c83a52002dd9ea68a7a_B_3 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[2];
                                                                        float _Split_6f37452d47b49c83a52002dd9ea68a7a_A_4 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[3];
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Property_a004be3064e610829f701db3bb905e19_Out_0 = Vector1_70FA963C;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2;
                                                                        Unity_Add_float(_Split_6f37452d47b49c83a52002dd9ea68a7a_A_4, _Property_a004be3064e610829f701db3bb905e19_Out_0, _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float4 _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
                                                                        float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.r;
                                                                        float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_G_5 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.g;
                                                                        float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_B_6 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.b;
                                                                        float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_A_7 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.a;
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2;
                                                                        Unity_Multiply_float(_Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2, _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4, _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                                                        Unity_Clamp_float(_Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2, 0, 1, _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3);
                                                                        #endif
                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        float _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0 = Vector1_A2984BC;
                                                                        #endif
                                                                        surface.Alpha = _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                                                        surface.AlphaClipThreshold = _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0;
                                                                        return surface;
                                                                    }

                                                                    // --------------------------------------------------
                                                                    // Build Graph Inputs

                                                                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                                    {
                                                                        VertexDescriptionInputs output;
                                                                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    output.ObjectSpaceNormal = input.normalOS;
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    output.ObjectSpaceTangent = input.tangentOS;
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    output.ObjectSpacePosition = input.positionOS;
                                                                    #endif


                                                                        return output;
                                                                    }

                                                                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                                    {
                                                                        SurfaceDescriptionInputs output;
                                                                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    output.uv0 = input.texCoord0;
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    output.uv1 = input.texCoord1;
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    output.VertexColor = input.color;
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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

                                                                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
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
                                                                        Cull Off
                                                                        Blend One Zero
                                                                        ZTest LEqual
                                                                        ZWrite On
                                                                        ColorMask 0

                                                                        // Debug
                                                                        // <None>

                                                                        // --------------------------------------------------
                                                                        // Pass

                                                                        HLSLPROGRAM

                                                                        // Pragmas
                                                                        #pragma target 4.5
                                                                        #pragma exclude_renderers gles gles3 glcore
                                                                        #pragma multi_compile_instancing
                                                                        #pragma multi_compile _ DOTS_INSTANCING_ON
                                                                        #pragma vertex vert
                                                                        #pragma fragment frag

                                                                        // DotsInstancingOptions: <None>
                                                                        // HybridV1InjectedBuiltinProperties: <None>

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

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    #define ATTRIBUTES_NEED_TEXCOORD1
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    #define ATTRIBUTES_NEED_COLOR
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    #define VARYINGS_NEED_TEXCOORD0
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    #define VARYINGS_NEED_TEXCOORD1
                                                                    #endif

                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                    #define VARYINGS_NEED_COLOR
                                                                    #endif

                                                                        #define FEATURES_GRAPH_VERTEX
                                                                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                                        #define SHADERPASS SHADERPASS_DEPTHONLY
                                                                        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

                                                                        // Includes
                                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
                                                                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

                                                                        // --------------------------------------------------
                                                                        // Structs and Packing

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
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                                                                        struct Varyings
                                                                        {
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 positionCS : SV_POSITION;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 texCoord0;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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
                                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                            #endif
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                            #endif
                                                                            #endif
                                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                            #endif
                                                                            #endif
                                                                        };
                                                                        struct SurfaceDescriptionInputs
                                                                        {
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 uv0;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 uv1;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 VertexColor;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float3 TimeParameters;
                                                                            #endif
                                                                        };
                                                                        struct VertexDescriptionInputs
                                                                        {
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float3 ObjectSpaceNormal;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float3 ObjectSpaceTangent;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float3 ObjectSpacePosition;
                                                                            #endif
                                                                        };
                                                                        struct PackedVaryings
                                                                        {
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 positionCS : SV_POSITION;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 interp0 : TEXCOORD0;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 interp1 : TEXCOORD1;
                                                                            #endif
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            float4 interp2 : TEXCOORD2;
                                                                            #endif
                                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            uint instanceID : CUSTOM_INSTANCE_ID;
                                                                            #endif
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                                                            #endif
                                                                            #endif
                                                                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                                                            #endif
                                                                            #endif
                                                                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                                                            #endif
                                                                            #endif
                                                                        };

                                                                        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                        PackedVaryings PackVaryings(Varyings input)
                                                                            {
                                                                                PackedVaryings output;
                                                                                output.positionCS = input.positionCS;
                                                                                output.interp0.xyzw = input.texCoord0;
                                                                                output.interp1.xyzw = input.texCoord1;
                                                                                output.interp2.xyzw = input.color;
                                                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                                                output.instanceID = input.instanceID;
                                                                                #endif
                                                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                                #endif
                                                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                                #endif
                                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                                output.cullFace = input.cullFace;
                                                                                #endif
                                                                                return output;
                                                                            }
                                                                            Varyings UnpackVaryings(PackedVaryings input)
                                                                            {
                                                                                Varyings output;
                                                                                output.positionCS = input.positionCS;
                                                                                output.texCoord0 = input.interp0.xyzw;
                                                                                output.texCoord1 = input.interp1.xyzw;
                                                                                output.color = input.interp2.xyzw;
                                                                                #if UNITY_ANY_INSTANCING_ENABLED
                                                                                output.instanceID = input.instanceID;
                                                                                #endif
                                                                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                                                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                                                                #endif
                                                                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                                                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                                                                #endif
                                                                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                                                                output.cullFace = input.cullFace;
                                                                                #endif
                                                                                return output;
                                                                            }
                                                                        #endif

                                                                            // --------------------------------------------------
                                                                            // Graph

                                                                            // Graph Properties
                                                                            CBUFFER_START(UnityPerMaterial)
                                                                            float4 _Color;
                                                                            float2 Vector2_FB60315F;
                                                                            float4 Texture2D_90210E7D_TexelSize;
                                                                            float4 _MaskTex_TexelSize;
                                                                            float Vector1_FC9BCA76;
                                                                            float Vector1_A2984BC;
                                                                            float Vector1_70FA963C;
                                                                            float Vector1_E514496D;
                                                                            float Vector1_18CD6163;
                                                                            float2 Vector2_B02498D3;
                                                                            CBUFFER_END

                                                                                // Object and Global properties
                                                                                TEXTURE2D(Texture2D_90210E7D);
                                                                                SAMPLER(samplerTexture2D_90210E7D);
                                                                                TEXTURE2D(_MaskTex);
                                                                                SAMPLER(sampler_MaskTex);
                                                                                SAMPLER(_SampleTexture2D_ce3836c16496338e911d572d6670f405_Sampler_3_Linear_Repeat);
                                                                                SAMPLER(_SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_Sampler_3_Linear_Repeat);

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
                                                                                struct VertexDescription
                                                                                {
                                                                                    float3 Position;
                                                                                    float3 Normal;
                                                                                    float3 Tangent;
                                                                                };

                                                                                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                                                                                {
                                                                                    VertexDescription description = (VertexDescription)0;
                                                                                    description.Position = IN.ObjectSpacePosition;
                                                                                    description.Normal = IN.ObjectSpaceNormal;
                                                                                    description.Tangent = IN.ObjectSpaceTangent;
                                                                                    return description;
                                                                                }

                                                                                // Graph Pixel
                                                                                struct SurfaceDescription
                                                                                {
                                                                                    float Alpha;
                                                                                    float AlphaClipThreshold;
                                                                                };

                                                                                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                                {
                                                                                    SurfaceDescription surface = (SurfaceDescription)0;
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0 = IN.uv1;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _Property_81fae46e52acac8e9081d434ee6c42a2_Out_0 = _Color;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float2 _Property_f32dcf59043a0586bef10901340ac50a_Out_0 = Vector2_FB60315F;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float2 _Property_a37180172af4f18692bb811032b8180e_Out_0 = Vector2_B02498D3;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float2 _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                                                                    Unity_Multiply_float(_Property_a37180172af4f18692bb811032b8180e_Out_0, (IN.TimeParameters.x.xx), _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    #if defined(BOOLEAN_214BDA66_ON)
                                                                                    float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = _Multiply_1d27f90aeec1408c8f5765fad783515d_Out_2;
                                                                                    #else
                                                                                    float2 _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0 = float2(0, 0);
                                                                                    #endif
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float2 _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3;
                                                                                    Unity_TilingAndOffset_float(IN.uv0.xy, _Property_f32dcf59043a0586bef10901340ac50a_Out_0, _UseMoveUV_e0ac58b25f5b99819aa76fdf15383e12_Out_0, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_90210E7D, samplerTexture2D_90210E7D, _TilingAndOffset_682076060611268f9ff84e9ece35cfb5_Out_3);
                                                                                    float _SampleTexture2D_ce3836c16496338e911d572d6670f405_R_4 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.r;
                                                                                    float _SampleTexture2D_ce3836c16496338e911d572d6670f405_G_5 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.g;
                                                                                    float _SampleTexture2D_ce3836c16496338e911d572d6670f405_B_6 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.b;
                                                                                    float _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7 = _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0.a;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                                                                    Unity_Multiply_float(_Property_81fae46e52acac8e9081d434ee6c42a2_Out_0, _SampleTexture2D_ce3836c16496338e911d572d6670f405_RGBA_0, _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0 = Vector1_E514496D;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2;
                                                                                    Unity_Posterize_float4(_Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2, (_Property_175b07f825b17d82a9f77166b5ff1bf0_Out_0.xxxx), _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[0];
                                                                                    float _Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[1];
                                                                                    float _Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[2];
                                                                                    float _Split_22ed15914cf4e985a2b9ffc09bb67a08_A_4 = _Posterize_7f0d13a5c0afc480bc1e6bed8807d01e_Out_2[3];
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0 = Vector1_18CD6163;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Add_3856ff70597d7483983cab57d5ed89d1_Out_2;
                                                                                    Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_R_1, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_3856ff70597d7483983cab57d5ed89d1_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Add_7855453f51a0138f8fee886546ac6dc2_Out_2;
                                                                                    Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_G_2, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2;
                                                                                    Unity_Add_float(_Split_22ed15914cf4e985a2b9ffc09bb67a08_B_3, _Property_f4f8a2b099d9f6859cc3bf923a4f74b2_Out_0, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4;
                                                                                    float3 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5;
                                                                                    float2 _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6;
                                                                                    Unity_Combine_float(_Add_3856ff70597d7483983cab57d5ed89d1_Out_2, _Add_7855453f51a0138f8fee886546ac6dc2_Out_2, _Add_1aebbc13e5acb78ea19688b409c1cdf5_Out_2, _SampleTexture2D_ce3836c16496338e911d572d6670f405_A_7, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RGB_5, _Combine_9ea598637d6e1f8a8b69a64558ca209e_RG_6);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                                                                    Unity_Clamp_float4(_Combine_9ea598637d6e1f8a8b69a64558ca209e_RGBA_4, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    #if defined(BOOLEAN_15B78E78_ON)
                                                                                    float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Clamp_63d41bab7c96638d9faded23de5dfd06_Out_3;
                                                                                    #else
                                                                                    float4 _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0 = _Multiply_e0c0307171fd4d86bdbc6425224b48d5_Out_2;
                                                                                    #endif
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                                                                    Unity_Multiply_float(IN.VertexColor, _UsePosterize_31bb8d6fea56188b946985c7326388ab_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                                                                    Unity_Multiply_float(_UV_13b0acfc75e9e78b8a8562328d4cbd77_Out_0, _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2, _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    #if defined(BOOLEAN_CA9D1AC6_ON)
                                                                                    float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_c9baacd54a03828f909fcbf82ccc6898_Out_2;
                                                                                    #else
                                                                                    float4 _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0 = _Multiply_6cffda7e459ba28ebda4a79c8f7c7fc2_Out_2;
                                                                                    #endif
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Split_6f37452d47b49c83a52002dd9ea68a7a_R_1 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[0];
                                                                                    float _Split_6f37452d47b49c83a52002dd9ea68a7a_G_2 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[1];
                                                                                    float _Split_6f37452d47b49c83a52002dd9ea68a7a_B_3 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[2];
                                                                                    float _Split_6f37452d47b49c83a52002dd9ea68a7a_A_4 = _UseUV1_aec414ee693bfd8fb91035560f28552c_Out_0[3];
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Property_a004be3064e610829f701db3bb905e19_Out_0 = Vector1_70FA963C;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2;
                                                                                    Unity_Add_float(_Split_6f37452d47b49c83a52002dd9ea68a7a_A_4, _Property_a004be3064e610829f701db3bb905e19_Out_0, _Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float4 _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0 = SAMPLE_TEXTURE2D(_MaskTex, sampler_MaskTex, IN.uv0.xy);
                                                                                    float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.r;
                                                                                    float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_G_5 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.g;
                                                                                    float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_B_6 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.b;
                                                                                    float _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_A_7 = _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_RGBA_0.a;
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2;
                                                                                    Unity_Multiply_float(_Add_7fbf4d7f38d8c48b80ec10a5e621be70_Out_2, _SampleTexture2D_cb17b5db465e5f8babc824f1f1fd1399_R_4, _Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                                                                    Unity_Clamp_float(_Multiply_e50e1a266e6b6b8d8e52f9e44df25698_Out_2, 0, 1, _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3);
                                                                                    #endif
                                                                                    #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                    float _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0 = Vector1_A2984BC;
                                                                                    #endif
                                                                                    surface.Alpha = _Clamp_35bd926ce4bf5d86ac5ad8c194df75bb_Out_3;
                                                                                    surface.AlphaClipThreshold = _Property_cea166b36fbe0e8d80b60e3dbdcae383_Out_0;
                                                                                    return surface;
                                                                                }

                                                                                // --------------------------------------------------
                                                                                // Build Graph Inputs

                                                                                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                                                                                {
                                                                                    VertexDescriptionInputs output;
                                                                                    ZERO_INITIALIZE(VertexDescriptionInputs, output);

                                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                output.ObjectSpaceNormal = input.normalOS;
                                                                                #endif

                                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                output.ObjectSpaceTangent = input.tangentOS;
                                                                                #endif

                                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                output.ObjectSpacePosition = input.positionOS;
                                                                                #endif


                                                                                    return output;
                                                                                }

                                                                                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                                                                                {
                                                                                    SurfaceDescriptionInputs output;
                                                                                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





                                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                output.uv0 = input.texCoord0;
                                                                                #endif

                                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                output.uv1 = input.texCoord1;
                                                                                #endif

                                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
                                                                                output.VertexColor = input.color;
                                                                                #endif

                                                                                #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1) || defined(KEYWORD_PERMUTATION_2) || defined(KEYWORD_PERMUTATION_3) || defined(KEYWORD_PERMUTATION_4) || defined(KEYWORD_PERMUTATION_5) || defined(KEYWORD_PERMUTATION_6) || defined(KEYWORD_PERMUTATION_7)
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

                                                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
                                                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                                                                                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

                                                                                ENDHLSL
                                                                            }
                                            }
                                                FallBack "Hidden/Shader Graph/FallbackError"
}
