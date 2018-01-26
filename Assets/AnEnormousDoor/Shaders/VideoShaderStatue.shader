Shader "Custom/VideoShaderStatue"
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
				col *= 5;	
				return col;
			}

			half4 effect1(half2 uv)
			{	
				half2 center = half2(.5, uv.y);
				half dist = abs(uv.x - .5);
				half4 color = tex2D(_MainTex, center);
				half4 orig = tex2D(_MainTex, uv);

				color += dist * .4;

				color = lerp(color, orig, fmod(floor(_Time.y * 5) / 5, 1));
				if (orig.r < .03)
				{
					color = orig.r;
					//color *= -1;
				}
				color = floor(color.r * 10) / 10;
				
				color *= 5;

				return color;
			}

			half4 effect2(half2 uv)
			{	
				half2 center = half2(.5, uv.y);
				half dist = abs(uv.x - .5);
				half4 color = tex2D(_MainTex, center);
				half4 orig = tex2D(_MainTex, uv);

				color += dist * .4;

				if (orig.r < .03)
				{
					color *= -1;
				}
				color = floor(color.r * 40) / 40;
				
				color *= 5;

				return color;
			}

			half4 effect3(half2 uv)
			{	
				half2 newUV = half2(.5, fmod(uv.y, .1));
				half sampleX = uv.x + fmod(uv.y, .1);
				half sampleY = uv.y;
				if (fmod(sampleY, .2) < .1)
				{
					sampleY = .7;
				}
				if (fmod(sampleX, .2) < .1)
				{
					sampleX = .7;
				}
				half4 noise = tex2D(_Noise, half2(fmod(sampleX, .5), fmod(sampleY * 10, .1)));
				
				half4 orig = tex2D(_MainTex, uv);
				if (orig.r < .04)
				{
					newUV += noise.xy;
				}

				half4 color = tex2D(_MainTex, newUV);
				color = floor(color.r * 40) / 40;

				if (color.r > .2)
				{
					color = lerp(color, orig, floor(uv.x * 10));
					color *= 2;
				}
				else
				{
					color *= 5;	
				}

				color *= 2;

				return color;
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
				fixed4 color = fixed4(0,0,0,0);
				if (_Effect < 1)
				{
					color = effect0(i.uv);
				}
				else if (_Effect < 2)
				{
					color = effect1(i.uv);
				}
				else if (_Effect < 3)
				{
					color = effect2(i.uv);
				}
				else if (_Effect < 4)
				{
					color = effect3(i.uv);
				}
				else if (_Effect < 5)
				{
					color = effect4(i.uv);
				}
				else if (_Effect < 6)
				{
					color = effect5(i.uv);
				}
				else
				{
					color = effect6(i.uv);
				}
				return color;
			}
			ENDCG
		}
	}
}