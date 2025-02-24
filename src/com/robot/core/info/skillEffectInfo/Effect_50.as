package com.robot.core.info.skillEffectInfo
{
   public class Effect_50 extends AbstractEffectInfo
   {
      public function Effect_50()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return array[0] + "回合自身受到物理攻击伤害减半";
      }
   }
}

