package com.robot.core.info.skillEffectInfo
{
   public class Effect_6 extends AbstractEffectInfo
   {
      public function Effect_6()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "对方所受伤害的1/" + array[0] + "会反弹给自己";
      }
   }
}

