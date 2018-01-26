using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimateLineMeshes : MonoBehaviour
{

    [SerializeField] protected Transform objectForStartPosition;
    [SerializeField] protected Line[] lines;
    [SerializeField] protected float yDeltaPerFrame = .01f;

    Vector3 startPosition;

    void Awake()
    {
        startPosition = objectForStartPosition.position;
    }

    void Update()
    {
        for (int i = 0; i < lines.Length; i++)
        {
            lines[i].transform.localPosition -= Vector3.up * yDeltaPerFrame;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.GetComponent<Line>())
        {
            other.transform.position = startPosition;
        }
    }

}
