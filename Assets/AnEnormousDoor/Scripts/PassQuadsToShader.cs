using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class PassQuadsToShader : MonoBehaviour
{
    [SerializeField] protected float xVal = 1;
    [SerializeField] protected float yVal = 1;
    [SerializeField] protected float maxScaleX = 1;
    [SerializeField] protected float minScaleX = 1;
    [SerializeField] protected float maxScaleY = 1;
    [SerializeField] protected float minScaleY = 1;

    [SerializeField] protected int quadCount = 30;
    [SerializeField] protected float shapeChangeInterval = .5f;

    [SerializeField] protected Renderer quadRenderer;

    List<Vector4> vectors = new List<Vector4>();

    [SerializeField] protected bool hardStep = false;

    void Awake()
    {
        int count = quadRenderer.material.GetInt("_Count");
        for (int i = 0; i < count; i++)
        {
            var newTransform = new Vector4();
            vectors.Add(newTransform);
        }
        
        StartCoroutine(ChangeTransforms());
    }

    Vector4 AffectVector(Vector4 vector)
    {
        vector.x = Random.Range(-xVal, xVal);
        vector.y = Random.Range(-yVal, yVal);
        vector.w = Random.Range(minScaleX, maxScaleX);
        vector.z = Random.Range(minScaleY, maxScaleY);
        
        return vector;
    }

    IEnumerator ChangeTransforms()
    {
        while (true)
        {
            AffectAllTransforms();

            if (hardStep)
            {
                yield return new WaitForSeconds(shapeChangeInterval);
            }
            else
            {
                for (float i = 0; i < 1; i += Time.deltaTime / shapeChangeInterval)
                {
                    HardStepTransition();
                    yield return new WaitForSeconds(Random.Range(.3f, .9f));
                }
            }
            
            int index = Random.Range(2, 15);
            for (int i = 0; i < index; i++)
            {
                yield return new WaitForSeconds(Random.Range(.05f, .25f));
                
                if (hardStep)
                {
                    HardStepTransition();
                }
                else
                {
                    yield return StartCoroutine(TransitionArrays());
                }
                
            }

            yield return new WaitForSeconds(Random.Range(.1f, .7f));
        }
    }

    IEnumerator TransitionArrays()
    {
        int count = quadRenderer.material.GetInt("_Count");
        var newVecs = new Vector4[count];

        for (int i = 0; i < count; i++)
        {
            newVecs[i] = AffectVector(Vector4.zero);
        }

        for (float step = 0; step < 1; step += Time.deltaTime / 5f)
        {
            for (int i = 0; i < count; i++)
            {
                vectors[i] = Vector4.Lerp(vectors[i], newVecs[i], (step * 10) % 1f);
            }
            quadRenderer.material.SetVectorArray("_Array", vectors.ToArray());
            //yield return null;
        }

        vectors = newVecs.ToList();
        yield break;
    }

    void HardStepTransition()
    {
        int count = quadRenderer.material.GetInt("_Count");
        var newVecs = new Vector4[count];

        for (int i = 0; i < count; i++)
        {
            newVecs[i] = AffectVector(Vector4.zero);
        }

        for (float step = 0; step < 1; step += Time.deltaTime / .25f)
        {
            for (int i = 0; i < count; i++)
            {
                vectors[i] = Vector4.Lerp(vectors[i], newVecs[i], step);
            }
            quadRenderer.material.SetVectorArray("_Array", vectors.ToArray());
        }

        vectors = newVecs.ToList();
    }

    void AffectAllTransforms()
    {
        int count = quadRenderer.material.GetInt("_Count");
        for (int i = 0; i < count; i++)
        {
            vectors[i] = AffectVector(vectors[i]);
        }

        quadRenderer.material.SetVectorArray("_Array", vectors.ToArray());
    }

}
