using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshCombineSingle : MonoBehaviour
{
    public bool useRandomSize;
    public float picture_Yoffset = 0.25f;
    public Vector2 sizeMinMax = new Vector2(0.5f, 3.0f);

    // Use this for initialization
    void Start()
    {
        //抓取所有子物件的MeshFilter;
        MeshFilter[] meshFilters = gameObject.GetComponentsInChildren<MeshFilter>();
        //存放不同的Material，相同的就使用同一個
        Dictionary<string, Material> materials = new Dictionary<string, Material>();

        //存放要合併的mesh;
        Dictionary<string, List<CombineInstance>> combines = new Dictionary<string, List<CombineInstance>>();
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

            

                //宣告一個網格合併物件
                CombineInstance combine = new CombineInstance();

                //賦予mesh值
                combine.mesh = meshFilters[i].mesh;
                combine.transform = meshFilters[i].transform.localToWorldMatrix;

                MeshRenderer renderer = meshFilters[i].GetComponent<MeshRenderer>();
                Material mat = renderer.sharedMaterial;

                if (!materials.ContainsKey(mat.name))
                {
                    materials.Add(mat.name, mat);
                }
                if (combines.ContainsKey(mat.name))
                {
                    combines[mat.name].Add(combine);
                }
                else
                {
                    List<CombineInstance> coms = new List<CombineInstance>();
                    coms.Add(combine);
                    combines[mat.name] = coms;
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

            //指定Material
            rend.sharedMaterial = mater.Value;
            rend.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
            rend.receiveShadows = true;
        }
    }
}
