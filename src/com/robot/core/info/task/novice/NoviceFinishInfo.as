package com.robot.core.info.task.novice
{
   import flash.utils.IDataInput;
   
   public class NoviceFinishInfo
   {
      private var _taskID:uint;
      
      private var _petID:uint;
      
      private var _captureTm:uint;
      
      private var _itemID:uint;
      
      private var _itemCnt:uint;
      
      private var _monBallList:Array;
      
      public function NoviceFinishInfo(data:IDataInput)
      {
         super();
         this._monBallList = new Array();
         this._taskID = data.readUnsignedInt();
         this._petID = data.readUnsignedInt();
         this._captureTm = data.readUnsignedInt();
         var itemCount:uint = data.readUnsignedInt();
         for(var i:uint = 0; i < itemCount; i++)
         {
            this._itemID = data.readUnsignedInt();
            this._itemCnt = data.readUnsignedInt();
            this._monBallList.push({
               "itemID":this._itemID,
               "itemCnt":this._itemCnt
            });
         }
      }
      
      public function get monBallList() : Array
      {
         return this._monBallList;
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
      
      public function get captureTm() : uint
      {
         return this._captureTm;
      }
   }
}

