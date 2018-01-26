using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NymphEffect : MonoBehaviour
{

    [SerializeField] protected Material nymphMaterial;

    NymphFlash[] flashes;

    private void Awake()
    {
        flashes = GetComponentsInChildren<NymphFlash>();

        var color = nymphMaterial.GetColor("_Color");
        color.a = 0;
        nymphMaterial.SetColor("_Color", color);
    }

    private void OnEnable()
    {
        StartCoroutine(Sequence());
    }

    IEnumerator Sequence()
    {
        float fadeInTime = .6f;
        float shardTime = .5f;

        while (true)
        {
            yield return new WaitForSeconds(1);

            var color = nymphMaterial.GetColor("_Color");
            for (float i = 0; i < 1; i += Time.deltaTime / fadeInTime)
            {
                color.a = i;
                nymphMaterial.SetColor("_Color", color);
                yield return null;
            }

            for (int i = 0; i < flashes.Length; i++)
            {
                flashes[i].enabled = true;
            }

            yield return new WaitForSeconds(shardTime);
            
            yield return new WaitForSeconds(1);

            for (int i = 0; i < flashes.Length; i++)
            {
                flashes[i].EnableAll();
                flashes[i].enabled = false;
            }

            for (float i = 0; i < 1; i += Time.deltaTime / fadeInTime)
            {
                color.a = 1 - i;
                nymphMaterial.SetColor("_Color", color);
                yield return null;
            }
            
            color.a = 0;
            nymphMaterial.SetColor("_Color", color);
        }
    }

    private void OnDisable()
    {
        var color = nymphMaterial.GetColor("_Color");
        color.a = 1;
        nymphMaterial.SetColor("_Color", color);
    }


}
