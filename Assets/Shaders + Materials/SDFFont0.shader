// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: commented out 'float3 _WorldSpaceCameraPos', a built-in variable

Shader "Font/SDFFont0"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Size("Size", Vector) = (1., -1., 1., 0.)
			_Spacing("Spacing", Vector) = (3., 2.25, 1.5, 3.5)
			_Ray("Ray x-steps y-escapeDist z-maxRay", Vector) = (32., .0001, 400., 0.)
			_Font("Font x-Width", Vector) = (.3, 0., 0., 0.)
			_Origin("Origin", Vector)=(0,0,0,0)
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex rayvert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "SDFFont.cginc"

#define line0 a_ u_ d_ i_ o_ crlf crlf
#define line1 t_ w_ i_ l_ i_ g_ h_ t_ _ e_ x_ p_ r_ e_ s_ s_ crlf
#define line2 c_ o_ s_ brR m_ o_ s_ brL sc crlf
#define line3 c_ o_ m_ m_ o_ d_ i_ f_ i_ e_ r_ crlf

			float fField(float3 p) {
				float f = sin(_Time.y*3.1415 + length(p.xy))*_Font.y;
				p -= _Origin.xyz;
				float3 pos = p;
				float x = 100.;
				float nr = 0.;
				float2 uv = pos.xy;
				float width = _Font.x;
				line0;
				line1;
				line2;
				line3;
				width += f;
				x = length(float2(x, pos.z));
				x -= width;
				return x;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//_WorldSpaceCameraPos.x -= _Spacing.x;
				//_WorldSpaceCameraPos.y += _Spacing.x;
				float3 dir = normalize(i.ray);// float3(uv.x, uv.y, 1.));


				_Spacing.y = _Spacing.x*.5;
				_Spacing.z = 1. / _Spacing.x;

				float4 color = shade(_WorldSpaceCameraPos.xyz, dir);
				//color = sin(fField(float3(uv.x, uv.y, 0))*20.);
				return color;
			}



			ENDCG
		}
	}
}
