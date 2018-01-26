using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CycleAnimations : MonoBehaviour
{
    [SerializeField] protected int animations = 0;
    [SerializeField] protected float changeFrequency = 1f;
    [SerializeField] protected MeshRenderer meshRenderer;

    [SerializeField] protected List<int> animationIndices;

    float lastChange = 0;
    int currentAnimation = 0;

     void Awake()
    {
        lastChange = Time.time + changeFrequency;
    }

    void Update ()
    {
        if (Time.time - lastChange > changeFrequency)
        {
            if (animationIndices != null && animationIndices.Count > 0)
            {
                currentAnimation = (currentAnimation + 1) % animationIndices.Count;
                meshRenderer.sharedMaterial.SetFloat("_Effect", animationIndices[currentAnimation]);
            }
            else
            {
                currentAnimation = (currentAnimation + 1) % animations;
                meshRenderer.sharedMaterial.SetFloat("_Effect", currentAnimation);
            }
            lastChange = Time.time;
            
        }
	}
}
