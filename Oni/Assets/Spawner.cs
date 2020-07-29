using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour
{
    public EnemyGroup[] enemyGroups;

    // Start is called before the first frame update
    void Start()
    {
        int length = enemyGroups.Length;
        for (int i = 0; i < length; i++)
        {
            int cnt = enemyGroups[i].Count;
            GameObject go = new GameObject(enemyGroups[i].enemyPrefab.name);
            go.transform.SetParent(transform);
            for (int j = 0; j < cnt; j++)
            {
                Vector3 pos = transform.position + Vector3.forward * Random.Range(-1, 1) + Vector3.right * Random.Range(-1, 1);
                GameObject g = Instantiate(enemyGroups[i].enemyPrefab, pos, Quaternion.identity);
                g.transform.SetParent(go.transform);
                if(enemyGroups[i].IdlePath != null)
                {
                    g.GetComponent<Enemy>().SetIdleWalkPath(enemyGroups[i].IdlePath);
                }
            }
        }
        
    }
}

[System.Serializable]
public class EnemyGroup
{
    public GameObject enemyPrefab;
    public int Count = 1;
    public IdlePath IdlePath;
}