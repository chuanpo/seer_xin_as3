package com.robot.core.info.skillEffectInfo
{
   public class Effect_44 extends AbstractEffectInfo
   {
      public function Effect_44()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return array[0] + "回合自己受到特殊攻击伤害减半";
      }
   }
}

