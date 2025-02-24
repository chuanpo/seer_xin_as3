package com.robot.core.info.task.novice
{
   import flash.utils.IDataInput;
   
   public class NoviceBufInfo
   {
      private var _taskId:uint;
      
      private var _flag:uint;
      
      private var _buf:String;
      
      public function NoviceBufInfo(data:IDataInput)
      {
         super();
         this._taskId = data.readUnsignedInt();
         this._flag = data.readUnsignedInt();
         this._buf = data.readUTFBytes(100);
      }
      
      public function get taskId() : uint
      {
         return this._taskId;
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
      
      public function get buf() : String
      {
         return this._buf;
      }
   }
}

