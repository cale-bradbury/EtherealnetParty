using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IncrementOverTime : MonoBehaviour 
{
	[SerializeField] protected int steps = 0;
	[SerializeField] protected float time = 5;
	[SerializeField] protected Material targetMaterial;
	[SerializeField] protected string propertyName = "";

	void Start()
	{
		StartCoroutine(Increment());
	}

	IEnumerator Increment()
	{
		int step = 0;
		while (true)
		{
			if (step == 0)
			{
				yield return new WaitForSeconds(2);
			}
			targetMaterial.SetFloat(propertyName, (float)step);
			step = (step + 1) % steps;
			yield return new WaitForSeconds(time / steps);
		}
	}
	
}
