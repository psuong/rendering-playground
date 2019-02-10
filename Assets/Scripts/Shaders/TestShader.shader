// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TestShader" {

    Properties {
        _tint("Tint", Color) = (1, 1, 1, 1)
        _texture("Texture", 2D) = "white" {}
    }

    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            #include "UnityCG.cginc"

            float4 _tint;
            sampler2D _texture;
            float4 _texture_ST;

            struct Interpolators {
                float4 position : SV_POSITION;
                // float3 localPosition : TEXCOORD0; // FOR REFERENCE ONLY!!!
                float2 uv : TEXCOORD0;
            };

            struct VertexData {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            // Output the position of the vertex, where the SV_POSITION stands for SYSTEM VALUE
            Interpolators MyVertexProgram(VertexData v) {
                Interpolators i;
                // i.localPosition = v.position.xyz; // FOR REFERENCE ONLY!!!
                i.position = UnityObjectToClipPos(v.position);
                i.uv = TRANSFORM_TEX(v.uv, _texture);
                return i;
            }

            // Shader is an opaque shader
            // Vertex Shader -> Fragment Shader
            float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
                // Move to the object space to a range of 0, 1 as negative values are clamped to 0
                // making the sphere dark.
                // return float4(i.localPosition + 0.5, 1) * _tint;
                // return float4(i.uv, 1, 1);
                return tex2D(_texture, i.uv) * _tint;
            }
            ENDCG
        }
    }
}
