package com.robot.core.info.skillEffectInfo
{
   public class Effect_66 extends AbstractEffectInfo
   {
      public function Effect_66()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "当次攻击击败对方出战精灵时恢复自身最大体力的1/" + array[0];
      }
   }
}

