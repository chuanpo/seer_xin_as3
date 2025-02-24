package com.robot.core.info.teamPK
{
   import com.robot.core.info.team.SimpleTeamInfo;
   
   public class TeamPKTeamInfo
   {
      private var _ename:String;
      
      private var _eleader:String;
      
      private var _elevel:uint;
      
      private var _myLevel:uint;
      
      private var _myLeader:String;
      
      private var _myName:String;
      
      private var _eInfo:SimpleTeamInfo;
      
      private var _myInfo:SimpleTeamInfo;
      
      public function TeamPKTeamInfo()
      {
         super();
      }
      
      public function set myInfo(i:SimpleTeamInfo) : void
      {
         this._myInfo = i;
      }
      
      public function get myInfo() : SimpleTeamInfo
      {
         return this._myInfo;
      }
      
      public function set eInfo(i:SimpleTeamInfo) : void
      {
         this._eInfo = i;
      }
      
      public function get eInfo() : SimpleTeamInfo
      {
         return this._eInfo;
      }
      
      public function get myName() : String
      {
         return this._myName;
      }
      
      public function set myName(n:String) : void
      {
         this._myName = n;
      }
      
      public function get myLevel() : uint
      {
         return this._myLevel;
      }
      
      public function set myLevel(n:uint) : void
      {
         this._myLevel = n;
      }
      
      public function get elevel() : uint
      {
         return this._elevel;
      }
      
      public function set elevel(n:uint) : void
      {
         this._elevel = n;
      }
      
      public function set myLeader(n:String) : void
      {
         this._myLeader = n;
      }
      
      public function get myLeader() : String
      {
         return this._myLeader;
      }
      
      public function get eLeader() : String
      {
         return this._eleader;
      }
      
      public function set eLeader(n:String) : void
      {
         this._eleader = n;
      }
      
      public function set ename(n:String) : void
      {
         this._ename = n;
      }
      
      public function get ename() : String
      {
         return this._ename;
      }
   }
}

