using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeScaleController : MonoBehaviour
{
    [SerializeField, Range(0,1)]
    protected float timeScale;

    [SerializeField, Range(0,1)]float timeFrequency = .1f;

    [SerializeField] protected ParticleSystem candle1;
    [SerializeField] protected ParticleSystem candle2;
    [SerializeField] protected ParticleSystem candle3;

    private void Start()
    {
        candle1Main = candle1.main;
        candle2Main = candle2.main;
        candle3Main = candle3.main;
        StartCoroutine(AnimateCandle(candle1));
        StartCoroutine(AnimateCandle(candle2));
        StartCoroutine(AnimateCandle(candle3));
    }

    ParticleSystem.MainModule candle1Main;
    ParticleSystem.MainModule candle2Main;
    ParticleSystem.MainModule candle3Main;

    private void Update()
    {
        candle1Main.simulationSpeed = timeFrequency;
        candle2Main.simulationSpeed = timeFrequency;
        candle3Main.simulationSpeed = timeFrequency;

        Time.timeScale = timeScale;
    }

    IEnumerator AnimateCandle(ParticleSystem ps)
    {
        ps.Play();
        yield return new WaitForSeconds(Random.Range(.1f, .7f));
        ps.Pause();
        yield return new WaitForSeconds(Random.Range(.1f, .7f));

        while (true)
        {
            ps.Play();
            yield return new WaitForSeconds(Random.Range(.5f, 2f));
            ps.Pause();
            yield return new WaitForSeconds(Random.Range(.1f, .9f));
        }
    }

}
