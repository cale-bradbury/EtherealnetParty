using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InterfaceEffectClass : MonoBehaviour
{
    [SerializeField] protected string effectClassName;
    [SerializeField] protected List<InterfaceEffect> effects;

    protected InterfaceEffect currentEffect;

    void Awake()
    {
        currentEffect = effects[0];
        currentEffect.EnableEffect();
        InitializeEffect();
    }

    public string EffectClassName
    {
        get
        {
            return effectClassName;
        }
    }

    public List<InterfaceEffect> Effects
    {
        get
        {
            return effects;
        }
    }

    public void HandleCurrentEffect(float value)
    {
        var conversion = value * effects.Count;
        if (conversion == effects.Count)
        {
            conversion = effects.Count - 1;
        }

        if (effects[Mathf.FloorToInt(conversion)] != currentEffect)
        {
            if (currentEffect != null)
            {
                currentEffect.DisableEffect();
                CleanupEffect();
            }

            currentEffect = effects[Mathf.FloorToInt(conversion)];
            currentEffect.EnableEffect();
            InitializeEffect();
        }
    }

    public virtual void HandleEffectParameters(float valueA, float valueB, float valueC, float valueD)
    {
        currentEffect.HandleEffectParameters(valueA, valueB, valueC, valueD);
    }

    public virtual void EnableEffect()
    {
        throw new System.NotImplementedException();
    }

    public virtual void DisableEffect()
    {
        throw new System.NotImplementedException();
    }

    public virtual void InitializeEffect()
    {
        throw new System.NotImplementedException();
    }

    public virtual void CleanupEffect()
    {
        throw new System.NotImplementedException();
    }
}
