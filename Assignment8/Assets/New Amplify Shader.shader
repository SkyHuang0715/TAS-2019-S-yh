// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_char_woodman_normals("char_woodman_normals", 2D) = "white" {}
		_UVOffset1("UVOffset1", Vector) = (-0.1,-0.1,-0.1,0)
		_UVOffset0("UVOffset0", Vector) = (0.07,0.1,0.1,0)
		_Cubemap("Cubemap", CUBE) = "white" {}
		_TextureSample3("Texture Sample 3", CUBE) = "white" {}
		_TextureSample1("Texture Sample 1", CUBE) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_Amplitude("Amplitude", Float) = 0.02
		_TimeOffset("Time Offset", Float) = 5
		_Frequency("Frequency", Float) = 0.5
		_AmplitudeOffset("Amplitude Offset", Float) = 2
		_PositionalOffsetScalar("Positional Offset Scalar", Float) = 2
		_PositoinalAmplitudeScalar("Positoinal Amplitude Scalar", Float) = 16
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldRefl;
			INTERNAL_DATA
		};

		uniform float _Amplitude;
		uniform float _Frequency;
		uniform float _TimeOffset;
		uniform float _PositionalOffsetScalar;
		uniform float _PositoinalAmplitudeScalar;
		uniform float _AmplitudeOffset;
		uniform sampler2D _char_woodman_normals;
		uniform float4 _char_woodman_normals_ST;
		uniform samplerCUBE _TextureSample1;
		uniform float3 _UVOffset0;
		uniform samplerCUBE _Cubemap;
		uniform samplerCUBE _TextureSample3;
		uniform float3 _UVOffset1;
		uniform float _Smoothness;
		uniform float _Opacity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_46_0 = sin( ( ( _Frequency * _Time.y ) + _TimeOffset + ( ase_vertex3Pos.z * _PositionalOffsetScalar ) ) );
			float temp_output_52_0 = ( ( _Amplitude * temp_output_46_0 * ( ase_vertex3Pos.z * _PositoinalAmplitudeScalar ) ) + 0.0 );
			float4 appendResult53 = (float4(temp_output_52_0 , temp_output_52_0 , ( ( 0.3 * _AmplitudeOffset * temp_output_46_0 ) + 0.0 ) , 0.0));
			v.vertex.xyz += appendResult53.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_char_woodman_normals = i.uv_texcoord * _char_woodman_normals_ST.xy + _char_woodman_normals_ST.zw;
			float4 tex2DNode66 = tex2D( _char_woodman_normals, uv_char_woodman_normals );
			o.Normal = tex2DNode66.rgb;
			o.Albedo = float4(0.1481844,0.1652521,0.2830189,0).rgb;
			float3 newWorldReflection67 = WorldReflectionVector( i , tex2DNode66.rgb );
			float3 appendResult75 = (float3(texCUBE( _TextureSample1, ( newWorldReflection67 + _UVOffset0 ) ).r , texCUBE( _Cubemap, newWorldReflection67 ).g , texCUBE( _TextureSample3, ( newWorldReflection67 + _UVOffset1 ) ).b));
			o.Emission = appendResult75;
			o.Metallic = 0.4441597;
			o.Smoothness = _Smoothness;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
