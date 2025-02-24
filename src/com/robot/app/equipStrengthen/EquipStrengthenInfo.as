package com.robot.app.equipStrengthen
{
   public class EquipStrengthenInfo
   {
      private var _itemId:uint;
      
      private var _itemLev:uint;
      
      private var _levelId:uint;
      
      private var _needCatalystId:uint;
      
      private var _needMatterA:Array;
      
      private var _ownNeedA:Array;
      
      private var _needMatterNumA:Array;
      
      private var _des:String;
      
      private var _prob:String;
      
      private var _needCatalystNum:uint;
      
      private var _ownCatalystNum:uint;
      
      private var _sendId:uint;
      
      public function EquipStrengthenInfo()
      {
         super();
      }
      
      public function set sendId(id:uint) : void
      {
         this._sendId = id;
      }
      
      public function get sendId() : uint
      {
         return this._sendId;
      }
      
      public function set ownCatalystNum(num:uint) : void
      {
         this._ownCatalystNum = num;
      }
      
      public function get ownCatalystNum() : uint
      {
         return this._ownCatalystNum;
      }
      
      public function set needCatalystNum(num:uint) : void
      {
         this._needCatalystNum = num;
      }
      
      public function get needCatalystNum() : uint
      {
         return this._needCatalystNum;
      }
      
      public function set ownNeedA(a:Array) : void
      {
         this._ownNeedA = a;
      }
      
      public function get ownNeedA() : Array
      {
         return this._ownNeedA;
      }
      
      public function get itemId() : uint
      {
         return this._itemId;
      }
      
      public function set itemId(id:uint) : void
      {
         this._itemId = id;
      }
      
      public function get levelId() : uint
      {
         return this._levelId;
      }
      
      public function set levelId(id:uint) : void
      {
         this._levelId = id;
      }
      
      public function get needCatalystId() : uint
      {
         return this._needCatalystId;
      }
      
      public function set needCatalystId(id:uint) : void
      {
         this._needCatalystId = id;
      }
      
      public function get needMatterA() : Array
      {
         return this._needMatterA;
      }
      
      public function set needMatterA(a:Array) : void
      {
         this._needMatterA = a;
      }
      
      public function get needMatterNumA() : Array
      {
         return this._needMatterNumA;
      }
      
      public function set needMatterNumA(a:Array) : void
      {
         this._needMatterNumA = a;
      }
      
      public function get prob() : String
      {
         return this._prob;
      }
      
      public function set prob(str:String) : void
      {
         this._prob = str;
      }
      
      public function get des() : String
      {
         return this._des;
      }
      
      public function set des(str:String) : void
      {
         this._des = str;
      }
   }
}

