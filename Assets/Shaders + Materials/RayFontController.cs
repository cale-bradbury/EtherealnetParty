using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RayFontController : MonoBehaviour {

    public Material mat;
    public Vector4 addtionalOffset = Vector4.zero;

	// Use this for initialization
	
	// Update is called once per frame
	void Update () {
        mat.SetVector("_Origin", new Vector4(transform.position.x, transform.position.y, transform.position.z, 0)+addtionalOffset);
    }
}
