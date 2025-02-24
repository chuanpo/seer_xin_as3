package com.robot.app.fightLevel
{
   import flash.utils.IDataInput;
   
   public class SuccessFightRequestInfo
   {
      private var bossId:Array;
      
      private var curLevel:uint;
      
      private var _bossIdA:Array;
      
      public function SuccessFightRequestInfo(data:IDataInput)
      {
         super();
         this._bossIdA = [];
         this.curLevel = data.readUnsignedInt();
         var length:uint = uint(data.readUnsignedInt());
         for(var i1:int = 0; i1 < length; i1++)
         {
            this._bossIdA.push(data.readUnsignedInt());
         }
      }
      
      public function get getBossId() : Array
      {
         return this._bossIdA;
      }
      
      public function get getCurLevel() : uint
      {
         return this.curLevel;
      }
   }
}

