using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
    using UnityEditor;
#endif

public class CombineMesh : MonoBehaviour
{
    [SerializeField] private SkinnedMeshRenderer bodyMesh;
    public bool useAllChildrenMesh = true;           //如果開啟的話就會直接把底下的所有的SkinnedMeshRenderer都包起來(除了bodyMesh)，否則就依照meshesToEquip清單
    public bool useList = false;
    public SkinnedMeshRenderer[] SkinnedMeshList;
    [SerializeField] private string[] meshesToEquip;
    private List<SkinnedMeshRenderer> meshes;

    [Header("Texture Combine")]
    public bool useCombineTexture = false;
    public bool compress = true;
    public bool saveCombineTexture = false;
    public int textureSize = 2048;
    public MaterialTextureGroup[] materialTextureGroups;
    [SerializeField] private Texture2D[] texture2D;

    [Header("Ghost Effect")]
    public GhostEffect ghostEffect;

    [Header("Sobel Effect")]
    public bool useSobelEffect = false;
    public string sobelShaderName = "Unlit/Texture";
    public string sobelShaderTexName = "_MainTex";
    private int sobelTexNum = 0;

    // Start is called before the first frame update
    void Start()
    {
        if(useCombineTexture)
            CombineMaterialTexture();
        Equip();
        Destroy(this);
    }

