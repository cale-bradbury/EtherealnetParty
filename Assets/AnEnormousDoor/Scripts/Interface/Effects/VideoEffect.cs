using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class VideoEffect : InterfaceEffect
{

    [SerializeField] protected bool feedbackEffect = false;
    [SerializeField] protected GameObject targetObject;
    
    public bool FeedbackEffect
    {
        get
        {
            return feedbackEffect;
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
        targetObject.GetComponent<Renderer>().material.SetFloat("_Effect", valueA * 8);
    }
}
