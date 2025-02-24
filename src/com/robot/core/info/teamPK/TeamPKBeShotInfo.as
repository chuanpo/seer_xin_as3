package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKBeShotInfo
   {
      public static const PLAYER_TO_PLAYER:uint = 1;
      
      public static const PLAYER_TO_BUILDING:uint = 2;
      
      public static const BUILDING_TO_PLAYER:uint = 3;
      
      private var _type:uint;
      
      private var _dmg:uint;
      
      private var _crit:uint;
      
      private var _shooter:ShooterInfo;
      
      private var _beShooter:ShooterInfo;
      
      public function TeamPKBeShotInfo(data:IDataInput)
      {
         super();
         this._type = data.readUnsignedInt();
         this._dmg = data.readUnsignedInt();
         this._crit = data.readUnsignedInt();
         this._shooter = new ShooterInfo(data);
         this._beShooter = new ShooterInfo(data);
      }
      
      public function get shotType() : uint
      {
         return this._type;
      }
      
      public function get damage() : uint
      {
         return this._dmg;
      }
      
      public function isCrit() : Boolean
      {
         return Boolean(this._crit);
      }
      
      public function shooter() : ShooterInfo
      {
         return this._shooter;
      }
      
      public function beShooer() : ShooterInfo
      {
         return this._beShooter;
      }
   }
}

