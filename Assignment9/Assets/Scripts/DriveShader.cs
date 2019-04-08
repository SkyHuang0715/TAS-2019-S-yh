using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DriveShader : MonoBehaviour
{
    Shader shader1;
    Shader shader2;
    Renderer rend;


    void Start()
    {
        Material material = new Material(Shader.Find("fishanime"));
        material.color = Color.Lerp(Color.yellow, Color.red, Time.deltaTime);
        
        GetComponent<Renderer>().material = material;
        
        rend = GetComponent<Renderer> ();
        shader1 = Shader.Find("fishanime");
        shader2 = Shader.Find("AnotherShader");
    }

    void Update()
    {
        if (Input.GetButtonDown("Jump"))
        {
            if (rend.material.shader == shader1)
            {
                rend.material.shader = shader2;
            }
            else
            {
                rend.material.shader = shader1;
            }
        }
    }
}