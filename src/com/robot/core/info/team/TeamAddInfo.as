package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class TeamAddInfo
   {
      private var _ret:uint;
      
      private var _teamID:uint;
      
      public function TeamAddInfo(data:IDataInput)
      {
         super();
         this._ret = data.readUnsignedInt();
         this._teamID = data.readUnsignedInt();
      }
      
      public function get ret() : uint
      {
         return this._ret;
      }
      
      public function get teamID() : uint
      {
         return this._teamID;
      }
   }
}

