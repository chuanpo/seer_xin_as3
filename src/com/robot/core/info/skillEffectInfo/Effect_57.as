package com.robot.core.info.skillEffectInfo
{
   public class Effect_57 extends AbstractEffectInfo
   {
      public function Effect_57()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return array[0] + "回合内每回合恢复自身体力1/" + array[1];
      }
   }
}

