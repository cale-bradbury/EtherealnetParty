Shader "Custom/VideoShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Noise("Texture", 2D) = "white" {}
		_Effect("Effect", Range(0,6)) = 0
		_Curve("Curve", Float) = 0
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
				float4 vertex : SV_POSITION;
			};

			sampler2D _Noise;
			sampler2D _MainTex;
			float4 _Noise_ST;
			sampler2D _MainTex_ST;
			half _Effect;
			half _Curve;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _Noise);
				return o;
			}

			half4 effect0(half2 uv)
			{	
				half4 col = tex2D(_MainTex, uv);
				return col;
			}

			half4 effect1(half2 uv)
			{	
				half tempY = uv.y;
				half tempX = uv.x;
				half stepVal = floor(uv.y * 10) / 10;

				half2 sampleValue = half2(_Time.x + stepVal, _Time.x + stepVal);
				half4 noise = tex2D(_Noise, uv + sampleValue);
				tempX += floor(noise.r * .05 * 1000) / 1000;

				half testY = tempY * tempY * tempY * tempY + .1;
				half testX = tempX * tempX * tempX * tempX;

				half2 noise2 = half2(floor(noise.r * 10), floor(noise.g * 10));
				half4 secondTex = tex2D(_MainTex, noise2);
				half sample2 = 0;

				if (testY < tempX && testX < tempY)
				{
					sample2 = floor(uv.x * 10) / 10;	
				}
				else
				{
					uv.x -= .15;
					half originalX = uv.x;
					uv.x += fmod(uv.y, .1);

					uv.x = lerp(originalX, uv.x, fmod(_Time.x * 5 + floor(uv.y * 10) / 10, 1));
					uv.y = fmod(uv.y, .1) + .9;
				}
				
				half4 col = lerp(tex2D(_MainTex, uv), secondTex, sample2);
				return col;
			}

			half4 effect2(half2 uv)
			{	
				half tempX = uv.x;

				half stepVal = floor(uv.y * 10) / 10;
				half2 sampleValue = half2(_Time.x + stepVal, _Time.x + stepVal);
				half4 noise = tex2D(_Noise, uv + sampleValue);
				tempX += noise.r * .05;

				half testX = tempX * tempX * tempX * tempX + .2;

				testX += sin(uv.y);

				uv.x = lerp(uv.x - .3 + sin(uv.y * 6), uv.x, saturate((uv.x / .45)));
				uv.x += .2;

				if (testX > uv.y + .2)
				{
					uv.x -= .5;
					uv.x = floor(uv.x * 100) / 100;
					uv.y = floor(uv.y * 100) / 100;
				}
				half4 col = tex2D(_MainTex, uv);
				return col;
			}

			half4 effect3(half2 uv)
			{	
				half tempX = uv.x;

				half stepVal = floor(uv.y * 10) / 10;
				half2 sampleValue = half2(_Time.x + stepVal, _Time.x + stepVal);
				half4 noise = tex2D(_Noise, uv + sampleValue);
				tempX += noise.r * .05;

				half testX = tempX * tempX * tempX + .2;

				testX += sin(uv.y * 2);

				
				uv.x = lerp(uv.x, uv.x - .3 + sin(uv.y * 8), 1 - (uv.x / .5));
				uv.x += .25;

				if (testX > uv.y + .2)
				{
					uv.x -= .5;
					uv.x = floor(uv.x * 100) / 100;
					uv.y = floor(uv.y * 100) / 100;
				}
				half4 col = tex2D(_MainTex, uv);
				return col;
			}

			half4 effect4(half2 uv)
			{	
				half tempY = uv.y;
				half tempX = uv.x;
				half stepVal = floor(uv.y * 10) / 10;
				half testY = tempY * tempY * tempY * tempY + .2;
				half2 sampleValue = half2(_Time.x + stepVal, _Time.x + stepVal);
				half4 noise = tex2D(_Noise, uv + sampleValue);
				tempX += noise.r * .05;

				half testX = tempX * tempX * tempX * tempX + .2;

				if (testY > testX)
				{
					half2 dist = half2(testX - testY, testY - testX);
				}
				else
				{
					uv.x = fmod(uv.x, .25);
					uv.y = fmod(uv.y, .1) + .9;
				}
				
				half4 col = tex2D(_MainTex, uv);
				return col;
			}

			half4 effect5(half2 uv)
			{	
				half tempY =uv.y;

				half stepVal = floor(uv.y * 10) / 10;
				half testY = tempY * tempY * tempY * tempY - .2;
				half testX = uv.x + .2;
				if (testY < testX)
				{
					uv.y -= testY * 2;
				}
				
				half4 col = tex2D(_MainTex, uv);
				return col;
			}

			half4 effect6(half2 uv)
			{	
				half tempX = uv.x;

				half stepVal = floor(uv.y * 10) / 10;
				half2 sampleValue = half2(_Time.x + stepVal, _Time.x + stepVal);
				half4 noise = tex2D(_Noise, uv + sampleValue);

				half sampleStep = 100;
				half2 sample2 = half2(floor(uv.y * sampleStep) / sampleStep, floor(uv.y * sampleStep) / sampleStep);
				half4 noise2 = tex2D(_Noise, sample2);
				
				half testX = tempX * tempX * tempX + .2;
				half timeStep = lerp(1, 1.5, fmod(floor(_Time.y * 10) / 10 + sample2.r * 10, 1));
				testX += floor(uv.y * 100) / 100 * noise2.r * timeStep;

				if (testX > uv.y + .2)
				{
					half y = uv.y;
					uv.y = uv.x;
					uv.x = y;
					uv.x -= .1;
					uv.x = floor(uv.x * 100) / 100;
					uv.y = floor(uv.y * 100) / 100;
				}
				half4 col = tex2D(_MainTex, uv);
				return col;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				if (_Effect < 1)
				{
					return effect0(i.uv);
				}
				else if (_Effect < 2)
				{
					return effect1(i.uv);
				}
				else if (_Effect < 3)
				{
					return effect2(i.uv);
				}
				else if (_Effect < 4)
				{
					return effect3(i.uv);
				}
				else if (_Effect < 5)
				{
					return effect4(i.uv);
				}
				else if (_Effect < 6)
				{
					return effect5(i.uv);
				}
				else
				{
					return effect6(i.uv);
				}
			}
			ENDCG
		}
	}
}