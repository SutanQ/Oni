using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(IdlePath))]
public class IdlePathEditor : Editor
{
    public override void OnInspectorGUI()
    {
        //base.OnInspectorGUI();
        IdlePath idlePath = (IdlePath)target;

        DrawDefaultInspector();

        if (GUILayout.Button("Create Next Point"))
            idlePath.CreatePoint();
    }
}
