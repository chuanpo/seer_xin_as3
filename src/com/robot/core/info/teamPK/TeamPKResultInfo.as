package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPKResultInfo
   {
      private var _flag:uint;
      
      private var _mvp_uid:uint;
      
      private var _result:uint;
      
      private var _thisPoint:uint;
      
      private var _get_flag:int;
      
      private var _destroy_hqrts:int;
      
      private var _team_kill_player:int;
      
      private var _team_kill_building:int;
      
      private var _gain_coins:int;
      
      private var _gain_badge:int;
      
      private var _gain_exp:int;
      
      private var _freez_times:int;
      
      private var _kill_player:int;
      
      private var _kill_building:int;
      
      public function TeamPKResultInfo(data:IDataInput)
      {
         super();
         this._flag = data.readUnsignedInt();
         this._result = data.readUnsignedInt();
         if(this._flag == 0)
         {
            return;
         }
         this._mvp_uid = data.readUnsignedInt();
         this._thisPoint = data.readUnsignedInt();
         this._get_flag = data.readInt();
         this._destroy_hqrts = data.readInt();
         this._team_kill_player = data.readInt();
         this._team_kill_building = data.readInt();
         this._gain_coins = data.readInt();
         this._gain_badge = data.readInt();
         this._gain_exp = data.readInt();
         this._freez_times = data.readInt();
         this._kill_player = data.readInt();
         this._kill_building = data.readInt();
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
      
      public function get killBuilding() : int
      {
         return this._kill_building;
      }
      
      public function get killPlayer() : int
      {
         return this._kill_player;
      }
      
      public function get freezTimes() : int
      {
         return this._freez_times;
      }
      
      public function get getExp() : int
      {
         return this._gain_exp;
      }
      
      public function get getCoins() : int
      {
         return this._gain_coins;
      }
      
      public function get getBadge() : int
      {
         return this._gain_badge;
      }
      
      public function get teamKillBuilding() : int
      {
         return this._team_kill_building;
      }
      
      public function get teamKillPlayer() : int
      {
         return this._team_kill_player;
      }
      
      public function get isDestroyHqrts() : Boolean
      {
         if(this._destroy_hqrts == 0)
         {
            return false;
         }
         return true;
      }
      
      public function get isGetFlag() : Boolean
      {
         if(this._get_flag == 0)
         {
            return false;
         }
         return true;
      }
      
      public function get thisScore() : uint
      {
         return this._thisPoint;
      }
      
      public function get result() : uint
      {
         return this._result;
      }
      
      public function get mvpUID() : uint
      {
         return this._mvp_uid;
      }
   }
}

