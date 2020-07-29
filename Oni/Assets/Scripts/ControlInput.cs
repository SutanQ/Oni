using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ControlInput
{
    public int PlayerNum;        //玩家號碼
    public string Horizontal;    //控制器左類比(水平)
    public string Vertical;      //控制器左類比(垂直)
    public string StartButton;   //Start鍵
    public string ConfirmButton; //確認鍵
    public string CancelButton;  //取消鍵
    public string AttackButton;  //攻擊鍵
    public string JumpButton;    //跳躍鍵
    public string SpecialButton; //特殊鍵
    public string DashButton;    //衝刺鍵
    public string MagicButton;   //魔法鍵
    public string RBButton;      //RB
    public string LBButton;      //RB
    public string ChangeMagicLeftutton;    //向左切換魔法鍵
    public string ChangeMagicRightButton;  //向右切換魔法鍵

    public void SetPlayerNum(int num = 0)
    {
        PlayerNum = num;
        if (PlayerNum == 0)
        {
            Horizontal = "Horizontal";
            Vertical = "Vertical";
            ConfirmButton = "Fire1";
            CancelButton = "Cancel";
            AttackButton = ConfirmButton;
            JumpButton = "Jump";
            SpecialButton = "Fire2";
            //DashButton = "Space";
        }
        else
        {
            Horizontal = "Joy" + PlayerNum + "X";
            Vertical = "Joy" + PlayerNum + "Y";

            if (Input.GetJoystickNames().Length <= 0)
                return;
            string controllerName = Input.GetJoystickNames()[PlayerNum - 1];
            /*
            if ((PlayerNum - 1) < Input.GetJoystickNames().Length)
            {
                string controllerName = Input.GetJoystickNames()[PlayerNum - 1];
               // Debug.Log(PlayerNum);
                if (controllerName.Length == 19)
                {
                    //Debug.Log("PS4");
                    GameData.controllerTypes[PlayerNum - 1] = ControllerType.PlayStation;
                }
                else if (controllerName.Length == 33)
                {
                    //Debug.Log("XBOX");
                    GameData.controllerTypes[PlayerNum - 1] = ControllerType.XBOX;
                }
                else
                {
                    //Debug.Log("None");
                    GameData.controllerTypes[PlayerNum - 1] = ControllerType.None;
                }
            }
            */

            //XBOX
            if (controllerName.Length == 33 /*GameData.controllerTypes[PlayerNum-1] == ControllerType.XBOX*/)
            {
                CancelButton = "Joy" + PlayerNum + "BorX";
                ConfirmButton = "Joy" + PlayerNum + "AorSquare";
                SpecialButton = "Joy" + PlayerNum + "YorTriangle";
                DashButton = "Joy" + PlayerNum + "XorCircle";
                StartButton = "Joy" + PlayerNum + "StartorR2";
                RBButton = "Joy" + PlayerNum + "RBorR1";
                LBButton = "Joy" + PlayerNum + "LBorL1";
            }
            else //PS4
            {
                CancelButton = "Joy" + PlayerNum + "BorX";
                ConfirmButton = "Joy" + PlayerNum + "XorCircle";
                SpecialButton = "Joy" + PlayerNum + "YorTriangle";
                DashButton = "Joy" + PlayerNum + "AorSquare";
                StartButton = "Joy" + PlayerNum + "RSorOption";
                RBButton = "Joy" + PlayerNum + "RBorR1";
                LBButton = "Joy" + PlayerNum + "LBorL1";
            }

            //YorTriangle
            AttackButton = ConfirmButton;
            JumpButton = CancelButton;
        }
    }

    public ControlInput(int num = 0)
    {
        SetPlayerNum(num);
    }

}

public enum ControllerType { None, XBOX, PlayStation};
