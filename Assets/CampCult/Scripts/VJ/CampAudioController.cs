using UnityEngine;
using System.Collections;
using System.Reflection;
using System.Collections.Generic;

public class CampAudioController : MonoBehaviour {

	public static float value = 0;
    public TextAsset preRenderedAudio;
    public RenderCamera rendercam;
    int preRenderIndex = 0;
    List<float[]> preRenderData;
	public bool oscMode = true;

	public string oscHost = "127.0.0.1";
	public int SendToPort = 12000;
	public int ListenerPort = 32000;
	public string address = "/vj";
    public static float max = 1;
	
	public AudioSource source;
	public int numSamples;
	public int channel = 0;
	public FFTWindow FFTWindow;
	public float lerp = .5f;
	public AnimationCurve spectrumCurve = AnimationCurve.Linear(0,1,1,1);
	public float spectrumMul = 1;
    public float spectrumPow = 2;
    public float falloffRate = .01f;

    public float peakFalloffMul = .99f;
    public float peakMin = .1f;

    public float blur = 0;

	UDPPacketIO udp;
	Osc handler;
    public static float[] FFT = new float[1];
    static float[] peak = new float[1];
    public static int largestIndex;
    public static float largestValue;


    void OnEnable(){
		if (oscMode) {
			udp = gameObject.AddComponent<UDPPacketIO> ();
			handler = gameObject.AddComponent<Osc> ();

			udp.init (oscHost, SendToPort, ListenerPort);
			handler.init (udp);
			handler.SetAddressHandler (address, vjValue);
			FFT = new float[1];
            peak = new float[1];
		} else
        {
            if (preRenderedAudio!=null)
            {
                preRenderData = new List<float[]>();
                string[] frames = preRenderedAudio.text.Split(new char[]{ '\n'}, System.StringSplitOptions.RemoveEmptyEntries);
                for (int i = 0; i < frames.Length; i++)
                {
                    string[] d = frames[i].Split(new char[]{ '|'}, System.StringSplitOptions.RemoveEmptyEntries);
                    float[] f = new float[d.Length];
                    for (int j = 0; j < d.Length; j++)
                    {
                        f[j] = float.Parse( d[j]);
                    }
                    preRenderData.Add(f);
                }
                numSamples = preRenderData[0].Length;
                Debug.Log(numSamples);
            }
            FFT = new float[numSamples];
            peak = new float[numSamples];
            for (int i = 0; i < FFT.Length; i++)
            {
                FFT[i] = 0;
                peak[i] = 0;
            }
        }
	}

	void Update(){
		if (!oscMode && preRenderedAudio==null) {
			float[] n = new float[FFT.Length];
			source.GetSpectrumData (n, channel, FFTWindow);
			for(int i = 0; i< FFT.Length;i++){
                Blend(i, n[i]);
            }
		}
	}

    void FixedUpdate()
    {
        if (preRenderedAudio != null)
        {

            float[] n = preRenderData[preRenderIndex];
            preRenderIndex++;
            if(preRenderIndex >= preRenderData.Count){
                preRenderIndex = 0;
                if (rendercam != null)
                {
                    rendercam.enabled = true;
                    rendercam.numFrames = preRenderData.Count;
                    rendercam = null;
                }
            }
            for (int i = 0; i < FFT.Length; i++)
            {
                Blend(i, n[i]);
            }
        }
    }

    void Blend(int i, float f)
    {
        peak[i] = Mathf.Max(Mathf.Max(peakMin, peak[i] * peakFalloffMul), f, 0);
        f /= peak[i] + peakMin;
        FFT[i] = Mathf.Max(FFT[i] - falloffRate, Mathf.Lerp(FFT[i], Mathf.Pow(f * spectrumMul, spectrumPow) * spectrumCurve.Evaluate((float)i / FFT.Length), lerp));

        FFT[i] = Mathf.Lerp(FFT[i], (FFT[Mathf.Min(i + 1, FFT.Length-1)] + FFT[Mathf.Max(i - 1, 0)]) * .5f, blur);

        if (FFT[i] > largestValue)
        {
            largestValue = FFT[i];
            largestIndex = i;
        }
    }

	void vjValue(OscMessage msg){

		if (FFT.Length != msg.Values.Count)
        {
            FFT = new float[msg.Values.Count];
            peak = new float[msg.Values.Count];
            for (int i = 0; i<FFT.Length;i++){
				FFT[i] = 0;
                peak[i] = 0;
			}
		}
        largestIndex = 0;
        largestValue = 0;
        for (int i = 0; i < FFT.Length; i++)
        {
            Blend(i,(float) msg.Values[i]);
        }
    }


	
}