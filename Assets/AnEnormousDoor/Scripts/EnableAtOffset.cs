using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnableAtOffset : MonoBehaviour
{

    Animator animator;

    private void Awake()
    {
        animator = GetComponent<Animator>();
        animator.enabled = false;

        StartCoroutine(WaitThenEnableAnimator());
    }

    IEnumerator WaitThenEnableAnimator()
    {
        yield return new WaitForSeconds(Random.Range(0, 1.3f));
        animator.enabled = true;
    }
}
