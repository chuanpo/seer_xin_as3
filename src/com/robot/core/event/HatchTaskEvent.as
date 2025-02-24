package com.robot.core.event
{
   import flash.events.Event;
   
   public class HatchTaskEvent extends Event
   {
      public static const COMPLETE:String = "complete";
      
      public static const GET_PRO_STATUS:String = "getProStatus";
      
      public static const SET_PRO_STATUS:String = "setProStatus";
      
      public static const GET_PRO_STATUS_LIST:String = "getProStatusList";
      
      private var _actType:String;
      
      private var _taskID:uint;
      
      private var _itemID:uint;
      
      private var _pro:uint;
      
      private var _data:Array;
      
      public function HatchTaskEvent(actType:String, taskID:uint, itemID:uint, pro:uint, data:Array = null)
      {
         super(actType + "_" + taskID.toString() + "_" + itemID.toString() + pro.toString());
         this._actType = actType;
         this._taskID = taskID;
         this._itemID = itemID;
         this._pro = pro;
         this._data = data;
      }
      
      public function get actType() : String
      {
         return this._actType;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function get pro() : uint
      {
         return this._pro;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
   }
}

