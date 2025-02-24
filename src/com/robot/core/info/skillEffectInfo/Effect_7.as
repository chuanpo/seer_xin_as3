package com.robot.core.info.skillEffectInfo
{
   public class Effect_7 extends AbstractEffectInfo
   {
      public function Effect_7()
      {
         super();
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "对方体力高于自己时才能命中，将对方体力减到和自己相同";
      }
   }
}

