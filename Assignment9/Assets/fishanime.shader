// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "fishanime"
{
	Properties
	{
		_Amplitude("Amplitude", Float) = 0.02
		_TimeOffset("Time Offset", Float) = 5
		_Frequency("Frequency", Float) = 4
		_AmplitudeOffset("Amplitude Offset", Float) = 0
		_PositionalOffsetScalar("Positional Offset Scalar", Float) = 6
		_PositoinalAmplitudeScalar("Positoinal Amplitude Scalar", Float) = 16
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			half filler;
		};

		uniform float _Amplitude;
		uniform float _Frequency;
		uniform float _TimeOffset;
		uniform float _PositionalOffsetScalar;
		uniform float _PositoinalAmplitudeScalar;
		uniform float _AmplitudeOffset;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult15 = (float4(0.0 , 0.0 , ( ( _Amplitude * sin( ( ( _Frequency * _Time.y ) + _TimeOffset + ( ase_vertex3Pos.x * _PositionalOffsetScalar ) ) ) * ( ase_vertex3Pos.x * _PositoinalAmplitudeScalar ) ) + _AmplitudeOffset ) , 0.0));
			v.vertex.xyz += appendResult15.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color29 = IsGammaSpace() ? float4(0.7169812,0.503916,0.6713243,0.5176471) : float4(0.4725527,0.2176837,0.4082325,0.5176471);
			o.Albedo = color29.rgb;
			o.Alpha = color29.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16300
122;232;1819;1010;1593.034;160.9046;1.225693;True;True
Node;AmplifyShaderEditor.CommentaryNode;22;-1836.972,220.222;Float;False;922.8853;762;Adding the scaled and offset time value to the vertex's y position;4;13;5;20;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;21;-1692.972,270.2219;Float;False;394;324;Scales and Offsets Time Input;4;6;9;8;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-1786.972,630.2219;Float;False;498;326;Scales Vertex Y Position;3;17;19;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1758.144,834.1267;Float;False;Property;_PositionalOffsetScalar;Positional Offset Scalar;5;0;Create;True;0;0;False;0;6;17.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-1645.087,419.7452;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;16;-1696.305,679.5172;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1643.087,326.7451;Float;False;Property;_Frequency;Frequency;3;0;Create;True;0;0;False;0;4;5.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1459.087,396.7452;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1483.087,498.7452;Float;False;Property;_TimeOffset;Time Offset;2;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1461.104,705.0176;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;28;-1456.918,1002.752;Float;False;543.639;249.309;Uses distance from origin as scalar multiplier of amplitude;2;27;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-884.4871,222.9452;Float;False;553.9999;353;Scaling and offsetting sin ouput;4;3;4;10;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1406.918,1137.061;Float;False;Property;_PositoinalAmplitudeScalar;Positoinal Amplitude Scalar;6;0;Create;True;0;0;False;0;16;16.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1204.087,393.7451;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;5;-1056.087,393.7451;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1082.279,1052.752;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-834.4871,272.9451;Float;False;Property;_Amplitude;Amplitude;1;0;Create;True;0;0;False;0;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-730.4871,460.9451;Float;False;Property;_AmplitudeOffset;Amplitude Offset;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-664.4871,276.9451;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;25;-300.4957,228.0251;Float;False;217;229;Applying result to x axis;1;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-484.4872,276.9451;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-250.4957,278.0251;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;29;-826.975,27.85208;Float;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;False;0;0.7169812,0.503916,0.6713243,0.5176471;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;fishanime;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;8;0
WireConnection;9;1;2;0
WireConnection;17;0;16;1
WireConnection;17;1;19;0
WireConnection;13;0;9;0
WireConnection;13;1;6;0
WireConnection;13;2;17;0
WireConnection;5;0;13;0
WireConnection;26;0;16;1
WireConnection;26;1;27;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;4;2;26;0
WireConnection;7;0;4;0
WireConnection;7;1;10;0
WireConnection;15;2;7;0
WireConnection;0;0;29;0
WireConnection;0;9;29;4
WireConnection;0;11;15;0
ASEEND*/
//CHKSM=7F5F3D8A18369033AC658E0F05912779A5649B8C