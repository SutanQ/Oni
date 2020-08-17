using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdlePath : MonoBehaviour
{
    //public bool cycle = false;
    public List<Transform> pathPoints;
//    int pointIndex = 0;
    int maxLength = 0;

    public Transform GetPoint(int index)
    {
        if (index >= pathPoints.Count)
            return null;
        else
            return pathPoints[index]; 
    }

    public Transform GetNextPoint(ref int pointIndex, ref bool directionForward, bool cycle)
    {
        maxLength = pathPoints.Count;

        if (directionForward)
            pointIndex++;
        else
            pointIndex--;

        if(cycle)
        {
            if (pointIndex >= maxLength)
                pointIndex = 0;
            if (pointIndex < 0)
                pointIndex = maxLength - 1;
        }
        else
        {
            if (pointIndex >= maxLength)
            {
                directionForward = !directionForward;
                pointIndex -= 2;
            }
            if (pointIndex < 0)
            {
                directionForward = !directionForward;
                pointIndex += 2;
            }
            
        }

        return pathPoints[pointIndex];
    }

    public Transform GetPostPoint(ref int pointIndex, ref bool directionForward, bool cycle)
    {
        maxLength = pathPoints.Count;

        if (directionForward)
            pointIndex--;
        else
            pointIndex++;

        if (cycle)
        {
            if (pointIndex >= maxLength)
                pointIndex = 0;
            if (pointIndex < 0)
                pointIndex = maxLength - 1;
        }
        else
        {
            if (pointIndex >= maxLength)
                pointIndex -= 2;
            if (pointIndex < 0)
                pointIndex += 2;
            directionForward = !directionForward;
        }

        return pathPoints[pointIndex];
    }

    private void Start()
    {
        maxLength = pathPoints.Count;
    }

    private void OnDrawGizmosSelected()
    {
        drawGizmos();
    }

    public void drawGizmos()
    {
        maxLength = pathPoints.Count;

        for (int i = 0; i < maxLength; i++)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(pathPoints[i].position, 0.5f);

            Gizmos.color = Color.green;
            if (i < maxLength - 1)
                Gizmos.DrawLine(pathPoints[i].position, pathPoints[i + 1].position);
            
        }

    }

    public void CreatePoint()
    {
        maxLength = pathPoints.Count;

        GameObject nextPoint = new GameObject("point" + (maxLength + 1));
        nextPoint.transform.SetParent(transform);
        nextPoint.transform.localPosition = pathPoints[maxLength - 1].localPosition;
        nextPoint.transform.localRotation = pathPoints[maxLength - 1].localRotation;
        nextPoint.transform.localScale = pathPoints[maxLength - 1].localScale;

        pathPoints.Add(nextPoint.transform);
    }

    public int GetLength()
    {
        return maxLength;
    }
}

