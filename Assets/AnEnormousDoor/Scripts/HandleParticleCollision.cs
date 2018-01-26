using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HandleParticleCollision : MonoBehaviour 
{
	void OnParticleCollision(GameObject other)
	{
		Debug.Log(other.transform.position);
	}
}
