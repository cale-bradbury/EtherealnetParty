using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class TriangleCluster : MonoBehaviour 
{
	[SerializeField] protected GameObject triangle;
	[SerializeField] protected float xScale = 1;
	[SerializeField] protected float yScale = .66f;
	[SerializeField] protected float xStep = .2f;
	[SerializeField] protected float yStep = .2f;
	[SerializeField] protected float scale = 3;
	[SerializeField] protected int density = 500;

    [SerializeField] protected bool randomizeRotation = true;

    List<Transform> childTriangles = new List<Transform>();

    private void Awake()
    {
        childTriangles = GetComponentsInChildren<Transform>().Where(x => x != this.transform).ToList();
        StartCoroutine(PickRangeThenAnimate(0));
        StartCoroutine(PickRangeThenAnimate(1));
        StartCoroutine(PickRangeThenAnimate(2));
    }

    

    IEnumerator PickRangeThenAnimate(float delay)
    {
        yield return new WaitForSeconds(delay);
        while (true)
        {
            int coroutineCount = 0;

            int range = Random.Range(150, 350);
            bool[] waiting = new bool[range];
            for (int i = 0; i < range; i++)
            {
                int index = Random.Range(0, childTriangles.Count);
                var target = childTriangles[index];
                waiting[i] = true;
                childTriangles.RemoveAt(index);
                coroutineCount++;
                StartCoroutine(AnimateTriangle(target, () => coroutineCount--));
            }

            while (coroutineCount > 0)
            {
                yield return null;
            }
        }
        
    }

    IEnumerator AnimateTriangle(Transform target, System.Action doneAction)
    {
        yield return new WaitForSeconds(Random.Range(.25f, 2f));
        //var position = target.position;
        //var rotation = target.rotation;
        //target.localPosition += new Vector3(Random.Range(1.5f, -1.5f), 0, Random.Range(0, -1.5f));
        //for (int i = 0; i < 10; i++)
        //{
        //    target.rotation = Quaternion.Euler(new Vector3(Random.Range(0, 360), Random.Range(0, 360), Random.Range(0, 360)));
        //    yield return new WaitForSeconds(Random.Range(.5f, 1.5f));
        //}

        //target.position = position;
        //target.rotation = rotation;

        target.gameObject.SetActive(false);

        yield return new WaitForSeconds(Random.Range(.75f, 2f));

        target.gameObject.SetActive(true);

        childTriangles.Add(target);
        doneAction.Invoke();
    }

    [ContextMenu("Clear")]
	public void Clear()
	{
		GetComponentsInChildren<Transform>().Where(x => x != transform)
											.ToList()
											.ForEach(x => DestroyImmediate(x.gameObject));

	}

	[ContextMenu("Populate")]
	public void Populate()
	{
		float dimension = Mathf.Sqrt(density);
		Vector3 offset = new Vector3(xStep * dimension / 2f, yStep * dimension / 2f, 0);
		Vector3 position = Vector3.zero;
		float baseX = position.x;
		
		for (float i = 0; i < dimension; i++)
		{
			for (float j = 0; j < dimension; j++)
			{
				var tri = Instantiate(triangle).transform;
				tri.name = "Triangle";
				tri.SetParent(transform);
				tri.localScale = Vector3.one * scale;
                if (randomizeRotation)
                {
                    tri.localRotation = Quaternion.Euler(new Vector3(Random.Range(0, 360f), Random.Range(0, 360f), Random.Range(0, 360f)));
                }
                else
                {
                    tri.localRotation = Quaternion.identity;
                    if (j % 2 == 0)
                    {
                        tri.Rotate(new Vector3(0, 180, 90));
                    }
                    else
                    {
                        tri.Rotate(new Vector3(0, 180, -90));
                    }
                }
				
				tri.localPosition = position - offset;

				position.x += xStep * xScale;
			}
			position.x = baseX;
			position.y += yStep * yScale;
		}
	}
}
