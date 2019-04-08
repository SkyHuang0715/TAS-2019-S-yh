using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Flocks : MonoBehaviour
{
    public float speed = 0.001f;//control the initial speed of fish

    private float rotationSpeed = 4.0f;

    private Vector3 averageHeading;

    private Vector3 averagePosition;

    private float neighborDistance = 3.0f;

    private bool turning = false; //add turing boolean
    
    
    // Start is called before the first frame update
    void Start()
    {
        speed = Random.Range(0.5f, 1);
    }

    // Update is called once per frame
    void Update()
    {
        //use turning boolean
        if (Vector3.Distance(transform.position, Vector3.zero) >= GlobalFlock.tankSize)
        {
            turning = true;
        }
        else
        {
            turning = false;
            
        }

        if (turning)
        {
            Vector3 direction = Vector3.zero - transform.position;
            transform.rotation = Quaternion.Slerp(transform.rotation,
                                                  Quaternion.LookRotation(direction),
                                                  rotationSpeed * Time.deltaTime);
            speed = Random.Range(0.5f, 1);
        }
        else
        {
            if (Random.Range(0, 5) < 1)
                        ApplyRules();
        }
        
        transform.Translate(Time.deltaTime * speed, 0, speed *Time.deltaTime/2);
    }

    void ApplyRules()
    {
        var gos = GlobalFlock.allFish;

        Vector3 vcentre;
        vcentre = Vector3.zero;
        var vavoid = Vector3.zero;
        var gSpeed = 0.1f;

        var goalPos = GlobalFlock.goalPos;

        var groupSize = 0;
        foreach (GameObject go in gos)
        {
            if (go != this.gameObject)
            {
                var dist = Vector3.Distance(go.transform.position, this.transform.position);
                if (dist <= neighborDistance)
                {
                    vcentre += go.transform.position;
                    groupSize++;
                    
                    if (dist < 1.0f)
                    {
                        vavoid = vavoid + (this.transform.position - go.transform.position);
                    }

                    Flocks anotherFlock = go.GetComponent<Flocks>();
                    gSpeed = gSpeed + anotherFlock.speed;
                }
            }
        }

        if (groupSize > 0)
        {
            vcentre = vcentre / groupSize + (goalPos - this.transform.position);
            speed = gSpeed / groupSize;

            var direction = (vcentre + vavoid) - transform.position;
            if(direction != Vector3.zero)
                transform.rotation = Quaternion.Slerp(transform.rotation,
                                                      Quaternion.LookRotation(direction),
                                                      rotationSpeed * Time.deltaTime);
            //use slerp to control fish's look direction w/ time value
        }
    }
}
