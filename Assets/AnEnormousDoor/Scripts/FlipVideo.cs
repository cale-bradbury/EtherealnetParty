using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlipVideo : MonoBehaviour
{

    [SerializeField] protected RenderTexture textureA;
    [SerializeField] protected RenderTexture textureB;

    [SerializeField] protected Camera playerCamera;
    [SerializeField] protected Camera bonusCamera;

    [SerializeField] protected float renderInterval = 4;

    [SerializeField] protected MeshRenderer cachedRenderer;

    [SerializeField] protected AnimationCurve curve;

    [SerializeField]
    protected float manualStep = -1f;
    
    public float ManualStep
    {
        set
        {
            manualStep = value;
        }
    }

    private void OnEnable()
    {
        playerCamera.targetTexture = textureA;
        StartCoroutine(WaitAndFlip());
        cachedRenderer.material = new Material(cachedRenderer.material);
    }

    private void Update()
    {
        var curveStep = ((Time.time * .1f) % 1f);
        var step = curve.Evaluate(curveStep);
        if (manualStep < 0)
        {
            cachedRenderer.material.SetFloat("_Step", step);
        }
        else
        {
            cachedRenderer.material.SetFloat("_Step", manualStep);
        }
        
    }

    IEnumerator WaitAndFlip()
    {
        while (true)
        {
            bonusCamera.Render();
            yield return new WaitForSeconds(renderInterval);
        }
    }

}
