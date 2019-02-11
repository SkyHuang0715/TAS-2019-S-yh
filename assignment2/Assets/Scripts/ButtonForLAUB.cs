using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(LookAtUnityBezier))]
public class ButtonsForLAUB : Editor
{
    public override void OnInspectorGUI()
    {
        LookAtUnityBezier _myLAUB = (LookAtUnityBezier)target;

        DrawDefaultInspector();

        if (GUILayout.Button("Make new curve"))
        {
            Debug.Log("Button pressed.  Congrats!!!");

            BezierExample newBE = _myLAUB.myModel.gameObject.AddComponent<BezierExample>();

            if (_myLAUB.curveList.Count > 0)
            {
                BezierExample lastBE = _myLAUB.curveList[_myLAUB.curveList.Count - 1];

                newBE.startPoint = lastBE.endPoint;
                newBE.endPoint = lastBE.endPoint;
                newBE.startTangent = lastBE.endPoint;
                newBE.endTangent = lastBE.endPoint;
            }

            _myLAUB.curveList.Add(newBE);
        }
    }
}