    public void CombineMaterialTexture()
    {
        //新的材質
        Material newMaterial = SkinnedMeshList[0].material;
        newMaterial.color = Color.white;

        int[] SkinnedMeshListUVNum = new int[SkinnedMeshList.Length];
        Dictionary<string, Texture2D[]> textures = new Dictionary<string, Texture2D[]>();

        //找到並儲存所有材質不重覆的貼圖
        if (useList)
        {
            for (int i = 0; i < SkinnedMeshList.Length; i++)
            {
                if (SkinnedMeshList[i] == bodyMesh)
                {
                    ;
                }
                else
                {
                    //搜尋所有Texture
                    for (int sub = 0; sub < SkinnedMeshList[i].sharedMesh.subMeshCount; sub++)
                    {
                        Material mat = SkinnedMeshList[i].sharedMaterials[sub];

                        //如果還沒加入此材質
                        if (!textures.ContainsKey(mat.name))
                        {
                            Texture2D[] texture2Ds = new Texture2D[materialTextureGroups.Length];

                            //加入所有清單名稱中的texture
                            for (int j = 0; j < materialTextureGroups.Length; j++)
                            {
                                if (string.Compare(materialTextureGroups[j].name, "_SobelTex") == 0)
                                {
                                    sobelTexNum = j;
                                    SobelEffect sobelEffect = SkinnedMeshList[i].GetComponent<SobelEffect>();
                                    if(sobelEffect != null)
                                    {
                                        //mat = sobelEffect.Material;
                                        texture2Ds[j] = sobelEffect.Material.GetTexture(sobelShaderTexName) as Texture2D;
                                        //Debug.Log(mat.name + ":" + texture2Ds[j]);
                                    }
                                    else
                                    {
                                        continue;
                                    }
                                }
                                else
                                {
                                    texture2Ds[j] = mat.GetTexture(materialTextureGroups[j].name) as Texture2D;
                                }

                                //如果沒有貼圖，則新增一張預設顏色的圖來設定
                                if(texture2Ds[j] == null)
                                {
                                    Color baseColor = Color.white;
                                    if(materialTextureGroups[j].useMaterialColor)
                                    {
                                        baseColor = mat.color;
                                    }
                                    else
                                    {
                                        baseColor = materialTextureGroups[j].color;
                                    }

                                    float value = 1.0f;
                                    if(!string.IsNullOrEmpty(materialTextureGroups[j].textureValueName))
                                    {
                                        float v1 = newMaterial.GetFloat(materialTextureGroups[j].textureValueName);
                                        float v2 = mat.GetFloat(materialTextureGroups[j].textureValueName);
                                        value = v2 / v1;
                                    }

                                    Texture2D texture2D = new Texture2D(textureSize, textureSize);
                                    Color[] colors = texture2D.GetPixels();
                                    for (int k = 0; k < colors.Length; k++)
                                        colors[k] = baseColor * value;
                                    texture2D.SetPixels(colors);
                                    texture2D.Apply();
                                    texture2Ds[j] = texture2D;
                                }
                                else
                                {
                                    Color baseColor = Color.white;
                                    if (materialTextureGroups[j].useMaterialColor)
                                    {
                                        if (string.Compare(materialTextureGroups[j].name, "_SobelTex") != 0)
                                            baseColor = mat.color;
                                    }
                                    else
                                    {
                                        baseColor = materialTextureGroups[j].color;
                                    }

                                    float value = 1.0f;
                                    if (!string.IsNullOrEmpty(materialTextureGroups[j].textureValueName))
                                    {
                                        float v1 = newMaterial.GetFloat(materialTextureGroups[j].textureValueName);
                                        float v2 = mat.GetFloat(materialTextureGroups[j].textureValueName);
                                        value = v2 / v1;
                                    }

                                    Texture2D texture2D = new Texture2D(texture2Ds[j].width, texture2Ds[j].height);
                                    Color[] colors = texture2Ds[j].GetPixels();

                                    for (int k = 0; k < colors.Length; k++)
                                        colors[k] = colors[k] * value * baseColor;
                                    texture2D.SetPixels(colors);
                                    texture2D.Apply();
                                    texture2Ds[j] = texture2D;
                                }
                            }
                            textures.Add(mat.name, texture2Ds);
                        }
                    }
                }
            }

            //配置新貼圖儲存用的陣列
            Texture2D[][] final_Texture2Ds = new Texture2D[materialTextureGroups.Length][];
            for (int i = 0; i < materialTextureGroups.Length; i++)
                final_Texture2Ds[i] = new Texture2D[textures.Count];

            //轉換所有材質貼圖的排序 (橫->縱  縱->橫)
            int index = 0;
            foreach (KeyValuePair<string, Texture2D[]> texture in textures)
            {
                for (int i = 0; i < materialTextureGroups.Length; i++)
                {
                    //該材質有貼圖
                    if (texture.Value[i] != null)
                    {
                        final_Texture2Ds[i][index] = texture.Value[i];
                    }
                }

                //設定每個SkinnedMesh對應的UV編號
                for(int i = 0; i < SkinnedMeshList.Length; i++)
                {
                    if(SkinnedMeshList[i].material.name == (texture.Key + " (Instance)"))
                    {
                        SkinnedMeshListUVNum[i] = index;
                    }
                }

                index++;
            }

            //合併Texture
            int Texture_Size = 0;
            //找到合併成幾乘幾的大小 (1x1 2x2 3x3 4x4)
            for (int i = 0; i < 4; i++)
            {
                if (textures.Count >= Mathf.Pow(i, 2) && textures.Count <= Mathf.Pow(i + 1, 2))
                {
                    Texture_Size = i + 1;
                    break;
                }
            }

            //PackTextures後的UV分佈
            Rect[] packingResult = new Rect[SkinnedMeshList.Length];

            //依設定的貼圖名稱為單位來合併各個材質的貼圖
            int tW = 0;
            int tH = 0;
            texture2D = new Texture2D[materialTextureGroups.Length];
            for (int i = 0; i < materialTextureGroups.Length; i++)
            {
                Texture2D localTexture = final_Texture2Ds[i][0];
                for (int j = 1; j < textures.Count; j++)
                {
                    if (localTexture != null)
                    {
                        tW = localTexture.width;
                        tH = localTexture.height;
                        break;
                    }
                    else
                    {
                        localTexture = final_Texture2Ds[i][j];
                    }
                }

                if (localTexture != null)
                {
                    texture2D[i] = new Texture2D(localTexture.width * Texture_Size, localTexture.height * Texture_Size);
                    texture2D[i].name = transform.name + "_" + materialTextureGroups[i].name + "(Combine)";
                    
                    packingResult = texture2D[i].PackTextures(final_Texture2Ds[i], 0, Mathf.Max(localTexture.width * Texture_Size, localTexture.height * Texture_Size));
                    if (materialTextureGroups[i].texture != null)
                    {
                        texture2D[i] = materialTextureGroups[i].texture;
                    }
                    else
                    {
                        if (materialTextureGroups[i].name == "_NormalMap")
                        {
                            Texture2D normal = new Texture2D(texture2D[i].width, texture2D[i].height, TextureFormat.RGBA32, false);
                            normal.name = materialTextureGroups[i].name;
                            Color[] colors = texture2D[i].GetPixels();
                            if (!saveCombineTexture)
                            {
                                for (int k = 0; k < colors.Length; k++)
                                {
                                    //colors[k].r = colors[k].a;
                                    //colors[k].b = colors[k].g;
                                    colors[k].g = colors[k].g + 0.2f;
                                    colors[k].b = colors[k].b + 0.2f;
                                    //colors[k].a = 0;
                                }
                            }
                            normal.SetPixels(colors);
                            texture2D[i] = normal;
                            

                            /*
                            Texture2D normal = new Texture2D(texture2D[i].width, texture2D[i].height);
                            Color[] colors = texture2D[i].GetPixels();
                            for(int k = 0; k < colors.Length; k++)
                            {
                                colors[k].r = colors[k].g;
                                colors[k].g = colors[k].b;
                                colors[k].b = colors[k].a;
                            }
                            normal.SetPixels(colors);
                            texture2D[i] = normal;
                            Debug.Log("Normal");
                            */
                        }
                        if(!saveCombineTexture)
                            texture2D[i].Compress(compress);
                        texture2D[i].Apply();
                    }
                }
            }

            //儲存合併後的貼圖
            #if UNITY_EDITOR
                if (saveCombineTexture)
                {
                    if (!AssetDatabase.IsValidFolder("Assets/RuntimePrefab/" + gameObject.name))
                        AssetDatabase.CreateFolder("Assets/RuntimePrefab", gameObject.name);
                    if (!AssetDatabase.IsValidFolder("Assets/RuntimePrefab/" + gameObject.name + "/Texture"))
                        AssetDatabase.CreateFolder("Assets/RuntimePrefab/" + gameObject.name, "Texture");
                    for (int i = 0; i < texture2D.Length; i++)
                    {
                        //Texture2D tex = UnityEngine.Object.Instantiate(texture2D[i]);
                        byte[] pngData = texture2D[i].EncodeToPNG();
                    
                        string texPath = "Assets/RuntimePrefab/" + gameObject.name + "/Texture/" + texture2D[i].name + ".png";
                        System.IO.File.WriteAllBytes(texPath, pngData);
                        //AssetDatabase.CreateAsset(tex, texPath);
                        //texture2D[i] = tex;
                    }
                }
            #endif

            //設定合併後的貼圖到新材質
            for (int i = 0; i < materialTextureGroups.Length; i++)
            {
                newMaterial.SetTexture(materialTextureGroups[i].name, texture2D[i]);
            }

            //UV 的張數
            int w = texture2D[0].width  / tW;
            int h = texture2D[0].height / tH;

            //將新材質設定到物件上
            for (int i = 0; i < SkinnedMeshList.Length; i++)
            {
                SkinnedMeshList[i].material = newMaterial;

                //調整UV
                int uvCount = SkinnedMeshList[i].sharedMesh.uv.Length;
                Vector2[] atlasUVs = new Vector2[uvCount];

                //計算合併貼圖後的UV
                //float x1 = (SkinnedMeshListUVNum[i] % w) * (1 / (float)w);
                //float x2 = ((SkinnedMeshListUVNum[i] % w) + 1) * (1 / (float)w);
                //float y1 = Mathf.FloorToInt((SkinnedMeshListUVNum[i] / (float)w)) * (1 / (float)h);
                //float y2 = Mathf.FloorToInt(((SkinnedMeshListUVNum[i] / (float)w) + 1)) * (1 / (float)h);

                int UVnum = SkinnedMeshListUVNum[i];

                //Debug.Log(SkinnedMeshList[i].name + " " + SkinnedMeshListUVNum[i] + " UV = (" + x1 + ", " + x2 + ", " + y1 + ", " + y2 + ")");
                //設定UV
                for (int j = 0; j < uvCount; j++)
                {
                   // atlasUVs[j].x = Mathf.Lerp(x1, x2, SkinnedMeshList[i].sharedMesh.uv[j].x);
                    //atlasUVs[j].y = Mathf.Lerp(y1, y2, SkinnedMeshList[i].sharedMesh.uv[j].y);
                    atlasUVs[j].x = Mathf.Lerp(packingResult[UVnum].xMin, packingResult[UVnum].xMax, SkinnedMeshList[i].sharedMesh.uv[j].x);
                    atlasUVs[j].y = Mathf.Lerp(packingResult[UVnum].yMin, packingResult[UVnum].yMax, SkinnedMeshList[i].sharedMesh.uv[j].y);
                    
                }

                //建立一個新的Mesh再調整UV，這樣就不會修改到原始模型的UV了
                CombineInstance[] ci = new CombineInstance[1];
                ci[0].mesh = SkinnedMeshList[i].sharedMesh;
                SkinnedMeshList[i].sharedMesh = new Mesh();
                SkinnedMeshList[i].sharedMesh.CombineMeshes(ci, true, false);
                SkinnedMeshList[i].sharedMesh.uv = atlasUVs;
            }
        }
    }

