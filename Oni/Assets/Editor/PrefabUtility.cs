// Create a folder (right click in the Assets directory, click Create>New Folder)
// and name it “Editor” if one doesn’t exist already. Place this script in that folder.

// This script creates a new menu item Examples>Create Prefab in the main menu.
// Use it to create Prefab(s) from the selected GameObject(s).
// It will be placed in the root Assets folder.

using UnityEngine;
using UnityEditor;

public class Example
{
    // Creates a new menu item 'Examples > Create Prefab' in the main menu.
    [MenuItem("Examples/Create Prefab")]
    static void CreatePrefab()
    {
        // Keep track of the currently selected GameObject(s)
        GameObject[] objectArray = Selection.gameObjects;

        // Loop through every GameObject in the array above
        foreach (GameObject gameObject in objectArray)
        {
            SkinnedMeshRenderer[] skinnedMeshRenderers = gameObject.GetComponentsInChildren<SkinnedMeshRenderer>();

            if(!AssetDatabase.IsValidFolder("Assets/RuntimePrefab/" + gameObject.name))
                AssetDatabase.CreateFolder("Assets/RuntimePrefab", gameObject.name);
            for (int i = 0; i < skinnedMeshRenderers.Length; i++)
            {
                if (!AssetDatabase.IsValidFolder("Assets/RuntimePrefab/" + gameObject.name + "/Mesh"))
                    AssetDatabase.CreateFolder("Assets/RuntimePrefab/" + gameObject.name, "Mesh");
                Mesh mesh = UnityEngine.Object.Instantiate(skinnedMeshRenderers[i].sharedMesh);
                MeshUtility.Optimize(mesh);
                string meshPath = "Assets/RuntimePrefab/" + gameObject.name  + "/Mesh/" + mesh.name + ".mesh";
                AssetDatabase.CreateAsset(mesh, meshPath);
                skinnedMeshRenderers[i].sharedMesh = mesh;

                if (!AssetDatabase.IsValidFolder("Assets/RuntimePrefab/" + gameObject.name + "/Mat"))
                    AssetDatabase.CreateFolder("Assets/RuntimePrefab/" + gameObject.name, "Mat");
                Material mat = UnityEngine.Object.Instantiate(skinnedMeshRenderers[i].sharedMaterial);
                string matPath = "Assets/RuntimePrefab/" + gameObject.name + "/Mat/" + skinnedMeshRenderers[i].sharedMaterial.name + ".mat";
                AssetDatabase.CreateAsset(mat, matPath);
                skinnedMeshRenderers[i].sharedMaterial = mat;
            }

            // Set the path as within the Assets folder,
            // and name it as the GameObject's name with the .Prefab format
            string localPath = "Assets/RuntimePrefab/" + gameObject.name + "/" + gameObject.name + ".prefab";

            // Make sure the file name is unique, in case an existing Prefab has the same name.
            localPath = AssetDatabase.GenerateUniqueAssetPath(localPath);

            // Create the new Prefab.
            PrefabUtility.SaveAsPrefabAssetAndConnect(gameObject, localPath, InteractionMode.UserAction);
        }
    }

    // Disable the menu item if no selection is in place.
    [MenuItem("Examples/Create Prefab", true)]
    static bool ValidateCreatePrefab()
    {
        return Selection.activeGameObject != null && !EditorUtility.IsPersistent(Selection.activeGameObject);
    }
}