Shader "Custom/VideoShaderGallowdance"
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
				half4 color = tex2D(_MainTex, uv);
				return color;
			}

			half4 effect1(half2 uv)
			{	
				half4 col = tex2D(_MainTex, uv);
				col *= 5;	
				return col;
			}

			half4 effect2(half2 uv)
			{	
				
				if (uv.x < .2)
				{
					uv.x = .5;
				}
				else if (uv.x > .8)
				{
					uv.x = .55;
				}
				else
				{
					uv.x = uv.x * 2 - 1;
					uv.x /= 5;
					uv.x = (uv.x + 1) / 2;
				}

				if (uv.y > .6)
				{
					uv.y -= .3;
				}

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

				color *= 4;

				return color;
			}

			half4 effect3(half2 uv)
			{	
				uv.x /= 10;

				if (uv.x > .6 || uv.x < .7)
				{
					float value = fmod(uv.x, .1);
					uv.x = .45 + value;
					uv.y += value * uv.x;
				}
				else
				{
					uv.x *= 10;
					uv.y *= .2;
				}

				half2 center = half2(uv.x, .5);
				half dist = abs(uv.y - .5);
				half4 color = tex2D(_MainTex, center);
				half4 orig = tex2D(_MainTex, uv);

				half4 col = color + dist * .4 * fmod(floor(_Time.y), .5);
				half4 col2 = color + dist * .4 * floor(fmod(_Time.x * 5, 1) * 5);

				half step = floor(fmod(_Time.x * 2, 1) + .5);
				color = lerp(col, col2, step);

				if (orig.r < .03)
				{
					color *= -1;
				}
				color = floor(color.r * 40) / 40;
				
				color *= 5;

				return color;
			}

			half4 effect4(half2 uv)
			{	
				half2 tempUV = uv;
				half2 tempUV2 = uv;

				tempUV.y /= 2;
				tempUV.x += .5;
				tempUV2.x = fmod(uv.x * 2, 1);
				tempUV2.x *= 1.5;
				tempUV.x = fmod(tempUV.x * 2, 1);

				half tempY = uv.y;
				half tempX = uv.x;
				half stepVal = uv.y;
				half2 sampleValue = half2(_Time.x + stepVal, _Time.x + stepVal);
				sampleValue *= sin(uv.x) * 10;
				half4 noise = tex2D(_Noise, uv + sampleValue * sin(uv.x * floor(fmod(_Time.y * 10, 1))));
				noise += tex2D(_Noise, half2(floor(_Time.y), 1)) * .2;
				tempX += noise.r * .05;

				half4 col = tex2D(_MainTex, uv);
				half4 col2 = tex2D(_MainTex, tempUV);
				half4 col3 = tex2D(_MainTex, tempUV2);

				if (col.r > .2)
				{
					col.rgb = noise.rgb;
				}

				col += col2;
				col -= col3 * .4;

				return col;
			}

			half4 effect5(half2 uv)
			{	
				half timeX = _Time.x + 300;
				half timeY = _Time.y + 300;
				// -.3 to .3
				half range = lerp(-.4, .5, fmod(floor(timeY * 2) / 10, 1));
				uv.x += range;
				half tempY = uv.y;

				half stepVal = floor(uv.y * 10) / 10;
				half testY = tempY * tempY * tempY * - .2;
				half testX = uv.x + .2;
				if (testY < testX)
				{
					uv.y -= testY * 4 * sin(uv.x * 20 - (uv.y * 10 * timeX * 10));
				}

				half2 center = uv.x * 2 - half2(1,1);
				uv.x = center.x;
				
				uv.x -= uv.y * 2;

				uv.x = (center.x + 1) / 2;

				uv.y += stepVal * uv.x * fmod(timeX * 2, .1) * 10;
				
				half4 col = tex2D(_MainTex, uv);
				col *= 1.5;
				return col;
			}

			half4 effect6(half2 uv)
			{	
				half2 uvTemp = uv;
				uv.x = sin(uv.x * 3);

				half4 col = tex2D(_MainTex, uv);

				half4 col2 = tex2D(_MainTex, uvTemp);

				for (int i = 0; i < 10; i++)
				{
					int mod = i % 2 == 0 ? 1 : -1;
					uvTemp += .01;
					col2 += mod * tex2D(_MainTex, uvTemp);
					col -= mod * tex2D(_MainTex, uvTemp);
				}				
				
				col = lerp(col, col2, uv.x * 5);

				return col;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 color = fixed4(0,0,0,0);
				/*if (_Effect < 1)
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
				}*/

				half effect = fmod(_Time.y * .5, 14);
				half step = fmod(_Time.y * .5, 2);

				if (effect < 2)
				{
					if (step < 1)
					{
						color = effect0(i.uv);
					}
					else
					{
						step = step - 1;
						color = lerp(effect0(i.uv), effect1(i.uv), step);
					}
				}
				else if (effect < 4)
				{
					if (step < 1)
					{
						color = effect1(i.uv);
					}
					else
					{
						step = step - 1;
						color = lerp(effect1(i.uv), effect2(i.uv), step);
					}
				}
				else if (effect < 6)
				{
					if (step < 1)
					{
						color = effect2(i.uv);
					}
					else
					{
						step = step - 1;
						color = lerp(effect2(i.uv), effect3(i.uv), step);
					}
				}
				else if (effect < 8)
				{
					if (step < 1)
					{
						color = effect3(i.uv);
					}
					else
					{
						step = step - 1;
						color = lerp(effect3(i.uv), effect4(i.uv), step);
					}
				}
				else if (effect < 10)
				{
					if (step < 1)
					{
						color = effect4(i.uv);
					}
					else
					{
						step = step - 1;
						color = lerp(effect4(i.uv), effect5(i.uv), step);
					}
				}
				else if (effect < 12)
				{
					if (step < 1)
					{
						color = effect5(i.uv);
					}
					else
					{
						step = step - 1;
						color = lerp(effect5(i.uv), effect6(i.uv), step);
					}
				}
				else
				{
					if (step < 1)
					{
						color = effect6(i.uv);
					}
					else
					{
						step = step - 1;
						color = lerp(effect6(i.uv), effect0(i.uv), step);
					}
				}

				return color;
			}
			ENDCG
		}
	}
}