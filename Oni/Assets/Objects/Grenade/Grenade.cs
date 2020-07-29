using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grenade : MonoBehaviour
{
    public Rigidbody rb;
    public LayerMask layerMask;
    public int damege = 1;
    public float radius = 1.0f;
    public GameObject grenadeParticlePrefab;
    public float particleLifeTime = 1.0f;
    public AudioClip audioClip;
    float height = 0.5f;
    Vector3 startPos;
    Vector3 targetPos;

    private void Update()
    {
        transform.Rotate(rb.velocity.x * Vector3.right * 0.8f, Space.Self);
    }

    public void SetTargetPosAndVelocity(Vector3 pos, Vector3 velocity, float h)
    {
        startPos = transform.position;
        targetPos = pos;
        height = h;
        transform.LookAt(targetPos, Vector3.up);
        rb.velocity = velocity + CalculateVelocity();
    }

    Vector3 CalculateVelocity()
    {
        float displacementY = targetPos.y - startPos.y;
        Vector3 displacementXZ = new Vector3(targetPos.x - startPos.x, 0, targetPos.z - startPos.z);

        Vector3 velocityY = Vector3.up * Mathf.Sqrt(-2 * Physics.gravity.y * height);
        Vector3 velocityXZ = displacementXZ / (Mathf.Sqrt(-2 * height / Physics.gravity.y) + Mathf.Sqrt(2 * (displacementY - height) / Physics.gravity.y));

        return velocityXZ + velocityY;
    }

    private void OnCollisionEnter(Collision collision)
    {
        Boom();
    }

    void Boom()
    {
        Attack();
        Destroy(Instantiate(grenadeParticlePrefab, transform.position, Quaternion.identity), particleLifeTime);
        AudioManager.instance.PlaySound(audioClip, transform.position);
        Destroy(gameObject);
    }

    void Attack()
    {
        //EnemyManager.Instance.AttackEnemy(transform.position, radius, damege);
        /*
        Collider[] colliders = Physics.OverlapSphere(transform.position, radius, layerMask);
        Debug.Log(transform.position + " " + colliders.Length);
        for (int i = 0; i < colliders.Length; i++)
        {
            colliders[i].GetComponent<Rigidbody>().AddExplosionForce(800.0f, transform.position, radius);
            colliders[i].GetComponent<Damegeable>().TakeDamege(damege);
        }
        */
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, radius);
    }
}
