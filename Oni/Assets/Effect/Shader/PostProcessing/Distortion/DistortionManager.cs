using System.Collections.Generic;
using UnityEngine.Rendering;

/// <summary>
/// A manager that keeps tracks of objects that need to be rendered to the distortion buffer just
/// before rendering our custom after-stack Post Process effect.
/// </summary>
public class DistortionManager
{
    #region Singleton

    /// <summary>
    /// Singleton backing field.
    /// </summary>
    private static DistortionManager _instance;

    /// <summary>
    /// Singleton accessor. Replacing this for whatever ServiceLocator/Injection pattern your game
    /// uses would be a good idea when implementing a system like this!
    /// </summary>
    public static DistortionManager Instance
    {
        get
        {
            return _instance = _instance ?? new DistortionManager();
        }
    }

    #endregion

    /// <summary>
    /// The collection of distortion effects 
    /// </summary>
    private readonly List<DistortionEffect> _distortionEffects = new List<DistortionEffect>();
    private readonly List<DistortionEffect> _distortionEffects_ps = new List<DistortionEffect>();

    /// <summary>
    /// Registers an effect with the manager.
    /// </summary>
    public void Register(DistortionEffect distortionEffect)
    {
        if (distortionEffect.particleSystemRenderer != null)
            _distortionEffects_ps.Add(distortionEffect);
        else
            _distortionEffects.Add(distortionEffect);
    }

    /// <summary>
    /// Deregisters an effect from the manager.
    /// </summary>
    public void Deregister(DistortionEffect distortionEffect)
    {
        if (distortionEffect.particleSystemRenderer != null)
            _distortionEffects_ps.Remove(distortionEffect);
        else
            _distortionEffects.Remove(distortionEffect);
    }

    public DistortionEffect GetDistortionEffect()
    {
        return _distortionEffects[0];
    }

    public int GetCount()
    {
        return _distortionEffects.Count;
    }

    public int GetPsCount()
    {
        return _distortionEffects_ps.Count;
    }

    /// <summary>
    /// Adds the commands which draw the registered renderers to the target CommandBuffer.
    /// </summary>
    public void PopulateCommandBuffer(CommandBuffer commandBuffer, ref UnityEngine.Camera cam)
    {
        for (int i = 0, len = _distortionEffects.Count; i < len; i++)
        {
            var effect = _distortionEffects[i];
            commandBuffer.DrawRenderer(effect.Renderer, effect.Material);
        }

        //因為URP的BUG，導致無法直接使用DrawRenderer來繪製Particle，因此要先將Particle的結果Bake成Mesh，然後再用DrawMesh來達成效果。
        // https://forum.unity.com/threads/particles-dont-render-via-commandbuffer.860779/
        if (_distortionEffects_ps.Count > 0)
        {
            for (int i = 0, len = _distortionEffects_ps.Count; i < len; i++)
            {
                
                if (_distortionEffects_ps[i].bakedMesh == null)
                    _distortionEffects_ps[i].bakedMesh = new UnityEngine.Mesh();
                _distortionEffects_ps[i].particleSystemRenderer.BakeMesh(_distortionEffects_ps[i].bakedMesh, cam);
                commandBuffer.DrawMesh(_distortionEffects_ps[i].bakedMesh, UnityEngine.Matrix4x4.identity, _distortionEffects_ps[i].Material, 0);
                //bool localSpace = _distortionEffects_ps[i].particleSystem.main.simulationSpace == UnityEngine.ParticleSystemSimulationSpace.Local;
                //commandBuffer.DrawMesh(_distortionEffects_ps[i].bakedMesh, localSpace ? _distortionEffects_ps[i].particleSystemRenderer.localToWorldMatrix : UnityEngine.Matrix4x4.identity, _distortionEffects_ps[i].Material, 0);
            }
        }
    }
}
