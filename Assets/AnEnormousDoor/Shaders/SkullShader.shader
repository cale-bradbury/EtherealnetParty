// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "Custom/SkullShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Noise("Noise", 2D) = "white" {}
		_Effect("Effect", Range(0,5)) = 0
		_Intensity("Intensity", Range(0,1)) = 0
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
		half _Effect;
		half _Intensity;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		half3 vertexTransform1(half3 vertex)
		{
			half4 noise = tex2Dlod(_Noise, float4(vertex.y + fmod(floor(_Time.y * 10), 20) * 10, vertex.y, 0, 0));
			half posNeg = -1;

			half step = floor(_Time.y * 5) * .005;

			if (fmod(vertex.x + step, .1) > .015)
			{
				posNeg = 1;
			}

			vertex.xy += noise.xy * 10 * _Intensity * .005 * posNeg;
			return vertex;
		}

		half3 vertexTransform2(half3 vertex, half3 normal)
		{
			half effect = _Time.y * .4;
			half ySample = 0;
			half ySampleMultiplier = 0;

			if (fmod(effect, 1) > .66666)
			{
				ySampleMultiplier = 2;
			}
			else if (fmod(effect, 1) > .33333)
			{
				ySampleMultiplier = 10;
			}
			else
			{
				ySampleMultiplier = 20;
			}

			if (fmod(effect, 1) > .66666)
			{
				ySample = vertex.y;
			}
			else if (fmod(effect / 2, 1) > .33333)
			{
				ySample = vertex.x;
			}
			else
			{
				ySample = vertex.z;
			}

			half4 noise = tex2Dlod(_Noise, float4(vertex.y + floor(fmod(floor(_Time.y * 10), 20) * 10), ySample * ySampleMultiplier, 0, 0));
			half posNeg = sign(sin(noise.y));

			vertex.xyz += normal.xyz * noise.x * 10 * _Intensity * .005 * posNeg;
			return vertex;
		}

		half3 vertexTransform3(half3 vertex, half3 normal)
		{
			half4 noise = tex2Dlod(_Noise, float4(vertex.y + fmod(floor(_Time.y * 10), 20) * 10, vertex.y, 0, 0));
			half posNeg = -1;

			half2 start = normal.xy * 10 * _Intensity * .005 * posNeg;
			half2 end = normal.xy * 10 * _Intensity * .005 * posNeg + vertex.xy * noise.x * 1.5;

			half step = floor(fmod(_Time.y * .1, .2) * 30) / 6;
			vertex.xy += lerp(start, end, step);

			return vertex;
		}

		half3 vertexTransform4(half3 vertex, half3 normal)
		{
			half time = _Time.y * .5;

			half4 noise = tex2Dlod(_Noise, float4(vertex.y + fmod(floor(time * 10), 20) * 10, vertex.z, 0, 0));
			half posNeg = sign(sin(noise.y));

			half step = floor(time * 5) * .005;

			vertex.xyz += normal.xyz * noise.x * 10 * _Intensity * .05 * posNeg;
			return vertex;
		}

		half3 vertexTransform5(half3 vertex, half3 normal)
		{
			half4 noise = tex2Dlod(_Noise, float4(vertex.y + fmod(floor(_Time.y * 10), 20) * 10, vertex.z, 0, 0));
			half posNeg = sign(sin(noise.y));

			half step = floor(_Time.y * 5) * .005;

			//vertex.xyz += normal.xyz * noise.x * 10 * _Intensity * .005 * posNeg;
			vertex.y -= noise.x * 10 * _Intensity * .025;
			return vertex;
		}

		void vert(inout appdata_full v)
		{
			half4 noise = tex2Dlod(_Noise, float4(v.vertex.y + fmod(floor(_Time.y * 10), 20) * 10, v.vertex.y, 0, 0));
			half3 vert = v.vertex.xyz;

			if (_Effect < 1)
			{
				v.vertex.xyz = vertexTransform1(v.vertex.xyz);
			}
			else if (_Effect < 2)
			{
				v.vertex.xyz = vertexTransform2(v.vertex.xyz, v.normal);
			}
			else if (_Effect < 3)
			{
				v.vertex.xyz = vertexTransform3(v.vertex.xyz, v.normal);
			}
			else if (_Effect < 4)
			{
				v.vertex.xyz = vertexTransform4(v.vertex.xyz, v.normal);
			}
			else if (_Effect < 5)
			{
				v.vertex.xyz = vertexTransform5(v.vertex.xyz, v.normal);
			}
			
			// Don't modify mesh if >= last value
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
