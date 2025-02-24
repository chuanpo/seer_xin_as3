package com.robot.core.info.fightInfo
{
   import flash.utils.IDataInput;
   
   public class FightPetInfo
   {
      private var _userID:uint;
      
      private var _petID:uint;
      
      private var _petName:String;
      
      private var _catchTime:uint;
      
      private var _hp:uint;
      
      private var _maxHP:uint;
      
      private var _lv:uint;
      
      private var _catchable:Boolean;
      
      public function FightPetInfo(data:IDataInput)
      {
         super();
         this._userID = data.readUnsignedInt();
         this._petID = data.readUnsignedInt();
         this._petName = data.readUTFBytes(16);
         this._catchTime = data.readUnsignedInt();
         this._hp = data.readUnsignedInt();
         this._maxHP = data.readUnsignedInt();
         this._lv = data.readUnsignedInt();
         this._catchable = data.readUnsignedInt() == 1;
         if(this._hp > this._maxHP)
         {
            this._maxHP = this._hp;
         }
         trace("\r\rfigher：",this._userID,"pet：",this._petID,"name:",this._petName,"catchTime:",this._catchTime,"catchable",this._catchable,"\r\r");
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
      
      public function get petName() : String
      {
         return this._petName;
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
      
      public function get hp() : uint
      {
         return this._hp;
      }
      
      public function get maxHP() : uint
      {
         return this._maxHP;
      }
      
      public function get level() : uint
      {
         return this._lv;
      }
      
      public function get catchable() : Boolean
      {
         return this._catchable;
      }
   }
}

