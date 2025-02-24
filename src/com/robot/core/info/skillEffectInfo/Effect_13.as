package com.robot.core.info.skillEffectInfo
{
   public class Effect_13 extends AbstractEffectInfo
   {
      public function Effect_13()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return array[0] + "回合吸取对方最大体力的1/8(对草系无效)";
      }
   }
}

