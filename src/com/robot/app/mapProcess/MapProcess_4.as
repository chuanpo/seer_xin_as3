package com.robot.app.mapProcess
{
   import com.robot.app.energy.ore.DayOreCount;
   import com.robot.app.help.HelpManager;
   import com.robot.app.newspaper.ContributeAlert;
   import com.robot.app.task.books.FlyBook;
   import com.robot.core.CommandID;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_4 extends BaseMapProcess
   {
      private var loader:MCLoader;
      
      private var curDisplayObj:DisplayObject;
      
      private var flyBookBtn:SimpleButton;
      
      private var tgMC:SimpleButton;
      
      private var bookMC:SimpleButton;
      
      private var gyMC:SimpleButton;
      
      private var gyPanel:MovieClip;
      
      private var gyCloseBtn:SimpleButton;
      
      private var _npc:MovieClip;
      
      private var _shipBreakageMc:MovieClip;
      
      private var wbMc:MovieClip;
      
      private var mbox:DialogBox;
      
      public function MapProcess_4()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.flyBookBtn = conLevel["flyBookBtn"];
         this.bookMC = conLevel["bookMC"];
         this.flyBookBtn.addEventListener(MouseEvent.CLICK,this.showBook);
         this.bookMC.addEventListener(MouseEvent.CLICK,this.showBook);
         this.tgMC = conLevel["tgMC"];
         ToolTipManager.add(this.tgMC,"给船长写信");
         this.tgMC.addEventListener(MouseEvent.CLICK,this.tgFun);
         ToolTipManager.add(conLevel["gameMc"],"保护导航仪");
         ToolTipManager.add(this.flyBookBtn,"飞船手册");
         ToolTipManager.add(this.bookMC,"飞船手册");
         this.gyMC = conLevel["GY_MC"];
         this.gyMC.addEventListener(MouseEvent.CLICK,this.openGy);
         ToolTipManager.add(this.gyMC,"船员公约");
         DisplayUtil.removeForParent(depthLevel["wenMc"],false);
         DisplayUtil.removeForParent(depthLevel["wenMc"],false);
         var btn:SimpleButton = conLevel["nonoBtn"];
         ToolTipManager.add(btn,"超能NoNo赛尔豆领取");
         btn.addEventListener(MouseEvent.CLICK,this.clickNonoBtn);
         this.wbMc = conLevel["hitWbMC"];
         this.wbMc.addEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.addEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
      }
      
      private function wbmcOverHandler(e:MouseEvent) : void
      {
         this.mbox = new DialogBox();
         this.mbox.show("有什么需要我帮助您的吗？",0,-30,conLevel["wbNpc"]);
      }
      
      private function wbmcOUTHandler(e:MouseEvent) : void
      {
         this.mbox.hide();
      }
      
      private function clickNonoBtn(event:MouseEvent) : void
      {
         var or:DayOreCount = null;
         if(!MainManager.actorModel.nono)
         {
            Alarm.show("你要带上NoNo才能领取物品哦！");
            return;
         }
         if(MainManager.actorInfo.superNono)
         {
            or = new DayOreCount();
            or.addEventListener(DayOreCount.countOK,this.onCount);
            or.sendToServer(2001);
         }
      }
      
      public function showWBTask() : void
      {
         HelpManager.show(0);
      }
      
      private function onCount(event:Event) : void
      {
         if(DayOreCount.oreCount < 1)
         {
            SocketConnection.addCmdListener(CommandID.TALK_CATE,this.onTalk);
            SocketConnection.send(CommandID.TALK_CATE,2001);
         }
         else
         {
            Alarm.show("本周你已经领取过赛尔豆了，下周再来吧。");
         }
      }
      
      private function onTalk(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onTalk);
         Alarm.show("恭喜你获得" + TextFormatUtil.getRedTxt("5000赛尔豆"));
         MainManager.actorInfo.coins += 5000;
      }
      
      private function onTaskComplete(e:Event) : void
      {
         DisplayUtil.removeForParent(depthLevel["wenMc"]);
      }
      
      private function tgFun(event:MouseEvent) : void
      {
         ContributeAlert.show(ContributeAlert.SHIPER_TYPE);
      }
      
      public function showWbAction() : void
      {
         var mc:MovieClip = conLevel["wbNpc"] as MovieClip;
         mc.gotoAndPlay(2);
      }
      
      override public function destroy() : void
      {
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         this.wbMc = null;
         this.mbox = null;
         ToolTipManager.remove(this.flyBookBtn);
         ToolTipManager.remove(this.bookMC);
         ToolTipManager.remove(this.tgMC);
         ToolTipManager.remove(conLevel["gameMc"]);
         this.curDisplayObj = null;
         this.loader = null;
         this.flyBookBtn.removeEventListener(MouseEvent.CLICK,this.showBook);
         this.tgMC.removeEventListener(MouseEvent.CLICK,this.tgFun);
         this.bookMC.removeEventListener(MouseEvent.CLICK,this.showBook);
         this.tgMC = null;
         this.bookMC = null;
         ToolTipManager.remove(this.gyMC);
         this.gyMC.removeEventListener(MouseEvent.CLICK,this.openGy);
         this.gyMC = null;
      }
      
      private function openGy(event:MouseEvent) : void
      {
         if(!this.gyPanel)
         {
            this.gyPanel = MapLibManager.getMovieClip("ui_gy_mc");
            this.gyCloseBtn = this.gyPanel["closeBtn"];
            this.gyCloseBtn.addEventListener(MouseEvent.CLICK,this.closeGy);
         }
         DisplayUtil.align(this.gyPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this.gyPanel);
      }
      
      private function closeGy(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.gyPanel,false);
      }
      
      private function showBook(e:MouseEvent) : void
      {
         FlyBook.loadPanel();
      }
      
      public function showGame() : void
      {
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         SocketConnection.send(CommandID.JOIN_GAME,1);
      }
      
      private function onJoinGame(e:SocketEvent) : void
      {
         MapManager.destroy();
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         this.loader = new MCLoader("resource/Games/ShootGame.swf",LevelManager.topLevel,1,"正在加载保护导航仪游戏");
         this.loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         this.loader.doLoad();
      }
      
      private function onLoadDLL(event:MCLoadEvent) : void
      {
         this.loader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         LevelManager.topLevel.addChild(event.getContent());
         event.getContent().addEventListener("shootGameOver",this.onGameOver);
         this.curDisplayObj = event.getContent();
      }
      
      private function onGameOver(e:Event) : void
      {
         var sp:* = e.target as Sprite;
         var obj:Object = sp.scoreObj;
         var per:uint = uint(obj.per);
         var score:uint = uint(obj.score);
         MapManager.refMap();
         SocketConnection.send(CommandID.GAME_OVER,per,score);
      }
   }
}

