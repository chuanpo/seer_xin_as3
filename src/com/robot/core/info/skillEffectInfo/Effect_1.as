package com.robot.core.info.skillEffectInfo
{
   public class Effect_1 extends AbstractEffectInfo
   {
      public function Effect_1()
      {
         super();
         _argsNum = 0;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "给予对方损伤的一半会回复自己的体力";
      }
   }
}

