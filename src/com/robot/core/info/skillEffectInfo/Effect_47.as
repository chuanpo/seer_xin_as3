package com.robot.core.info.skillEffectInfo
{
   public class Effect_47 extends AbstractEffectInfo
   {
      public function Effect_47()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return array[0] + "回合自身不受能力下降技能影响";
      }
   }
}

