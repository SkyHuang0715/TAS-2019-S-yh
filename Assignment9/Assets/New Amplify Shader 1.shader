// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AnotherShader"
{
	Properties
	{
		_char_woodman_normals("char_woodman_normals", 2D) = "white" {}
		_Amplitude("Amplitude", Float) = 0.02
		_UVOffset1("UVOffset1", Vector) = (-0.1,-0.1,-0.1,0)
		_TimeOffset("Time Offset", Float) = 5
		_UVOffset0("UVOffset0", Vector) = (0.07,0.1,0.1,0)
		_Frequency("Frequency", Float) = 4
		_Cubemap("Cubemap", CUBE) = "white" {}
		_AmplitudeOffset("Amplitude Offset", Float) = 0
		_TextureSample3("Texture Sample 3", CUBE) = "white" {}
		_PositionalOffsetScalar("Positional Offset Scalar", Float) = 6
		_TextureSample1("Texture Sample 1", CUBE) = "white" {}
		_PositoinalAmplitudeScalar("Positoinal Amplitude Scalar", Float) = 16
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 1
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
			float4 appendResult102 = (float4(0.0 , 0.0 , ( ( _Amplitude * sin( ( ( _Frequency * _Time.y ) + _TimeOffset + ( ase_vertex3Pos.x * _PositionalOffsetScalar ) ) ) * ( ase_vertex3Pos.x * _PositoinalAmplitudeScalar ) ) + _AmplitudeOffset ) , 0.0));
			v.vertex.xyz += appendResult102.xyz;
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
191;485;1819;1010;2493.272;999.0548;3.32141;True;True
Node;AmplifyShaderEditor.CommentaryNode;81;-256.4253,517.8162;Float;False;922.8853;762;Adding the scaled and offset time value to the vertex's y position;4;95;94;83;82;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;83;-206.4253,927.8162;Float;False;498;326;Scales Vertex Y Position;3;89;87;84;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;82;-112.4253,567.8162;Float;False;394;324;Scales and Offsets Time Input;4;91;90;86;85;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;84;-115.7583,977.1115;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-177.5973,1131.721;Float;False;Property;_PositionalOffsetScalar;Positional Offset Scalar;9;0;Create;True;0;0;False;0;6;17.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;86;-64.54028,717.3395;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-62.54028,624.3394;Float;False;Property;_Frequency;Frequency;5;0;Create;True;0;0;False;0;4;5.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;121.4597,694.3395;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;97.45972,796.3395;Float;False;Property;_TimeOffset;Time Offset;3;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;119.4427,1002.612;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;88;123.6288,1300.346;Float;False;543.639;249.309;Uses distance from origin as scalar multiplier of amplitude;2;96;92;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;376.4597,691.3394;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;93;696.0596,520.5394;Float;False;553.9999;353;Scaling and offsetting sin ouput;4;101;99;98;97;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;92;173.6288,1434.655;Float;False;Property;_PositoinalAmplitudeScalar;Positoinal Amplitude Scalar;11;0;Create;True;0;0;False;0;16;16.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-681.7403,-646.7669;Float;True;Property;_char_woodman_normals;char_woodman_normals;0;0;Create;True;0;0;False;0;9a4a55d8d2e54394d97426434477cdcf;9a4a55d8d2e54394d97426434477cdcf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;746.0596,570.5393;Float;False;Property;_Amplitude;Amplitude;1;0;Create;True;0;0;False;0;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;498.2677,1350.346;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;68;-291.3555,34.47725;Float;False;Property;_UVOffset1;UVOffset1;2;0;Create;True;0;0;False;0;-0.1,-0.1,-0.1;-0.1,-0.1,-0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldReflectionVector;67;-324.2384,-412.6661;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;69;-283.3554,-136.5222;Float;False;Property;_UVOffset0;UVOffset0;4;0;Create;True;0;0;False;0;0.07,0.1,0.1;0.07,0.1,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinOpNode;95;524.4597,691.3394;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-23.35519,16.47728;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;916.0596,574.5393;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;850.0596,758.5393;Float;False;Property;_AmplitudeOffset;Amplitude Offset;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-23.95508,-439.1224;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;100;1280.051,525.6193;Float;False;217;229;Applying result to x axis;1;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;1096.06,574.5393;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;164.1444,-476.7224;Float;True;Property;_TextureSample1;Texture Sample 1;10;0;Create;True;0;0;False;0;73ed6c6049520484b9b253605475002d;ef7513b54a0670140b9b967af7620563;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;72;149.8603,-283.6664;Float;True;Property;_Cubemap;Cubemap;6;0;Create;True;0;0;False;0;73ed6c6049520484b9b253605475002d;a9f053d430424adb925523ba78342596;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;73;151.6446,-81.52232;Float;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;73ed6c6049520484b9b253605475002d;a9f053d430424adb925523ba78342596;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;75;560.1469,-328.6214;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;79;765.2141,-59.28214;Float;False;Property;_Smoothness;Smoothness;12;0;Create;True;0;0;False;0;0;0.723;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;757.4142,-151.0825;Float;False;Constant;_Metallic;Metallic;-1;0;Create;True;0;0;False;0;0.4441597;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;772.8119,38.01759;Float;False;Property;_Opacity;Opacity;13;0;Create;True;0;0;False;0;1;0.461;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;813.1442,-866.1227;Float;False;Constant;_Color0;Color 0;-1;0;Create;True;0;0;False;0;0.1481844,0.1652521,0.2830189,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;102;1330.051,575.6193;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1634.675,-216.3173;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AnotherShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;91;0;85;0
WireConnection;91;1;86;0
WireConnection;89;0;84;1
WireConnection;89;1;87;0
WireConnection;94;0;91;0
WireConnection;94;1;90;0
WireConnection;94;2;89;0
WireConnection;96;0;84;1
WireConnection;96;1;92;0
WireConnection;67;0;66;0
WireConnection;95;0;94;0
WireConnection;70;0;67;0
WireConnection;70;1;68;0
WireConnection;99;0;97;0
WireConnection;99;1;95;0
WireConnection;99;2;96;0
WireConnection;71;0;67;0
WireConnection;71;1;69;0
WireConnection;101;0;99;0
WireConnection;101;1;98;0
WireConnection;74;1;71;0
WireConnection;72;1;67;0
WireConnection;73;1;70;0
WireConnection;75;0;74;1
WireConnection;75;1;72;2
WireConnection;75;2;73;3
WireConnection;102;2;101;0
WireConnection;0;0;78;0
WireConnection;0;1;66;0
WireConnection;0;2;75;0
WireConnection;0;3;76;0
WireConnection;0;4;79;0
WireConnection;0;9;80;0
WireConnection;0;11;102;0
ASEEND*/
//CHKSM=5FA36CE9FC4289F1CBFF8DB876138487BECF2B53