    public void Equip()
    {
        meshes = new List<SkinnedMeshRenderer>();
        if (useAllChildrenMesh)
        {
            SkinnedMeshRenderer[] skinnedMeshRenderers = GetComponentsInChildren<SkinnedMeshRenderer>();
            for (int i = 0; i < skinnedMeshRenderers.Length; i++)
            {
                if (skinnedMeshRenderers[i] == bodyMesh)
                {
                    ;
                }
                else
                {
                    SkinnedMeshRenderer newSkin = skinnedMeshRenderers[i];
                    meshes.Add(newSkin);
                    Destroy(skinnedMeshRenderers[i].gameObject);
                }
            }
        }
        else if(useList)
        {
            for (int i = 0; i < SkinnedMeshList.Length; i++)
            {
                if (SkinnedMeshList[i] == bodyMesh)
                {
                    ;
                }
                else
                {
                    SkinnedMeshRenderer newSkin = SkinnedMeshList[i];
                    meshes.Add(newSkin);
                    Destroy(SkinnedMeshList[i].gameObject);
                }
            }
            //SkinnedMeshList[0].material.GetTexture
        }
        else
        {
            for (int i = 0; i < meshesToEquip.Length; i++)
            {
                GameObject newGameObject = Resources.Load(meshesToEquip[i]) as GameObject;

                //將mesh加進待生成列表
                meshes.Add(newGameObject.GetComponent<SkinnedMeshRenderer>());
            }
        }

        //設定BlenderShapeKey
        //bodyMesh.SetBlendShapeWeight(1, 100);
        //bodyMesh.SetBlendShapeWeight(2, 100);

        //合併Mesh
        CombineThisMesh();
    }

