using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModelEffect : InterfaceEffect
{

    [SerializeField] protected bool fogEffect = false;
    [SerializeField] protected GameObject targetObject;

    [SerializeField] protected float upperEffectBound = 1;
    [SerializeField] protected Renderer targetRenderer;

    public bool FogEffect
    {
        get
        {
            return fogEffect;
        }
    }

    public override void EnableEffect()
    {
        targetObject.SetActive(true);
    }

    public override void DisableEffect()
    {
        targetObject.SetActive(false);
    }

    public override void HandleEffectParameters(float valueA, float valueB, float valueC, float valueD)
    {
        if (targetRenderer != null && targetRenderer.material.HasProperty("_Effect"))
        {
            float value = Mathf.FloorToInt((valueC * upperEffectBound) * 10) / 10f;
            targetRenderer.material.SetFloat("_Effect", value);
        }
    }
}
