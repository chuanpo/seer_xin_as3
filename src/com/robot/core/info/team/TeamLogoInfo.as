package com.robot.core.info.team
{
   import com.robot.core.manager.MainManager;
   import flash.utils.IDataInput;
   
   public class TeamLogoInfo implements ITeamLogoInfo
   {
      private var _id:uint;
      
      private var _logoBg:uint;
      
      private var _logoIcon:uint;
      
      private var _logoColor:uint;
      
      private var _txtColor:uint;
      
      private var _logoWord:String;
      
      public function TeamLogoInfo(data:IDataInput = null)
      {
         super();
         if(!data)
         {
            return;
         }
         this._id = data.readUnsignedInt();
         this._logoBg = data.readShort();
         this._logoIcon = data.readShort();
         this._logoColor = data.readShort();
         this._txtColor = data.readShort();
         this._logoWord = data.readUTFBytes(4);
         if(this._id == MainManager.actorInfo.teamInfo.id)
         {
            MainManager.actorInfo.teamInfo.logoBg = this.logoBg;
            MainManager.actorInfo.teamInfo.logoIcon = this.logoIcon;
            MainManager.actorInfo.teamInfo.logoColor = this.logoColor;
            MainManager.actorInfo.teamInfo.txtColor = this.txtColor;
            MainManager.actorInfo.teamInfo.logoWord = this.logoWord;
         }
      }
      
      public function get teamID() : uint
      {
         return this._id;
      }
      
      public function get logoBg() : uint
      {
         return this._logoBg;
      }
      
      public function get logoIcon() : uint
      {
         return this._logoIcon;
      }
      
      public function get logoColor() : uint
      {
         return this._logoColor;
      }
      
      public function get txtColor() : uint
      {
         return this._txtColor;
      }
      
      public function get logoWord() : String
      {
         return this._logoWord;
      }
      
      public function set logoBg(i:uint) : void
      {
         this._logoBg = i;
      }
      
      public function set logoIcon(i:uint) : void
      {
         this._logoIcon = i;
      }
      
      public function set logoColor(i:uint) : void
      {
         this._logoColor = i;
      }
      
      public function set txtColor(i:uint) : void
      {
         this._txtColor = i;
      }
      
      public function set logoWord(i:String) : void
      {
         this._logoWord = i;
      }
   }
}

