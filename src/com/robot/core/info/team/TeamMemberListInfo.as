package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class TeamMemberListInfo
   {
      private var _teamID:uint;
      
      private var _userList:Array = [];
      
      private var _superCoreNum:uint;
      
      public function TeamMemberListInfo(data:IDataInput)
      {
         super();
         this._teamID = data.readUnsignedInt();
         this._superCoreNum = data.readUnsignedInt();
         var count:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < count; i++)
         {
            this._userList.push(new TeamMemberInfo(data));
         }
      }
      
      public function get teamID() : uint
      {
         return this._teamID;
      }
      
      public function get superCoreNum() : uint
      {
         return this._superCoreNum;
      }
      
      public function get memberList() : Array
      {
         return this._userList;
      }
   }
}

