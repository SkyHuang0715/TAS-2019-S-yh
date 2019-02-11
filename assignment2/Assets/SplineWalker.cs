using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using UnityEngine;

public class SplineWalker : MonoBehaviour
{

    public BezierSpline spline;

    public float duration;

    private float progress;

    public bool lookForward;

    public SplineWalkerMode mode;

    private bool goingForward = true;
    

    private void Update()
    {

	    if (goingForward)
	    {
		    progress += Time.deltaTime / duration;
		    if (progress > 1f)
		    {

			    if (mode == SplineWalkerMode.Once)
			    {
				    progress = 1f;
			    }
			    
			    else if (mode == SplineWalkerMode.Loop) {
                					progress -= 1f;
                				}
                				else {
                					progress = 2f - progress;
                					goingForward = false;
                				}
		    }
	    }
	    
	    else {
        			progress -= Time.deltaTime / duration;
        			if (progress < 0f) {
        				progress = -progress;
        				goingForward = true;
        			}
        		}








	    UnityEngine.Vector3 position = spline.GetPoint(progress);
        transform.localPosition = position;
        if (lookForward) {
        			transform.LookAt(position + spline.GetDirection(progress));
        		}


    }
    
    public enum SplineWalkerMode {
    	Once,
    	Loop,
    	PingPong
    }
    
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
   
}
