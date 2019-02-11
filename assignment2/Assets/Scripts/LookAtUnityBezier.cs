using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class LookAtUnityBezier : MonoBehaviour {

    [Header("Public References")]
    public GameObject marker;
    public BezierExample bezEx;
    public Transform myModel;

    [Header("My List of Curves")]
    public List<BezierExample> curveList = new List<BezierExample>();


    public void Start()
    {
        _PutPointsOnCurve();
    }

    private void _PutPointsOnCurve()
    {
        // Run through 100 points, and place a marker at those points on the bezier curve
        // Step 1: For loop through 100 points between 0 and 1
        // Step 2: Pass that fraction to a curve calc to find the resultant V3
        // Step 3: Place a marker at that V3

        for (int i = 0; i <= 100; i++)
        {
            float t = (float)i / 100;
            Vector3 pointOnCurve = CalculateBezier(bezEx, t);
            Instantiate(marker, pointOnCurve, Quaternion.identity, null);
        }
    }

    Vector3 CalculateBezier(BezierExample curveData, float t)
    {
        Vector3 a = curveData.startPoint;
        Vector3 b = curveData.startTangent;
        Vector3 c = curveData.endTangent;
        Vector3 d = curveData.endPoint;

        Vector3 ab = Vector3.Lerp(a, b, t);
        Vector3 bc = Vector3.Lerp(b, c, t);
        Vector3 cd = Vector3.Lerp(c, d, t);

        Vector3 abc = Vector3.Lerp(ab, bc, t);
        Vector3 bcd = Vector3.Lerp(bc, cd, t);

        Vector3 final = Vector3.Lerp(abc, bcd, t);

        return final;
    }
}


