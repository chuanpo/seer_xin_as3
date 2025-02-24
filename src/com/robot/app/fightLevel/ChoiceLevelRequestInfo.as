package com.robot.app.fightLevel
{
   import flash.utils.IDataInput;
   
   public class ChoiceLevelRequestInfo
   {
      private var bossId:uint;
      
      private var curFightLevel:uint;
      
      private var _bossIdA:Array;
      
      public function ChoiceLevelRequestInfo(data:IDataInput)
      {
         super();
         this._bossIdA = [];
         this.curFightLevel = data.readUnsignedInt();
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
      
      public function get getLevel() : uint
      {
         return this.curFightLevel;
      }
   }
}

