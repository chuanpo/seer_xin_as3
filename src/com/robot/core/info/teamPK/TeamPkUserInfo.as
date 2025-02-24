package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPkUserInfo
   {
      private var _uid:uint;
      
      private var _hp:uint;
      
      private var _maxHp:uint;
      
      private var _where:uint;
      
      public function TeamPkUserInfo(data:IDataInput)
      {
         super();
         this._uid = data.readUnsignedInt();
         this._hp = data.readUnsignedInt();
         this._maxHp = data.readUnsignedInt();
         this._where = data.readUnsignedInt();
         data.readUnsignedInt();
         data.readUnsignedInt();
      }
      
      public function get uid() : uint
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
      
      public function get isFreeze() : Boolean
      {
         return this._where == 2;
      }
   }
}

