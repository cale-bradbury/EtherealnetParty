using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectController : MonoBehaviour
{
    
    [SerializeField] protected VolumetricFog[] allFog;
    [SerializeField] protected GameObject volumetricLighting;

    bool fogEnabled;

    public void ToggleFog()
    {
        fogEnabled = !fogEnabled;
        for (int i = 0; i < allFog.Length; i++)
        {
            allFog[i].enabled = fogEnabled;
        }

        volumetricLighting.SetActive(fogEnabled);
    }

}
