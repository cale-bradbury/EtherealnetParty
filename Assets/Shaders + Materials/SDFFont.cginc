
float2 xLine = float2(0., 0.);
uniform float4 _Size;

sampler2D _MainTex;
float4 _MainTex_ST;
uniform float4 _Spacing;
uniform float4 _Font;
uniform float3 _Origin;
uniform float4 _Ray; //x-steps y-escapeDist z-maxRay

struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
};

struct v2f
{
	float2 uv : TEXCOORD0;
	float3 ray:TEXCOORD1;
	UNITY_FOG_COORDS(1)
		float4 vertex : SV_POSITION;
};

v2f rayvert(appdata v)
{
	//v.uv.y -= 1.;
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);// -_Size.xy*2.;
	UNITY_TRANSFER_FOG(o, o.vertex);
	o.ray = normalize(WorldSpaceViewDir(v.vertex)*float3(-1., -1., -1));// float3(o.uv.x, o.uv.y - 1., 1.);
	return o;
}

float fField(float3 p);

float3 dNormal(float3 p)
{
	const float2 e = float2(0.01, 0.0);
	return normalize(float3(
		fField(p + e.xyy) - fField(p - e.xyy),
		fField(p + e.yxy) - fField(p - e.yxy),
		fField(p + e.yyx) - fField(p - e.yyx)));
}


void pR(inout float2 p, float a) {
	p = cos(a)*p + sin(a)*float2(p.y, -p.x);
}

float4 trace(float3 ray_start, float3 ray_dir)
{
	float ray_len = 0.0;
	float3 p = ray_start;
	float closest = 10000000.;
	for (float i = 0.; i<_Ray.x; ++i) {
		float dist = fField(p);
		closest = min(closest, dist);
		if (ray_len > _Ray.z) return float4(0.0, 0., 0., closest);
		p += dist*ray_dir;
		ray_len += dist;
	}
	return float4(p, closest);
}

float4 shade(float3 ray_start, float3 ray_dir)
{
	float4 hit = trace(ray_start, ray_dir);

	float3 light_dir1 = normalize(_WorldSpaceLightPos0.xyz);

	float ray_len;
	float4 color = (1.);
	if (hit.w > .01) {
		ray_len = 1e16;
		color = (0.0);
		color.a = smoothstep(_Font.w,_Font.z, hit.w);
	}
	else {
		float3 dir = hit.xyz - ray_start;
		float3 norm = dNormal(hit.xyz);

		float diffuse = max(0.0, dot(norm, light_dir1));
		diffuse = clamp(diffuse, 0.0, 1.);
		ray_len = distance(hit.xyz, ray_start);

		float3 base_color = (1.);

		color.rgb = max((diffuse)*base_color, (0.)) + .3;
	}
	return color;
}



