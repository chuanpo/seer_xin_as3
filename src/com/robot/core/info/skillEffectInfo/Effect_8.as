package com.robot.core.info.skillEffectInfo
{
   public class Effect_8 extends AbstractEffectInfo
   {
      public function Effect_8()
      {
         super();
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "伤害大于对方体力时,对方会余下1体力";
      }
   }
}

