package com.robot.core.info.skillEffectInfo
{
   public class Effect_58 extends AbstractEffectInfo
   {
      public function Effect_58()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "使自身在接下来的" + array[0] + "回合中每次直接攻击必定致命一击";
      }
   }
}

