using UnityEngine;
using UnityEditor;

[ExecuteInEditMode]
public class NeoMidi : EditorWindow
{
    MidiInput input;
    NeoMidiManager manager;
    Vector2 scrollPos = Vector2.zero;
    static GameObject midi;

    [MenuItem("CampCult/NeoMidi %_m")]
    static void Init()
    {
        NeoMidi m = EditorWindow.GetWindow<NeoMidi>();
        m.input = FindObjectOfType<MidiInput>();
        m.manager = FindObjectOfType<NeoMidiManager>();
        if (m.manager == null)
        {
            if(midi == null)
            {
                if(m.input != null)
                {
                    midi = m.input.gameObject;
                }else
                {
                    midi = new GameObject("Midi");
                }
            }
            Debug.LogWarning("No NeoMidiManager found in scene, adding on " + midi.name +" GameObject");
            m.manager = midi.AddComponent<NeoMidiManager>();
        }
        if(m.input == null)
        {
            if (midi == null)
            {
                if (m.manager != null)
                {
                    midi = m.manager.gameObject;
                }
                else
                {
                    midi = new GameObject("Midi");
                }
            }
            Debug.LogWarning("No NeoMidiManager found in scene, adding on " + midi.name + " GameObject");
            m.input = midi.AddComponent<MidiInput>();
        }
    }

    Vector2 maxBounds = Vector2.zero;

    void OnGUI()
    {
        if (manager ==null)
        {
            input = FindObjectOfType<MidiInput>();
            manager = FindObjectOfType<NeoMidiManager>();
        }

        if (GUILayout.Button("Add Stack"))
        {
            manager.stacks.Add(new MidiStack(manager));
            manager.stacks[manager.stacks.Count - 1].index = manager.stacks.Count - 1;
        }

        int stackWidth = 200;
        scrollPos = GUI.BeginScrollView(new Rect(0,25,position.width, position.height-25), scrollPos, new Rect(0, 0, maxBounds.x, maxBounds.y));

        Rect stackRect = new Rect(0, 0, stackWidth, 300);
        maxBounds = Vector2.zero;
        for (int i = 0; i < manager.stacks.Count; i++)
        {
            Vector2 v =manager.stacks[i].OnGUI(stackRect) + new Vector2(10, 0);
            stackRect.x += v.x;
            maxBounds.y = Mathf.Max(maxBounds.y, v.y);
        }
        maxBounds.x = stackRect.x;
    GUI.EndScrollView();
    }

}