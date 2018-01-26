using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class MarianneDelete : MonoBehaviour
{

    [SerializeField] protected Transform[] subMeshes;
    [SerializeField] protected Transform rotationParent;
    [SerializeField] protected Material vertexMaterial;

    [SerializeField] protected Camera viewCamera;
    [SerializeField] protected float vertexDeformSpeed = 3;
    [SerializeField] protected float deformWait = 0;

    GameObject instance;

    int subMeshCount;

    float minPoint = -0.5f;
    float maxPoint = 0.9f;

    Material internalMat;

    private void OnEnable()
    {
        if (instance == null || instance == this)
        {
            instance = this.gameObject;
            
        }

        StartCoroutine(AnimateMaterial("_Point"));
        StartCoroutine(AnimateMaterial("_Point2"));

        internalMat = new Material(vertexMaterial);
        GetComponentsInChildren<MeshRenderer>().ToList().ForEach(mesh => mesh.material = internalMat);

        subMeshCount = subMeshes.Length;
        StartCoroutine(HideRandomSubmeshes());
    }

    void Start()
    {
        
    }

    float lastTime = 0;
    float wait = 0;
    void Update()
    {
        if (Time.time - lastTime > wait)
        {
            wait = Random.Range(.2f, 4);
            lastTime = Time.time;

            float rotationSpeed = Random.Range(10, 60);
            rotationParent.Rotate(Vector3.up * rotationSpeed);
        }

        if (instance == this.gameObject)
        {
            var direction = rotationParent.InverseTransformDirection(viewCamera.transform.right);
            internalMat.SetVector("_Direction", direction.normalized * .7f);
        }
        
    }

    IEnumerator HideRandomSubmeshes()
    {
        while (true)
        {
            int meshCount = Random.Range(3, 8);
            var randomMeshes = new Transform[meshCount];

            for (int i = 0; i < randomMeshes.Length; i++)
            {
                randomMeshes[i] = subMeshes[Random.Range(0, subMeshCount - 1)];
            }

            float delay = 0;
            for (int i = 0; i < meshCount; i++)
            {
                delay = EnableDisableMesh(randomMeshes[i].GetComponent<MeshRenderer>(), false, .1f, .3f);
            }
            yield return new WaitForSeconds(delay);

            for (int i = 0; i < meshCount; i++)
            {
                delay = EnableDisableMesh(randomMeshes[i].GetComponent<MeshRenderer>(), true, .1f, .3f);
            }
            yield return new WaitForSeconds(delay);

            for (int i = 0; i < meshCount; i++)
            {
                delay = EnableDisableMesh(randomMeshes[i].GetComponent<MeshRenderer>(), false, .1f, .3f);
            }
            yield return new WaitForSeconds(delay);

            for (int i = 0; i < meshCount; i++)
            {
                delay = EnableDisableMesh(randomMeshes[i].GetComponent<MeshRenderer>(), true, .1f, .5f);
            }
            yield return new WaitForSeconds(delay);

            for (int i = 0; i < meshCount; i++)
            {
                delay = EnableDisableMesh(randomMeshes[i].GetComponent<MeshRenderer>(), false, .1f, .3f);
            }
            yield return new WaitForSeconds(delay);
            for (int i = 0; i < meshCount; i++)
            {
                delay = EnableDisableMesh(randomMeshes[i].GetComponent<MeshRenderer>(), true, .05f, .2f);
            }
            yield return new WaitForSeconds(delay);

            for (int i = 0; i < meshCount; i++)
            {
                delay = EnableDisableMesh(randomMeshes[i].GetComponent<MeshRenderer>(), false, .05f, .15f);
            }
            yield return new WaitForSeconds(delay);

            for (int i = 0; i < meshCount; i++)
            {
                delay = EnableDisableMesh(randomMeshes[i].GetComponent<MeshRenderer>(), true, .05f, .1f);
            }
            yield return new WaitForSeconds(delay);
        }
    }

    IEnumerator AnimateMaterial(string property)
    {
        float duration = Random.Range(vertexDeformSpeed - 1, vertexDeformSpeed);
        yield return new WaitForSeconds(deformWait);
        
        while (true)
        {
            bool next = false;
            for (float i = 0; i <= 1; i += Time.deltaTime / duration)
            {
                if (i % .15f < .1f)
                {
                    if (!next)
                    {
                        next = true;
                        internalMat.SetFloat(property, i);
                    }
                }
                else
                {
                    next = false;
                }
                
                yield return null;
            }

            internalMat.SetFloat(property, maxPoint);
            yield return new WaitForSeconds(Random.Range(0, .7f));
        }
    }

    float EnableDisableMesh(MeshRenderer mesh, bool enable, float minWait, float maxWait)
    {
        mesh.enabled = enable;
        return Random.Range(minWait, maxWait);
    }

    private void OnDisable()
    {
        if (instance == this.gameObject)
        {
            SetPoints(minPoint, minPoint);
        }
    }

    void SetPoints(float p1, float p2)
    {
        vertexMaterial.SetFloat("_Point", p1);
        vertexMaterial.SetFloat("_Point2", p2);
    }
}
