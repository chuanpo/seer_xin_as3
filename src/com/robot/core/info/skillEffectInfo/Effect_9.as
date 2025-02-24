package com.robot.core.info.skillEffectInfo
{
   public class Effect_9 extends AbstractEffectInfo
   {
      public function Effect_9()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "连续使用每次威力增加" + array[0] + "，最高威力" + array[1];
      }
   }
}

