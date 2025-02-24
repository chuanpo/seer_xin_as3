package com.robot.app.mapProcess
{
   import com.robot.app.magicPassword.MagicPasswordController;
   import com.robot.app.paintBook.PaintBookController;
   import com.robot.app.task.books.FlyBook;
   import com.robot.app.task.books.InstructorBook;
   import com.robot.app.task.books.MonsterBook;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.ModuleManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_9 extends BaseMapProcess
   {
      private static var panel:AppModel;
      
      private var newsPaperBtn:SimpleButton;
      
      private var allBookPanel:MovieClip;
      
      private var cupBtn:SimpleButton;
      
      private var planBtn:SimpleButton;
      
      private var _nonoBookApp:AppModel;
      
      private var _nonoChipMix:AppModel;
      
      private var _superApp:AppModel;
      
      private var timePanel:AppModel;
      
      public function MapProcess_9()
      {
         super();
      }
      
      override protected function init() : void
      {
         ToolTipManager.add(conLevel["change_btn"],"分子频谱分析仪");
         ToolTipManager.add(conLevel["newsPaperBtn"],"往期航行日志");
         ToolTipManager.add(conLevel["spaceVurvey_mc"],"帕诺星系测绘图");
         conLevel["spaceVurvey_mc"].buttonMode = true;
         conLevel["spaceVurvey_mc"].mouseChildren = false;
         this.checkTask();
         this.newsPaperBtn = conLevel["newsPaperBtn"];
         this.newsPaperBtn.addEventListener(MouseEvent.CLICK,this.clickNewsPaper);
         this.planBtn = conLevel["planBtn"];
         this.planBtn.visible = true;
         this.planBtn.addEventListener(MouseEvent.CLICK,this.loadBook1);
         conLevel["bookBtn"].addEventListener(MouseEvent.CLICK,this.showAllBook);
         ToolTipManager.add(conLevel["bookBtn"],"赛尔资料库");
         ToolTipManager.add(conLevel["starGame"],"星座档案管理");
         this.cupBtn = conLevel["cupBtn"];
         this.cupBtn.addEventListener(MouseEvent.CLICK,this.loadBook);
      }
      
      private function checkTask() : void
      {
         conLevel["spaceVurvey_mc"].addEventListener(MouseEvent.CLICK,this.onSpaceVurveyMCClick);
         conLevel["spaceVurvey_mc"].addEventListener(MouseEvent.MOUSE_OVER,this.onSpaceVurveyMCOver);
         conLevel["spaceVurvey_mc"].addEventListener(MouseEvent.MOUSE_OUT,this.onSpaceVurveyMCOut);
      }
      
      private function onSpaceVurveyMCOver(e:MouseEvent) : void
      {
         conLevel["spaceVurvey_mc"].gotoAndStop(2);
      }
      
      private function onSpaceVurveyMCOut(e:MouseEvent) : void
      {
         conLevel["spaceVurvey_mc"].gotoAndStop(1);
      }
      
      private function onSpaceVurveyMCClick(event:MouseEvent) : void
      {
         if(!panel)
         {
            panel = new AppModel(ClientConfig.getTaskModule("SpaceSurveyView"),"正在打开测绘帕诺星系图");
            panel.setup();
         }
         panel.show();
      }
      
      private function loadBook1(event:MouseEvent) : void
      {
         var mcloader:MCLoader = new MCLoader("resource/module/greadPlan/greadPlan.swf",LevelManager.appLevel,1,"正在打开书本");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess1);
         mcloader.doLoad();
      }
      
      private function onLoadSuccess1(event:MCLoadEvent) : void
      {
         var app:ApplicationDomain = event.getApplicationDomain();
         var cls:* = app.getDefinition("GreadPlanPanel");
         var mc:MovieClip = new cls() as MovieClip;
         LevelManager.appLevel.addChild(mc);
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
      }
      
      private function loadBook(event:MouseEvent) : void
      {
         var mcloader:MCLoader = new MCLoader("resource/module/book/book.swf",LevelManager.appLevel,1,"正在打开书本");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         mcloader.doLoad();
      }
      
      private function onLoadSuccess(event:MCLoadEvent) : void
      {
         var app:ApplicationDomain = event.getApplicationDomain();
         var cls:* = app.getDefinition("Book");
         var mc:MovieClip = new cls() as MovieClip;
         LevelManager.appLevel.addChild(mc);
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
      }
      
      private function showAllBook(event:MouseEvent) : void
      {
         if(!this.allBookPanel)
         {
            this.allBookPanel = MapLibManager.getMovieClip("AllBookPanel");
            this.allBookPanel["petBtn"].addEventListener(MouseEvent.CLICK,this.showPetBook);
            this.allBookPanel["jgBtn"].addEventListener(MouseEvent.CLICK,this.showJgBook);
            this.allBookPanel["shipBtn"].addEventListener(MouseEvent.CLICK,this.showShipBook);
            this.allBookPanel["nonoBookBtn"].addEventListener(MouseEvent.CLICK,this.onNoNoBookHandler);
            this.allBookPanel["paintBtn"].addEventListener(MouseEvent.CLICK,this.onPaintBook);
         }
         DisplayUtil.align(this.allBookPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this.allBookPanel);
      }
      
      private function onPaintBook(event:MouseEvent) : void
      {
         PaintBookController.show();
      }
      
      private function onNoNoBookHandler(e:MouseEvent) : void
      {
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         if(!this._nonoBookApp)
         {
            this._nonoBookApp = new AppModel(ClientConfig.getBookModule("NoNoBook"),"正在打开NoNo手册");
            this._nonoBookApp.setup();
            this._nonoBookApp.sharedEvents.addEventListener(Event.CLOSE,this.onNoNoBookCloseHandler);
            this._nonoBookApp.sharedEvents.addEventListener(Event.OPEN,this.onOpenHandler);
            this._nonoBookApp.sharedEvents.addEventListener("supernonooper",this.onSuperNoOper);
         }
         this._nonoBookApp.show();
      }
      
      private function onNoNoSuperHandler(e:MouseEvent) : void
      {
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(!this._superApp)
         {
            this._superApp = new AppModel(ClientConfig.getBookModule("NoNoJieShaoBook"),"正在打开超能NoNo手册");
            this._superApp.setup();
            this._superApp.sharedEvents.addEventListener(Event.CLOSE,this.onNoNoJieShaoBookCloseHandler);
            this._superApp.sharedEvents.addEventListener(Event.OPEN,this.onOpenHandler);
            this._superApp.sharedEvents.addEventListener("nonobookchange",this.onOpenHandler1);
         }
         this._superApp.show();
      }
      
      private function onNoNoJieShaoBookCloseHandler(e:Event) : void
      {
         if(!this._superApp)
         {
            return;
         }
         this._superApp.sharedEvents.removeEventListener(Event.OPEN,this.onOpenHandler);
         this._superApp.sharedEvents.removeEventListener(Event.CLOSE,this.onNoNoJieShaoBookCloseHandler);
         this._superApp.sharedEvents.removeEventListener("nonobookchange",this.onOpenHandler1);
         this._superApp.destroy();
         this._superApp = null;
      }
      
      private function onNoNoBookCloseHandler(e:Event = null) : void
      {
         if(!this._nonoBookApp)
         {
            return;
         }
         this._nonoBookApp.sharedEvents.removeEventListener(Event.OPEN,this.onOpenHandler);
         this._nonoBookApp.sharedEvents.removeEventListener(Event.CLOSE,this.onNoNoBookCloseHandler);
         this._nonoBookApp.destroy();
         this._nonoBookApp = null;
      }
      
      private function onSuperNoOper(e:Event) : void
      {
         this.onCloseMixHandler(null);
         this.onNoNoSuperHandler(null);
         this.onNoNoBookCloseHandler(null);
      }
      
      private function onOpenHandler1(e:Event) : void
      {
         this.onCloseMixHandler(null);
         this.onNoNoBookHandler(null);
         this.onNoNoBookCloseHandler(null);
      }
      
      private function onOpenHandler(e:Event) : void
      {
         this.onNoNoBookCloseHandler(null);
         this.onChipMixHandler(null);
         this.onNoNoBookCloseHandler(null);
      }
      
      private function onChipMixHandler(e:MouseEvent) : void
      {
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         if(!this._nonoChipMix)
         {
            this._nonoChipMix = new AppModel(ClientConfig.getBookModule("NoNoChipMicBook"),"正在打开芯片合成书");
            this._nonoChipMix.setup();
            this._nonoChipMix.sharedEvents.addEventListener(Event.CLOSE,this.onCloseMixHandler);
         }
         this._nonoChipMix.show();
      }
      
      private function onCloseMixHandler(e:Event) : void
      {
         if(!this._nonoChipMix)
         {
            return;
         }
         this._nonoChipMix.sharedEvents.removeEventListener(Event.CLOSE,this.onCloseMixHandler);
         this._nonoChipMix.destroy();
         this._nonoChipMix = null;
      }
      
      private function showPetBook(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.allBookPanel);
         MonsterBook.loadPanel();
      }
      
      private function showJgBook(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.allBookPanel);
         InstructorBook.loadPanel();
      }
      
      private function showShipBook(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.allBookPanel);
         FlyBook.loadPanel();
      }
      
      override public function destroy() : void
      {
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         this.planBtn.removeEventListener(MouseEvent.CLICK,this.loadBook1);
         this.planBtn = null;
         ToolTipManager.remove(conLevel["starGame"]);
         this.allBookPanel = null;
         conLevel["bookBtn"].removeEventListener(MouseEvent.CLICK,this.showAllBook);
         ToolTipManager.remove(conLevel["change_btn"]);
         ToolTipManager.remove(conLevel["newsPaperBtn"]);
         this.newsPaperBtn.removeEventListener(MouseEvent.CLICK,this.clickNewsPaper);
         this.newsPaperBtn = null;
         conLevel["spaceVurvey_mc"].removeEventListener(MouseEvent.CLICK,this.onSpaceVurveyMCClick);
         conLevel["spaceVurvey_mc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onSpaceVurveyMCOver);
         conLevel["spaceVurvey_mc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onSpaceVurveyMCOut);
      }
      
      public function passExChangeHandler() : void
      {
         MagicPasswordController.show();
      }
      
      private function clickNewsPaper(event:MouseEvent) : void
      {
         Alarm.show("此功能暂不开放！");
      }
      
      public function starGame() : void
      {
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoin);
         SocketConnection.send(CommandID.JOIN_GAME,1);
      }
      
      private function onJoin(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoin);
         var mcloader:MCLoader = new MCLoader("resource/Games/theStarGame.swf",LevelManager.appLevel,1,"正在加载游戏");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onSuccess);
         mcloader.doLoad();
      }
      
      private function onSuccess(event:MCLoadEvent) : void
      {
         LevelManager.gameLevel.addChild(event.getContent());
      }
      
      public function timeMachine() : void
      {
         if(this.timePanel == null)
         {
            this.timePanel = ModuleManager.getModule(ClientConfig.getAppModule("TimePasswordMachine"),"正在打开时空密码机");
            this.timePanel.setup();
         }
         this.timePanel.show();
      }
   }
}

