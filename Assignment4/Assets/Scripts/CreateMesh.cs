using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
public class CreateMesh : MonoBehaviour
{
    private Mesh mesh;

    private Vector3[] vertices;
    private int[] triangles;

    public int xSize = 20;
    public int zSize = 20;//set the terrain size on x axis and z axis
    
    
    // Start is called before the first frame update
    void Start()
    {
      mesh = new Mesh();
      GetComponent<MeshFilter>().mesh = mesh;

      CreateShape();
      UpdateMesh(); 
      
    }


    void CreateShape()
    {
       vertices = new Vector3[(xSize + 1) * (zSize + 1)]; //x+1 & z+1 beacuse they start from (0,0)

       
       for (int i = 0, z = 0; z <= zSize; z++)
       {
           for (int x = 0; x <= xSize; x++)
           {
               
               float y = Mathf.PerlinNoise(x * .3f, z * .3f) * 2f; //use perlin noise to modify the y axis
               vertices[i] = new Vector3(x, y, z);
               
               //but we need more layers of noise to generate the terrain here!
               
               //vertices[i] = new Vector3(x,0, z); //create the triangles
               i++;
               
           }
       }

       triangles = new int[xSize * zSize * 6];
       
       int vert = 0;
       int quads = 0;

       for (int z = 0; z < zSize; z++) //create quad on z axis
       {

           for (int x = 0; x < xSize; x++) //create quad on x axis
           {
               //create a quad

               triangles[quads + 0] = vert + 0;
               triangles[quads + 1] = vert + xSize + 1;
               triangles[quads + 2] = vert + 1;//1st triangle
               triangles[quads + 3] = vert + 1;
               triangles[quads + 4] = vert + xSize + 1;
               triangles[quads + 5] = vert + xSize + 2;//2nd triangle

               vert++;
               quads += 6;

               //yield return new WaitForSeconds(.01f);

           }

           vert++;

       }

       //vertices = new Vector3[]
       //{
       //new Vector3(0, 0, 0),
       // new Vector3(0, 0, 1),
       // new Vector3(1, 0, 0),
       // new Vector3(1, 0, 1),

       // };
    }

    void UpdateMesh()
    {
        mesh.Clear();

        mesh.vertices = vertices;
        mesh.triangles = triangles;
        
        mesh.RecalculateNormals();
    }

    
    //Gizmo dots for points on the quad
  //  private void OnDrawGizmos()
    //{
    //    if (vertices == null)
      //      return;
        
     //   for (int i = 0; i < vertices.Length; i++)
     //   {
      //      Gizmos.DrawSphere(vertices[i], .1f);
      //  }
  //  }

    
    // Update is called once per frame
    //procedural generate the quads
    private void Update()
    {
        
    }
}
