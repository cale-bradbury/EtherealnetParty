using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{

    [SerializeField] protected Material[] materials;

    [SerializeField] protected float startDelay = 3;
    [SerializeField] protected float effect1 = 30;
    [SerializeField] protected float effect2 = 2;
    [SerializeField] protected float effect3 = 10;

    Material mat;

    private void Awake()
    {
        StartCoroutine(Animate());
        mat = GetComponent<Renderer>().material;
        mat = new Material(mat);
        GetComponent<Renderer>().material = mat;
    }

    IEnumerator Animate()
    {
        yield return new WaitForSeconds(startDelay);

        var mat = GetComponent<Renderer>().sharedMaterial;
        for (float i = 0; i < 1; i += Time.deltaTime / effect1)
        {
            mat.SetFloat("_Effect", 1 - i);
            yield return null;
        }

        mat.SetFloat("_Effect", 0);

        for (float i = 0; i < 1; i += Time.deltaTime / effect2)
        {
            mat.SetFloat("_Effect2", 1 - i);
            yield return null;
        }

        var color = mat.GetColor("_Color");
        var endColor = new Color(2, 2, 2);
        for (float i = 0; i < 1; i += Time.deltaTime / effect3)
        {
            mat.SetColor("_Color", Color.Lerp(color, endColor, i));
            yield return null;
        }

        mat.SetFloat("_Effect2", 0);
    }
    
}
