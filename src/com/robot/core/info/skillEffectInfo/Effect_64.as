package com.robot.core.info.skillEffectInfo
{
   public class Effect_64 extends AbstractEffectInfo
   {
      public function Effect_64()
      {
         super();
         _argsNum = 0;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "自身在烧伤、冻伤、中毒状态下造成的伤害反而加倍";
      }
   }
}

