package com.robot.core.info.skillEffectInfo
{
   public class Effect_48 extends AbstractEffectInfo
   {
      public function Effect_48()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return array[0] + "回合内不会出现异常状态";
      }
   }
}

