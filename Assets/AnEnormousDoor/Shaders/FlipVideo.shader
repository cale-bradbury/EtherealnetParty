// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/FlipVideo"
{
	Properties
	{
		_TextureA("TextureA", 2D) = "white" {}
		_TextureB("TextureB", 2D) = "white" {}
		_Step("Step", Range(0,1)) = 0
	}
		SubShader
	{
		Tags{ "RenderType" = "Overlay" }
		LOD 100

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _TextureA;
			sampler2D _TextureB;
			float4 _MainTex_ST;
			float _Step;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half4 colA = tex2D(_TextureA, i.uv);
				half4 colB = tex2D(_TextureB, i.uv);

				half step = sin(_Step * 3.1415 * 2);
				return lerp(colA, colB, step) * 1.5;
			}

		ENDCG
		}
	}
}