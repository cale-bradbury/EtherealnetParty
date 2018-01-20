Shader "Camp Cult/Color/FFT Tint" {
Properties {
	_MainTex("MainTex", 2D) = "white" {} 
	_Shape("Shape", Vector) = (0,0,0,0)
}
SubShader{
	Pass{
	ZTest Always Cull Off ZWrite Off
	Fog{ Mode off }
CGPROGRAM
#include "UnityCG.cginc"
#pragma vertex vert_img
#pragma fragment frag

uniform float4 _Shape;
uniform sampler2D _AudioTex;
uniform sampler2D _MainTex;
uniform float4 _MainTex_TexelSize;

fixed4 frag(v2f_img i) : COLOR
{
	float4 c = tex2D(_MainTex, i.uv);
	float f = tex2D(_AudioTex, float2(saturate(length(c.rgb)*.666), 0.)).r;
	
	c.rgb += float3(f,f,f)*_Shape.x;
	c.rgb = fmod(c.rgb+1., float3(1., 1., 1.));
	return  c;
}
ENDCG
}
}
FallBack "Unlit"
}
