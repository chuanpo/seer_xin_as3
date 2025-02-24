package com.robot.core.info.skillEffectInfo
{
   public class Effect_52 extends AbstractEffectInfo
   {
      public function Effect_52()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return array[0] + "回合若本方先手攻击，使得对方的技能失效";
      }
   }
}

