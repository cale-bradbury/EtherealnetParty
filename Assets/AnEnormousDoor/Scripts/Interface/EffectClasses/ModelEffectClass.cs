using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModelEffectClass : InterfaceEffectClass
{

    [SerializeField] protected GameObject effectParent;

    [SerializeField] protected GameObject bgCamera;
    [SerializeField] protected GameObject noFogBackground;

    [SerializeField] protected Renderer bgRenderer;
    [SerializeField] protected Renderer fgRenderer;

    public override void EnableEffect()
    {
        effectParent.SetActive(true);
    }

    public override void DisableEffect()
    {
        effectParent.SetActive(false);
    }

    public override void HandleEffectParameters(float valueA, float valueB, float valueC, float valueD)
    {
        currentEffect.HandleEffectParameters(valueA, valueB, valueC, valueD);
        var converted = Mathf.Floor(valueC * .2f * 10f) / 5f;
        //feedbackCamera.fieldOfView = Mathf.Lerp(60, 120, converted * 2);

        if (currentEffect as ModelEffect)
        {
            if ((currentEffect as ModelEffect).FogEffect)
            {
                bgCamera.GetComponent<VolumetricFog>().enabled = true;
                noFogBackground.SetActive(false);
            }
            else
            {
                bgCamera.GetComponent<VolumetricFog>().enabled = false;
                noFogBackground.SetActive(true);
            }
        }

        // 0-11
        var conversion = Mathf.FloorToInt(valueA * 12);
        if (conversion == 11)
        {
            conversion = 10;
        }
        bgRenderer.material.SetFloat("_Effect", conversion);

        // 0-7
        conversion = Mathf.FloorToInt(valueB * 8);
        if (conversion == 7)
        {
            conversion = 6;
        }
        fgRenderer.material.SetFloat("_Effect", conversion);
    }

    public override void InitializeEffect()
    {
        if (currentEffect as ModelEffect)
        {
            if ((currentEffect as ModelEffect).FogEffect)
            {
                bgCamera.GetComponent<VolumetricFog>().enabled = true;
                noFogBackground.SetActive(false);
            }
            else
            {
                bgCamera.GetComponent<VolumetricFog>().enabled = false;
                noFogBackground.SetActive(true);
            }
        }
    }

    public override void CleanupEffect()
    {

    }
}
