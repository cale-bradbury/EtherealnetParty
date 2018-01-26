using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class SetChildRendererMaterial : MonoBehaviour
{
    [SerializeField] protected Material materialToSet;
	

    [ContextMenu("Set child materials")]
    public void SetChildRendererMaterials()
    {
        var renderers = GetComponentsInChildren<MeshRenderer>().ToList();
        renderers.ForEach(child => child.material = materialToSet);
    }
}
