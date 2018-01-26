using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class NymphFlash : MonoBehaviour
{

    [SerializeField] protected MeshRenderer[] subMeshes;

    List<MeshRenderer> subMeshList;

    float lastTime = 0;
    float interval = .4f;

	void OnEnable ()
    {
        subMeshList = subMeshes.ToList();
	}
	
	void Update ()
    {
        if (Time.time - lastTime > interval && (subMeshList.Count - subMeshes.Length) < 2)
        {
            interval = Random.Range(0, .3f);
            lastTime = Time.time;
            int index = Random.Range(0, subMeshList.Count - 1);
            StartCoroutine(HideSubMeshThenAddToList(subMeshList[index], Random.Range(.7f, 2f)));
        }
	}

    IEnumerator HideSubMeshThenAddToList(MeshRenderer render, float delay)
    {
        subMeshList.Remove(render);
        render.enabled = false;
        
        yield return new WaitForSeconds(delay);

        render.enabled = true;
        subMeshList.Add(render);
    }

    public void EnableAll()
    {
        for (int i = 0; i < subMeshes.Length; i++)
        {
            subMeshes[i].enabled = true;
        }

        subMeshList = subMeshes.ToList();
    }
}
