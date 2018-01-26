using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class SkeletonAndArches : MonoBehaviour
{

    [SerializeField] protected GameObject[] skeletons;
    [SerializeField] protected GameObject[] arches;

    [SerializeField] protected Material skeletonMaterial;
    Material effectMaterial;

    bool disableMeshes = false;

    void Start ()
    {

        // First skeleton's renderers should be set to a copy of the material. This
        // is done so that we don't keep eating memory and crashing the machine on
        // every deformation of the additional meshes
        effectMaterial = new Material(skeletonMaterial);
        skeletons[0].GetComponentsInChildren<MeshRenderer>()
                    .ToList()
                    .ForEach(childRenderer =>
                    {
                        childRenderer.material = effectMaterial;
                    });

        for (int i = 0; i < skeletons.Length; i++)
        {
            //StartCoroutine(AnimateSkeletons());
            StartCoroutine(AnimateOneSkeleton());
        }
	}

    IEnumerator DisableAllMeshes()
    {
        var elements = new List<MeshRenderer>();
        skeletons.ToList().ForEach(x => elements.AddRange(x.GetComponentsInChildren<MeshRenderer>().ToList()));

        while (true)
        {
            while (!disableMeshes)
            {
                yield return null;
            }

            elements.ForEach(x => x.enabled = false);
            disableMeshes = false;
        }
    }
    
    // Arches need to be animated for this to be any good
    IEnumerator AnimateSkeletons()
    {
        float meshExpansionTime = 20f;
        float skeletonRevealTime = .6f;
        while (true)
        {
            // Hide each skeleton, except the last one
            for (int i = skeletons.Length - 1; i > 0; i--)
            {
                // Hide skeleton
                skeletons[i].SetActive(false);
            }

            yield return new WaitForSeconds(skeletonRevealTime);

            for (int i = 1; i < skeletons.Length; i++)
            {
                skeletons[i].SetActive(true);
                yield return new WaitForSeconds(skeletonRevealTime);
            }

            for (float i = .1f; i < 1; i += Time.deltaTime / meshExpansionTime)
            {
                // Increment material's _Effect property within some range
                float step = Mathf.Floor(i * 10) / 10f;
                effectMaterial.SetFloat("_Effect", Mathf.Lerp(0, .6f, step));
                effectMaterial.SetFloat("_EffectBoost", 1 - step);
                yield return null;
            }

            for (float i = .1f; i < 1; i += Time.deltaTime / meshExpansionTime)
            {
                float inc = 1 - i;
                // Increment material's _Effect property within some range
                float step = Mathf.Floor(inc * 10) / 10f;
                effectMaterial.SetFloat("_Effect", Mathf.Lerp(0, .6f, step));
                effectMaterial.SetFloat("_EffectBoost", 1 - step);
                yield return null;
            }


            for (int i = 1; i < skeletons.Length; i++)
            {
                skeletons[i].SetActive(false);
            }

            effectMaterial.SetFloat("_Effect", 0);
        }
    }

    // We like .35f - .45f for the material values;
    IEnumerator AnimateOneSkeleton()
    {
        float meshExpansionTime = 10f;
        while (true)
        {
            // Hide each skeleton, except the last one
            for (int i = skeletons.Length - 1; i > 0; i--)
            {
                // Hide skeleton
                skeletons[i].SetActive(false);
            }

            for (float i = .1f; i < 1; i += Time.deltaTime / meshExpansionTime)
            {
                // Increment material's _Effect property within some range
                float step = Mathf.Floor(i * 10) / 10f;
                effectMaterial.SetFloat("_Effect", Mathf.Lerp(.35f, .45f, step));
                effectMaterial.SetFloat("_EffectBoost", 1 - step);
                yield return null;
            }

            for (float i = .1f; i < 1; i += Time.deltaTime / meshExpansionTime)
            {
                float inc = 1 - i;
                // Increment material's _Effect property within some range
                float step = Mathf.Floor(inc * 10) / 10f;
                effectMaterial.SetFloat("_Effect", Mathf.Lerp(.35f, .4f, step));
                effectMaterial.SetFloat("_EffectBoost", 1 - step);
                yield return null;
            }

        }
    }

    IEnumerator ShowArches()
    {
        for (int i = 0; i < arches.Length; i++)
        {
            // Show each arch

            yield return new WaitForSeconds(.2f);
        }

        // Wait for animation reset
    }
    
}
