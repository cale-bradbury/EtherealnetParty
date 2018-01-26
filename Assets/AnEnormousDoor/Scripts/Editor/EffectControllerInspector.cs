using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(EffectController))]
public class EffectControllerInspector : Editor
{

    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        var effectController = target as EffectController;

        if (GUILayout.Button("Toggle Fog"))
        {
            effectController.ToggleFog();
        }
    }
}
