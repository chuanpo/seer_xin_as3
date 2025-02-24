package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class CateInfo
   {
      private var _id:uint;
      
      private var _count:uint;
      
      public function CateInfo(data:IDataInput)
      {
         super();
         this._id = data.readUnsignedInt();
         this._count = data.readUnsignedInt();
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get count() : uint
      {
         return this._count;
      }
   }
}

