using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InterfaceAdapter : MonoBehaviour
{

    [SerializeField, Range(0, 1)] public float effectA = 0;
    [SerializeField, Range(0, 1)] public float effectB = 0;
    [SerializeField, Range(0, 1)] public float effectC = 0;

    private float effectD = 0;

    [SerializeField, Range(0, 1)] public float currentEffect = 0;
    [SerializeField, Range(0, 1)] public float currentEffectClass = 0;

    [SerializeField] protected List<InterfaceEffectClass> effectClasses;

    InterfaceEffectClass activeEffectClass;

    void Awake()
    {
        activeEffectClass = effectClasses[0];
        activeEffectClass.HandleCurrentEffect(currentEffect);
        SwitchActiveEffect(0);
    }

    void Update ()
    {
        HandleEffectClass();
        HandleCurrentEffect();
        HandleEffectParameters();
    }

    void HandleEffectClass()
    {
        var conversion = currentEffectClass * effectClasses.Count;
        if (conversion == effectClasses.Count)
        {
            conversion = effectClasses.Count - 1;
        }

        if (effectClasses[Mathf.FloorToInt(conversion)] != activeEffectClass)
        {
            SwitchActiveEffect(Mathf.FloorToInt(conversion));
        }
    }

    void HandleCurrentEffect()
    {
        activeEffectClass.HandleCurrentEffect(currentEffect);
    }

    void HandleEffectParameters()
    {
        activeEffectClass.HandleEffectParameters(effectA, effectB, effectC, effectD);
    }

    void SwitchActiveEffect(int index)
    {
        activeEffectClass.DisableEffect();
        activeEffectClass = effectClasses[index];
        activeEffectClass.EnableEffect();
    }
}
