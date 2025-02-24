package com.robot.core.info.skillEffectInfo
{
   public class Effect_39 extends AbstractEffectInfo
   {
      public function Effect_39()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "命中对方时，有" + array[0] + "%的几率降低对方所有技能" + array[1] + "点PP值";
      }
   }
}

