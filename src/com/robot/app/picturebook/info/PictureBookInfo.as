package com.robot.app.picturebook.info
{
   import flash.utils.IDataInput;
   
   public class PictureBookInfo
   {
      private var _id:uint;
      
      private var _encont:uint;
      
      private var _isCacth:Boolean;
      
      public function PictureBookInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this._id = data.readUnsignedInt();
            this._encont = data.readUnsignedInt();
            this._isCacth = Boolean(data.readUnsignedInt());
            data.readUnsignedInt();
         }
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get encont() : uint
      {
         return this._encont;
      }
      
      public function get isCacth() : Boolean
      {
         return this._isCacth;
      }
   }
}

