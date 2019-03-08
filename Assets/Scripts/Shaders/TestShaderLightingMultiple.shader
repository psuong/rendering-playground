Shader "Custom/TestShaderLightingMultiple" {

    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
        _Mmoothness ("Smoothness", Range(0,1)) = 0.1
    }

    SubShader {
        Pass {
            Tags {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM

            #pragma target 3.0
			#pragma multi_compile _ VERTEXLIGHT_ON
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #define FORWARD_BASE_PASS
            #include "LightingBase.cginc"

            ENDCG
        }

        Pass {
            Tags {
                "LightMode" = "ForwardAdd"
            }

            Blend One One
            ZWrite Off // We don't need to write to the ZBuffer twice for the second light, so disable it.
            CGPROGRAM

            #pragma target 3.0
			#pragma multi_compile_fwdadd
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            #include "LightingBase.cginc"

            ENDCG
        }
    }
}
