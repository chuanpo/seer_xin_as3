package com.robot.app.freshFightLevel
{
   import flash.utils.IDataInput;
   
   public class FreshChoiceLevelRequestInfo
   {
      private var bossId:uint;
      
      private var curFightLevel:uint;
      
      private var _bossIdA:Array;
      
      public function FreshChoiceLevelRequestInfo(data:IDataInput = null)
      {
         var length:uint = 0;
         var i1:int = 0;
         super();
         if(data != null)
         {
            this._bossIdA = [];
            this.curFightLevel = data.readUnsignedInt();
            length = uint(data.readUnsignedInt());
            for(i1 = 0; i1 < length; i1++)
            {
               this._bossIdA.push(data.readUnsignedInt());
            }
         }
      }
      
      public function get getBossId() : Array
      {
         return this._bossIdA;
      }
      
      public function get getLevel() : uint
      {
         return this.curFightLevel;
      }
   }
}

