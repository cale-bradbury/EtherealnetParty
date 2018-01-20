Shader "Unlit/Tube"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Shape("Shape", Vector) = (0,0,0,0)
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
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			float4 _Shape;

			static const float3 c1 = float3(.05, .03, .0);
			static const float3 c2 = float3(1., 1., .95);
			static const float3 c3 = float3(0., .9, 1.);
			static const float3 c4 = float3(0., 1., 0.3);

			static const float2 resolution = float2(1., 1.);

			static const float4 size = float4(1., .5, .3, .15);
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			

			float sdSphere(float3 p, float s)
			{
				return length(p) - s;
			}

			float sdBox(float3 p, float3 b)
			{
				float3 d = abs(p) - b;
				return min(max(d.x, max(d.y, d.z)), 0.0) +
					length(max(d, 0.0));
			}

			float sdCylinder(float3 p, float2 h)
			{
				float2 d = abs(float2(length(p.xz), p.y)) - h;
				return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
			}

			float sdPlane(float3 p)
			{
				return p.y;
			}

			float2 opU(float2 d1, float2 d2)
			{
				return (d1.x<d2.x) ? d1 : d2;
			}

			float2 opS(float2 d1, float2 d2)
			{
				return ((-d2.x>d1.x)) ? d2 : d1;
			}
			float opS(float d1, float d2)
			{
				return max(-d2, d1);
			}

			float mic(float2 p) {
				p *= _MainTex_ST.xy;
				p += _MainTex_ST.zw;
				p = abs(fmod(p + 100., 2.) - 1.);
				p.x = pow(p.x, 2.);
				float3 v = float3(_MainTex_TexelSize.x, _MainTex_TexelSize.y, 0)*1.5;
				float f = tex2D(_MainTex, p);
				float f1 = tex2D(_MainTex, p + v.xz);
				float f2 = tex2D(_MainTex, p - v.xz);
				float f3 = tex2D(_MainTex, p + v.zy);
				float f4 = tex2D(_MainTex, p - v.zy);
				return lerp(f, (f1 + f2 + f3 + f4)*.25, .5);
			}

			float2 tunnel(in float3 pos, in float2 res) {
				float t = _Time.y*1.5707;
				pos -= float3(size.x, size.x, 0.);
				pos.x = pos.x + cos(pos.z*5.-t)*size.w + pos.z*.1+.1;
				float q = mic(pos.xz);
				pos.y *= 1. + q*_Shape.y;
				//pos.z += t;
				float c = abs(fmod(pos.x + size.w+ size.z*200., size.z*2.) - size.z) / size.w;
				c = floor(c*2.);
				pos.x = abs(fmod(pos.x+ size.z*200., size.z) - size.w);

				float2 g = float2(sdBox(float3(pos.x, pos.y, 0.), float3(size.w*.4 + sin(pos.z*10. )*size.w*.1-q*_Shape.x, size.w, size.x)), 1.);

				float2 f = float2(sdBox(float3(pos.x, pos.y, 0.), float3(size.w*.3, sin(pos.z*5. )*size.w*.5 + size.w*1.5, size.x)), 2.5 + sin(pos.z + pos.x + c*3.14-t)*.49);
				
				res = opU(res, g);
				res = opU(res, f);

				//pos.z = fmod(pos.z+size.y*200., size.y);
				//res = opU(res, float2(sdSphere(pos + float3(0., size.z, 0.), sin(_Time.y*.5)*size.w*.5 + size.w*.5), sin(_Time.y)*.9 + 3.));
				return res;
			}

			float2 map(in float3 pos) {
				pos.xy = float2(atan2(pos.y, -pos.x)*0.625, length(pos.xy));

				float3 ipos = float3(0., pos.y, 0.);
				float2 res = float2(sdBox(ipos, size.xxx*2.), 0.);
				res.x = opS(res.x, sdBox(ipos, size.xxx));

				return tunnel(pos, res);
			}

			float2 castRay(in float3 ro, in float3 rd)
			{
				float tmin = .1;
				float tmax = 100.0;

				float t = tmin;
				float m = -1.0;
				for (int i = 0; i<128; i++)
				{
					float2 res = map(ro + rd*t);
					//if(  t>tmax ) break;
					t += res.x;
					m = res.y;
				}

				if (t>tmax) m = -1.0;
				return float2(t, m);
			}

			float3 palette(in float t, in float3 a, in float3 b, in float3 c, in float3 d)
			{
				return lerp(lerp(a, b, t), lerp(c, d, t - 2.), floor(t*.5));
			}

			float3 calcNormal(in float3 pos) {
				float3 eps = float3(0.00001, 0.0, 0.);
				float3 nor = float3(
					map(pos + eps.xyy).x - map(pos - eps.xyy).x,
					map(pos + eps.yxy).x - map(pos - eps.yxy).x,
					map(pos + eps.yyx).x - map(pos - eps.yyx).x);
				return normalize(nor);
			}

			float calcAO(in float3 pos, in float3 nor)
			{
				float occ = 0.0;
				float sca = 1.0;
				for (int i = 0; i<10; i++) {
					float hr = 0.01 + 0.006*float(i);
					float3 aopos = nor * hr + pos;
					float dd = map(aopos).x;
					occ += -(dd - hr)*sca;
					sca *= 0.6;
				}
				return clamp(1.0 - 3.0*occ, 0.0, 1.0);
			}

			float3 render(in float3 ro, in float3 rd)
			{
				float3 col = (1.0);
				float2 res = castRay(ro, rd);
				float3 pos = ro + res.x*rd;
				float3 nor = calcNormal(pos);
				float ao = pow(calcAO(pos, nor), 2.);

				col = palette(res.y, c1, c2, c3, c4);
				col = col*ao;
				col = lerp(col, c1, clamp(smoothstep(0.5, 2., res.x), 0., 1.));//*.85;
				return float3(clamp(col, 0.0, 1.0));
			}
			float3x3 setCamera(in float3 ro, in float3 ta, float cr)
			{
				float3 cw = normalize(ta - ro);
				float3 cp = float3(sin(cr), cos(cr), 0.0);
				float3 cu = normalize(cross(cw, cp));
				float3 cv = normalize(cross(cu, cw));
				return float3x3(cu, cv, cw);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 q = i.uv;
				float2 p = float2(q.x, -1.0 + 2.0*q.y);
				p.x = abs(p.x);
				//p.x /= 1.0 + resolution.x / resolution.y;

				float3 ro = float3(0., 0., 0.);// +_Time.y*.5);
				float3 ta = ro + float3(0., 0., 1.);
				float3x3 ca = setCamera(ro, ta, 0.0);

				float warp = .666;
				float fov = 70.0;
				float rayZ = tan((90. - 0.5 * fov) * 0.01745329252);
				float3 rd = mul(ca, normalize(float3(p.x, p.y, -rayZ)));
				rd = float3(rd.xy, sqrt(1.0 - warp * warp) * (rd.z + warp));
				rd = normalize(rd);

				float3 col = render(ro, rd);

				return  float4(col, 1.0);
			}
			ENDCG
		}
	}
}
