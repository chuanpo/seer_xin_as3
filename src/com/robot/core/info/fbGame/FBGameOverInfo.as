package com.robot.core.info.fbGame
{
   import flash.utils.IDataInput;
   
   public class FBGameOverInfo
   {
      private var _array:Array = [];
      
      public function FBGameOverInfo(data:IDataInput)
      {
         super();
         var count:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < count; i++)
         {
            this._array.push(new GameOverUserInfo(data));
         }
      }
      
      public function get userList() : Array
      {
         return this._array;
      }
   }
}

