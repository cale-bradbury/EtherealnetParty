using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorCorrectionController : MonoBehaviour {

    public CampColorCorrection cc1;
    public CampColorCorrection cc2;
    public float animationTime = .2f;
    public AnimationCurve animationCurve;
    [SerializeField]
    public TextureEvent[] events;

    bool animating = false;
    int nextUp = -1;

    // Use this for initialization
    void OnEnable () {
        for (int i = 0; i < events.Length; i++)
        {
            int j = i;
            Messenger.AddListener(events[i].eventName, () =>
            {
                SwapTo(j);
            });
        }
	}
	
	// Update is called once per frame
	void SwapTo (int index) {
        if (animating)
            nextUp = index;
        else
        {
            animating = true;
            cc2.textureRamp = events[index].texture;
            cc2.offset.x = cc2.offset.y = cc2.offset.z = events[index].value;
            StartCoroutine(Utils.AnimationCoroutine(animationCurve, animationTime, OnSwap, CheckNext));
        }
	}

    void OnSwap(float f)
    {
        cc1.offset.w = 1f - f;
        cc2.offset.w = f;
    }

    void CheckNext()
    {
        cc1.textureRamp = cc2.textureRamp;
        cc1.offset.w = 1;
        cc2.offset.w = 0;
        cc1.offset.x = cc1.offset.y = cc1.offset.z = cc2.offset.x;
        animating = false;
        if (nextUp != -1)
        {
            SwapTo(nextUp);
            nextUp = -1;
        }
    }
}

[System.Serializable]
public class TextureEvent
{
    public Texture texture;
    public string eventName;
    public float value;
}
