package com.robot.core.info.skillEffectInfo
{
   public class Effect_37 extends AbstractEffectInfo
   {
      public function Effect_37()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "自身HP小于1/" + array[0] + "时威力加" + array[1] + "倍";
      }
   }
}

