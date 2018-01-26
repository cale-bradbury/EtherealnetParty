using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InterfaceEffect : MonoBehaviour
{
    public virtual void EnableEffect()
    {
        throw new System.NotImplementedException();
    }

    public virtual void DisableEffect()
    {
        throw new System.NotImplementedException();
    }

    public virtual void HandleEffectParameters(float valueA, float valueB, float valueC, float valueD)
    {
        throw new System.NotImplementedException();
    }
}
