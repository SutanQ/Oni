using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
    using UnityEditor;
#endif

public class MeshCombine : MonoBehaviour
{
    public bool saveCombineMesh = false;
    public bool useRandomSize;
    public float picture_Yoffset = 0.25f;
    public Vector2 sizeMinMax = new Vector2(0.5f, 3.0f);
    public bool allMaterialUseMeshCollider = false;
    public string meshTag = "Ground";
    public PhysicMaterial physicMaterial;
    public SceneObjectType[] sceneObjectTypes;

    // Use this for initialization
    void Start()
    {
        //抓取所有子物件的MeshFilter;
        MeshFilter[] meshFilters = gameObject.GetComponentsInChildren<MeshFilter>();
        //存放不同的Material，相同的就使用同一個
        Dictionary<string, Material> materials = new Dictionary<string, Material>();

        //存放要合併的mesh;
        Dictionary<string, List<CombineInstance>> combines = new Dictionary<string, List<CombineInstance>>();

        //計算物件面數
        Dictionary<string, int> combines_count = new Dictionary<string, int>();

        for (int i = 0; i < meshFilters.Length; i++)
        {
            if(useRandomSize)
            {
                //隨機變換大小，並保持模型底部位置一致
                //float r = Random.Range(sizeMinMax.x, sizeMinMax.y);
                float x = Random.Range(sizeMinMax.x, sizeMinMax.y);
                float y = Random.Range(sizeMinMax.x, sizeMinMax.y);
                float z = Random.Range(sizeMinMax.x, sizeMinMax.y);
                Transform pos = meshFilters[i].gameObject.transform;

                float yPos = pos.position.y;
                float ySize1 = meshFilters[i].mesh.bounds.size.y * pos.lossyScale.y;
                float yBottom1 = yPos - ySize1 * 0.5f + picture_Yoffset * pos.lossyScale.y;

                meshFilters[i].gameObject.transform.localScale = new Vector3(x, y, z);
                float ySize2 = meshFilters[i].mesh.bounds.size.y * pos.lossyScale.y;
                float yBottom2 = yPos - ySize2 * 0.5f + picture_Yoffset * pos.lossyScale.y;
                float yOffset = yBottom1 - yBottom2;

                //將大小變換後的位移重新再調整
                pos.position = new Vector3(pos.position.x, pos.position.y + yOffset, pos.position.z);

            }

            for (int j = 0; j < meshFilters[i].sharedMesh.subMeshCount; j++)
            {
                //宣告一個網格合併物件
                CombineInstance combine = new CombineInstance();

                //賦予mesh值
                combine.subMeshIndex = j;
                combine.mesh = meshFilters[i].mesh;
                combine.transform = meshFilters[i].transform.localToWorldMatrix;
                
                MeshRenderer renderer = meshFilters[i].GetComponent<MeshRenderer>();

                if (renderer.sharedMaterials[j] == null)
                    Debug.Log(meshFilters[i].name + "'s material " + j + " is NULL.");
                else
                {
                    Material mat = renderer.sharedMaterials[j];

                    //當網格面數超過單個物件上限時要新增一個物件
                    string default_matName = mat.name;
                    string matName = default_matName;

                    //同個材質最多10個物件
                    for (int k = 0; k < 10; k++)
                    {
                        //設定物件編號
                        if (k == 0)
                            matName = default_matName;
                        else
                            matName = default_matName + "__" + k.ToString();

                        if (!combines_count.ContainsKey(matName))
                        {
                            combines_count.Add(matName, 0);
                        }
                        //當網格面數超過單個物件上限時要新增一個物件
                        if ((combines_count[matName] + combine.mesh.vertexCount) < 65000)
                        {
                            if (combines_count.ContainsKey(matName))
                            {
                                combines_count[matName] += combine.mesh.vertexCount;
                            }
                            break;
                        }
                    }

                    //添加材質
                    if (!materials.ContainsKey(matName))
                    {
                        materials.Add(matName, mat);
                    }
                    if (combines.ContainsKey(matName))
                    {
                        combines[matName].Add(combine);
                    }
                    else
                    {
                        List<CombineInstance> coms = new List<CombineInstance>();
                        coms.Add(combine);
                        combines[matName] = coms;
                    }
                }
            }
            Destroy(meshFilters[i].gameObject);
        }
        GameObject combineObj = new GameObject("Combine");
        combineObj.transform.parent = transform;
        foreach (KeyValuePair<string, Material> mater in materials)
        {
            GameObject obj = new GameObject(mater.Key);
            obj.transform.parent = combineObj.transform;
            MeshFilter combineMeshFilter = obj.AddComponent<MeshFilter>();
            combineMeshFilter.mesh = new Mesh();

            //合併相同Material的Mesh
            combineMeshFilter.mesh.CombineMeshes(combines[mater.Key].ToArray(), true, true);
            MeshRenderer rend = obj.AddComponent<MeshRenderer>();

            //儲存合併後的Mesh
            #if UNITY_EDITOR
                if (saveCombineMesh)
                {
                    if (!AssetDatabase.IsValidFolder("Assets/RuntimePrefab/" + gameObject.name))
                        AssetDatabase.CreateFolder("Assets/RuntimePrefab", gameObject.name);
                    if (!AssetDatabase.IsValidFolder("Assets/RuntimePrefab/" + gameObject.name + "/Mesh"))
                        AssetDatabase.CreateFolder("Assets/RuntimePrefab/" + gameObject.name, "Mesh");

                    string meshPath = "Assets/RuntimePrefab/" + gameObject.name + "/Mesh/" + obj.name + ".mesh";
                    //Debug.Log("MeshPath = " + meshPath);
                    AssetDatabase.CreateAsset(combineMeshFilter.mesh, meshPath);
                }
            #endif

            //指定Material
            rend.sharedMaterial = mater.Value;
            rend.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
            rend.receiveShadows = true;

            if (allMaterialUseMeshCollider == true)
            {
                MeshCollider meshCollider = obj.AddComponent<MeshCollider>();
                obj.tag = meshTag;

                for (int i = 0; i < sceneObjectTypes.Length; i++)
                {
                    if (mater.Value.name == sceneObjectTypes[i].addMeshMaterialName)
                    {
                        obj.tag = sceneObjectTypes[i].meshTag;
                        if (physicMaterial)
                            meshCollider.material = physicMaterial;
                        break;
                    }
                }
            }
            else
            {
                for(int i = 0; i < sceneObjectTypes.Length; i++)
                {
                    if (mater.Value.name == sceneObjectTypes[i].addMeshMaterialName)
                    {
                        MeshCollider meshCollider = obj.AddComponent<MeshCollider>();
                        obj.tag = sceneObjectTypes[i].meshTag;
                        if (sceneObjectTypes[i].physicMaterial)
                            meshCollider.material = sceneObjectTypes[i].physicMaterial;
                        break;
                    }
                }
            }
        }

        Destroy(this);
    }
}

[System.Serializable]
public class SceneObjectType
{
    public string addMeshMaterialName;
    public string meshTag = "Ground";
    public PhysicMaterial physicMaterial;
}