package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class DayTalkInfo
   {
      private var _cateCount:uint;
      
      private var _cateList:Array = [];
      
      private var _outCount:uint;
      
      private var _outList:Array = [];
      
      public function DayTalkInfo(data:IDataInput)
      {
         super();
         this._cateCount = data.readUnsignedInt();
         for(var i:int = 0; i < this._cateCount; i++)
         {
            this._cateList.push(new CateInfo(data));
         }
         this._outCount = data.readUnsignedInt();
         for(var k:int = 0; k < this._outCount; k++)
         {
            this._outList.push(new CateInfo(data));
         }
      }
      
      public function get cateCount() : uint
      {
         return this._cateCount;
      }
      
      public function get cateList() : Array
      {
         return this._cateList;
      }
      
      public function get outCount() : uint
      {
         return this._outCount;
      }
      
      public function get outList() : Array
      {
         return this._outList;
      }
   }
}

