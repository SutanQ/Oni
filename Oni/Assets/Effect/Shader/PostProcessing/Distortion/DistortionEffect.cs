using UnityEngine;

/// <summary>
/// A component used to register a renderer to be drawn during the Distortion Post Process pass.
/// </summary>
[ExecuteInEditMode]
[RequireComponent(typeof(Renderer))]
public class DistortionEffect : MonoBehaviour
{
    /// <summary>
    /// The attached Renderer component.
    /// </summary>
    public Renderer Renderer { get; private set; }
    public ParticleSystem particleSystem { get; private set; }
    public ParticleSystemRenderer particleSystemRenderer { get; private set; }
    public Mesh bakedMesh;

    /// <summary>
    /// The primary material on the renderer.
    /// Currently draws all submeshes with the same material and does not support the materials
    /// array for different submesh indices.
    /// </summary>
    public Material Material { get; private set; }

    /// <summary>
    /// Caches values and registers with the manager when enabled. Disables the renderer component
    /// because it should only be visible to the Post Process pass.
    /// </summary>
    private void OnEnable()
    {
        Renderer = GetComponent<Renderer>();
        particleSystem = GetComponent<ParticleSystem>();
        particleSystemRenderer = GetComponent<ParticleSystemRenderer>();
        Renderer.enabled = false;
        Material = Renderer.sharedMaterial;
        DistortionManager.Instance.Register(this);
    }

    /// <summary>
    /// Deregisters the effect from the manager.
    /// </summary>
    private void OnDisable()
    {
        DistortionManager.Instance.Deregister(this);
    }
}
