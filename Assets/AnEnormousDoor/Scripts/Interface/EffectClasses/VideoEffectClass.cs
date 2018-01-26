using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VideoEffectClass : InterfaceEffectClass
{

	[SerializeField] protected GameObject regularDisplayQuad;
    [SerializeField] protected GameObject feedbackDisplayQuad;

    [SerializeField] protected GameObject effectParent;
    [SerializeField] protected Camera feedbackCamera;

    float defaultFOV = 60;

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
        feedbackCamera.fieldOfView = Mathf.Lerp(60, 120, converted * 2);

        if (currentEffect as VideoEffect)
        {
            if ((currentEffect as VideoEffect).FeedbackEffect)
            {
                feedbackDisplayQuad.GetComponent<Renderer>().material.SetFloat("_Step", valueB);
            }
            else
            {
                regularDisplayQuad.GetComponent<Renderer>().material.SetFloat("_Effect", Mathf.Lerp(0, 7, valueB));
            }
        }
    }

    public override void InitializeEffect()
    {
        if (currentEffect as VideoEffect)
        {
            if ((currentEffect as VideoEffect).FeedbackEffect)
            {
                regularDisplayQuad.SetActive(false);
                feedbackDisplayQuad.SetActive(true);
            }
            else
            {
                regularDisplayQuad.SetActive(true);
                feedbackDisplayQuad.SetActive(false);
            }
        }

        feedbackCamera.fieldOfView = defaultFOV;
    }

    public override void CleanupEffect()
    {
        
    }

}
