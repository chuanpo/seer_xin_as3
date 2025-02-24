package com.robot.core.teamPK
{
   import com.robot.core.CommandID;
   import com.robot.core.controller.MouseController;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.event.TeamPKEvent;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.fightInfo.PetFightModel;
   import com.robot.core.info.team.SimpleTeamInfo;
   import com.robot.core.info.teamPK.ShooterInfo;
   import com.robot.core.info.teamPK.SomeoneJoinInfo;
   import com.robot.core.info.teamPK.SuperNonoShieldInfo;
   import com.robot.core.info.teamPK.TeamPKBeShotInfo;
   import com.robot.core.info.teamPK.TeamPKBuildingListInfo;
   import com.robot.core.info.teamPK.TeamPKFreezeInfo;
   import com.robot.core.info.teamPK.TeamPKJoinInfo;
   import com.robot.core.info.teamPK.TeamPKNoteInfo;
   import com.robot.core.info.teamPK.TeamPKResultInfo;
   import com.robot.core.info.teamPK.TeamPKSignInfo;
   import com.robot.core.info.teamPK.TeamPKTeamInfo;
   import com.robot.core.info.teamPK.TeamPkStInfo;
   import com.robot.core.info.teamPK.TeamPkUserInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.UserInfoManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.map.MapType;
   import com.robot.core.manager.map.config.MapConfig;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.PKArmModel;
   import com.robot.core.mode.spriteModelAdditive.PeopleBloodBar;
   import com.robot.core.mode.spriteModelAdditive.SpriteBloodBar;
   import com.robot.core.mode.spriteModelAdditive.SpriteFreeze;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.teamInstallation.TeamInfoManager;
   import com.robot.core.teamPK.shotActive.AutoShotManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TeamPKManager
   {
      private static var homeTeamID:uint;
      
      private static var awayTeamID:uint;
      
      public static var sign:ByteArray;
      
      private static var homeList:Array;
      
      private static var awayList:Array;
      
      public static var TEAM:uint;
      
      private static var loader:Loader;
      
      private static var waitPanel:MovieClip;
      
      public static var enemyInfo:TeamPKTeamInfo;
      
      public static var enemyBuildingList:Array;
      
      public static var homeHeaderHp:uint;
      
      public static var awayHeaderHp:uint;
      
      public static var isShowPanel:Boolean;
      
      public static var myMaxHp:uint;
      
      public static var myHp:uint;
      
      private static var oldMap:uint;
      
      private static var infoIcon:InteractiveObject;
      
      private static var fun:Function;
      
      private static var infoPanel:MovieClip;
      
      private static var teamPKMessPanel:TeamPKMessPanel;
      
      private static var win_mc:MovieClip;
      
      public static var teamPkSituationInfo:TeamPkStInfo;
      
      private static var instance:EventDispatcher;
      
      private static var URL:String = "resource/eff/shotEffect.swf";
      
      private static const MAP_ID:uint = 700001;
      
      public static var PK_STATUS:uint = 0;
      
      public static const START:uint = 1;
      
      public static const OPEN_DOOR:uint = 2;
      
      public static const OVER:uint = 3;
      
      public static var inMap:Boolean = false;
      
      public static var isGetBuilding:Boolean = false;
      
      public static var buildingMap:HashMap = new HashMap();
      
      public static var homeBuildingMap:HashMap = new HashMap();
      
      public static var awayBuildingMap:HashMap = new HashMap();
      
      public static const HOME:uint = 1;
      
      public static const AWAY:uint = 2;
      
      private static var freezeIDs:Array = [];
      
      private static var noModelMaps:HashMap = new HashMap();
      
      public static const REDX:uint = 1880;
      
      public static const INIT_INFO:String = "initinfo";
      
      public static const INIT_HP:String = "inithp";
      
      private static var isSendB:Boolean = false;
      
      public function TeamPKManager()
      {
         super();
      }
      
      public static function closeWait() : void
      {
         setTimeout(function():void
         {
            if(oldMap != 0)
            {
               MapManager.changeMap(oldMap);
            }
            DisplayUtil.removeForParent(waitPanel,false);
         },200);
      }
      
      public static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_PK_SIGN,onGetTeamSign);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_NOTE,onTeamPKNote);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_JOIN,onPKJoin);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_SOMEONE_JOIN_INFO,onSomeoneJoin);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_GET_BUILDING_INFO,onGetBuildingInfo);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_BE_SHOT,beShotHandler);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_FREEZE,onFreeze);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_USE_SHIELD,onUseShield);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_RESULT,resultHandler);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_NO_PET,noPetHandler);
         EventManager.addEventListener(RobotEvent.CREATED_MAP_USER,onCreateMapUser);
         if(!enemyInfo)
         {
            enemyInfo = new TeamPKTeamInfo();
         }
         if(!infoIcon)
         {
            infoIcon = TaskIconManager.getIcon("TeamPK_icon");
            infoIcon.addEventListener(MouseEvent.CLICK,showTaskPanel);
            ToolTipManager.add(infoIcon,"对抗赛消息");
         }
      }
      
      private static function noPetHandler(event:SocketEvent) : void
      {
         Alarm.show("精灵对战失败！你没有可出战的精灵应对敌方的挑战。");
      }
      
      public static function showIcon() : void
      {
         TaskIconManager.addIcon(infoIcon);
      }
      
      public static function removeIcon() : void
      {
         TaskIconManager.delIcon(infoIcon);
         if(Boolean(teamPKMessPanel))
         {
            teamPKMessPanel.destroy();
         }
      }
      
      private static function showTaskPanel(e:MouseEvent) : void
      {
         if(!teamPKMessPanel)
         {
            teamPKMessPanel = new TeamPKMessPanel();
            teamPKMessPanel.setup();
         }
         else
         {
            teamPKMessPanel.setup();
         }
      }
      
      public static function register() : void
      {
         SocketConnection.send(CommandID.TEAM_PK_SIGN);
      }
      
      public static function joinPK() : void
      {
         oldMap = MainManager.actorInfo.mapID;
         if(MainManager.actorInfo.teamPKInfo.homeTeamID == 0)
         {
            Alarm.show("你现在不能进入对抗赛");
         }
         fun = join;
         var mcloader:MCLoader = new MCLoader(URL,LevelManager.appLevel,1,"正在进入对战系统");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,onLoadByJoin);
         mcloader.doLoad();
      }
      
      private static function onLoadByRegister(event:MCLoadEvent) : void
      {
         var closeBtn:SimpleButton;
         var num:uint;
         ShotBehaviorManager.setup(event.getLoader());
         waitPanel = ShotBehaviorManager.getMovieClip("pk_wait_panel");
         closeBtn = waitPanel["closeBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            closeWait();
         });
         num = Math.ceil(Math.random() * 3);
         waitPanel["mc"].gotoAndStop(num);
         MainManager.getStage().addChild(waitPanel);
         fun();
      }
      
      private static function onLoadByJoin(event:MCLoadEvent) : void
      {
         ShotBehaviorManager.setup(event.getLoader());
         fun();
      }
      
      public static function initBuildList() : void
      {
         if(TEAM == HOME)
         {
            enemyBuildingList = awayBuildinList;
         }
         else
         {
            enemyBuildingList = homeBuildinList;
         }
      }
      
      private static function onCreateMapUser(event:RobotEvent) : void
      {
         var i:uint = 0;
         var data:TeamPKFreezeInfo = null;
         var model:BasePeoleModel = null;
         var flag:uint = 0;
         var uid:uint = 0;
         var people:BasePeoleModel = null;
         var _point:Point = null;
         var array:Array = noModelMaps.getKeys();
         for each(i in array)
         {
            model = UserManager.getUserModel(i);
            if(Boolean(model))
            {
               if(model.info.teamInfo.id == homeTeamID)
               {
                  model.bloodBar.colorType = PeopleBloodBar.RED;
               }
               else
               {
                  model.bloodBar.colorType = PeopleBloodBar.BLUE;
               }
               noModelMaps.remove(i);
            }
         }
         for each(data in freezeIDs)
         {
            flag = data.flag;
            trace("freeze flag ---------->",flag);
            uid = data.uid;
            people = UserManager.getUserModel(uid);
            if(Boolean(people))
            {
               if(flag == 1)
               {
                  _point = MapConfig.getMapPeopleXY(0,homeTeamID);
                  if(people.info.teamInfo.id == homeTeamID)
                  {
                     people.x = _point.x;
                     people.y = _point.y;
                  }
                  else
                  {
                     people.x = _point.x + REDX;
                     _point.x += REDX;
                     people.y = _point.y;
                  }
                  people.additive = [new SpriteFreeze()];
                  if(uid == MainManager.actorID)
                  {
                     if(TEAM == HOME)
                     {
                        LevelManager.moveToLeft();
                     }
                     else
                     {
                        LevelManager.moveToRight();
                     }
                     people.walkAction(_point);
                     dispatchEvent(new Event(INIT_INFO));
                     LevelManager.closeMouseEvent();
                  }
               }
               else
               {
                  people.filters = [];
                  if(uid == MainManager.actorID)
                  {
                     LevelManager.openMouseEvent();
                  }
               }
            }
         }
         freezeIDs = [];
      }
      
      private static function showWin(n:uint) : void
      {
         if(n != 2)
         {
            if(TEAM == HOME)
            {
               if(n == 0)
               {
                  win_mc = ShotBehaviorManager.getMovieClip("AwayWin");
               }
               else
               {
                  win_mc = ShotBehaviorManager.getMovieClip("HomeWin");
               }
            }
            else if(n == 0)
            {
               win_mc = ShotBehaviorManager.getMovieClip("HomeWin");
            }
            else
            {
               win_mc = ShotBehaviorManager.getMovieClip("AwayWin");
            }
            if(Boolean(win_mc))
            {
               win_mc.x = MainManager.getStageWidth() / 2 - 100;
               win_mc.y = MainManager.getStageHeight() / 2;
               win_mc.addFrameScript(win_mc.totalFrames - 1,onEnd);
               LevelManager.topLevel.addChild(win_mc);
            }
         }
      }
      
      private static function onEnd() : void
      {
         win_mc.addFrameScript(win_mc.totalFrames - 1,null);
         LevelManager.topLevel.removeChild(win_mc);
         win_mc = null;
      }
      
      public static function resultHandler(e:SocketEvent) : void
      {
         var data:TeamPKResultInfo = e.data as TeamPKResultInfo;
         var panel:TeamPKResultPanel = new TeamPKResultPanel();
         panel.setup(data);
         showWin(data.result);
         PK_STATUS = 0;
      }
      
      public static function getTeamSituation() : void
      {
         SocketConnection.send(CommandID.TEAM_PK_SITUATION);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_SITUATION,getPkSituationHandler);
      }
      
      private static function getPkSituationHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_PK_SITUATION,getPkSituationHandler);
         var data:TeamPkStInfo = e.data as TeamPkStInfo;
         if(data.flag == 0)
         {
            return;
         }
         teamPkSituationInfo = data;
         dispatchEvent(new Event(INIT_INFO));
      }
      
      private static function _register() : void
      {
         MapManager.styleID = MAP_ID;
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchMap);
         MapManager.changeMap(MainManager.actorInfo.teamInfo.id,0,MapType.PK_TYPE);
      }
      
      private static function onGetTeamSign(event:SocketEvent) : void
      {
         var data:TeamPKSignInfo = event.data as TeamPKSignInfo;
         sign = data.sign;
         oldMap = MainManager.actorInfo.mapID;
         fun = _register;
         var mcloader:MCLoader = new MCLoader(URL,LevelManager.appLevel,1,"正在进入对战系统");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,onLoadByRegister);
         mcloader.doLoad();
      }
      
      private static function onSwitchMap(event:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onSwitchMap);
         SocketConnection.send(CommandID.TEAM_PK_REGISTER,TeamPKManager.sign);
      }
      
      private static function getEnamyTeamInfo() : void
      {
         if(awayTeamID == 0)
         {
            return;
         }
         TeamInfoManager.getSimpleTeamInfo(awayTeamID,function(info:SimpleTeamInfo):void
         {
            enemyInfo.ename = info.name;
            enemyInfo.elevel = info.level;
            enemyInfo.eInfo = info;
            UserInfoManager.getInfo(info.leader,function(info1:UserInfo):void
            {
               enemyInfo.eLeader = info1.nick;
               getMyTeamInfo();
            });
         });
      }
      
      private static function getMyTeamInfo() : void
      {
         TeamInfoManager.getSimpleTeamInfo(homeTeamID,function(info1:SimpleTeamInfo):void
         {
            enemyInfo.myName = info1.name;
            enemyInfo.myLevel = info1.level;
            enemyInfo.myInfo = info1;
            UserInfoManager.getInfo(info1.leader,function(info2:UserInfo):void
            {
               enemyInfo.myLeader = info2.nick;
            });
         });
      }
      
      private static function onTeamPKNote(event:SocketEvent) : void
      {
         var data:TeamPKNoteInfo = event.data as TeamPKNoteInfo;
         homeTeamID = data.homeTeamID;
         awayTeamID = data.awayTeamID;
         PK_STATUS = data.event;
         if(PK_STATUS == START || PK_STATUS == OPEN_DOOR)
         {
            if(!inMap)
            {
               TeamPKManager.showIcon();
            }
         }
         if((PK_STATUS == START || PK_STATUS == OPEN_DOOR) && inMap && !isGetBuilding)
         {
            if(inMap)
            {
               getBuildingList();
               AutoShotManager.setup();
            }
         }
         DisplayUtil.removeForParent(waitPanel);
         if(PK_STATUS == START)
         {
            MainManager.actorInfo.teamPKInfo.homeTeamID = data.homeTeamID;
            if(data.homeTeamID != data.selfTeamID)
            {
               TEAM = AWAY;
               if(inMap)
               {
                  MapManager.styleID = MAP_ID;
                  MapManager.changeMap(data.homeTeamID,0,MapType.PK_TYPE);
               }
            }
            else
            {
               TEAM = HOME;
            }
            if(!isSendB)
            {
               isSendB = true;
               initBuildList();
               if(inMap)
               {
                  getTeamSituation();
               }
            }
            trace("teampkmanage:" + TeamPKManager.TEAM);
         }
         else if(PK_STATUS == OPEN_DOOR && inMap)
         {
            trace("homeList[0]:" + homeList[0].pos.x);
            dispatchEvent(new TeamPKEvent(TeamPKEvent.OPEN_DOOR));
         }
         else if(PK_STATUS == OVER)
         {
            trace("team pk note info ----------->" + data.event);
            removeIcon();
            PK_STATUS = 0;
         }
      }
      
      public static function levelMapInt() : void
      {
         TEAM = 0;
         teamPkSituationInfo = null;
      }
      
      public static function outTeamMap() : void
      {
         levelMapInt();
         gameOver();
      }
      
      public static function gameOver() : void
      {
         MapManager.DESTROY_SWITCH = true;
         buildingMap.clear();
         homeBuildingMap.clear();
         awayBuildingMap.clear();
         MapManager.changeMap(1);
      }
      
      private static function join() : void
      {
         MapManager.styleID = MAP_ID;
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchWithJoin);
         if(MainManager.actorInfo.teamInfo.id == MainManager.actorInfo.teamPKInfo.homeTeamID)
         {
            TEAM = HOME;
         }
         else
         {
            TEAM = AWAY;
         }
         MapManager.changeMap(MainManager.actorInfo.teamPKInfo.homeTeamID,0,MapType.PK_TYPE);
      }
      
      private static function onMapSwitchWithJoin(event:MapEvent) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchWithJoin);
         SocketConnection.send(CommandID.TEAM_PK_JOIN);
      }
      
      private static function isMySelf(p:BasePeoleModel) : Boolean
      {
         if(MainManager.actorInfo.userID == p.info.userID)
         {
            return true;
         }
         return false;
      }
      
      private static function onPKJoin(event:SocketEvent) : void
      {
         var data:TeamPKJoinInfo = null;
         data = event.data as TeamPKJoinInfo;
         homeTeamID = data.homeTeamId;
         awayTeamID = data.awayTeamId;
         getEnamyTeamInfo();
         setTimeout(function():void
         {
            var i:TeamPkUserInfo = null;
            var people:BasePeoleModel = null;
            for each(i in data.homeUserList)
            {
               people = UserManager.getUserModel(i.uid);
               if(Boolean(people))
               {
                  people.bloodBar.colorType = PeopleBloodBar.RED;
                  people.bloodBar.setHp(i.hp,i.maxHp);
                  if(isMySelf(people))
                  {
                     myMaxHp = i.maxHp;
                     myHp = i.hp;
                     TeamPKManager.dispatchEvent(new Event(INIT_HP));
                  }
                  if(i.isFreeze)
                  {
                  }
               }
               else
               {
                  noModelMaps.add(i.uid,i.uid);
               }
            }
            for each(i in data.awayUserList)
            {
               people = UserManager.getUserModel(i.uid);
               if(Boolean(people))
               {
                  people.bloodBar.colorType = PeopleBloodBar.BLUE;
                  people.bloodBar.setHp(i.hp,i.maxHp);
                  if(isMySelf(people))
                  {
                     myMaxHp = i.maxHp;
                     myHp = i.hp;
                     TeamPKManager.dispatchEvent(new Event(INIT_HP));
                  }
                  if(i.isFreeze)
                  {
                  }
               }
               else
               {
                  noModelMaps.add(i.uid,i.uid);
               }
            }
         },1000);
      }
      
      private static function onSomeoneJoin(event:SocketEvent) : void
      {
         var data:SomeoneJoinInfo = null;
         data = event.data as SomeoneJoinInfo;
         setTimeout(function():void
         {
            var model:BasePeoleModel = null;
            if(data.userID != MainManager.actorID)
            {
               model = UserManager.getUserModel(data.userID);
               if(!model)
               {
                  noModelMaps.add(data.userID,data.userID);
               }
               else
               {
                  if(model.info.teamInfo.id == homeTeamID)
                  {
                     model.bloodBar.colorType = PeopleBloodBar.RED;
                  }
                  else
                  {
                     model.bloodBar.colorType = PeopleBloodBar.BLUE;
                  }
                  model.bloodBar.setHp(data.hp,data.maxHp);
               }
            }
         },1000);
      }
      
      public static function petFight(uid:uint) : void
      {
         PetFightModel.status = PetFightModel.FIGHT_WITH_PLAYER;
         PetFightModel.mode = PetFightModel.SINGLE_MODE;
         SocketConnection.send(CommandID.TEAM_PK_PET_FIGHT,uid);
      }
      
      public static function shot(uid:uint, buyTime:uint, dis:uint) : void
      {
         trace("someone shot---->",uid);
         SocketConnection.send(CommandID.TEAM_PK_SHOT,uid,buyTime,dis);
      }
      
      private static function beShotHandler(event:SocketEvent) : void
      {
         var people:BasePeoleModel = null;
         var people1:BasePeoleModel = null;
         var building:PKArmModel = null;
         var bar:SpriteBloodBar = null;
         var data:TeamPKBeShotInfo = event.data as TeamPKBeShotInfo;
         var shooter:ShooterInfo = data.shooter();
         var beShooter:ShooterInfo = data.beShooer();
         trace("======================= some one be shot =======================");
         trace(data.shotType,shooter.leftHp,beShooter.leftHp);
         trace("======================= end of shot =======================");
         switch(data.shotType)
         {
            case TeamPKBeShotInfo.BUILDING_TO_PLAYER:
               people = UserManager.getUserModel(beShooter.userID);
               if(Boolean(people))
               {
                  people.bloodBar.setHp(beShooter.leftHp,beShooter.maxHp,data.damage);
               }
               bar = new SpriteBloodBar(ShotBehaviorManager.getMovieClip("pk_blood_bar"));
               bar.setHp(shooter.leftHp,shooter.maxHp);
               building = buildingMap.getValue(shooter.buyTime);
               building.additive = [bar];
               if(shooter.leftHp == 0)
               {
                  building.freeze();
               }
               people1 = people;
               building.shot(people);
               if(TEAM == HOME)
               {
                  if(awayBuildingMap.containsKey(shooter.buyTime) && shooter.leftHp == 0)
                  {
                     win();
                  }
               }
               else if(homeBuildingMap.containsKey(shooter.buyTime) && shooter.leftHp == 0)
               {
                  win();
               }
               break;
            case TeamPKBeShotInfo.PLAYER_TO_BUILDING:
               bar = new SpriteBloodBar(ShotBehaviorManager.getMovieClip("pk_blood_bar"));
               building = buildingMap.getValue(beShooter.buyTime);
               building.additive = [bar];
               bar.setHp(beShooter.leftHp,beShooter.maxHp,data.damage);
               if(beShooter.leftHp == 0)
               {
                  building.freeze();
               }
               people = UserManager.getUserModel(shooter.userID);
               if(Boolean(people))
               {
                  people.bloodBar.setHp(shooter.leftHp,shooter.maxHp);
               }
               if(TEAM == HOME)
               {
                  if(awayBuildingMap.containsKey(beShooter.buyTime) && beShooter.leftHp == 0)
                  {
                     win();
                  }
               }
               else if(homeBuildingMap.containsKey(beShooter.buyTime) && beShooter.leftHp == 0)
               {
                  win();
               }
               break;
            case TeamPKBeShotInfo.PLAYER_TO_PLAYER:
               people = UserManager.getUserModel(beShooter.userID);
               if(Boolean(people))
               {
                  people.bloodBar.setHp(beShooter.leftHp,beShooter.maxHp,data.damage);
               }
               people1 = people;
               people = UserManager.getUserModel(shooter.userID);
               if(Boolean(people))
               {
                  people.bloodBar.setHp(shooter.leftHp,shooter.maxHp);
               }
         }
         if(!people1)
         {
            return;
         }
         if(isMySelf(people1))
         {
            myHp = beShooter.leftHp;
            TeamPKManager.dispatchEvent(new Event(INIT_HP));
         }
      }
      
      public static function updateDistance(array:Array) : void
      {
         var i:PKArmModel = null;
         var by:ByteArray = new ByteArray();
         var count:uint = array.length;
         by.writeUnsignedInt(count);
         for each(i in array)
         {
            by.writeUnsignedInt(i.info.buyTime);
            by.writeUnsignedInt(Point.distance(i.info.pos,MainManager.actorModel.pos));
         }
         SocketConnection.send(CommandID.TEAM_PK_REFRESH_DISTANCE,by);
      }
      
      public static function win() : void
      {
         SocketConnection.send(CommandID.TEAM_PK_WIN);
      }
      
      public static function getBuildingList() : void
      {
         SocketConnection.send(CommandID.TEAM_PK_GET_BUILDING_INFO);
      }
      
      private static function onGetBuildingInfo(event:SocketEvent) : void
      {
         MapManager.DESTROY_SWITCH = false;
         var data:TeamPKBuildingListInfo = event.data as TeamPKBuildingListInfo;
         homeList = data.homeList;
         awayList = data.awayList;
         TeamPKManager.dispatchEvent(new TeamPKEvent(TeamPKEvent.GET_BUILDING_LIST));
         getEnamyTeamInfo();
      }
      
      public static function get homeBuildinList() : Array
      {
         return homeList;
      }
      
      public static function get awayBuildinList() : Array
      {
         return awayList;
      }
      
      private static function onFreeze(event:SocketEvent) : void
      {
         var _point:Point = null;
         var data:TeamPKFreezeInfo = event.data as TeamPKFreezeInfo;
         var flag:uint = data.flag;
         var uid:uint = data.uid;
         var people:BasePeoleModel = UserManager.getUserModel(uid);
         trace("======================= freeze =======================");
         trace("flag",flag,"uid",uid);
         trace("======================= end of freeze =======================");
         if(!people)
         {
            freezeIDs.push(data);
            return;
         }
         if(flag == 1)
         {
            people.additive = [new SpriteFreeze()];
            _point = MapConfig.getMapPeopleXY(0,homeTeamID);
            if(people.info.teamInfo.id == homeTeamID)
            {
               people.x = _point.x;
               people.y = _point.y;
            }
            else
            {
               people.x = _point.x + REDX;
               _point.x += REDX;
               people.y = _point.y;
            }
            if(uid == MainManager.actorID)
            {
               if(TEAM == HOME)
               {
                  LevelManager.moveToLeft();
               }
               else
               {
                  LevelManager.moveToRight();
               }
               people.walkAction(_point);
               MouseController.removeMouseEvent();
               TeamPKManager.dispatchEvent(new TeamPKEvent(TeamPKEvent.CLOSE_TOOL));
            }
         }
         else
         {
            people.skeleton.getBodyMC().filters = [];
            if(uid == MainManager.actorID)
            {
               myHp = TeamPKManager.myMaxHp;
               people.bloodBar.setHp(myHp,myHp);
               dispatchEvent(new Event(INIT_HP));
               MouseController.addMouseEvent();
               TeamPKManager.dispatchEvent(new TeamPKEvent(TeamPKEvent.OPEN_TOOL));
            }
         }
      }
      
      private static function onUseShield(event:SocketEvent) : void
      {
         var data:SuperNonoShieldInfo = event.data as SuperNonoShieldInfo;
         if(data.uid == 0)
         {
            return;
         }
         var people:BasePeoleModel = UserManager.getUserModel(data.uid);
         people.showNonoShield(data.leftTime);
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getInstance().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         getInstance().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getInstance().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getInstance().willTrigger(type);
      }
   }
}

