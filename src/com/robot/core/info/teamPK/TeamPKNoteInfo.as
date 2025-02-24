package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKNoteInfo
   {
      private var _selfTeamID:uint;
      
      private var _homeTeamID:uint;
      
      private var _awayTeamID:uint;
      
      private var _event:uint;
      
      private var _time:int;
      
      public function TeamPKNoteInfo(data:IDataInput)
      {
         super();
         this._selfTeamID = data.readUnsignedInt();
         this._homeTeamID = data.readUnsignedInt();
         this._awayTeamID = data.readUnsignedInt();
         this._event = data.readUnsignedInt();
         this._time = data.readInt();
      }
      
      public function get homeTeamID() : uint
      {
         return this._homeTeamID;
      }
      
      public function get awayTeamID() : uint
      {
         return this._awayTeamID;
      }
      
      public function get selfTeamID() : uint
      {
         return this._selfTeamID;
      }
      
      public function get event() : uint
      {
         return this._event;
      }
   }
}

