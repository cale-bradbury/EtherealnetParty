using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MarsDeform : MonoBehaviour
{

    [SerializeField] protected Transform[] subMeshes;
    [SerializeField] protected Transform rotationParent;
    [SerializeField] protected float explodedTime = 1f;
    [SerializeField] protected float wholeTime = 1f;

    int subMeshCount;

    Vector3[] directions;
    Vector3[] originalPositions;
    Vector3[] explodedPositions;

    void OnEnable()
    {
        for (int i = 0; i < subMeshCount; i++)
        {
            subMeshes[i].transform.localPosition = originalPositions[i];
        }
        StartCoroutine(MoveSubMeshes());
    }

    void Awake()
    {
        subMeshCount = subMeshes.Length;
        directions = new Vector3[subMeshCount];
        originalPositions = new Vector3[subMeshCount];
        explodedPositions = new Vector3[subMeshCount];

        Vector3 dir = Vector3.forward;
        for (int i = 0; i < subMeshCount; i++)
        {
            var tempDir = dir;
            var cs = Mathf.Cos(360 / (float)i);
            var sn = Mathf.Sin(360 / (float)i);
            var x = 0f;
            var z = 0f;
            x = tempDir.x * cs - tempDir.z * sn;
            z = tempDir.x * sn + tempDir.z * cs;

            directions[i] = new Vector3(x, tempDir.y, z) * 5;
            originalPositions[i] = subMeshes[i].transform.localPosition;
            explodedPositions[i] = subMeshes[i].transform.localPosition + directions[i];
        }
    }

    void Update()
    {
        float rotationSpeed = 50;
        rotationParent.Rotate(Vector3.up * rotationSpeed * Time.deltaTime);
    }

    IEnumerator MoveSubMeshes()
    {
        float duration = 1.5f;
        yield return new WaitForSeconds(Random.Range(0,1));
        while (true)
        {
            for (float i = 0; i < 1; i += Time.deltaTime / duration)
            {
                for (int index = 0; index < subMeshCount; index++)
                {
                    subMeshes[index].transform.localPosition = Vector3.Lerp(originalPositions[index], explodedPositions[index], i);
                }

                yield return null;
            }

            for (int index = 0; index < subMeshCount; index++)
            {
                subMeshes[index].transform.localPosition = explodedPositions[index];
            }

            yield return new WaitForSeconds(explodedTime);

            for (float i = 0; i < 1; i += Time.deltaTime / duration)
            {
                for (int index = 0; index < subMeshCount; index++)
                {
                    subMeshes[index].transform.localPosition = Vector3.Lerp(explodedPositions[index], originalPositions[index], i);
                }

                yield return null;
            }

            for (int index = 0; index < subMeshCount; index++)
            {
                subMeshes[index].transform.localPosition = originalPositions[index];
            }

            yield return new WaitForSeconds(wholeTime);
        }
    }
    
}
