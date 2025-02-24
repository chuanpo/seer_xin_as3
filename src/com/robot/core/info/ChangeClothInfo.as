package com.robot.core.info
{
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import flash.utils.IDataInput;
   
   public class ChangeClothInfo
   {
      private var _userID:uint;
      
      private var _clothArray:Array;
      
      public function ChangeClothInfo(data:IDataInput)
      {
         var id:uint = 0;
         var level:uint = 0;
         this._clothArray = [];
         super();
         this._userID = data.readUnsignedInt();
         var count:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < count; i++)
         {
            id = uint(data.readUnsignedInt());
            level = uint(data.readUnsignedInt());
            this._clothArray.push(new PeopleItemInfo(id,level));
         }
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get clothArray() : Array
      {
         return this._clothArray;
      }
   }
}

