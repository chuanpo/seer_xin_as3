package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKJoinInfo
   {
      private var _homeUserList:Array;
      
      private var _awayUserList:Array;
      
      private var _homeid:uint;
      
      private var _awayid:uint;
      
      public function TeamPKJoinInfo(data:IDataInput)
      {
         var i:uint = 0;
         this._homeUserList = [];
         this._awayUserList = [];
         super();
         this._homeid = data.readUnsignedInt();
         var homeCount:uint = uint(data.readUnsignedInt());
         for(i = 0; i < homeCount; i++)
         {
            this._homeUserList.push(new TeamPkUserInfo(data));
         }
         this._awayid = data.readUnsignedInt();
         var awayCount:uint = uint(data.readUnsignedInt());
         for(i = 0; i < awayCount; i++)
         {
            this._awayUserList.push(new TeamPkUserInfo(data));
         }
      }
      
      public function get homeTeamId() : uint
      {
         return this._homeid;
      }
      
      public function get awayTeamId() : uint
      {
         return this._awayid;
      }
      
      public function get homeUserList() : Array
      {
         return this._homeUserList;
      }
      
      public function get awayUserList() : Array
      {
         return this._awayUserList;
      }
   }
}

