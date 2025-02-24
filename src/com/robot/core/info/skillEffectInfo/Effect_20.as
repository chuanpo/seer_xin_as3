package com.robot.core.info.skillEffectInfo
{
   public class Effect_20 extends AbstractEffectInfo
   {
      public function Effect_20()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return array[0] + "%令本方疲惫，" + array[1] + "回合无法攻击";
      }
   }
}

