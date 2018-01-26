Shader "Unlit/Foreground Shader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Noise("Texture", 2D) = "white" {}
		_Effect ("Effect", Range(0,7)) = 0
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
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _Noise;
			float4 _MainTex_ST;
			float _Effect;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			half4 effect1(half2 uv)
			{
				half step = floor(fmod(_Time.y * 2, 4.0)) + 2;
				uv.x -= (floor(uv.y * 5) / 5.0 * .5) * floor(fmod(_Time.y, 5.0) + 6);
				uv.x *= 4 + sin(step * 50 + uv.y * 50) * (.01 * step) + .5;

				return tex2D(_MainTex, uv);
			}

			half4 effect2(half2 uv)
			{
				half step = floor(fmod(_Time.y * 2, 8) + 1);
				uv.x = floor(uv.x * step) / step;
				
				return tex2D(_MainTex, uv);
			}

			half4 effect3(half2 uv)
			{
				uv.x += sin(cos(uv.y * (uv.x * 10)) * 2);
				
				return tex2D(_MainTex, uv);
			}

			half4 effect4(half2 uv)
			{
				half step = floor(fmod(_Time.y * 4, 5));
				half4 color = tex2D(_MainTex, uv);
				if (step < 1)
				{
					return color;
				}
				uv.x += .2;
				color -= tex2D(_MainTex, uv) * .8;
				if (step < 2)
				{
					return color;
				}
				uv.x += .2;
				color += tex2D(_MainTex, uv) * .1;
				if (step < 3)
				{
					return color;
				}
				uv.x += .2;
				color -= tex2D(_MainTex, uv) * .3;
				uv.x += .2;
				if (step < 4)
				{
					return color;
				}
				color += tex2D(_MainTex, uv) * .1;
				return color;
			}

			half4 effect5(half2 uv)
			{
				uv.x *= 3;
				half4 color = tex2D(_MainTex, uv);

				return color;
			}

			half4 effect6(half2 uv)
			{
				half4 color = tex2D(_MainTex, uv);
				color = 1 - color;

				return color;
			}

			half4 effect7(half2 uv)
			{
				half2 sampleUV = uv;
				sampleUV.x = .5;
				half sampledPoint = tex2D(_MainTex, sampleUV).r;
				half4 noise = tex2D(_Noise, sampleUV);

				half distanceFromMiddle = abs(((uv.x + noise.r) * 2) - 1);
				distanceFromMiddle = floor(distanceFromMiddle * 10) / 10;


				half4 color = half4(sampledPoint, sampledPoint, sampledPoint, sampledPoint) * distanceFromMiddle * 2;
				return color;
			}

			half4 effect8(half2 uv)
			{
				half2 sampleUV = uv;
				sampleUV.x = .5;
				half sampledPoint = tex2D(_MainTex, sampleUV).r * 2;
				half4 noise = tex2D(_Noise, sampleUV);

				half weight1 = .3;
				half weight2 = .55;
				half weight3 = .8;

				half distanceFromMiddle = abs((uv.x * 2) - 1);
				if (distanceFromMiddle < weight1 * sampledPoint)
				{
					distanceFromMiddle = weight1;
				}
				else if (distanceFromMiddle < weight2  * sampledPoint)
				{
					distanceFromMiddle = weight2;
				}
				else if (distanceFromMiddle < weight3  * sampledPoint)
				{
					distanceFromMiddle = weight3;
				}
				else
				{
					distanceFromMiddle = 1;
				}


				half4 color = half4(sampledPoint, sampledPoint, sampledPoint, sampledPoint) * (1 - distanceFromMiddle);
				return color;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				half2 uv = i.uv;
				half stepCount = 30;

				if (_Effect < 1)
				{
					return effect1(uv);
				}
				else if (_Effect < 2)
				{
					return effect3(uv);
				}
				else if (_Effect < 3)
				{
					return effect4(i.uv);
				}
				else if (_Effect < 4)
				{
					return effect5(i.uv);
				}
				else if (_Effect < 5)
				{
					return effect6(uv);
				}
				else if (_Effect < 6)
				{
					return effect7(uv);
				}
				else if (_Effect < 7)
				{
					return effect8(uv);
				}

				return tex2D(_MainTex, uv);
			}
			ENDCG
		}
	}
}
