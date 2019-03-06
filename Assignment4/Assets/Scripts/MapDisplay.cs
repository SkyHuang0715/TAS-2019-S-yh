using UnityEngine;
using System.Collections;

//after map generator collects all the messages, this script can display them in unity

public class MapDisplay : MonoBehaviour {

	public Renderer textureRender;//new material
	public MeshFilter meshFilter;//mesh filter in the mesh generator
	public MeshRenderer meshRenderer;//mesh render in the mesh generator

	//get from texture generator
	public void DrawTexture(Texture2D texture) {
		textureRender.sharedMaterial.mainTexture = texture;
		textureRender.transform.localScale = new Vector3 (texture.width, 1, texture.height);
	}

	public void DrawMesh(MeshData meshData, Texture2D texture) {
		meshFilter.sharedMesh = meshData.CreateMesh ();
		meshRenderer.sharedMaterial.mainTexture = texture;
	}

}
