using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shuriken : MonoBehaviour
{
    public float lifeTime = 2.0f;
    public float rotationSpeed = 30;
    public float moveSpeedX = 5.0f;
    public float moveSpeedY = 5.0f;
    public float moveSpeedZ = 5.0f;
    public Transform shuriken;
    public AnimationCurve x;
    public AnimationCurve y;
    public AnimationCurve z;
    float t, p;
    Vector3 toVector;
    float angle;

    // Update is called once per frame
    void Update()
    {
        t += Time.deltaTime;
        p = t / lifeTime;

        transform.position += transform.forward * z.Evaluate(p) * moveSpeedZ * Time.deltaTime * transform.localScale.z + transform.right * x.Evaluate(p) * Time.deltaTime * moveSpeedX * transform.localScale.x + transform.up * y.Evaluate(p) * moveSpeedY * Time.deltaTime * transform.localScale.y;
        shuriken.eulerAngles += Vector3.forward * rotationSpeed * Time.deltaTime;

        toVector = new Vector3(x.Evaluate(p) * moveSpeedX * transform.localScale.x, Mathf.Abs(y.Evaluate(p) * moveSpeedY * transform.localScale.y), 0).normalized;
        angle = Mathf.Acos(Vector3.Dot(Vector3.up, toVector)) * Mathf.Rad2Deg;
        shuriken.eulerAngles = new Vector3(angle, shuriken.eulerAngles.y, shuriken.eulerAngles.z);

        if (t >= lifeTime)
            Destroy(gameObject);
    }

    private void Start()
    {
        t = 0;
        p = 0;
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Player"))
            Destroy(gameObject);
    }

    public void SetMoveSpeedX(float s)
    {
        moveSpeedX = s;
    }

    public void SetMoveSpeedY(float s)
    {
        moveSpeedY = s;
    }

    public void SetMoveSpeedZ(float s)
    {
        moveSpeedZ = s;
    }

    public void SetRotationSpeed(float s)
    {
        rotationSpeed = s;
    }
}
