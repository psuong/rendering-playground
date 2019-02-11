// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TestShaderWithLighting" {

    Properties {
        _tint("Tint", Color) = (1, 1, 1, 1)
        _texture("Albedo", 2D) = "white" {}
        _specular_tint("Specular", Color ) = (0.5, 0.5, 0.5, 0.5)
        _smoothness("Smoothness", Range(0,1)) = 0.5
    }

    SubShader {
        Pass {
            Tags {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            #include "UnityStandardBRDF.cginc"

            float4 _tint;
            sampler2D _texture;
            float4 _texture_ST, _specular_tint;
            float _smoothness;

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
                float3 diffuse = albedo * lightColour * DotClamped(lightDir, i.normal);

                float3 halfVector = normalize(lightDir + viewDir);
                float3 specular = _specular_tint.rgb * lightColour * pow(DotClamped(halfVector, i.normal), _smoothness * 100);
                // float3 reflectionDir = reflect(-lightDir, i.normal);
                return float4(specular, 1);
            }
            ENDCG
        }
    }
}
