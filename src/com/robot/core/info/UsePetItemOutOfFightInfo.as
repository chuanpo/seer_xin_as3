package com.robot.core.info
{
   import com.robot.core.info.pet.PetSkillInfo;
   import flash.utils.IDataInput;
   
   public class UsePetItemOutOfFightInfo
   {
      private var _hp:uint;
      
      private var _maxHp:uint;
      
      private var _a:uint;
      
      private var _sa:uint;
      
      private var _d:uint;
      
      private var _sd:uint;
      
      private var _sp:uint;
      
      public var catchTime:uint;
      
      public var id:uint;
      
      public var exp:uint;
      
      public var nick:String;
      
      public var nature:uint;
      
      public var dv:uint;
      
      public var lv:uint;
      
      public var ev_hp:uint;
      
      public var ev_attack:uint;
      
      public var ev_defence:uint;
      
      public var ev_sa:uint;
      
      public var ev_sd:uint;
      
      public var ev_sp:uint;
      
      private var _skillArray:Array = [];
      
      public function UsePetItemOutOfFightInfo(data:IDataInput)
      {
         super();
         this.catchTime = data.readUnsignedInt();
         this.id = data.readUnsignedInt();
         this.nick = data.readUTFBytes(16);
         this.nature = data.readUnsignedInt();
         this.dv = data.readUnsignedInt();
         this.lv = data.readUnsignedInt();
         this._hp = data.readUnsignedInt();
         this._maxHp = data.readUnsignedInt();
         this.exp = data.readUnsignedInt();
         this.ev_hp = data.readUnsignedInt();
         this.ev_attack = data.readUnsignedInt();
         this.ev_defence = data.readUnsignedInt();
         this.ev_sa = data.readUnsignedInt();
         this.ev_sd = data.readUnsignedInt();
         this.ev_sp = data.readUnsignedInt();
         this._a = data.readUnsignedInt();
         this._sa = data.readUnsignedInt();
         this._d = data.readUnsignedInt();
         this._sd = data.readUnsignedInt();
         this._sp = data.readUnsignedInt();
         var num:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < num; i++)
         {
            this._skillArray.push(new PetSkillInfo(data));
         }
      }
      
      public function get hp() : uint
      {
         return this._hp;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
      
      public function get a() : uint
      {
         return this._a;
      }
      
      public function get sa() : uint
      {
         return this._sa;
      }
      
      public function get d() : uint
      {
         return this._d;
      }
      
      public function get sd() : uint
      {
         return this._sd;
      }
      
      public function get sp() : uint
      {
         return this._sp;
      }
      
      public function get skillArray() : Array
      {
         return this._skillArray;
      }
   }
}

