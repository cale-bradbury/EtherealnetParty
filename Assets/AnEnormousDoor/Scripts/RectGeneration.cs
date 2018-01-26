using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RectGeneration : MonoBehaviour
{

    [SerializeField] protected GameObject rectPrefab;

    [SerializeField] protected float xVal = 1;
    [SerializeField] protected float yVal = 1;
    [SerializeField] protected float maxScaleX = 1;
    [SerializeField] protected float minScaleX = 1;
    [SerializeField] protected float maxScaleY = 1;
    [SerializeField] protected float minScaleY = 1;

    [SerializeField] protected int quadCount = 30;
    [SerializeField] protected float shapeChangeInterval = .5f;
    [SerializeField] protected bool earlyAbort = true;

    List<Transform> quads = new List<Transform>();

    void Awake()
    {
        if (earlyAbort)
        {
            Debug.LogWarning("Aborting Awake function early because flag was set to true");
            return;
        }

        for (int i = 0; i < quadCount; i++)
        {
            var newQuad = Instantiate(rectPrefab).transform;
            newQuad.SetParent(transform);
            AffectQuad(ref newQuad);
            quads.Add(newQuad);
        }
        rectPrefab.SetActive(false);

        StartCoroutine(ChangeQuads());
    }

    void AffectQuad(ref Transform quad)
    {
        var originalPos = rectPrefab.transform.localPosition;
        quad.localPosition = new Vector3(Random.Range(-xVal, xVal), Random.Range(-yVal, yVal), originalPos.z);
        quad.localScale = new Vector3(Random.Range(minScaleX, maxScaleX), Random.Range(minScaleY, maxScaleY), 1);
    }

    IEnumerator ChangeQuads()
    {
        while (true)
        {
            AffectAllQuads();
            yield return new WaitForSeconds(shapeChangeInterval);

            int index = Random.Range(2, 15);
            for (int i = 0; i < index; i++)
            {
                yield return new WaitForSeconds(Random.Range(.01f, .125f));
                AffectAllQuads();
            }
        }
    }

    void AffectAllQuads()
    {
        for (int i = 0; i < quads.Count; i++)
        {
            var quad = quads[i];
            AffectQuad(ref quad);
        }
    }

}
