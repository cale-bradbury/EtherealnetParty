Shader "Unlit/UnlitAudioVertDisplace"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplacementTex("R-Freq G-Time B-Amp", 2D) = "grey"{}
		_Shape("XY-min/max displacement", Vector) = (0., 1., 0., 0.)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DisplacementTex;
			float4 _DisplacementTex_ST;
			float4 _Shape;
			sampler2D _AudioTex;
			
			v2f vert (appdata v)
			{
				float2 uv = TRANSFORM_TEX(v.uv, _DisplacementTex);
				float4 f = tex2Dlod(_DisplacementTex, float4(uv, 1., 1.));
				float a = tex2Dlod(_AudioTex, float4(f.r, f.g, 1., 1.)).r;
				v.vertex.xyz += v.normal*lerp(_Shape.x, _Shape.y, a)*(f.b-.5);
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
