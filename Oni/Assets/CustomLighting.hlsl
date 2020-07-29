void MainLight_half(float3 WorldPos, out half3 Direction, out half3 Color, out half DistanceAtten, out half ShadowAtten)
{
	#if SHADERGRAPH_PREVIEW
		Direction = half3(0.5, 0.5, 0);
		Color = 1;
		DistanceAtten = 1;
		ShadowAtten = 1;
	#else
		#if SHADOWS_SCREEN
			half4 clipPos = TransformWorldToHClip(WorldPos);
			half4 shadowCoord = ComputeScreenPos(clipPos);
		#else
			/* 因為_MAIN_LIGHT_SHADOWS_CASCADE 在Build版本時一直是Disable狀況，導致Build版本的陰影有錯誤，所以這邊先強制改成會執行ComputeCascadeIndex的方式
			(這樣會導致使用No Cascades時會無法產生陰影，需要使用Two或Four Cascades才有陰影，所以要注意不要設定成No Cascades)
			half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
			*/
			half cascadeIndex = ComputeCascadeIndex(WorldPos);
			half4 shadowCoord = mul(_MainLightWorldToShadow[cascadeIndex], float4(WorldPos, 1.0));
		#endif
			Light mainLight = GetMainLight(shadowCoord);
			Direction = mainLight.direction;
			Color = mainLight.color;
			DistanceAtten = mainLight.distanceAttenuation;

		#if !defined(_MAIN_LIGHT_SHADOWS) || defined(_RECEIVE_SHADOWS_OFF)
			ShadowAtten = 1.0h;
		#endif
			
		#if SHADOWS_SCREEN
			ShadowAtten = SampleScreenSpaceShadowmap(shadowCoord);
		#else
			ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
			half shadowStrength = GetMainLightShadowStrength();
			ShadowAtten = SampleShadowmap(TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), shadowCoord, shadowSamplingData, shadowStrength, false);
		#endif
	#endif
}
/*
void MainLight_half(float3 WorldPos, out half3 Direction, out half3 Color, out half DistanceAtten, out half ShadowAtten)
{
	#if SHADERGRAPH_PREVIEW
		Direction = half3(0.5, 0.5, 0);
		Color = 1;
		DistanceAtten = 1;
		ShadowAtten = 0.1f;
	#else
		#if SHADOWS_SCREEN
			half4 clipPos = TransformWorldToHClip(WorldPos);
			half4 shadowCoord = ComputeScreenPos(clipPos);
		#else
			half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
		#endif
		Light mainLight = GetMainLight(shadowCoord);
		Direction = mainLight.direction;
		Color = mainLight.color;
		DistanceAtten = mainLight.distanceAttenuation;
		ShadowAtten = mainLight.shadowAttenuation;
	#endif
}
*/