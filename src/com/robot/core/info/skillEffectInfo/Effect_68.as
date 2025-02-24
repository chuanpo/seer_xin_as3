package com.robot.core.info.skillEffectInfo
{
   public class Effect_68 extends AbstractEffectInfo
   {
      public function Effect_68()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "1回合内，受到致死攻击时则余下1点体力";
      }
   }
}

