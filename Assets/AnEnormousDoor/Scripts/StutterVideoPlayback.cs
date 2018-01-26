using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class StutterVideoPlayback : MonoBehaviour 
{

	VideoPlayer player;

	void Awake()
	{
		player = GetComponent<VideoPlayer>();
		StartCoroutine(StutterPlayback2());
	}
	
	IEnumerator StutterPlayback2()
	{
		while (true)
		{
			player.Pause();
			yield return new WaitForSeconds(.05f);
			player.Play();
			yield return new WaitForSeconds(.05f);
		}
	}

	IEnumerator StutterPlayback()
	{
		while (true)
		{
			player.time -= .5f;
			yield return new WaitForSeconds(1);

			player.time -= .5f;
			yield return new WaitForSeconds(2);

			player.time -= .5f;
			yield return new WaitForSeconds(1);

			player.Pause();
			player.time -= .1f;
			yield return new WaitForSeconds(.2f);
			player.time += .3f;
			yield return new WaitForSeconds(.15f);
			player.time -= .1f;
			yield return new WaitForSeconds(.1f);
			player.time += .1f;
			yield return new WaitForSeconds(.2f);
			player.time -= .5f;
			yield return new WaitForSeconds(.1f);
			player.time += .2f;
			player.Play();

			yield return new WaitForSeconds(3);
		}
	}
}
