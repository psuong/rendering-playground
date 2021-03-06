﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TestShaderWithDetail" {

    Properties {
        _tint("Tint", Color) = (1, 1, 1, 1)
        _texture("Texture", 2D) = "white" {}
        _detail_texture("Detail Texture", 2D) = "gray" {}
    }

    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            #include "UnityCG.cginc"

            float4 _tint;
            sampler2D _texture, _detail_texture;
            float4 _texture_ST, _detail_texture_ST;

            struct Interpolators {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uvDetail : TEXCOORD1;
            };

            struct VertexData {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            Interpolators MyVertexProgram(VertexData v) {
                Interpolators i;
                i.position = UnityObjectToClipPos(v.position);
                i.uv = TRANSFORM_TEX(v.uv, _texture);
                i.uvDetail = TRANSFORM_TEX(v.uv, _detail_texture);
                return i;
            }

            // Shader is an opaque shader
            // Vertex Shader -> Fragment Shader
            float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
                float4 colour = tex2D(_texture, i.uv) * _tint;
                colour *= tex2D(_texture, i.uv * 10) * 2;
                return colour;
            }
            ENDCG
        }
    }
}
