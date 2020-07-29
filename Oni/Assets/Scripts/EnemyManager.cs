using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    public static EnemyManager Instance;

    List<Enemy> enemies = new List<Enemy>();

    private void Awake()
    {
        if (Instance == null)
            Instance = this;
        else
            Destroy(this);
    }

    public void AddEnemy(Enemy enemy)
    {
        enemies.Add(enemy);
    }

    public void RemoveEnemy(Enemy enemy)
    {
        enemies.Remove(enemy);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        for(int i = 0; i < enemies.Count; i++)
        {
            enemies[i].UpdateAction();
        }
    }

    public Transform GetClostEnemy(Vector3 playerPos, float lockRange, float lockAngle, Vector3 camPos,  Vector3 camDir)
    {
        if (enemies.Count == 0)
            return null;

        Transform target = null;

        float minLength = 9999;
        for(int i = 0; i < enemies.Count; i++)
        {
            float d = Vector3.Distance(playerPos, enemies[i].transform.position);
            if (d < minLength && d < lockRange)
            {
                Vector3 dirr = (enemies[i].transform.position - camPos).normalized;
                float angle = Mathf.Acos(Vector3.Dot(dirr, camDir) / (dirr.sqrMagnitude * camDir.sqrMagnitude)) * 180 / Mathf.PI;

                if (Mathf.Abs(angle) <= lockAngle * 0.5f)
                {
                    minLength = d;
                    target = enemies[i].transform;
                }
            }
        }
        return target;
    }
}