    public void CombineThisMesh()
    {
        //存放不同的Material，相同的就使用同一個
        Dictionary<string, Material> materials = new Dictionary<string, Material>();

        //存放要合併的mesh;
        Dictionary<string, List<CombineInstance>> combines = new Dictionary<string, List<CombineInstance>>();
        Dictionary<string, List<BoneWeight>> boneWeights = new Dictionary<string, List<BoneWeight>>();


        //原本直接擷取bodyMesh.bones，這邊要個別收集了
        List<Transform> bones = new List<Transform>();

        //合併mesh會影響權重，相關資料也要收集
        List<Matrix4x4> bindPoses = new List<Matrix4x4>();

        for (int j = 0; j < meshes.Count; j++)
        {
            SkinnedMeshRenderer smr = meshes[j];
            BoneWeight[] meshBoneweight = smr.sharedMesh.boneWeights;

            for (int sub = 0; sub < smr.sharedMesh.subMeshCount; sub++)
            {
                //將renderer資料(mesh、transform)存進一個new CombineInstance，再加進待合列表
                CombineInstance ci = new CombineInstance();
                ci.mesh = smr.sharedMesh;
                ci.subMeshIndex = sub;
                ci.transform = smr.transform.localToWorldMatrix;

                Material mat = smr.sharedMaterials[sub];
                if (!materials.ContainsKey(mat.name))
                {
                    materials.Add(mat.name, mat);
                }
                if (combines.ContainsKey(mat.name))
                {
                    combines[mat.name].Add(ci);
                }
                else
                {
                    List<CombineInstance> coms = new List<CombineInstance>();
                    coms.Add(ci);
                    combines[mat.name] = coms;
                }

                //蒐集renderer權重資料
                for (int w = 0; w < meshBoneweight.Length; w++)
                {
                    if(boneWeights.ContainsKey(mat.name))
                    {
                        boneWeights[mat.name].Add(meshBoneweight[w]);
                    }
                    else
                    {
                        List<BoneWeight> boneW = new List<BoneWeight>();
                        boneW.Add(meshBoneweight[w]);
                        boneWeights[mat.name] = boneW;
                    }
                } 
                
            }

            //每個renderer，都會寫入一次整個bodyMesh.bones資料
            for (int b = 0; b < bodyMesh.bones.Length; b++)
            {
                bones.Add(bodyMesh.bones[b]);

                //蒐集每根骨頭的bindposes資料
                bindPoses.Add(smr.sharedMesh.bindposes[b] * smr.transform.worldToLocalMatrix);
            }
            
        }

        //生成新物件，名字隨便用第一個代表
        foreach (KeyValuePair<string, Material> mater in materials)
        {
            GameObject newPart = new GameObject(mater.Key);
            SkinnedMeshRenderer combinedMesh = newPart.AddComponent<SkinnedMeshRenderer>();
            combinedMesh.sharedMesh = new Mesh();

            //CombineMeshes後面要set true才會真正合併mesh，剩下很白話就不另外註解了
            combinedMesh.sharedMesh.CombineMeshes(combines[mater.Key].ToArray(), true);
            combinedMesh.material = mater.Value;
            combinedMesh.bones = bones.ToArray();

            //目前這邊當物件有多個材質時，boneWeights跟mesh Vertex數量就會不一致，還要再想想要怎麼修改
            //雖然現在不設定boneWeights的話，執行上看起來也還是沒什麼問題
            if (boneWeights[mater.Key].Count == combinedMesh.sharedMesh.vertexCount)
            {
                combinedMesh.sharedMesh.boneWeights = boneWeights[mater.Key].ToArray();
            }
            combinedMesh.sharedMesh.bindposes = bindPoses.ToArray();
            combinedMesh.sharedMesh.RecalculateBounds();

            combinedMesh.rootBone = bodyMesh.rootBone;

            combinedMesh.gameObject.layer = meshes[0].gameObject.layer;

            newPart.transform.parent = bodyMesh.transform;

            //如果有合併圖層跟有要使用SobelEffect
            if(useSobelEffect && useCombineTexture)
            {
                SobelEffect sobelEffect = newPart.AddComponent<SobelEffect>();
                Material sobelMaterial = new Material(Shader.Find(sobelShaderName));
                sobelMaterial.SetTexture(sobelShaderTexName, texture2D[sobelTexNum]);
                sobelEffect.Material = sobelMaterial;
            }
        }
    }

