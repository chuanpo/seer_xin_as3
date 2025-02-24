package com.robot.app.superParty
{
   public class SuperPartyInfo
   {
      private var _mapID:uint;
      
      private var _petIDs:Array;
      
      private var _oreIDs:Array;
      
      private var _games:Array;
      
      public function SuperPartyInfo()
      {
         super();
      }
      
      public function get mapID() : uint
      {
         return this._mapID;
      }
      
      public function set mapID(id:uint) : void
      {
         this._mapID = id;
      }
      
      public function get petIDs() : Array
      {
         return this._petIDs;
      }
      
      public function set petIDs(a:Array) : void
      {
         this._petIDs = a;
      }
      
      public function get oreIDs() : Array
      {
         return this._oreIDs;
      }
      
      public function set oreIDs(a:Array) : void
      {
         this._oreIDs = a;
      }
      
      public function get games() : Array
      {
         return this._games;
      }
      
      public function set games(a:Array) : void
      {
         this._games = a;
      }
   }
}

