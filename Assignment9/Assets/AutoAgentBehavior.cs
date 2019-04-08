using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoAgentBehavior : MonoBehaviour
{
    public Vector3 moveDirection;
    public float moveVelocityMagnitude;

    public Transform myModelTransform;

    [Range(0.0f, 1.0f)] public float clumpStrength;
    [Range(0.0f, 1.0f)] public float alignStrength;
    [Range(0.0f, 1.0f)] public float avoidStrength;
    [Range(0.0f, 1.0f)] public float originStrength;


    void Start()
    {
        myModelTransform = transform.GetChild(0);
    }

    public void PassArrayOfContext(Collider[] context)
    {
        // use context

        List<Collider> contextWithoutMe = new List<Collider>();

        foreach (Collider c in context)
        {
            if (c.gameObject != gameObject)
                contextWithoutMe.Add(c);
        }

        CalcMyDir(contextWithoutMe.ToArray());

        MoveInMyAssignedDirection(moveDirection, moveVelocityMagnitude);
    }

    void CalcMyDir(Collider[] context)
    {
        moveDirection = Vector3.Lerp(
            moveDirection, 
            Vector3.Normalize(
                ClumpDir(context) * clumpStrength +
                Align(context) * alignStrength +
                Avoidance(context) * avoidStrength +
                MoveTowardsOrigin() * originStrength * Vector3.Magnitude(transform.position)/500 ), 
            .05f);
    }

    Vector3 ClumpDir (Collider[] context)
    {
        Vector3 midpoint = Vector3.zero;

        foreach (Collider c in context)
        {
            midpoint += c.transform.position;
        }

        midpoint /= context.Length;

        Vector3 dirIWantToGo = midpoint - transform.position;

        Vector3 normalizedDirIWantToGo = Vector3.Normalize(dirIWantToGo);

        return normalizedDirIWantToGo;
    }

    Vector3 Align (Collider[] context)
    {
        Vector3 headings = Vector3.zero;

        foreach (Collider c in context)
        {
            headings += c.transform.GetChild(0).forward;
        }

        headings /= context.Length;

        return Vector3.Normalize(headings);
    }

    Vector3 Avoidance (Collider[] context)
    {
        Vector3 midpoint = Vector3.zero;

        foreach (Collider c in context)
        {
            midpoint += c.transform.position;
        }

        midpoint /= context.Length;

        Vector3 dirIWantToGo = midpoint - transform.position;

        Vector3 normalizedDirIWantToGo = Vector3.Normalize(dirIWantToGo);

        return (-normalizedDirIWantToGo);
    }

    Vector3 MoveTowardsOrigin()
    {
        return Vector3.zero - transform.position;
    }

    void MoveInMyAssignedDirection(Vector3 direction, float magnitude)
    {
        transform.position += direction * magnitude * Time.deltaTime;
        myModelTransform.rotation = Quaternion.LookRotation(direction);
    }
}
