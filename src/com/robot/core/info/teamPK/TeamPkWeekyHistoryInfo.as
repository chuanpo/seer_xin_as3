package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPkWeekyHistoryInfo
   {
      public var killPlayer:uint;
      
      public var killBuilding:uint;
      
      public var mvpNum:uint;
      
      public var winTimes:uint;
      
      public var lostTimes:uint;
      
      public var drawTimes:uint;
      
      public var point:uint;
      
      public function TeamPkWeekyHistoryInfo(data:IDataInput)
      {
         super();
         this.killPlayer = data.readUnsignedInt();
         this.killBuilding = data.readUnsignedInt();
         this.mvpNum = data.readUnsignedInt();
         this.winTimes = data.readUnsignedInt();
         this.lostTimes = data.readUnsignedInt();
         this.drawTimes = data.readUnsignedInt();
         this.point = data.readUnsignedInt();
      }
   }
}

