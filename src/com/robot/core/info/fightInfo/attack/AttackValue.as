package com.robot.core.info.fightInfo.attack
{
   import flash.utils.IDataInput;
   import com.robot.core.ui.alert.Alarm;
   
   public class AttackValue
   {
      private var _userID:uint;
      
      private var _skillID:uint;
      
      private var _atkTimes:uint;
      
      private var _lostHP:uint;
      
      private var _gainHP:int;
      
      private var _remainHp:int;
      
      private var _maxHp:uint;
      
      private var _isCrit:uint;
      
      private var _status:Array;
      
      private var _state:uint;
      
      private var _battleLv:Array;

      public function AttackValue(data:IDataInput)
      {
         var id:uint = 0;
         var pp:uint = 0;
         this._status = [];
         this._battleLv = [];
         super();
         this._userID = data.readUnsignedInt();
         this._skillID = data.readUnsignedInt();
         this._atkTimes = data.readUnsignedInt();
         this._lostHP = data.readUnsignedInt();
         this._gainHP = data.readInt();
         this._remainHp = data.readInt();
         this._maxHp = data.readUnsignedInt();
         this._state = data.readUnsignedInt();
         var skillCount:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < skillCount; i++)
         {
            id = uint(data.readUnsignedInt());
            pp = uint(data.readUnsignedInt());
         }
         this._isCrit = data.readUnsignedInt();
         for(i = 0; i < 20; i++)
         {
            this._status.push(data.readByte());
         }
         for(j = 0; j < 6; j++)
         {
            this._battleLv.push(data.readByte());
         }
         trace("\r出招用户：",this._userID,"使用技能：",this._skillID,"对方掉血：",this._lostHP,"自己回血:",this._gainHP,"最后血：",this._remainHp,"\r");
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get skillID() : uint
      {
         return this._skillID;
      }
      
      public function get lostHP() : uint
      {
         return this._lostHP;
      }
      
      public function get gainHP() : int
      {
         return this._gainHP;
      }
      
      public function get remainHP() : int
      {
         return this._remainHp;
      }
      
      public function get isCrit() : Boolean
      {
         return this._isCrit == 1;
      }
      
      public function get atkTimes() : uint
      {
         return this._atkTimes;
      }
      
      public function get status() : Array
      {
         return this._status;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
      
      public function get state() : uint
      {
         return this._state;
      }

      public function get battleLv() : Array
      {
         return this._battleLv;
      }
   }
}

