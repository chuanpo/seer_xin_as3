package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKInfo
   {
      private var _groupID:uint;
      
      private var _homeTeamID:uint;
      
      public function TeamPKInfo(data:IDataInput)
      {
         super();
         this._groupID = data.readUnsignedInt();
         this._homeTeamID = data.readUnsignedInt();
      }
      
      public function get groupID() : uint
      {
         return this._groupID;
      }
      
      public function get homeTeamID() : uint
      {
         return this._homeTeamID;
      }
      
      public function set homeTeamID(i:uint) : void
      {
         this._homeTeamID = i;
      }
   }
}

