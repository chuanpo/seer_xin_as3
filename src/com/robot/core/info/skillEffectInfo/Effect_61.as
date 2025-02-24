package com.robot.core.info.skillEffectInfo
{
   public class Effect_61 extends AbstractEffectInfo
   {
      public function Effect_61()
      {
         super();
         _argsNum = 0;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "威力随机，随机范围50~150";
      }
   }
}

