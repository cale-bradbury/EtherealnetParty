// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/SkullTears" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
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

		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
			float3 normal : TEXCOORD1;
		};

		struct Input {
			float2 uv_MainTex;
			float3 normal;
			float3 vertex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);

			half3 original = v.vertex.xyz;
			half4 obj = mul(unity_ObjectToWorld, v.vertex);
			half2 step = half2(v.vertex.x - (_Time.x * .6 + v.uv.x - obj.x * 3) * 2, v.vertex.y);
			half3 noise = tex2Dlod(_MainTex, float4(step, 0, 0)).xyz;

			half posNeg = sign(v.vertex.z);
			v.vertex.xyz += noise * .001;

			v.vertex.z += posNeg * -.001;

			

			o.vertex = v.vertex;
			o.normal = v.normal;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			half4 noise = tex2D(_MainTex, IN.vertex.xy);

			// Albedo comes from a texture tinted by color
			fixed4 c = _Color;
			o.Albedo = c;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			//o.Normal = IN.normal;
			//o.Normal = half3(1, 0, 0);
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