//font shapes


			float stick(float2 p, float2 a, float2 b)
			{
				float2 pa = p - a;
				float2 ba = b - a;
				float h = saturate(dot(pa, ba) / dot(ba, ba));
				return length(pa - ba * h);
			}
			float circle(float2 uv) {
				return abs(length(uv) - _Size.x);
			}
			float circleS(float2 uv) {
				return abs(length(uv) - _Size.z);
			}
			float vertical(float2 uv) {
				return length(float2(uv.x, max(0., abs(uv.y) - _Size.x)));
			}
			float halfvertical(float2 uv) {
				return length(float2(uv.x, max(0., abs(uv.y) - _Size.z)));
			}
			float hori(float2 uv) {
				uv.x = max(0., abs(uv.x)-_Size.x);
				return length(uv);
			}
			float halfhori(float2 uv) {
				return length(float2(max(0., abs(uv.x) - _Size.z), uv.y));
			}
			float diag(float2 uv) {
				return length(float2(max(0., abs((uv.y - uv.x)) - _Size.x*2.), uv.y + uv.x))*.7;
			}
			float halfdiag(float2 uv) {
				return length(float2(max(0., abs(uv.x - uv.y) - _Size.x), uv.y + uv.x));
			}

			// Here is the alphabet
			float aa(float2 uv) {
				float x = circle(uv);
				x = lerp(x, min(vertical(uv - _Size.xw), vertical(uv + _Size.xw)), step(uv.y, 0.));
				x = min(x, hori(uv - xLine));
				return x;
			}
			float bb(float2 uv) {
				float x = vertical(uv + _Size.xw);
				x = min(x, hori(uv - _Size.wx));
				x = min(x, hori(uv + _Size.wx));
				x = min(x, hori(uv - xLine));
				x = lerp(min(circleS(uv - _Size.zz), circleS(uv - _Size*.5)), x, step(uv.x, .5));
				return x;
			}
			float cc(float2 uv) {
				float x = circle(uv);
				float p = .8;
				float a = atan2(uv.x, abs(uv.y));
				a = smoothstep(.7, 1.5707, a);
				x += a;
				uv.y = -abs(uv.y);
				x = min(length(uv + _Size.x*float2(-cos(p), sin(p))), x);
				return x;
			}
			float dd(float2 uv) {
				float x = vertical(uv + _Size.xw);
				x = min(x, hori(uv + _Size.wx));
				x = min(x, hori(uv - _Size.wx));
				x = lerp(circle(uv), x, step(uv.x, 0.));
				return x;
			}
			float ee(float2 uv) {
				float x = cc(uv);
				x = lerp(circle(uv), x, step(uv.y, 0.));
				x = min(x, hori(uv));
				return x;
			}
			float ff(float2 uv) {
				float x = vertical(uv + _Size.xw);
				x = min(x, hori(uv - _Size.wx));
				x = lerp(circle(uv), x, step(min(-uv.x, uv.y), 0.));
				x = min(x, halfhori(uv + _Size.zw));
				return x;
			}
			float gg(float2 uv) {
				float x = cc(uv);
				x = lerp(x, circle(uv), step(uv.y, 0.));
				x = min(x, halfhori(uv - _Size.zw));
				return x;
			}
			float hh(float2 uv) {
				float x = vertical(abs(uv) - _Size.xw);
				x = min(x, hori(uv));
				//x = min(x, circle(uv+_Size.wx));
				//x = lerp(x, min(length(uv-_Size.xy), length(uv-_Size.yy)), step(uv.y, _Size.y));
				return x;
			}
			float ii(float2 uv) {
				return hh(uv.yx);
			}
			float jj(float2 uv) {
				float x = vertical(uv - _Size.xw);
				x = min(x, length(uv + _Size.xw));
				x = lerp(x, circle(uv), step(uv.y, 0.));
				return x;
			}
			float kk(float2 uv) {
				uv.y = abs(uv.y);
				float x = circle(uv - _Size.wx);
				x = lerp(length(uv - _Size.xx), x, step(uv.y, _Size.x));
				x = lerp(x, min(vertical(uv + _Size.xw), hori(uv)), step(uv.x, 0.));
				return x;
			}
			float ll(float2 uv) {
				return min(vertical(uv + _Size.xw), hori(uv + _Size.wx));
			}
			float mm(float2 uv) {
				uv.x = abs(uv.x);
				float x = vertical(uv - _Size.xw);
				x = min(x, halfvertical(uv - _Size.wz));
				x = lerp(circleS(uv - _Size.zz), x, step(uv.y, 0.5));
				return x;
			}
			float nn(float2 uv) {
				float x = circle(uv);
				x = lerp(min(vertical(uv - _Size.xw), vertical(uv + _Size.xw)), x, clamp(ceil(uv.y), 0., 1.));
				return x;
			}
			float oo(float2 uv) {
				return circle(uv);
			}
			float pp(float2 uv) {
				float x = hori(uv);
				x = min(x, hori(uv - _Size.wx));
				x = lerp(circleS(uv - _Size.zz), x, step(uv.x, _Size.z));
				x = min(x, vertical(uv + _Size.xw));
				return x;
			}
			float qq(float2 uv) {
				float x = circle(uv);
				x = min(x, halfdiag(uv - _Size.xy*.5));
				return x;
			}
			float rr(float2 uv) {
				float x = min(hori(uv - _Size.wx), vertical(uv + _Size.xw));
				x = lerp(x, circle(uv), step(0., min(-uv.x, uv.y)));
				return x;
			}
			float ss(float2 uv) {
				float x = hori(uv - _Size.wx);
				x = min(x, halfhori(uv));
				float2 u = uv;
				u += float2(_Size.z, -_Size.z);
				x = lerp(circleS(u), x, step(-_Size.z, uv.x));

				float x2 = hori(uv + _Size.wx);
				x2 = min(x2, halfhori(uv));
				u = uv;
				u -= float2(_Size.z, -_Size.z);
				x2 = lerp(x2, circleS(u), step(_Size.z, uv.x));

				return min(x, x2);
			}
			float tt(float2 uv) {
				float x = min(vertical(uv), hori(uv - _Size.wx));
				return x;
			}
			float uu(float2 uv) {
				uv.x = abs(uv.x);
				float x = lerp(circle(uv), vertical(uv - _Size.xw), step(0., uv.y));
				return x;
			}
			float vv(float2 uv) {
				uv.y -= .3;
				uv.x = abs(uv.x);
				float p = .5;
				uv = mul(float2x2(cos(p), -sin(p), sin(p), cos(p)), uv);
				float x = vertical(uv - _Size.xw*.6);
				return x;
			}
			float ww(float2 uv) {
				uv.y = -uv.y;
				return mm(uv);
			}
			float xx(float2 uv) {
				return diag(abs(uv)*float2(-1., 1.));
			}
			float yy(float2 uv) {
				uv.x = abs(uv.x);
				float x = min(halfvertical(uv + _Size.wz), circle(uv - _Size.wx));
				x = lerp(x, length(uv - _Size.xx), step(_Size.x, uv.y));
				return x;
			}
			float zz(float2 uv) {
				float x = min(hori(uv - _Size.wx), hori(uv + _Size.wx));
				uv.x = -uv.x;
				return min(x, diag(uv));
			}
			float bracketRight(float2 uv) {
				uv.x -= _Size.x*1.5;
				float p = 1.3;
				uv.y = abs(uv.y);
				float a = atan2(uv.x, uv.y);
				float x = abs(length(uv) - _Size.x*2.);
				uv.y = -uv.y;
				x = lerp(x, length(uv + float2(cos(p), sin(p))*_Size.x*2.), step(-.3, a));
				return x;
			}
			float bracketLeft(float2 uv) {
				uv.x = -uv.x;
				return bracketRight(uv);
			}
			float semicolon(float2 uv) {
				float y = length(uv - _Size.wx);
				uv += float2(_Size.z, _Size.x*.75);
				float x = circleS(uv);
				float z = min(length(uv - _Size.zw), length(uv + _Size.wz));
				x = lerp(z, x, step(max(uv.y, -uv.x), 0.));
				x = min(x, y);
				return x;
			}

			float period(float2 uv) {
				return length(uv + _Size.wx);
			}

			float underscore(float2 uv) {
				uv.y += _Size.x;
				return hori(uv);
			}
			float slash(float2 uv) {
				uv.x = -uv.x;
				return diag(uv);
			}

			float num0(float2 uv) {
				float x = circle(uv);
				x = min(x, diag(uv));
				return x;
			}
			float num1(float2 uv) {
				float x = vertical(uv);
				x = min(x, hori(uv+_Size.wx));
				uv.y -= _Size.x;
				uv.x += _Size.z;
				x = min(x, halfhori(uv));
				return x;
			}
			float num3(float2 uv) {
				uv.xy = uv.yx;
				return mm(uv);
			}
			float num4(float2 uv) {
				float x = hori(uv);
				x = min(x, halfvertical(uv - _Size.yz));
				x = min(x, vertical(uv - _Size.xw));
				return x;
			}
			float num5(float2 uv) {
				float x = hori(uv + _Size.wx);
				x = min(x, hori(uv));
				x = lerp(circleS(uv + _Size.yx*.5), x, step(uv.x, 0.5));
				x = min(x, halfvertical(uv - _Size.yz));
				uv.y += _Size.y;
				x = min(x, hori(uv));
				return x;
			}
			float num2(float2 uv) {
				uv.y = -uv.y;
				return num5(uv);
			}
			float num6(float2 uv) {

				float y = hori(uv - _Size.wx);
				y = min(y, halfvertical(uv + _Size.xw));
				y = lerp(y, circleS(uv + _Size*.5), step(max(uv.x, -uv.y), -.5));
				uv.x = abs(uv.x);
				float x = hori(uv + _Size.wx);
				x = min(x, hori(uv - xLine));
				x = lerp(circleS(uv - _Size*.5), x, step(uv.x, .5));
				return min(x, y);
			}
			float num7(float2 uv) {
				uv.x = -uv.x;
				float x = diag(uv);
				uv.y += _Size.y;
				x = min(x, hori(uv));
				return x;
			}
			float num8(float2 uv) {
				uv.x = abs(uv.x);
				float x = hori(uv - _Size.wx);
				x = min(x, hori(uv + _Size.wx));
				x = min(x, hori(uv - xLine));
				x = lerp(min(circleS(uv - _Size.zz), circleS(uv - _Size*.5)), x, step(uv.x, .5));
				return x;
			}
			float num9(float2 uv) {
				uv = -uv;
				return num6(uv);
			}

			//Make it a bit easier to type text
