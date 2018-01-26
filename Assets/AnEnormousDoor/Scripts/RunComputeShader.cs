using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RunComputeShader : MonoBehaviour
{
    struct VecMatPair
    {
        public Vector3 point;
        public Matrix4x4 matrix;
    }

    [SerializeField] protected RenderTexture inputTexture;
    [SerializeField] protected Material outputMaterial;

    public ComputeShader computeShader;

    void Update()
    {
        int kernelIndex = computeShader.FindKernel("Sort");
        int blockWidth = 32;
        int blockHeight = 16;

        var renderTexture = new RenderTexture(inputTexture.width, inputTexture.height, 0);
        renderTexture.enableRandomWrite = true;
        renderTexture.Create();

        // Set all the necessary buffers
        computeShader.SetInt("textureWidth", inputTexture.width);
        computeShader.SetInt("textureHeight", inputTexture.height);
        computeShader.SetTexture(kernelIndex, "input", inputTexture);
        computeShader.SetTexture(kernelIndex, "output", renderTexture);

        // Dispatch
        computeShader.Dispatch(kernelIndex, inputTexture.width / blockWidth, inputTexture.height / blockHeight, 1);

        outputMaterial.SetTexture("_MainTex", renderTexture);
    }
}