    public void CombineThisMesh2()
    {
        //待合併的instancesxu列表，每個mesh會做成一個CombineInstance存進來
        List<CombineInstance> combineInstances = new List<CombineInstance>();

        //原本直接擷取bodyMesh.bones，這邊要各別收集了
        List<Transform> bones = new List<Transform>();

        //合併mesh會影響權重，相關資料也要收集
        List<BoneWeight> boneWeights = new List<BoneWeight>();
        List<Matrix4x4> bindPoses = new List<Matrix4x4>();

        //存個material合併後使用
        Material material = meshes[0].sharedMaterial;

        for (int j = 0; j < meshes.Count; j++)
        {
            SkinnedMeshRenderer smr = meshes[j];

            for (int sub = 0; sub < smr.sharedMesh.subMeshCount; sub++)
            {
                Debug.Log("sub:" + sub + " mesh:" + smr.sharedMesh.vertexCount);
                //將renderer資料(mesh、transform)存進一個new CombineInstance，再加進待合列表
                CombineInstance ci = new CombineInstance();
                ci.mesh = smr.sharedMesh;
                ci.subMeshIndex = sub;
                ci.transform = smr.transform.localToWorldMatrix;
                combineInstances.Add(ci);

                //蒐集renderer權重資料
                BoneWeight[] meshBoneweight = smr.sharedMesh.boneWeights;
                for (int w = 0; w < meshBoneweight.Length; w++)
                {
                    boneWeights.Add(meshBoneweight[w]);
                }
            }

            //每個renderer，都會寫入一次整個bodyMesh.bones資料
            for (int b = 0; b < bodyMesh.bones.Length; b++)
            {
                bones.Add(bodyMesh.bones[b]);

                //蒐集每根骨頭的bindposes資料
                bindPoses.Add(smr.sharedMesh.bindposes[b] * smr.transform.worldToLocalMatrix);
            }
        }

        //生成新物件，名字隨便用第一個代表
        GameObject newPart = new GameObject(meshes[0].name);
        SkinnedMeshRenderer combinedMesh = newPart.AddComponent<SkinnedMeshRenderer>();
        combinedMesh.sharedMesh = new Mesh();

        //CombineMeshes後面要set true才會真正合併mesh，剩下很白話就不另外註解了
        combinedMesh.sharedMesh.CombineMeshes(combineInstances.ToArray(), true);
        combinedMesh.material = material;
        //Debug.Log(combinedMesh.sharedMesh.vertexCount + " " +boneWeights.Count);
        combinedMesh.bones = bones.ToArray();
        Debug.Log("Count:" + boneWeights.Count);
        combinedMesh.sharedMesh.boneWeights = boneWeights.ToArray();
        combinedMesh.sharedMesh.bindposes = bindPoses.ToArray();
        combinedMesh.sharedMesh.RecalculateBounds();

        combinedMesh.rootBone = bodyMesh.rootBone;

        combinedMesh.gameObject.layer = meshes[0].gameObject.layer;

        newPart.transform.parent = bodyMesh.transform;
    }
}

[System.Serializable]
public class MaterialTextureGroup
{
    public string name = "MaterialTextureName";
    public bool useMaterialColor = false;
    public Color color = Color.white;
    public Texture2D texture;
    public string textureValueName;
}