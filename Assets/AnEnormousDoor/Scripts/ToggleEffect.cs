using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleEffect : MonoBehaviour
{

    bool effect = false;
    [SerializeField] protected float activeIndex = 0;
    [SerializeField] protected float inactiveIndex = 0;

    [SerializeField] protected Material targetMaterial;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            effect = !effect;
            if (effect)
            {
                targetMaterial.SetFloat("_Effect", activeIndex);
            }
            else
            {
                targetMaterial.SetFloat("_Effect", inactiveIndex);
            }

            Debug.Log("Toggled effect");
        }
    }

}
