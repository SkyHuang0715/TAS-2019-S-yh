using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlobalFlock : MonoBehaviour
{

    public GameObject fishPrefab;
    //set a goal
    public GameObject goalPrefab;
    
    
    public static int tankSize = 5;

    private static int numFish = 10;
    public static GameObject[] allFish = new GameObject[numFish];

    public static Vector3 goalPos = Vector3.zero; 
    
    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < numFish; i++)
        {
            Vector3 pos = new Vector3(Random.Range(-tankSize, tankSize), 
                                      Random.Range(-tankSize, tankSize), 
                                      Random.Range(-tankSize, tankSize)
                );
            allFish[i] = (GameObject) Instantiate(fishPrefab, pos, Quaternion.identity);
        }    
    }

    // Update is called once per frame
    void Update()
    {
        if (Random.Range(0, 10000) < 50)
        {
            goalPos = new Vector3(Random.Range(-tankSize, tankSize),
                Random.Range(-tankSize, tankSize),
                Random.Range(-tankSize, tankSize));
            
            //use the goal prefab
            goalPrefab.transform.position = goalPos;
            
        }
    }
}
