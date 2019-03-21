// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#if !defined(MY_SHADOWS_INCLUDED)
#define MY_SHADOWS_INCLUDED

#include "UnityCG.cginc"

// We need the normal to allow normal bias.
struct VertexData {
	float4 position : POSITION;
	float3 normal : NORMAL;
};

/*
 * UnityApplyLinearShadowBias increases the Z coordinate in clip space.
 * UnityClipSpaceShadowCasterPos converts the position to world space,
 * applies the normal bias, then converts to clip space.
 */
float4 MyShadowVertexProgram (VertexData v) : SV_POSITION {
	float4 position = UnityClipSpaceShadowCasterPos(v.position.xyz, v.normal);
	return UnityApplyLinearShadowBias(position);
}

half4 MyShadowFragmentProgram () : SV_TARGET {
	return 0;
}

#endif
