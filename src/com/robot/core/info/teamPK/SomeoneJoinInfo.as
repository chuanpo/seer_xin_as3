package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class SomeoneJoinInfo
   {
      private var _uid:uint;
      
      private var _hp:uint;
      
      private var _maxHp:uint;
      
      public function SomeoneJoinInfo(data:IDataInput)
      {
         super();
         this._uid = data.readUnsignedInt();
         this._hp = data.readUnsignedInt();
         this._maxHp = data.readUnsignedInt();
      }
      
      public function get userID() : uint
      {
         return this._uid;
      }
      
      public function get hp() : uint
      {
         return this._hp;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
   }
}

