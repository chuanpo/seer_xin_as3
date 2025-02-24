package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKFreezeInfo
   {
      private var _flag:uint;
      
      private var _uid:uint;
      
      public function TeamPKFreezeInfo(data:IDataInput)
      {
         super();
         this._flag = data.readUnsignedInt();
         this._uid = data.readUnsignedInt();
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
      
      public function get uid() : uint
      {
         return this._uid;
      }
   }
}

