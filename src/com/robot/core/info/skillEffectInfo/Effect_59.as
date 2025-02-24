package com.robot.core.info.skillEffectInfo
{
   public class Effect_59 extends AbstractEffectInfo
   {
      public function Effect_59()
      {
         super();
         _argsNum = 1;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         return "消耗自身全部体力(体力降到0), 使下一只出战精灵的特攻和特防能力提升1个等级";
      }
   }
}

