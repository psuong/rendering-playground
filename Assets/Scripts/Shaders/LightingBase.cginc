#if !defined(MY_LIGHTING_INCLUDED)
#define MY_LIGHTING_INCLUDED
#include "UnityPBSLighting.cginc"
#endif

float4 _tint;
sampler2D _texture;
float4 _texture_ST, _specular_tint;
float _smoothness, _metallic;

struct Interpolators {
    float4 position : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
    float4 worldPos : TEXCOORD2;
};

struct VertexData {
    float4 position : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

// Output the position of the vertex, where the SV_POSITION stands for SYSTEM VALUE
Interpolators MyVertexProgram(VertexData v) {
    Interpolators i;
    i.position = UnityObjectToClipPos(v.position);
    i.worldPos = mul(unity_ObjectToWorld, v.position);
    i.normal = mul(transpose((float3x3)unity_ObjectToWorld), float4(v.normal, 0));
    i.normal = UnityObjectToWorldNormal(v.normal);
    i.uv = TRANSFORM_TEX(v.uv, _texture);
    return i;
}

// Shader is an opaque shader
// Vertex Shader -> Fragment Shader
float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
    i.normal = normalize(i.normal);
    // What does saturate do?
    // Clamps between 0 and 1
    float3 lightDir = _WorldSpaceLightPos0.xyz;
    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
    float3 lightColour = _LightColor0.rgb;
    float3 albedo = tex2D(_texture, i.uv).rgb * _tint.rgb;

    float3 specularTint = albedo * _metallic;
    float oneMinusReflectivity = 1 - _metallic;

    // Instead use the standard function which computes the albedo via Diffuse and Metallic properties
    albedo = DiffuseAndSpecularFromMetallic(albedo, _metallic, specularTint, oneMinusReflectivity);

    UnityLight light;
    light.color = lightColour;
    light.dir = lightDir;
    light.ndotl = DotClamped(i.normal, lightDir);

    // Setting these to black for the time being...
    UnityIndirect indirectLight;
    indirectLight.diffuse = 0;
    indirectLight.specular = 0;

    // Use PBR instead!
    return UNITY_BRDF_PBS(
        albedo, specularTint,
        oneMinusReflectivity, _smoothness,
        i.normal, viewDir,
        light, indirectLight
    );
}