using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventSetDisplacement : MonoBehaviour {

    public string[] events;
    public Displacement.MergeType[] merge;
    public Displacement displacement;

	// Use this for initialization
	void OnEnable () {
        for (int i = 0; i < events.Length; i++)
        {
            int j = i;
            Messenger.AddListener(events[i], () =>
            {
                displacement.merge = merge[j];
            });
        }
	}
	
}
