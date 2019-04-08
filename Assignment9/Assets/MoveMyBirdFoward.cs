using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveMyBirdFoward : MonoBehaviour
{
    public float velMag;

    MeshRenderer _myMR;

    private void Start()
    {
        _myMR = GetComponent<MeshRenderer>();
    }

    void Update()
    {
        //transform.position += Vector3.forward * velMag * Time.deltaTime;

        foreach (Material m in _myMR.materials)
        {
            m.SetFloat("_Cutoff", Mathf.Sin(Time.time));
        }
    }
}
