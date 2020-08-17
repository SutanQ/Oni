using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TireTrack : MonoBehaviour
{
    public bool IsTracking = false;
    public float trackWidth = 0.7f;
    public float trackDensity = 0.2f;
    public float trackLifeTime = 1.0f;
    public float raycastLength = 0.7f;
    public LayerMask rayMask;
    public Material trackMaterial;
    public AudioClip brakesClip;

    RaycastHit hit;
    GameObject trackTransform;

    bool tracked = false;
    Vector3[] lastPos = new Vector3[2];

    float oldTime;

    // Start is called before the first frame update
    void Start()
    {
        trackTransform = new GameObject(transform.name + "'s Tracks");
        oldTime = Time.time;
    }

    // Update is called once per frame
    void Update()
    {
        if(IsTracking && (Time.time >= (oldTime + trackDensity)))
        {
            oldTime = Time.time;
            if (Physics.Raycast(transform.position, -Vector3.up, out hit, raycastLength, rayMask))
            {
                TireTracking(hit.point);
                AudioManager.instance.PlaySound(brakesClip, hit.point);
            }
        }
    }

    void TireTracking(Vector3 hitPos)
    {
        GameObject go = new GameObject("Track");
        go.transform.SetParent(trackTransform.transform);

        MeshFilter meshFilter = go.AddComponent<MeshFilter>();
        MeshRenderer meshRenderer = go.AddComponent<MeshRenderer>();

        Vector3[] vertexs = new Vector3[4];
        int[] triangles = new int[6];
        Vector2[] uvs = new Vector2[4];

        //第一次生成
        if (!tracked)
        {
            vertexs[0] = hitPos + Quaternion.Euler(transform.eulerAngles.x, transform.eulerAngles.y, transform.eulerAngles.z) * new Vector3(trackWidth, 0.01f, -trackWidth);
            vertexs[1] = hitPos + Quaternion.Euler(transform.eulerAngles.x, transform.eulerAngles.y, transform.eulerAngles.z) * new Vector3(-trackWidth, 0.01f, -trackWidth);
            vertexs[2] = hitPos + Quaternion.Euler(transform.eulerAngles.x, transform.eulerAngles.y, transform.eulerAngles.z) * new Vector3(-trackWidth, 0.01f, trackWidth);
            vertexs[3] = hitPos + Quaternion.Euler(transform.eulerAngles.x, transform.eulerAngles.y, transform.eulerAngles.z) * new Vector3(trackWidth, 0.01f, trackWidth);

            lastPos[0] = vertexs[2];
            lastPos[1] = vertexs[3];

            tracked = true;
        }
        else
        {
            vertexs[0] = lastPos[1];
            vertexs[1] = lastPos[0];
            vertexs[2] = hitPos + Quaternion.Euler(transform.eulerAngles.x, transform.eulerAngles.y, transform.eulerAngles.z) * new Vector3(-trackWidth, 0.01f, trackWidth);
            vertexs[3] = hitPos + Quaternion.Euler(transform.eulerAngles.x, transform.eulerAngles.y, transform.eulerAngles.z) * new Vector3(trackWidth, 0.01f, trackWidth);

            lastPos[0] = vertexs[2];
            lastPos[1] = vertexs[3];
        }

        uvs[0] = new Vector2(1.0f, 0.0f);
        uvs[1] = new Vector2(0.0f, 0.0f);
        uvs[2] = new Vector2(0.0f, 1.0f);
        uvs[3] = new Vector2(1.0f, 1.0f);

        triangles[0] = 0;
        triangles[1] = 1;
        triangles[2] = 2;
        triangles[3] = 2;
        triangles[4] = 3;
        triangles[5] = 0;


        Mesh mesh = new Mesh();
        mesh.vertices = vertexs;
        mesh.triangles = triangles;
        mesh.uv = uvs;
        mesh.RecalculateNormals();

        meshFilter.mesh = mesh;
        meshRenderer.sharedMaterial = trackMaterial;
        Destroy(go, trackLifeTime);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(transform.position, transform.position - Vector3.up * raycastLength);

        Gizmos.color = Color.green;
        Gizmos.DrawCube(transform.position, Vector3.one * trackWidth);
    }

    public void SetTracking(bool b)
    {
        IsTracking = b;
        if (b == true)
            tracked = false;
    }
}
