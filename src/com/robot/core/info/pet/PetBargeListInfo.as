package com.robot.core.info.pet
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PetBargeListInfo
   {
      private var _data:ByteArray;
      
      private var _monCount:uint;
      
      private var _monID:uint;
      
      private var _enCntCnt:uint;
      
      private var _isCatched:uint;
      
      private var _isKilled:uint;
      
      private var _petBargeIdList:Array;
      
      private var _isCatchedList:Array;
      
      private var _enCntCntList:Array;
      
      private var _isKillList:Array;
      
      public function PetBargeListInfo(data:IDataInput = null)
      {
         var i:uint = 0;
         this._petBargeIdList = [];
         this._isCatchedList = [];
         this._enCntCntList = [];
         this._isKillList = [];
         super();
         if(Boolean(data))
         {
            this._data = new ByteArray();
            data.readBytes(this._data);
            (data as ByteArray).position = 0;
            this._monCount = data.readUnsignedInt();
            for(i = 0; i < this._monCount; i++)
            {
               this._monID = data.readUnsignedInt();
               this._enCntCnt = data.readUnsignedInt();
               this._isCatched = data.readUnsignedInt();
               this._isKilled = data.readUnsignedInt();
               this._petBargeIdList.push(this._monID);
               this._isCatchedList.push([this._monID,this._isCatched]);
               this._enCntCntList.push([this._monID,this._enCntCnt]);
               this._isKillList.push([this._monID,this._isKilled]);
            }
         }
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
      
      public function get petBargeIdList() : Array
      {
         return this._petBargeIdList;
      }
      
      public function get isCatchedList() : Array
      {
         return this._isCatchedList;
      }
      
      public function get enCntCntList() : Array
      {
         return this._enCntCntList;
      }
      
      public function get isKillList() : Array
      {
         return this._isKillList;
      }
   }
}

