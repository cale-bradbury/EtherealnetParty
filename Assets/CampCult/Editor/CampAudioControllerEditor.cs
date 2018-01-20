// Unity MIDI Input plug-in / Inspector
// By Keijiro Takahashi, 2013
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

[CustomEditor(typeof(CampAudioController))]
class CampAudioControllerEditor : Editor
{
    public CampTextureFFT texture;
    public override void OnInspectorGUI ()
    {

        DrawDefaultInspector();
        if (Application.isPlaying)
        {
            if (texture == null)
            {
                texture = FindObjectOfType<CampTextureFFT>();
            }else
            {
                Rect r = EditorGUILayout.GetControlRect();
                r.height = 200;
                EditorGUI.DrawPreviewTexture(r, texture.tex);
                Repaint();
                GUILayout.Space(200);
            }
        }
    }
}
