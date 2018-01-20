// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: commented out 'float3 _WorldSpaceCameraPos', a built-in variable

Shader "Font/SDFFont2"
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
			
#define line0 e_ t_ h_ e_ r_ e_ a_ l_ n_ e_ t_ crlf
#define line1 c_ o_ s_ brR m_ o_ s_ brL sc _  d_ e_ b_ u_ t_ _ a_ l_ b_ u_ m_ _ r_ e_ l_ e_ a_ s_ e_ crlf crlf
#define line2 j_ a_ n_ _ n2 n6 crlf n7 _ t_ o_ _ n9 _ s_ h_ a_ r_ p_ crlf
#define line3 n_ o_ r_ t_ h_ _ e_ n_ d_ _ l_ i_ b_ r_ a_ r_ y_ _ g_ a_ r_ a_ g_ e_ sl s_ t_ r_ e_ a_ m_ crlf b_ y_ _ d_ o_ n_ a_ t_ i_ o_ n_

			//e_ t_ h_ e_ r_ e_ a_ l_ n_ e_ t_
			
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
