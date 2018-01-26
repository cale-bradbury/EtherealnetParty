// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "Custom/SkeletonShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(-.5, .7)) = 0.5
		_Metallic ("Metallic", Range(-.5, .7)) = 0.0

		_Noise("Noise", 2D) = "white" {}
		_Effect("Effect", Range(0,1)) = 0
		_EffectBoost("EffectBoost", Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Noise;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		half _Effect;
		half _EffectBoost;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata_full v) 
		{
			half4 noise = tex2Dlod(_Noise, float4(v.vertex.y + fmod(floor(_Time.y * 10), 20) * 10 + (_EffectBoost * 20), v.vertex.y, 0, 0));
			half3 vert = v.vertex.xyz;
			if (fmod(v.vertex.x, 2) < 1)
			{
				vert = lerp(vert, vert + noise.xyz * 200, _Effect);
			}
			else
			{
				vert = lerp(vert, vert - noise.xyz * 200, _Effect);
			}
			
			//vert.y -= _Effect * 50;
			v.vertex.xyz = vert;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

