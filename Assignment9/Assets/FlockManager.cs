using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlockManager : MonoBehaviour
{
    public GameObject myAutoAgentPrefab;

    [Range(1, 5000)] public int numberOfSpawns;

    List<GameObject> _allMyAgents = new List<GameObject>();
    
    void Start()
    {
        float rCubed = 3 * numberOfSpawns / (4 * Mathf.PI * .01f); // .01 per unit volume
        float r = Mathf.Pow(rCubed, .33f);

        for (int i = 0; i < numberOfSpawns; i++)
        {
            _allMyAgents.Add(Instantiate(myAutoAgentPrefab, Random.insideUnitSphere * r, Quaternion.identity, transform));
        }
    }

    Collider[] collInRad = new Collider[1];

    void Update()
    {
        foreach(GameObject g in _allMyAgents)
        {
            AutoAgentBehavior a = g.GetComponent<AutoAgentBehavior>();
            
            Physics.OverlapSphereNonAlloc(g.transform.position, 5, collInRad);

            // Currently getting a ref to itself so may do something weird

            a.PassArrayOfContext(collInRad);
        }
    }
}
