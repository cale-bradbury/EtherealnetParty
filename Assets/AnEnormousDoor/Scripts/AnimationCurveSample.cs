using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationCurveSample : MonoBehaviour
{

    [SerializeField] protected AnimationCurve curve;
    [SerializeField] protected float sampleSpeed = 1f;

    [SerializeField] protected Material materialTarget;
    [SerializeField] protected string materialParameter = "_Curve";

	void Update ()
    {
        materialTarget.SetFloat(materialParameter, curve.Evaluate((Time.time % sampleSpeed) / sampleSpeed));
    }
}
