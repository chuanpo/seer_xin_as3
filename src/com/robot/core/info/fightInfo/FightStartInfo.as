package com.robot.core.info.fightInfo
{
   import com.robot.core.manager.MainManager;
   import flash.utils.IDataInput;
   
   public class FightStartInfo
   {
      private var _myInfo:FightPetInfo;
      
      private var _otherInfo:FightPetInfo;
      
      private var _infoArray:Array = [];
      
      private var _isCanAuto:Boolean;
      
      public function FightStartInfo(data:IDataInput)
      {
         super();
         this._isCanAuto = data.readUnsignedInt() == 1;
         var info:FightPetInfo = new FightPetInfo(data);
         if(info.userID == MainManager.actorInfo.userID)
         {
            this._myInfo = info;
            this._otherInfo = new FightPetInfo(data);
            this._infoArray.push(this._myInfo,this._otherInfo);
         }
         else
         {
            this._otherInfo = info;
            this._myInfo = new FightPetInfo(data);
            this._infoArray.push(this._myInfo,this._otherInfo);
         }
      }
      
      public function get isCanAuto() : Boolean
      {
         return this._isCanAuto;
      }
      
      public function get myInfo() : FightPetInfo
      {
         return this._myInfo;
      }
      
      public function get otherInfo() : FightPetInfo
      {
         return this._otherInfo;
      }
      
      public function get infoArray() : Array
      {
         return this._infoArray;
      }
   }
}

