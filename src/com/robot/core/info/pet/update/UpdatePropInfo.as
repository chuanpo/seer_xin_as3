package com.robot.core.info.pet.update
{
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.PetManager;
   import flash.utils.IDataInput;
   
   public class UpdatePropInfo
   {
      private var _catchTime:uint;
      
      private var _id:uint;
      
      private var _level:uint;
      
      private var _exp:uint;
      
      private var _maxHp:uint;
      
      private var _attack:uint;
      
      private var _defence:uint;
      
      private var _sa:uint;
      
      private var _sd:uint;
      
      private var _sp:uint;
      
      private var _ev_hp:uint;
      
      private var _ev_a:uint;
      
      private var _ev_d:uint;
      
      private var _ev_sa:uint;
      
      private var _ev_sd:uint;
      
      private var _ev_sp:uint;
      
      private var _currentLvExp:uint;
      
      private var _nextLvExp:uint;
      
      public function UpdatePropInfo(data:IDataInput)
      {
         super();
         this._catchTime = data.readUnsignedInt();
         this._id = data.readUnsignedInt();
         this._level = data.readUnsignedInt();
         this._exp = data.readUnsignedInt();
         this._currentLvExp = data.readUnsignedInt();
         this._nextLvExp = data.readUnsignedInt();
         this._maxHp = data.readUnsignedInt();
         this._attack = data.readUnsignedInt();
         this._defence = data.readUnsignedInt();
         this._sa = data.readUnsignedInt();
         this._sd = data.readUnsignedInt();
         this._sp = data.readUnsignedInt();
         this._ev_hp = data.readUnsignedInt();
         this._ev_a = data.readUnsignedInt();
         this._ev_d = data.readUnsignedInt();
         this._ev_sa = data.readUnsignedInt();
         this._ev_sd = data.readUnsignedInt();
         this._ev_sp = data.readUnsignedInt();
      }
      
      public function update() : void
      {
         var petInfo:PetInfo = null;
         petInfo = PetManager.getPetInfo(this._catchTime);
         petInfo.id = this.id;
         petInfo.level = this.level;
         petInfo.maxHp = this.maxHp;
         petInfo.attack = this.attack;
         petInfo.defence = this.defence;
         petInfo.s_a = this.sa;
         petInfo.s_d = this.sd;
         petInfo.speed = this.sp;
         petInfo.exp = this.exp;
         petInfo.nextLvExp = this.nextLvExp;
         petInfo.lvExp = this.currentLvExp;
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get level() : uint
      {
         return this._level;
      }
      
      public function get exp() : uint
      {
         return this._exp;
      }
      
      public function get currentLvExp() : uint
      {
         return this._currentLvExp;
      }
      
      public function get nextLvExp() : uint
      {
         return this._nextLvExp;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
      
      public function get attack() : uint
      {
         return this._attack;
      }
      
      public function get defence() : uint
      {
         return this._defence;
      }
      
      public function get sa() : uint
      {
         return this._sa;
      }
      
      public function get sd() : uint
      {
         return this._sd;
      }
      
      public function get sp() : uint
      {
         return this._sp;
      }
   }
}