154;483;1819;1004;1588.007;1284.256;2.712186;True;True
Node;AmplifyShaderEditor.CommentaryNode;32;-459.5214,213.3341;Float;False;922.8853;762;Adding the scaled and offset time value to the vertex's y position;4;46;44;34;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-315.5214,263.334;Float;False;394;324;Scales and Offsets Time Input;4;40;39;37;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;34;-409.5214,623.3339;Float;False;498;326;Scales Vertex Y Position;3;42;38;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-265.6364,319.8572;Float;False;Property;_Frequency;Frequency;10;0;Create;True;0;0;False;0;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-380.6934,827.2386;Float;False;Property;_PositionalOffsetScalar;Positional Offset Scalar;12;0;Create;True;0;0;False;0;2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;38;-318.8544,672.6292;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;35;-267.6364,412.8574;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-81.63628,389.8574;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-105.6363,491.8575;Float;False;Property;_TimeOffset;Time Offset;9;0;Create;True;0;0;False;0;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-73.45165,692.9283;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;41;-93.76721,1032.264;Float;False;543.639;249.309;Uses distance from origin as scalar multiplier of amplitude;2;47;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;66;-681.7403,-646.7669;Float;True;Property;_char_woodman_normals;char_woodman_normals;0;0;Create;True;0;0;False;0;None;9a4a55d8d2e54394d97426434477cdcf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;45;478.6636,252.4573;Float;False;553.9999;353;Scaling and offsetting sin ouput;3;52;50;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;173.3636,386.8572;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-43.76724,1166.573;Float;False;Property;_PositoinalAmplitudeScalar;Positoinal Amplitude Scalar;13;0;Create;True;0;0;False;0;16;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;646.9262,874.2451;Float;False;Property;_AmplitudeOffset;Amplitude Offset;11;0;Create;True;0;0;False;0;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;46;321.3636,386.8572;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;682.5993,792.5332;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;528.6638,302.4572;Float;False;Property;_Amplitude;Amplitude;8;0;Create;True;0;0;False;0;0.02;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;69;-283.3554,-136.5222;Float;False;Property;_UVOffset0;UVOffset0;2;0;Create;True;0;0;False;0;0.07,0.1,0.1;0.07,0.1,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;280.8716,1082.264;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldReflectionVector;67;-324.2384,-412.6661;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;68;-291.3555,34.47725;Float;False;Property;_UVOffset1;UVOffset1;1;0;Create;True;0;0;False;0;-0.1,-0.1,-0.1;-0.1,-0.1,-0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;860.895,753.4796;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;698.6638,306.4572;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-23.35519,16.47728;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-23.95508,-439.1224;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;73;151.6446,-81.52232;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;False;0;None;a9f053d430424adb925523ba78342596;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;51;1062.655,257.5372;Float;False;217;229;Applying result to x axis;1;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;72;149.8603,-283.6664;Float;True;Property;_Cubemap;Cubemap;3;0;Create;True;0;0;False;0;None;a9f053d430424adb925523ba78342596;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;164.1444,-476.7224;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;ef7513b54a0670140b9b967af7620563;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;52;878.6638,306.4572;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;1049.072,533.0643;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;765.2141,-59.28214;Float;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;0;0.723;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;757.4142,-151.0825;Float;False;Constant;_Metallic;Metallic;-1;0;Create;True;0;0;False;0;0.4441597;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;772.8119,38.01759;Float;False;Property;_Opacity;Opacity;7;0;Create;True;0;0;False;0;1;0.461;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;813.1442,-866.1227;Float;False;Constant;_Color0;Color 0;-1;0;Create;True;0;0;False;0;0.1481844,0.1652521,0.2830189,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;75;560.1469,-328.6214;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;1112.655,307.5372;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1634.675,-216.3173;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;37;0
WireConnection;39;1;35;0
WireConnection;42;0;38;3
WireConnection;42;1;36;0
WireConnection;44;0;39;0
WireConnection;44;1;40;0
WireConnection;44;2;42;0
WireConnection;46;0;44;0
WireConnection;47;0;38;3
WireConnection;47;1;43;0
WireConnection;67;0;66;0
WireConnection;63;0;65;0
WireConnection;63;1;49;0
WireConnection;63;2;46;0
WireConnection;50;0;48;0
WireConnection;50;1;46;0
WireConnection;50;2;47;0
WireConnection;70;0;67;0
WireConnection;70;1;68;0
WireConnection;71;0;67;0
WireConnection;71;1;69;0
WireConnection;73;1;70;0
WireConnection;72;1;67;0
WireConnection;74;1;71;0
WireConnection;52;0;50;0
WireConnection;64;0;63;0
WireConnection;75;0;74;1
WireConnection;75;1;72;2
WireConnection;75;2;73;3
WireConnection;53;0;52;0
WireConnection;53;1;52;0
WireConnection;53;2;64;0
WireConnection;0;0;78;0
WireConnection;0;1;66;0
WireConnection;0;2;75;0
WireConnection;0;3;76;0
WireConnection;0;4;79;0
WireConnection;0;9;80;0
WireConnection;0;11;53;0
ASEEND*/
//CHKSM=4F0D85F689E4F6E8B993D744A6C7FBF3B5C54B63