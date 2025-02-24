package com.robot.core.info.skillEffectInfo
{
   public class Effect_38 extends AbstractEffectInfo
   {
      public function Effect_38()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "降低对方" + array[0] + "点战斗时的最高HP";
      }
   }
}