#define a_ ch(aa);
#define b_ ch(bb);
#define c_ ch(cc);
#define d_ ch(dd);
#define e_ ch(ee);
#define f_ ch(ff);
#define g_ ch(gg);
#define h_ ch(hh);
#define i_ ch(ii);
#define j_ ch(jj);
#define k_ ch(kk);
#define l_ ch(ll);
#define m_ ch(mm);
#define n_ ch(nn);
#define o_ ch(oo);
#define p_ ch(pp);
#define q_ ch(qq);
#define r_ ch(rr);
#define s_ ch(ss);
#define t_ ch(tt);
#define u_ ch(uu);
#define v_ ch(vv);
#define w_ ch(ww);
#define x_ ch(xx);
#define y_ ch(yy);
#define z_ ch(zz);
#define brR ch(bracketRight);
#define brL ch(bracketLeft);
#define sc ch(semicolon);
#define un ch(underscore);
#define sl ch(slash);
#define pr ch(period);
#define n0 ch(num0);
#define n1 ch(num1);
#define n2 ch(num2);
#define n3 ch(num3);
#define n4 ch(num4);
#define n5 ch(num5);
#define n6 ch(num6);
#define n7 ch(num7);
#define n8 ch(num8);
#define n9 ch(num9);

			//Space
#define _ nr--;
			//Space
#define _half nr-=.5;

			//Next line
#define crlf uv.y += _Spacing.w; nr = 0.;

			//Render char if it's up
#define ch(l)  x=min(x,l(uv+float2(_Spacing.x*nr, 0.)));nr-=_Size.x;