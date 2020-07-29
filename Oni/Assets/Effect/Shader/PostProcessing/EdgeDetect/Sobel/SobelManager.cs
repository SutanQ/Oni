using System.Collections.Generic;
using UnityEngine.Rendering;

/// <summary>
/// A manager that keeps tracks of objects that need to be rendered to the distortion buffer just
/// before rendering our custom after-stack Post Process effect.
/// </summary>
public class SobelManager
{
    #region Singleton

    /// <summary>
    /// Singleton backing field.
    /// </summary>
    private static SobelManager _instance;

    /// <summary>
    /// Singleton accessor. Replacing this for whatever ServiceLocator/Injection pattern your game
    /// uses would be a good idea when implementing a system like this!
    /// </summary>
    public static SobelManager Instance
    {
        get
        {
            return _instance = _instance ?? new SobelManager();
        }
    }

    #endregion

    /// <summary>
    /// The collection of distortion effects 
    /// </summary>
    private readonly List<SobelEffect> _sobelEffects = new List<SobelEffect>();

    /// <summary>
    /// Registers an effect with the manager.
    /// </summary>
    public void Register(SobelEffect sobelEffect)
    {
        _sobelEffects.Add(sobelEffect);
    }

    /// <summary>
    /// Deregisters an effect from the manager.
    /// </summary>
    public void Deregister(SobelEffect sobelEffect)
    {
        _sobelEffects.Remove(sobelEffect);
    }

    /// <summary>
    /// Adds the commands which draw the registered renderers to the target CommandBuffer.
    /// </summary>
    public void PopulateCommandBuffer(CommandBuffer commandBuffer)
    {
        for (int i = 0, len = _sobelEffects.Count; i < len; i++)
        {
            var effect = _sobelEffects[i];
            commandBuffer.DrawRenderer(effect.Renderer, effect.Material);
        }
    }
}
