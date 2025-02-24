package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKBuildingListInfo
   {
      private var _homeList:Array = [];
      
      private var _awayList:Array = [];
      
      public function TeamPKBuildingListInfo(data:IDataInput)
      {
         super();
         var homeCount:uint = uint(data.readUnsignedInt());
         var headID:uint = uint(data.readUnsignedInt());
         var i:uint = 0;
         for(i = 0; i < homeCount; i++)
         {
            this._homeList.push(new TeamPkBuildingInfo(data,headID));
         }
         var awayCount:uint = uint(data.readUnsignedInt());
         headID = uint(data.readUnsignedInt());
         for(i = 0; i < awayCount; i++)
         {
            this._awayList.push(new TeamPkBuildingInfo(data,headID));
         }
      }
      
      public function get homeList() : Array
      {
         return this._homeList;
      }
      
      public function get awayList() : Array
      {
         return this._awayList;
      }
   }
}

