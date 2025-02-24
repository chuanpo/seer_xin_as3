package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class SimpleTeamInfo implements ITeamLogoInfo
   {
      private var _teamID:uint;
      
      private var _leader:uint;
      
      private var _memberCount:uint;
      
      private var _interest:uint;
      
      private var _joinFlag:uint;
      
      private var _visitFlag:uint;
      
      private var _exp:uint;
      
      private var _score:uint;
      
      private var _name:String;
      
      private var _slogan:String;
      
      private var _notice:String;
      
      private var _logoBg:uint;
      
      private var _logoIcon:uint;
      
      private var _logoColor:uint;
      
      private var _txtColor:uint;
      
      private var _logoWord:String;
      
      private var _superCoreNum:uint;
      
      public function SimpleTeamInfo(data:IDataInput)
      {
         super();
         this._teamID = data.readUnsignedInt();
         this._leader = data.readUnsignedInt();
         this._superCoreNum = data.readUnsignedInt();
         this._memberCount = data.readUnsignedInt();
         this._interest = data.readUnsignedInt();
         this._joinFlag = data.readUnsignedInt();
         this._visitFlag = data.readUnsignedInt();
         this._exp = data.readUnsignedInt();
         this._score = data.readUnsignedInt();
         this._name = data.readUTFBytes(16);
         this._slogan = data.readUTFBytes(60);
         this._notice = data.readUTFBytes(60);
         this._logoBg = data.readShort();
         this._logoIcon = data.readShort();
         this._logoColor = data.readShort();
         this._txtColor = data.readShort();
         this._logoWord = data.readUTFBytes(4);
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
      
      public function get superCoreNum() : uint
      {
         return this._superCoreNum;
      }
      
      public function set superCoreNum(v:uint) : void
      {
         this._superCoreNum = v;
      }
      
      public function get exp() : uint
      {
         return this._exp;
      }
      
      public function get score() : uint
      {
         return this._score;
      }
      
      public function get teamID() : uint
      {
         return this._teamID;
      }
      
      public function get leader() : uint
      {
         return this._leader;
      }
      
      public function get memberCount() : uint
      {
         return this._memberCount;
      }
      
      public function get interest() : uint
      {
         return this._interest;
      }
      
      public function get joinFlag() : uint
      {
         return this._joinFlag;
      }
      
      public function get visitFlag() : uint
      {
         return this._visitFlag;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get slogan() : String
      {
         return this._slogan;
      }
      
      public function get notice() : String
      {
         return this._notice;
      }
      
      public function get level() : uint
      {
         var i:uint = 2;
         var e:int = this.countExp(i);
         while(e < this._exp)
         {
            i++;
            e = this.countExp(i);
         }
         var l:uint = uint(i - 1);
         if(l > 100)
         {
            l = 100;
         }
         return l;
      }
      
      public function get realLevel() : uint
      {
         var i:uint = 2;
         var e:int = this.countExp(i);
         while(e < this._exp)
         {
            i++;
            e = this.countExp(i);
         }
         return uint(i - 1);
      }
      
      public function countExp(i:uint) : int
      {
         trace("level--:",i,6 * Math.pow(i,3) / 5 - 15 * Math.pow(i,2) + 100 * i - 140);
         return uint(Math.ceil(6 * Math.pow(i,3) / 5 - 15 * Math.pow(i,2) + 100 * i - 140));
      }
   }
}

