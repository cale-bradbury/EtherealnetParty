using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityStandardAssets.ImageEffects;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/Camp Cult/Color/FFTTint")]
public class FFTTint : ImageEffectBase
{

    public Vector4 shape;
    
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
       
        material.SetVector("_Shape", shape);
        Graphics.Blit(source, destination, material);
    }
}
