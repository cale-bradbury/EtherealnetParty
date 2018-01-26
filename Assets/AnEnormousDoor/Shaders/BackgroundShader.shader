Shader "Unlit/BackgroundShader"
{
	Properties
	{
		_Noise("Texture", 2D) = "white" {}
		_Effect("Effect", Range(0,11)) = 0
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
			float4 _Noise_ST;
			half _Effect;
			half _Curve;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _Noise);
				return o;
			}

			// Done
			half4 effect1(half2 uv)
			{
				uv.x += uv.y % .1 * 10 * sin(floor(_Time.y * 5));
				fixed4 col = half4(1, 1, 1, 1);
				float value = floor(uv.x % .2 * 10);
				col.x = value;
				col.y = 1 - value;
				col.z = 1 - value;
				return col;
			}
			
			// Done
			half4 effect2(half2 uv)
			{
				fixed4 col = half4(1, 1, 1, 1);
				uv.x += floor(fmod(_Time.y * 10, 12));
				uv.x += floor(fmod(uv.y * 5, 5)) * floor(fmod(_Time.y * 10, 12.5));
				float value = saturate(sin(uv.x * 100));

				col.x = value;
				col.y = 1 - value;
				col.z = 1 - value;
				
				return col;
			}

			// Done
			half4 effect3(half2 uv)
			{
				half2 value = uv * 2 - half2(1, 1);
				// -3.5 to 2
				half cap = 3.5;
				half step = fmod(_Time.y * 1.5, 2 + cap) - cap;
				value += normalize(value) * step;
					
				fixed4 col = half4(1, 1, 1, 1);

				half fill = distance(value, half2(0, 0));
				col.x = fill;
				col.y = 1 - fill;
				col.z = 1 - fill;
				
				return col;
			}

			// Done
			half4 effect4(half2 uv)
			{
				half frequency = 5;
				half2 center = half2(0, 0);
				center.x = floor((uv.x) * frequency) / frequency + .01 * frequency;
				center.y = floor((uv.y) * frequency) / frequency + .01 * frequency;

				uv -= half2(.01 * frequency, .01 * frequency);
				fixed4 col = half4(1, 1, 1, 1);


				half offset = center.x + center.y + sin(center.x) - cos(center.y);
				half step = lerp(30, 50, floor(fmod(_Time.y + offset, 1) * 6) / 6);
				half fill = distance(center, uv) * step;
				col.x = fill;
				col.y = 0;
				col.z = 0;


				return col;
			}

			// Done
			half4 effect5(half2 uv)
			{
				half timeStep = floor(_Time.x);
				half4 noise = tex2D(_Noise, half2(sin(uv.x), uv.y + timeStep));

				half2 center = half2(0, 0);
				uv.x = (uv.x * 2) - 1;
				uv.y = (uv.y * 2) - 1;

				fixed4 col = half4(1, 1, 1, 1);

				half step = lerp(30, 50, floor(fmod(_Time.y * noise.y, 1) * 6) / 6);
				half fill = distance(center, uv) * step * .055;
				half fillStep = lerp(0, 1 - fill, floor(fmod(_Time.x * 10, 1) * 12) / 12 / 1);
				col.x = fill;
				col.y = fillStep;
				col.z = fillStep;


				return col;
			}
			
			// Done
			half4 effect6(half2 uv)
			{
				half timeStep = floor(_Time.x);
				uv /= 5;

				half4 noise = tex2D(_Noise, half2(sin(uv.x), uv.y + timeStep));

				half2 center = half2(0, 0);
				uv.x = (uv.x * 2) - 1;
				uv.y = (uv.y * 2) - 1;

				fixed4 col = half4(1, 1, 1, 1);

				half step = lerp(30, 50, floor(fmod(_Time.y * noise.y, 1) * 6) / 6);
				half fill = distance(center, uv) * step * .055;
				half fillStep = lerp(0, 1 - fill, 1);
				col.x = fill * .5;
				col.y = fillStep * .5;
				col.z = fillStep * .5;


				return col;
			}

			// Improve
			half4 effect7(half2 uv)
			{
				half2 originalUV = uv + half2(1, 1);
				originalUV = half2(originalUV.x / 2, originalUV.y / 2);
				half4 noise = tex2D(_Noise, half2(sin(uv.x), sin(uv.y + _Time.x)));

				half2 center = half2(0, 0);
				uv.x = (uv.x * 2) - 1;
				uv.y = (uv.y * 2) - 1;

				fixed4 col = half4(1, 1, 1, 1);

				half step = lerp(10, 2, floor(fmod(_Time.x * 5 + noise.y, 1) * 6) / 6);
				half fill = 0;

				half xThreshold = 1 - (originalUV.y) + .2;
				if (abs(uv.x) < xThreshold && abs(uv.y) < .7)
				{
					fill = 1;
				}
				
				col.x = fill;
				col.y = fill;
				col.z = fill;

				col *= step;

				return col;
			}

			// Done
			half4 effect8(half2 uv)
			{
				half timeStep = floor(fmod(_Time.y * 4, 6));
				half4 noise = tex2D(_Noise, half2(uv.x, uv.y));

				half2 center = half2(0, 0);
				uv.x = (uv.x * 2) - 1;
				uv.y = (uv.y * 2) - 1;

				fixed4 col = half4(1, 1, 1, 1);
				half2 test = half2(1, 0);

				half theta = 20;
				half cs = cos(theta);
				half sn = sin(theta);
				uv.x = uv.x * cs - uv.y * sn;
				uv.y = uv.x * sn + uv.y * cs;

				half angle = acos(dot(uv, test) / (length(uv) * length(test))) * 57.2958;

				half divisions = 360 / 80;

				half dist = distance(center, uv);
				half step = fmod(angle + timeStep * 10, divisions) / divisions;
				half fill = dist * lerp(1.25, .25, timeStep / 6);

				if (fmod(step, 40) < .5)
				{
					fill = 0;
				}

				col.x = fill;
				col.y = 0;
				col.z = 0;

				return fill;
			}

			// Done
			half4 effect9(half2 uv)
			{
				half timeStep = floor(fmod(_Time.y, 1) * 6) / 6;

				half frequency = 5;
				half2 center = half2(0, 0);
				uv.x = (uv.x * 2) - 1;
				uv.y = (uv.y * 2) - 1;

				uv -= half2(.01 * frequency, .01 * frequency);
				fixed4 col = half4(1, 1, 1, 1);

				half step = 2;
				half fill = distance(center, uv) * step;

				fill = min(abs(uv.x), lerp(.2, .3, timeStep));
				fill = min(abs(uv.y), fill);
				fill *= lerp(2, 12, timeStep) * 2;

				col.x = fill;
				col.y = 0;
				col.z = 0;


				return col;
			}

			// Done
			half4 effect10(half2 uv)
			{
				half timeStep = floor(fmod(_Time.y * 4, 6));
				half4 noise = tex2D(_Noise, half2(uv.x, uv.y));

				half2 center = half2(0, 0);
				uv.x = (uv.x * 2) - 1;
				uv.y = (uv.y * 2) - 1;

				half dist = distance(center, uv);

				fixed4 col = half4(1, 1, 1, 1);
				half2 test = half2(1, 0);

				half theta = fmod(dist + noise.x * fmod(_Time.x * 10, 1) * .1, .2);
				half cs = cos(theta);
				half sn = sin(theta);
				half x = 0;
				half y = 0;
				x = uv.x * cs - uv.y * sn;
				y = uv.x * sn + uv.y * cs;

				uv = half2(x, y);

				half angle = acos(dot(uv, test) / (length(uv) * length(test))) * 57.2958;

				half divisions = 360 / 20;
				half step = fmod(angle + timeStep * 10, divisions) / divisions;
				half fill = dist * lerp(1.25, .7, timeStep / 6);

				if (fmod(step, 40) < .5)
				{
					fill = 0;
				}

				col.x = fill;
				col.y = 0;
				col.z = 0;

				return fill;
			}

			// Done, works with inverted colours and more objects
			half4 effect11(half2 uv)
			{
				half2 originalUV = uv + half2(1, 1);
				originalUV = half2(originalUV.x / 2, originalUV.y / 2);

				half2 center = half2(-.15, .8);
				uv.x = (uv.x * 2) - 1;
				uv.y = (uv.y * 2) - 1;

				fixed4 col = half4(1, 1, 1, 1);

				half fill = distance(uv, center) * 5.5;

				col.x = fill;
				col.y = 0;
				col.z = 0;

				return col;
			}

			half4 effect12(half2 uv)
			{
				half slices = 5;
				uv *= slices;

				half time = (_Time.y + _Curve);
				half colourBoost = lerp(3, 5, fmod(floor(time), 4) / 4.0);

				

				half2 chunk = half2(floor(uv.x), floor(uv.y));
				half2 chunkCenter = chunk + half2(.5, .5);

				fixed4 col = half4(1, 1, 1, 1);

				half fill = max(distance(abs(uv.x), chunkCenter.x), distance(abs(uv.y), chunkCenter.y)) * colourBoost;

				col.x = fill;
				col.y = 0;
				col.z = 0;

				return col;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				if (_Effect < 1)
				{
					return effect1(i.uv);
				}
				else if (_Effect < 2)
				{
					return effect2(i.uv);
				}
				else if (_Effect < 3)
				{
					return effect3(i.uv);
				}
				else if (_Effect < 4)
				{
					return effect4(i.uv);
				}
				else if (_Effect < 5)
				{
					return effect5(i.uv);
				}
				else if (_Effect < 6)
				{
					return effect6(i.uv);
				}
				else if (_Effect < 7)
				{
					return effect7(i.uv);
				}
				else if(_Effect < 8)
				{
					return effect8(i.uv);
				}
				else if (_Effect < 9)
				{
					return effect9(i.uv);
				}
				else if (_Effect < 9)
				{
					return effect10(i.uv);
				}
				else if (_Effect < 10)
				{
					return effect11(i.uv);
				}
				else
				{
					return effect12(i.uv);
				}
				
			}
			ENDCG
		}
	}
}