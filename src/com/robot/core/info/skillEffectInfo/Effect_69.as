package com.robot.core.info.skillEffectInfo
{
   public class Effect_69 extends AbstractEffectInfo
   {
      public function Effect_69()
      {
         super();
         _argsNum = 5;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "接下来" + _argsNum + "回合使用体力药剂变成降低相应的体力";
      }
   }
}

