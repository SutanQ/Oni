using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HalfMoonSlash : MonoBehaviour
{
    public ParticleSystem particleSystem;
    public float moveSpeed = 5.0f;
    public AnimationCurve animationCurve;

    public Transform collisionTransform;
    public AnimationCurve collisionCurve;

    public Transform groundPos;
    public LayerMask groundLayer;
    public GameObject createPrefab;
    public float createDistance = 0.5f;
    public Vector3 createRotation;
    public float DestroyTime = 1.0f;
    float startTime;
    float endTime;
    Vector3 oldPos;
    Vector3 collisionStartScale;

    RaycastHit hit;

    // Start is called before the first frame update
    void Start()
    {
        float lifeTime = particleSystem.main.duration;
        startTime = Time.time;
        endTime = Time.time + lifeTime;
        collisionStartScale = collisionTransform.localScale;
        oldPos = groundPos.position;
        Destroy(gameObject, lifeTime);
    }

    // Update is called once per frame
    void Update()
    {
        //調整本身的高度(貼著地面)
        if(Physics.Raycast(groundPos.position + Vector3.up * 8.0f, -Vector3.up, out hit, 15.0f, groundLayer))
        {
            transform.position = new Vector3(transform.position.x, hit.point.y, transform.position.z);
        }

        //位移
        transform.position += transform.forward * moveSpeed * animationCurve.Evaluate((Time.time - startTime) / (endTime - startTime)) * Time.deltaTime;
        //Collision Size
        collisionTransform.localScale = collisionStartScale * collisionCurve.Evaluate((Time.time - startTime) / (endTime - startTime));

        //產生地面特效
        if (Physics.Raycast(groundPos.position + Vector3.up * 8.0f, -Vector3.up, out hit, 15.0f, groundLayer))
        {
            if(Vector3.Distance(oldPos, hit.point) >= createDistance)
            {
                oldPos = hit.point;

                GameObject g = Instantiate(createPrefab, hit.point, Quaternion.Euler(createRotation));
                Destroy(g, DestroyTime);
            }
        }

    }
}
