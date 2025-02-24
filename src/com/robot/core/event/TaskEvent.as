package com.robot.core.event
{
   import flash.events.Event;
   
   public class TaskEvent extends Event
   {
      public static const ACCEPT:String = "accept";
      
      public static const COMPLETE:String = "complete";
      
      public static const QUIT:String = "quit";
      
      public static const GET_PRO_STATUS:String = "getProStatus";
      
      public static const SET_PRO_STATUS:String = "setProStatus";
      
      public static const GET_PRO_STATUS_LIST:String = "getProStatusList";
      
      private var _actType:String;
      
      private var _taskID:uint;
      
      private var _pro:uint;
      
      private var _flag:Boolean;
      
      private var _data:Array;
      
      public function TaskEvent(actType:String, taskID:uint, pro:uint, flag:Boolean, data:Array = null)
      {
         super(actType + "_" + taskID.toString() + "_" + pro.toString());
         this._actType = actType;
         this._taskID = taskID;
         this._pro = pro;
         this._flag = flag;
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
      
      public function get pro() : uint
      {
         return this._pro;
      }
      
      public function get flag() : Boolean
      {
         return this._flag;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
   }
}

