// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TestShaderSplatting" {

    Properties {
        _texture("Splat Map", 2D) = "white" {}
        [NoScaleOffset] _texture1("Texture 1", 2D) = "white" {}
        [NoScaleOffset] _texture2("Texture 2", 2D) = "white" {}
        [NoScaleOffset] _texture3("Texture 1", 2D) = "white" {}
        [NoScaleOffset] _texture4("Texture 2", 2D) = "white" {}
    }

    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            #include "UnityCG.cginc"

            sampler2D _texture;
            float4 _texture_ST;
            sampler2D _texture1, _texture2, _texture3, _texture4;

            struct Interpolators {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uvSplat : TEXCOORD1;
            };

            struct VertexData {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            // Output the position of the vertex, where the SV_POSITION stands for SYSTEM VALUE
            Interpolators MyVertexProgram(VertexData v) {
                Interpolators i;
                i.position = UnityObjectToClipPos(v.position);
                i.uv = TRANSFORM_TEX(v.uv, _texture);
                i.uvSplat = v.uv;
                return i;
            }

            // Shader is an opaque shader
            // Vertex Shader -> Fragment Shader
            float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
                float4 splat = tex2D(_texture, i.uvSplat);
                return 
                    tex2D(_texture1, i.uv) * splat.r + 
                    tex2D(_texture2, i.uv) * splat.g +
                    tex2D(_texture3, i.uv) * splat.b +
                    tex2D(_texture4, i.uv) * (1 - splat.r - splat.g - splat.b);
            }
            ENDCG
        }
    }
}
