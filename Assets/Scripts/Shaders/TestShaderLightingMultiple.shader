Shader "Custom/TestShaderLightingMultiple" {

    Properties {
        _tint("Tint", Color) = (1, 1, 1, 1)
        _texture("Albedo", 2D) = "white" {}
        // Single values are not computed correctly in gamma space
        [Gamma] _metallic("Metallic", Range(0, 1)) = 0.1
        _smoothness("Smoothness", Range(0,1)) = 0.5
    }

    SubShader {
        Pass {
            Tags {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM

            #pragma target 3.0
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
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
            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram
            #define POINT
            #include "LightingBase.cginc"

            ENDCG
        }
    }
}
