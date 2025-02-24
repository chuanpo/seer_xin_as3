package com.robot.core.info.skillEffectInfo
{
   public class Effect_16 extends AbstractEffectInfo
   {
      public function Effect_16()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "命中后" + array[0] + "%令对手睡眠";
      }
   }
}

