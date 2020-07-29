using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GhostEffect : MonoBehaviour
{
    private SkinnedMeshRenderer[] skinMesh;  //儲存物件底下所有的SkinnedMeshRenderer
    private MeshFilter[] meshFilters;
    private MeshRenderer[] meshRendererss;
    public bool IsActive = false;     //是否啟動顯示幻影
    public bool CastShadow = false;   //幻影是否會產生影子
    public float timer = 0.3f; 
    public float rate = 0.3f;  //rate為每幾秒生一個幻影，數值越小，生成的幻影數越多
    public float lifeTime = 1.5f;  //幻影存活的時間
    public bool useOriginalMaterial = false;  //是否使用模型原有的材質
    public Material material;      //幻影用材質1
    public Material material2;     //幻影用材質2
    private Material newMaterial;  //用來判斷最新的材質為何
    private Material oldMaterial;  //用來判斷上一種材質為何
    private bool isFirst = true;   //用來更新一次物件的SkinnedMeshRenderer

    void Start()
    {
        //取得物件底下所有的SkinnedMeshRenderer
        skinMesh = transform.GetComponentsInChildren<SkinnedMeshRenderer>();
        if (skinMesh.Length <= 0)
        {
            meshFilters = transform.GetComponentsInChildren<MeshFilter>();
            meshRendererss = transform.GetComponentsInChildren<MeshRenderer>();
        }

        //將材質預設為材質1
        oldMaterial = newMaterial = material;
    }

    void Update()
    {
        /*
        //測試切換材質用，按下1切換成材質1
        if(Input.GetKeyDown(KeyCode.Alpha1))
        {
            oldMaterial = newMaterial;
            newMaterial = material;
        }
        //測試切換材質用，按下2切換成材質2
        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            oldMaterial = newMaterial;
            newMaterial = material2;
        }
        //測試切換材質用，按下3切換成原始材質，再按一次就會取消
        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            UseOriginalMaterial();
        }
        */
        //如果有啟動幻影
        if (IsActive)
        {
            timer += Time.deltaTime; //計時
            if (timer > rate)  //每次時間到rate時則會顯示一個幻影
            {
                timer = 0;
                Plays();
            }
        }
        else
        {
            timer = 0.3f;
        }
    }

    public void ResetSkinnedMeshList()
    {
        skinMesh = transform.GetComponentsInChildren<SkinnedMeshRenderer>();
        if (skinMesh.Length <= 0)
        {
            meshFilters = transform.GetComponentsInChildren<MeshFilter>();
            meshRendererss = transform.GetComponentsInChildren<MeshRenderer>();
        }
    }

    //使用原始材質
    public void UseOriginalMaterial()
    {
        useOriginalMaterial = !useOriginalMaterial;
        if(useOriginalMaterial)
        {
            oldMaterial = null;
        }
    }

    //播放/產生幻影
    private void Plays()
    {
        //因為物件可能會再重新合併Mesh，所以在一開始執行前會先再重新更新Mesh的資料，以免出錯
        if(isFirst)
        {
            isFirst = false;
            ResetSkinnedMeshList();
        }
        if (skinMesh.Length > 0)
        {
            for (int i = 0; i < skinMesh.Length; i++)
            {
                Mesh mesh = new Mesh();
                skinMesh[i].BakeMesh(mesh);  //將目前模型的網格狀態(受動畫骨架影響後的模型狀態)烘焙至mesh中，也就是把當下的模型動作記錄成一個MESH
                GameObject t = ObjPool.Instance.TackOut(transform.name);
                MeshFilter mesh_ = null;
                MeshRenderer meshRenderer = null;
                if (t == null) //如果目前pool備用的數不夠，則需要再產生新的備用物件
                {
                    t = new GameObject();
                    t.hideFlags = HideFlags.HideAndDontSave;
                    mesh_ = t.AddComponent<MeshFilter>();
                    meshRenderer = t.AddComponent<MeshRenderer>();

                    //是否使用原有材質
                    if (useOriginalMaterial)
                        meshRenderer.material = skinMesh[i].material;
                    else
                        meshRenderer.material = newMaterial;
                    

                    if (CastShadow)
                        meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
                    else
                        meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;

                    DesT dest = t.AddComponent<DesT>();
                    dest.SetSkinNameAndMaterial(transform.name, meshRenderer.material); //將幻影名稱及材質設定給DesT知道
                    dest.SetLifeTime(lifeTime);  //設定幻影存活的時間
                }
                else
                {
                    //如果發現玩家有更換材質的話，則替換物件的材質
                    if (newMaterial != oldMaterial)
                    {
                        //是否使用原有材質
                        if (useOriginalMaterial)
                            t.GetComponent<MeshRenderer>().material = skinMesh[i].material;
                        else
                            t.GetComponent<MeshRenderer>().material = newMaterial;
                    }
                    t.SetActive(true);
                    mesh_ = t.GetComponent<MeshFilter>();
                }
                mesh_.mesh = mesh;
                t.transform.position = skinMesh[i].transform.position;
                t.transform.rotation = skinMesh[i].transform.rotation;
            }
        }
        else
        {
            for (int i = 0; i < meshFilters.Length; i++)
            {
                GameObject t = ObjPool.Instance.TackOut(transform.name);
                if (t == null) //如果目前pool備用的數不夠，則需要再產生新的備用物件
                {
                    MeshFilter mesh_ = null;
                    MeshRenderer meshRenderer = null;

                    t = new GameObject();
                    t.hideFlags = HideFlags.HideAndDontSave;
                    mesh_ = t.AddComponent<MeshFilter>();
                    meshRenderer = t.AddComponent<MeshRenderer>();

                    Mesh mesh = meshFilters[i].mesh;
                    mesh_.mesh = mesh;

                    
                    //是否使用原有材質
                    if (useOriginalMaterial)
                    {
                        meshRenderer.materials = meshRendererss[i].materials;
                    }
                    else
                    {
                        Material[] mats = new Material[meshRendererss[i].materials.Length];
                        mats[0] = new Material(newMaterial.shader);
                        for (int j = 1; j < meshRendererss[i].materials.Length; j++)
                        {
                            mats[j] = mats[0];
                        }
                        meshRenderer.sharedMaterials = mats;
                    }


                    if (CastShadow)
                        meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
                    else
                        meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;

                    DesT dest = t.AddComponent<DesT>();
                    dest.SetSkinNameAndMaterial(transform.name, meshRenderer.sharedMaterial); //將幻影名稱及材質設定給DesT知道
                    dest.SetLifeTime(lifeTime);  //設定幻影存活的時間
                    
                }
                else
                {
                    //如果發現玩家有更換材質的話，則替換物件的材質
                    if (newMaterial != oldMaterial)
                    {
                        //是否使用原有材質
                        if (useOriginalMaterial)
                        {
                            t.GetComponent<MeshRenderer>().materials = meshRendererss[i].materials;
                        }
                        else
                        {
                            Material[] mats = new Material[meshRendererss[i].materials.Length];
                            mats[0] = new Material(newMaterial.shader);
                            for (int j = 1; j < meshRendererss[i].materials.Length; j++)
                            {
                                mats[j] = mats[0];
                            }
                            t.GetComponent<MeshRenderer>().sharedMaterials = mats;
                        }
                    }
                    t.SetActive(true);
                    //mesh_ = t.GetComponent<MeshFilter>();
                }
                
                t.transform.position = meshFilters[i].transform.position;
                t.transform.rotation = meshFilters[i].transform.rotation;
                t.transform.localScale = meshFilters[i].transform.lossyScale;
                
            }
        }
    }
}

/// <summary>
/// 幻影用的Pool
/// </summary>
public class ObjPool
{
    private Dictionary<string, List<GameObject>> pool;
    private static ObjPool instance;
    public static ObjPool Instance
    {
        get
        {
            if (instance == null)
                instance = new ObjPool();
            return instance;
        }
    }
    private ObjPool()
    {
        pool = new Dictionary<string, List<GameObject>>();
    }

    //將產生的幻影物件再回收至pool中
    public void Add(string name, GameObject o)
    {
        if (pool.ContainsKey(name))
        {
            pool[name].Add(o);
            return;
        }
        pool.Add(name, new List<GameObject>());
        pool[name].Add(o);
    }

    //從pool中取出物件
    public GameObject TackOut(string name)
    {
        GameObject o = null;
        //如果尚未建立該pool
        if (!pool.ContainsKey(name))
        {
            pool.Add(name, new List<GameObject>());
            return o;
        }
        //如果被取出的物件過多而使得pool中沒有物件
        if (pool[name].Count == 0)
        {
            return o;
        }
        o = pool[name][0];
        pool[name].RemoveAt(0);
        return o;
    }

}