package com.robot.core.info.skillEffectInfo
{
   public class Effect_41 extends AbstractEffectInfo
   {
      public function Effect_41()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         var str:String = null;
         if(array[0] != array[1])
         {
            str = array[0] + "~" + array[1] + "回合本方受到的火系攻击伤害减半";
         }
         else
         {
            str = array[0] + "回合本方受到的火系攻击伤害减半";
         }
         return str;
      }
   }
}

