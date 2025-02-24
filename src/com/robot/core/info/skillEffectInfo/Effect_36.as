package com.robot.core.info.skillEffectInfo
{
   public class Effect_36 extends AbstractEffectInfo
   {
      public function Effect_36()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "命中时" + array[0] + "%的概率秒杀对方";
      }
   }
}

