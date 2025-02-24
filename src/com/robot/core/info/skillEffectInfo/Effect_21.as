package com.robot.core.info.skillEffectInfo
{
   public class Effect_21 extends AbstractEffectInfo
   {
      public function Effect_21()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         var str:String = null;
         if(array[0] != array[1])
         {
            str = "作用" + array[0] + "~" + array[1] + "回合，每回合反弹对手1/" + array[2] + "的伤害";
         }
         else
         {
            str = "作用" + array[0] + "回合，每回合反弹对手1/" + array[2] + "的伤害";
         }
         return str;
      }
   }
}

