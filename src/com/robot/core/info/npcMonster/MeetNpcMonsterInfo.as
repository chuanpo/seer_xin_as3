package com.robot.core.info.npcMonster
{
   import flash.utils.IDataInput;
   
   public class MeetNpcMonsterInfo
   {
      private var _rect:uint;
      
      public function MeetNpcMonsterInfo(data:IDataInput)
      {
         super();
         this._rect = data.readUnsignedInt();
      }
      
      public function get rect() : uint
      {
         return this._rect;
      }
   }
}

