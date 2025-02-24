package com.robot.app.mapProcess
{
   import com.robot.app.mapProcess.active.PKMapActive;
   import com.robot.app.protectSys.ProtectSystem;
   import com.robot.app.toolBar.ToolBarController;
   import com.robot.app.toolBar.pkTool.TeamPkTool;
   import com.robot.core.CommandID;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.FortressItemXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.event.TeamPKEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.info.teamPK.TeamPkBuildingInfo;
   import com.robot.core.info.teamPK.TeamPkStInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.PKArmModel;
   import com.robot.core.mode.SpriteModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.teamPK.TeamInfoPanel;
   import com.robot.core.teamPK.TeamPKManager;
   import com.robot.core.teamPK.TeamPKMyHpPanel;
   import com.robot.core.teamPK.shotActive.AutoShotManager;
   import com.robot.core.ui.alert.Answer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.control.UIMovieClip;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class PKMap extends BaseMapProcess
   {
      private var _teamPKST_icon:InteractiveObject;
      
      private var _teamPkSt_panel:AppModel;
      
      private var _radius:uint;
      
      private var _teaminfo_panel:MovieClip;
      
      private var _homeScore_txt:TextField;
      
      private var _awayScore_txt:TextField;
      
      private var _time_txt:TextField;
      
      private var _time:Timer;
      
      private var _mySt_panel:TeamPKMyHpPanel;
      
      private var _go_0:MovieClip;
      
      private var _go_1:MovieClip;
      
      private var box:HBox;
      
      private var quitBtn:SimpleButton;
      
      private var firstLogin:Boolean = true;
      
      private var active:PKMapActive;
      
      private var teamInfo_panel:TeamInfoPanel;
      
      private var dis:uint;
      
      private var les:uint;
      
      private var inBuildingArr:Array = new Array();
      
      private var outBuildingArr:Array;
      
      private var sendBuildArr:Array = new Array();
      
      private var building_txt:TextField;
      
      public function PKMap()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _point:Point = null;
         if(MainManager.actorInfo.actionType == 1)
         {
            SocketConnection.send(CommandID.NONO_FOLLOW_OR_HOOM,0);
         }
         ProtectSystem.canShow = false;
         LevelManager.iconLevel.visible = false;
         this.box = new HBox(30);
         this.box.halign = FlowLayout.RIGHT;
         this.box.valign = FlowLayout.MIDLLE;
         this.box.setSizeWH(950,70);
         this._go_0 = conLevel["go1_mc"];
         this._go_1 = conLevel["go2_mc"];
         this._go_0.gotoAndStop(1);
         this._go_1.gotoAndStop(1);
         TeamPkTool.instance.show();
         TeamPkTool.instance.open();
         TeamPKManager.addEventListener(TeamPKEvent.COUNT_TIME,this.onTimeCount);
         TeamPKManager.addEventListener(TeamPKEvent.GET_BUILDING_LIST,this.onGetBuilding);
         TeamPKManager.addEventListener(TeamPKEvent.OPEN_DOOR,this.onOpenDoor);
         TeamPKManager.inMap = true;
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         AutoShotManager.setup();
         trace("pkmap:" + TeamPKManager.TEAM);
         if(TeamPKManager.TEAM == TeamPKManager.AWAY)
         {
            _point = new Point(MainManager.actorModel.pos.x + TeamPKManager.REDX,MainManager.actorModel.pos.y);
            MainManager.actorModel.x = _point.x;
            MainManager.actorModel.walkAction(_point);
            _point = null;
            LevelManager.moveToRight();
            MainManager.actorModel.additiveInfo.info = TeamPKManager.AWAY;
         }
         else
         {
            MainManager.actorModel.additiveInfo.info = TeamPKManager.HOME;
         }
         LevelManager.topLevel.addChild(this.box);
         this._teamPKST_icon = TaskIconManager.getIcon("TeamPkSt_icon");
         LevelManager.iconLevel.addChild(this._teamPKST_icon);
         ToolTipManager.add(this._teamPKST_icon,"战队战况");
         this._teamPKST_icon.addEventListener(MouseEvent.CLICK,this.clickPkStHandler);
         this.quitBtn = ShotBehaviorManager.getButton("pk_quit_btn");
         this.quitBtn.addEventListener(MouseEvent.CLICK,this.quit);
         ToolTipManager.add(this.quitBtn,"离开战场");
         this.box.append(new UIMovieClip(this._teamPKST_icon));
         this.box.append(new UIMovieClip(this.quitBtn));
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.walkEnterHandler);
         ToolBarController.aimatOff();
         ToolBarController.bagOff();
         ToolBarController.homeOff();
         ToolBarController.panel.closeMap();
         this.teamInfo_panel = new TeamInfoPanel();
         this.teamInfo_panel.setup();
         TeamPKManager.addEventListener(TeamPKManager.INIT_INFO,this.initInfoHandler);
         TeamPKManager.addEventListener(TeamPKManager.INIT_HP,this.initHpHandler);
         this.initInfoHandler();
         this._time = new Timer(10000,0);
         this._time.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this._mySt_panel = new TeamPKMyHpPanel();
         this._mySt_panel.setup();
         this._mySt_panel.show();
         this.active = new PKMapActive();
      }
      
      private function quit(event:MouseEvent) : void
      {
         Answer.show("现在离开战场将无法返回本场保卫战，你确定要离开吗？",this.quitMap);
      }
      
      private function quitMap() : void
      {
         TeamPKManager.levelMapInt();
         MapManager.changeMap(1);
      }
      
      private function getStatus() : void
      {
         TeamPKManager.getTeamSituation();
      }
      
      private function initHpHandler(e:Event) : void
      {
         this._mySt_panel.init();
      }
      
      private function timerHandler(e:TimerEvent) : void
      {
         TeamPKManager.getTeamSituation();
      }
      
      private function initInfoHandler(e:Event = null) : void
      {
         TeamPKManager.getBuildingList();
         if(!TeamPKManager.teamPkSituationInfo)
         {
            return;
         }
         if(this.firstLogin)
         {
            this.firstLogin = false;
            TeamPKManager.PK_STATUS = TeamPKManager.teamPkSituationInfo.pkStatus;
            if(TeamPKManager.PK_STATUS == TeamPKManager.START || TeamPKManager.PK_STATUS == TeamPKManager.OPEN_DOOR)
            {
               if(TeamPKManager.PK_STATUS == TeamPKManager.OPEN_DOOR)
               {
                  this.onOpenDoor(null);
               }
            }
         }
         if(TeamPKManager.isShowPanel)
         {
            if(!this._teamPkSt_panel)
            {
               this._teamPkSt_panel = new AppModel(ClientConfig.getAppModule("TeamPkStPanel"),"打开战队战况");
               this._teamPkSt_panel.setup();
            }
            this._teamPkSt_panel.init(TeamPKManager.teamPkSituationInfo);
            this._teamPkSt_panel.show();
         }
         var temp:TeamPkStInfo = TeamPKManager.teamPkSituationInfo;
         var n:uint = uint(temp.time);
         n = Math.ceil(n / 60);
         var m:uint = uint(temp.awayKillBuilding * 50 + temp.awayKillPlayer * 25);
         var z:uint = uint(temp.homeKillBuilding * 50 + temp.homeKillPlayer * 25);
         this.teamInfo_panel.setTime(n);
         this.teamInfo_panel.setAwayScore(m);
         this.teamInfo_panel.setHomeScore(z);
         this.walkEnterHandler();
      }
      
      private function walkEnterHandler(e:RobotEvent = null) : void
      {
         var i:uint = 0;
         var k:uint = 0;
         var by:ByteArray = null;
         var count:uint = 0;
         var z:TeamPkBuildingInfo = null;
         if(TeamPKManager.PK_STATUS == TeamPKManager.OPEN_DOOR)
         {
            this.sendBuildArr = [];
            if(!this.outBuildingArr)
            {
               this.outBuildingArr = TeamPKManager.enemyBuildingList;
            }
            for(i = 0; i < this.outBuildingArr.length; i++)
            {
               this.dis = Point.distance(this.outBuildingArr[i].pos,MainManager.actorModel.pos);
               this.les = uint(FortressItemXMLInfo.getShootRadius(this.outBuildingArr[i].id,this.outBuildingArr[i].form));
               if(this.dis <= this.les)
               {
                  this.inBuildingArr.push(this.outBuildingArr[i]);
                  this.sendBuildArr.push(this.outBuildingArr[i]);
                  this.outBuildingArr.splice(i,1);
               }
            }
            for(k = 0; k < this.inBuildingArr.length; k++)
            {
               this.dis = Point.distance(this.inBuildingArr[k].pos,MainManager.actorModel.pos);
               this.les = uint(FortressItemXMLInfo.getShootRadius(this.inBuildingArr[k].id,this.inBuildingArr[k].form));
               if(this.dis > this.les)
               {
                  this.outBuildingArr.push(this.inBuildingArr[k]);
                  this.sendBuildArr.push(this.inBuildingArr[k]);
                  this.inBuildingArr.splice(k,1);
               }
            }
            if(this.sendBuildArr.length > 0)
            {
               by = new ByteArray();
               count = this.sendBuildArr.length;
               by.writeUnsignedInt(count);
               for each(z in this.sendBuildArr)
               {
                  by.writeUnsignedInt(z.buyTime);
                  by.writeUnsignedInt(Point.distance(z.pos,MainManager.actorModel.pos));
               }
               SocketConnection.send(CommandID.TEAM_PK_REFRESH_DISTANCE,by);
            }
         }
      }
      
      private function clickPkStHandler(e:MouseEvent) : void
      {
         TeamPKManager.getTeamSituation();
         TeamPKManager.isShowPanel = true;
      }
      
      override public function destroy() : void
      {
         this.active.destroy();
         this.active = null;
         AutoShotManager.destroy();
         LevelManager.openMouseEvent();
         ProtectSystem.canShow = true;
         DisplayUtil.removeForParent(this.box);
         this.box.destroy();
         this.box = null;
         this._mySt_panel.destroy();
         MainManager.actorModel.removeBloodBar();
         MainManager.actorModel.hideRadius();
         MainManager.actorModel.removeAllAditive(true);
         TeamPkTool.instance.hide();
         TeamPKManager.removeEventListener(TeamPKEvent.COUNT_TIME,this.onTimeCount);
         TeamPKManager.removeEventListener(TeamPKEvent.GET_BUILDING_LIST,this.onGetBuilding);
         TeamPKManager.removeEventListener(TeamPKEvent.OPEN_DOOR,this.onOpenDoor);
         DisplayUtil.removeForParent(this._teamPKST_icon);
         TeamPKManager.gameOver();
         LevelManager.iconLevel.visible = true;
         if(Boolean(this._time))
         {
            this._time.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._time.stop();
            this._time = null;
         }
         this.teamInfo_panel.destroy();
         this.teamInfo_panel = null;
         TeamPKManager.removeEventListener(TeamPKManager.INIT_INFO,this.initInfoHandler);
         TeamPKManager.removeEventListener(TeamPKManager.INIT_HP,this.initHpHandler);
         this.inBuildingArr = null;
         this.outBuildingArr = null;
         this.sendBuildArr = null;
         this._mySt_panel = null;
         MainManager.actorModel.additiveInfo.destroy();
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.walkEnterHandler);
         if(Boolean(this._teamPkSt_panel))
         {
            this._teamPkSt_panel.destroy();
         }
         this._teamPkSt_panel = null;
         this._teamPKST_icon.removeEventListener(MouseEvent.CLICK,this.clickPkStHandler);
         this._teamPKST_icon = null;
         TeamPKManager.inMap = false;
         TeamPKManager.isGetBuilding = false;
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         ToolBarController.aimatOn();
         ToolBarController.bagOn();
         ToolBarController.homeOn();
         ToolBarController.panel.openMap();
      }
      
      private function onGetBuilding(event:TeamPKEvent) : void
      {
         var model:PKArmModel = null;
         var i:TeamPkBuildingInfo = null;
         TeamPKManager.isGetBuilding = true;
         TeamPKManager.removeEventListener(TeamPKEvent.GET_BUILDING_LIST,this.onGetBuilding);
         for each(i in TeamPKManager.homeBuildinList)
         {
            model = new PKArmModel(i,true,TeamPKManager.HOME);
            if(TeamPKManager.TEAM == TeamPKManager.AWAY)
            {
               model.isEnemy = true;
            }
            model.x = MainManager.getStageWidth() - model.pos.x;
            model.info.pos.x = model.x;
            model.info.pos.y = model.y;
            TeamPKManager.homeBuildingMap.add(i.buyTime,model);
            TeamPKManager.buildingMap.add(i.buyTime,model);
            depthLevel.addChild(model);
            ToolTipManager.add(model,FortressItemXMLInfo.getName(model.info.id));
         }
         for each(i in TeamPKManager.awayBuildinList)
         {
            model = new PKArmModel(i,false,TeamPKManager.AWAY);
            if(TeamPKManager.TEAM == TeamPKManager.HOME)
            {
               model.isEnemy = true;
            }
            model.x = model.pos.x + TeamPKManager.REDX;
            model.info.pos.x = model.x;
            model.info.pos.y = model.y - model.height;
            TeamPKManager.awayBuildingMap.add(i.buyTime,model);
            TeamPKManager.buildingMap.add(i.buyTime,model);
            depthLevel.addChild(model);
            ToolTipManager.add(model,FortressItemXMLInfo.getName(model.info.id));
         }
         TeamPKManager.initBuildList();
         this._time.start();
         this.getStatus();
      }
      
      private function onOpenDoor(event:TeamPKEvent) : void
      {
         DisplayUtil.removeForParent(typeLevel["mask_1"]);
         DisplayUtil.removeForParent(typeLevel["mask_2"]);
         DisplayUtil.removeAllChild(btnLevel);
         MapManager.currentMap.makeMapArray();
         this._go_0.gotoAndPlay(2);
         this._go_1.gotoAndPlay(2);
         if(TeamPKManager.TEAM == TeamPKManager.HOME)
         {
            TeamPKManager.updateDistance(TeamPKManager.awayBuildingMap.getValues());
         }
         else
         {
            TeamPKManager.updateDistance(TeamPKManager.homeBuildingMap.getValues());
         }
      }
      
      private function onAimat(event:AimatEvent) : void
      {
         var i:SpriteModel = null;
         if(TeamPKManager.PK_STATUS != TeamPKManager.OPEN_DOOR)
         {
            return;
         }
         var info:AimatInfo = event.info;
         var array:Array = UserManager.getUserModelList().concat(TeamPKManager.buildingMap.getValues());
         for each(i in array)
         {
            if(Boolean(i.hitTestPoint(info.endPos.x + LevelManager.mapLevel.x,info.endPos.y,true)) && event.info.userID == MainManager.actorID)
            {
               if(i is BasePeoleModel)
               {
                  if((i as BasePeoleModel).isShield)
                  {
                     (i as BasePeoleModel).showShieldMovie();
                  }
                  else
                  {
                     TeamPKManager.shot((i as BasePeoleModel).info.userID,0,Math.floor(Point.distance(i.pos,MainManager.actorModel.pos)));
                  }
               }
               else
               {
                  TeamPKManager.shot(0,(i as PKArmModel).info.buyTime,Math.floor(Point.distance(i.pos,MainManager.actorModel.pos)));
               }
               break;
            }
         }
      }
      
      private function onTimeCount(event:TeamPKEvent) : void
      {
      }
      
      public function clickPoit() : void
      {
         this.active.clickHandler();
      }
   }
}

