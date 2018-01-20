using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using System.IO;

public class RecordAudio : MonoBehaviour {

    public AudioSource source;
    public FFTWindow fftWindow;
    public int numSamples = 128;
    float[] FFT;
    List<float[]> data;
    bool saved = false;

    public string path;

	// Use this for initialization
	void OnEnable () {
        FFT = new float[numSamples];
        data = new List<float[]>();
        source.Play();
    }
	
	// Update is called once per frame
	void FixedUpdate () {
        if (source.isPlaying)
        {
            float[] n = new float[FFT.Length];
            source.GetSpectrumData(n, 0, fftWindow);
            data.Add(n);
        }
        else
        {
            if (!saved)
            {
                saved = true;
                string d = "";
                System.Text.StringBuilder s = new System.Text.StringBuilder();
                for (int i = 0; i < data.Count; i++)
                {
                    for (int j = 0; j < data[i].Length; j++)
                    {
                        s.Append(data[i][j]);
                        s.Append("|");
                    }
                    s.Append("\n");
                }
                System.IO.File.WriteAllText(path, s.ToString());
            }
        }
    }
}
