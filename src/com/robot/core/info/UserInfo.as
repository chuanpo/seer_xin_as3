package com.robot.core.info
{
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.team.TeamInfo;
   import com.robot.core.info.teamPK.TeamPKInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.TasksManager;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.utils.BitUtil;
   
   public class UserInfo
   {
      public var priorLevel:uint;
      
      public var userID:uint;
      
      public var timePoke:uint;
      
      public var hasSimpleInfo:Boolean = false;
      
      public var hasMoreInfo:Boolean = false;
      
      public var nick:String = "";
      
      public var vip:uint;
      
      public var viped:uint;
      
      public var color:uint;
      
      public var texture:uint;
      
      public var energy:uint;
      
      public var coins:uint;
      
      public var fightBadge:uint;
      
      public var status:uint;
      
      public var mapType:uint;
      
      public var mapID:uint;
      
      public var actionType:uint;
      
      public var pos:Point = new Point();
      
      public var spiritTime:uint;
      
      public var spiritID:uint;
      
      public var clothes:Array = [];
      
      public var ore:uint;
      
      public var serverID:uint;
      
      public var action:uint;
      
      public var direction:uint;
      
      public var changeShape:uint;
      
      public var petNum:uint;
      
      public var timeToday:uint;
      
      public var loginCnt:uint;
      
      public var inviter:uint;
      
      public var teamID:uint;
      
      public var isCanBeTeacher:Boolean;
      
      public var teacherID:uint;
      
      public var studentID:uint;
      
      public var graduationCount:uint;
      
      public var maxPuniLv:uint;
      
      public var regTime:uint;
      
      public var petAllNum:uint;
      
      public var petMaxLev:uint;
      
      public var bossAchievement:Array = [];
      
      public var fightFlag:uint;
      
      public var monKingWin:uint;
      
      public var messWin:uint;
      
      public var curStage:uint;
      
      public var maxStage:uint;
      
      public var curFreshStage:uint;
      
      public var maxFreshStage:uint;
      
      public var maxArenaWins:uint;
      
      public var badge:uint;
      
      public var reserved:ByteArray;
      
      public var superNono:Boolean;
      
      public var hasNono:Boolean;
      
      public var nonoState:Array = [];
      
      public var nonoNick:String = "";
      
      public var nonoColor:uint;
      
      public var timeLimit:uint;
      
      public var dsFlag:uint;
      
      public var newInviteeCnt:uint;
      
      public var freshManBonus:uint;
      
      public var dailyResArr:Array = [];
      
      public var nonoChipList:Array = [];
      
      public var teamInfo:TeamInfo;
      
      public var teamPKInfo:TeamPKInfo;
      
      public var playerForm:Boolean;
      
      public var transTime:uint;
      
      public var vipLevel:uint;
      
      public var vipValue:uint;
      
      public var vipStage:uint;
      
      public var autoCharge:uint;
      
      public var vipEndTime:uint;
      
      public var autoFight:uint;
      
      public var autoFightTimes:uint;
      
      public var twoTimes:uint;
      
      public var threeTimes:uint;
      
      public var monBtlMedal:uint;
      
      public var energyTimes:uint;
      
      public var learnTimes:uint;
      
      public var recordCnt:uint;
      
      public var obtainTm:uint;
      
      public var soulBeadItemID:uint;
      
      public var expireTm:uint;
      
      public var fuseTimes:uint;
      
      public var canReadSchedule:Boolean;
      
      public function UserInfo()
      {
         super();
      }
      
      public static function setForPeoleInfo(info:UserInfo, data:IDataInput) : void
      {
         var id:uint = 0;
         var level:uint = 0;
         info.hasSimpleInfo = true;
         info.userID = data.readUnsignedInt();
         info.nick = data.readUTFBytes(16);
         info.color = data.readUnsignedInt();
         info.texture = data.readUnsignedInt();
         var vvv:uint = data.readUnsignedInt();
         info.vip = BitUtil.getBit(vvv,0);
         info.viped = BitUtil.getBit(vvv,1);
         info.vipStage = data.readUnsignedInt();
         info.actionType = data.readUnsignedInt();
         info.pos = new Point(data.readUnsignedInt(),data.readUnsignedInt());
         info.action = data.readUnsignedInt();
         info.direction = data.readUnsignedInt();
         info.changeShape = data.readUnsignedInt();
         info.spiritTime = data.readUnsignedInt();
         info.spiritID = data.readUnsignedInt();
         info.fightFlag = data.readUnsignedInt();
         info.teacherID = data.readUnsignedInt();
         info.studentID = data.readUnsignedInt();
         var num:uint = data.readUnsignedInt();
         for(var s:int = 0; s < 32; s++)
         {
            info.nonoState.push(BitUtil.getBit(num,s));
         }
         info.nonoColor = data.readUnsignedInt();
         info.superNono = Boolean(data.readUnsignedInt());
         info.playerForm = Boolean(data.readUnsignedInt());
         info.transTime = data.readUnsignedInt();
         var ti:TeamInfo = new TeamInfo();
         ti.id = data.readUnsignedInt();
         ti.coreCount = data.readUnsignedInt();
         ti.isShow = Boolean(data.readUnsignedInt());
         info.teamInfo = ti;
         ti.logoBg = data.readShort();
         ti.logoIcon = data.readShort();
         ti.logoColor = data.readShort();
         ti.txtColor = data.readShort();
         ti.logoWord = data.readUTFBytes(4);
         var len:uint = data.readUnsignedInt();
         for(var i:int = 0; i < len; i++)
         {
            id = data.readUnsignedInt();
            level = data.readUnsignedInt();
            info.clothes.push(new PeopleItemInfo(id,level));
         }
      }
      
      public static function setForLoginInfo(info:UserInfo, data:IDataInput) : void
      {
         var id:uint = 0;
         var level:uint = 0;
         info.hasSimpleInfo = true;
         info.userID = data.readUnsignedInt();
         info.regTime = data.readUnsignedInt();
         info.nick = data.readUTFBytes(16);
         var vvv:uint = data.readUnsignedInt();
         info.vip = BitUtil.getBit(vvv,0);
         info.viped = BitUtil.getBit(vvv,1);
         info.dsFlag = data.readUnsignedInt();
         info.color = data.readUnsignedInt();
         info.texture = data.readUnsignedInt();
         info.energy = data.readUnsignedInt();
         info.coins = data.readUnsignedInt();
         info.fightBadge = data.readUnsignedInt();
         info.mapID = data.readUnsignedInt();
         info.pos = new Point(data.readUnsignedInt(),data.readUnsignedInt());
         info.timeToday = data.readUnsignedInt();
         info.timeLimit = data.readUnsignedInt();
         MainManager.isClothHalfDay = Boolean(data.readByte());
         MainManager.isRoomHalfDay = Boolean(data.readByte());
         MainManager.iFortressHalfDay = Boolean(data.readByte());
         MainManager.isHQHalfDay = Boolean(data.readByte());
         trace("个人装扮是否半价：",MainManager.isClothHalfDay);
         trace("小屋装扮是否半价：",MainManager.isRoomHalfDay);
         trace("要塞装扮是否半价：",MainManager.iFortressHalfDay);
         trace("总部装扮是否半价：",MainManager.isHQHalfDay);
         info.loginCnt = data.readUnsignedInt();
         info.inviter = data.readUnsignedInt();
         info.newInviteeCnt = data.readUnsignedInt();
         info.vipLevel = data.readUnsignedInt();
         info.vipValue = data.readUnsignedInt();
         info.vipStage = data.readUnsignedInt();
         if(info.vipStage > 4)
         {
            info.vipStage = 4;
         }
         if(info.vipStage == 0)
         {
            info.vipStage = 1;
         }
         info.autoCharge = data.readUnsignedInt();
         info.vipEndTime = data.readUnsignedInt();
         info.freshManBonus = data.readUnsignedInt();
         for(var r:int = 0; r < 80; r++)
         {
            info.nonoChipList.push(Boolean(data.readByte()));
         }
         for(var rr:int = 0; rr < 50; rr++)
         {
            info.dailyResArr.push(data.readByte());
         }
         info.teacherID = data.readUnsignedInt();
         info.studentID = data.readUnsignedInt();
         info.graduationCount = data.readUnsignedInt();
         info.maxPuniLv = data.readUnsignedInt();
         info.petMaxLev = data.readUnsignedInt();
         info.petAllNum = data.readUnsignedInt();
         info.monKingWin = data.readUnsignedInt();
         info.curStage = data.readUnsignedInt() + 1;
         info.maxStage = data.readUnsignedInt();
         info.curFreshStage = data.readUnsignedInt();
         info.maxFreshStage = data.readUnsignedInt();
         info.maxArenaWins = data.readUnsignedInt();
         info.twoTimes = data.readUnsignedInt();
         info.threeTimes = data.readUnsignedInt();
         info.autoFight = data.readUnsignedInt();
         info.autoFightTimes = data.readUnsignedInt();
         info.energyTimes = data.readUnsignedInt();
         info.learnTimes = data.readUnsignedInt();
         info.monBtlMedal = data.readUnsignedInt();
         info.recordCnt = data.readUnsignedInt();
         info.obtainTm = data.readUnsignedInt();
         info.soulBeadItemID = data.readUnsignedInt();
         info.expireTm = data.readUnsignedInt();
         info.fuseTimes = data.readUnsignedInt();
         info.hasNono = Boolean(data.readUnsignedInt());
         info.superNono = Boolean(data.readUnsignedInt());
         var num:uint = data.readUnsignedInt();
         for(var s:int = 0; s < 32; s++)
         {
            info.nonoState.push(BitUtil.getBit(num,s));
         }
         info.nonoColor = data.readUnsignedInt();
         info.nonoNick = data.readUTFBytes(16);
         info.teamInfo = new TeamInfo(data);
         info.teamPKInfo = new TeamPKInfo(data);
         data.readByte();
         info.badge = data.readUnsignedInt();
         var byte:ByteArray = new ByteArray();
         data.readBytes(byte,0,27);
         info.reserved = byte;
         for(var i:int = 0; i < 500; i++)
         {
            TasksManager.taskList.push(data.readUnsignedByte());
         }
         var a:Array = TasksManager.taskList;
         info.isCanBeTeacher = TasksManager.getTaskStatus(201) == 3;
         info.petNum = data.readUnsignedInt();
         PetManager.initData(data,info.petNum);
         var clothNum:uint = data.readUnsignedInt();
         for(var j:uint = 0; j < clothNum; j++)
         {
            id = data.readUnsignedInt();
            level = data.readUnsignedInt();
            info.clothes.push(new PeopleItemInfo(id,level));
         }
      }
      
      public static function setForSimpleInfo(info:UserInfo, data:IDataInput) : void
      {
         var id:uint = 0;
         var level:uint = 0;
         info.hasSimpleInfo = true;
         ByteArray(data).position = 0;
         info.userID = data.readUnsignedInt();
         info.nick = data.readUTFBytes(16);
         info.color = data.readUnsignedInt();
         info.texture = data.readUnsignedInt();
         info.vip = data.readUnsignedInt();
         info.status = data.readUnsignedInt();
         info.mapType = data.readUnsignedInt();
         info.mapID = data.readUnsignedInt();
         info.isCanBeTeacher = data.readUnsignedInt() == 1;
         info.teacherID = data.readUnsignedInt();
         info.studentID = data.readUnsignedInt();
         info.graduationCount = data.readUnsignedInt();
         info.vipLevel = data.readUnsignedInt();
         var t:TeamInfo = new TeamInfo();
         t.id = data.readUnsignedInt();
         t.isShow = Boolean(data.readUnsignedInt());
         info.teamInfo = t;
         info.teamID = t.id;
         var cloLen:uint = data.readUnsignedInt();
         for(var i:int = 0; i < cloLen; i++)
         {
            id = data.readUnsignedInt();
            level = data.readUnsignedInt();
            info.clothes.push(new PeopleItemInfo(id,level));
         }
      }
      
      public static function setForMoreInfo(info:UserInfo, data:IDataInput) : void
      {
         info.hasMoreInfo = true;
         info.userID = data.readUnsignedInt();
         info.nick = data.readUTFBytes(16);
         info.regTime = data.readUnsignedInt();
         info.petAllNum = data.readUnsignedInt();
         info.petMaxLev = data.readUnsignedInt();
         for(var i:int = 0; i < 20; i++)
         {
            info.bossAchievement.push(Boolean(data.readByte()));
         }
         info.graduationCount = data.readUnsignedInt();
         info.monKingWin = data.readUnsignedInt();
         info.messWin = data.readUnsignedInt();
         info.maxStage = data.readUnsignedInt();
         info.maxArenaWins = data.readUnsignedInt();
      }
      
      public function get clothIDs() : Array
      {
         var i:PeopleItemInfo = null;
         var array:Array = [];
         for each(i in this.clothes)
         {
            array.push(i.id);
         }
         return array;
      }
      
      public function get clothMaxLevel() : uint
      {
         var i:PeopleItemInfo = null;
         var max:uint = 0;
         for each(i in this.clothes)
         {
            max = Math.max(max,i.level);
         }
         return max;
      }
   }
}

