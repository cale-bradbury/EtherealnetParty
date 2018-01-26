using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class SetAllMeshesToPoints : MonoBehaviour {

    [MenuItem("Custom/SaveMesh")]
    public static void SaveMesh()
    {
        var mesh = FindObjectOfType<MeshFilter>().mesh;
        AssetDatabase.CreateAsset(mesh, "Assets/mesh.asset");
        AssetDatabase.SaveAssets();
    }
}
