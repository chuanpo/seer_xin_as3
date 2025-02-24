package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class SeerChartsItemInfo
   {
      private var _rank:uint;
      
      private var _uid:uint;
      
      private var _teamID:uint;
      
      private var _score:uint;
      
      private var _win:uint;
      
      private var _lost:uint;
      
      private var _draw:uint;
      
      private var _killPlayerCount:uint;
      
      private var _killBuildCount:uint;
      
      private var _mvp:uint;
      
      public function SeerChartsItemInfo(data:IDataInput)
      {
         super();
         this._rank = data.readUnsignedInt();
         this._uid = data.readUnsignedInt();
         this._teamID = data.readUnsignedInt();
         this._score = data.readUnsignedInt();
         this._win = data.readUnsignedInt();
         this._lost = data.readUnsignedInt();
         this._draw = data.readUnsignedInt();
         this._killPlayerCount = data.readUnsignedInt();
         this._killBuildCount = data.readUnsignedInt();
         this._mvp = data.readUnsignedInt();
      }
      
      public function get rank() : uint
      {
         return this._rank;
      }
      
      public function get uid() : uint
      {
         return this._uid;
      }
      
      public function get teamID() : uint
      {
         return this._teamID;
      }
      
      public function get score() : uint
      {
         return this._score;
      }
      
      public function get win() : uint
      {
         return this._win;
      }
      
      public function get lost() : uint
      {
         return this._lost;
      }
      
      public function get draw() : uint
      {
         return this._draw;
      }
      
      public function get killPlayerCount() : uint
      {
         return this._killPlayerCount;
      }
      
      public function get killBuildCount() : uint
      {
         return this._killBuildCount;
      }
      
      public function get mvp() : uint
      {
         return this._mvp;
      }
   }
}

