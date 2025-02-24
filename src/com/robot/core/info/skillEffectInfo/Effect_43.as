package com.robot.core.info.skillEffectInfo
{
   public class Effect_43 extends AbstractEffectInfo
   {
      public function Effect_43()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "恢复自身最大体力的1/" + array[0];
      }
   }
}

