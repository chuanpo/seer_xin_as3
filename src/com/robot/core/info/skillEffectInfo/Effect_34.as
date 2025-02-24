package com.robot.core.info.skillEffectInfo
{
   public class Effect_34 extends AbstractEffectInfo
   {
      public function Effect_34()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "将所受的伤害" + array[0] + "倍反馈给对手";
      }
   }
}

