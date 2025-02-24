package com.robot.app.mapProcess
{
   import com.robot.app.buyCloth.BuyClothController;
   import com.robot.app.buyItem.ItemAction;
   import com.robot.app.games.waterGunGame.WaterGunGame;
   import com.robot.app.help.HelpManager;
   import com.robot.app.task.noviceGuide.XixiDialog;
   import com.robot.app.task.pioneerTaskList.BatteryTestTask;
   import com.robot.app.task.pioneerTaskList.HOTestTask;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.event.TaskEvent;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.book.BookId;
   import com.robot.core.manager.book.BookManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcController;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.DialogBox;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_8 extends BaseMapProcess
   {
      private var _buyBtn:SimpleButton;
      
      private var _repairBtn:SimpleButton;
      
      private var _btnNpc:Sprite;
      
      private var _inID:uint;
      
      private var ciciMC:NpcModel;
      
      private var dialogTimer:Timer;
      
      private var xixi:String;
      
      private var _doodlePanel:AppModel;
      
      private var _isShow:Boolean = false;
      
      private var repairPanel:AppModel;
      
      private var halfIcon:MovieClip;
      
      private var _arrowHeadMC:MovieClip;
      
      private var _shopSo:SharedObject;
      
      private var _elietCoinBtn:SimpleButton;
      
      private var _bookApp:AppModel;
      
      private var _machPanel:MovieClip;
      
      private var wbMc:MovieClip;
      
      private var mbox:DialogBox;
      
      private var drillInBagMC:MovieClip;
      
      private var npc:NpcModel;
      
      public function MapProcess_8()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._machPanel = MapLibManager.getMovieClip("GetMachPanel");
         if(MainManager.actorInfo.loginCnt == 0)
         {
            if(!MainManager.checkIsNovice())
            {
               XixiDialog.showNew();
            }
            MainManager.actorInfo.loginCnt = 1;
         }
         ToolTipManager.add(conLevel["itemBtn"],"领取挖矿钻头");
         this._repairBtn = conLevel["repairBtn"];
         this._repairBtn.addEventListener(MouseEvent.CLICK,this.openRepair);
         this._buyBtn = conLevel["buyBtn"];
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.buyHandler);
         this._shopSo = SOManager.getUserSO(SOManager.Is_Readed_ShopingBook);
         this.conLevel["shopMc"].addEventListener(MouseEvent.CLICK,this.onShopHandler);
         this.dialogTimer = new Timer(10 * 1000);
         this.dialogTimer.addEventListener(TimerEvent.TIMER,this.showDialog);
         this.dialogTimer.start();
         this.xixi = NpcTipDialog.CICI;
         var box:DialogBox = new DialogBox();
         this._elietCoinBtn = conLevel["elietCoinBtn"];
         ToolTipManager.add(conLevel["shopMc"],"赛尔典藏手册");
         ToolTipManager.add(this._buyBtn,"赛尔工厂");
         ToolTipManager.add(conLevel["getMach_btn"],"特殊装置领取舱");
         ToolTipManager.add(conLevel["buyBtn2"],"赛尔工厂");
         ToolTipManager.add(conLevel["color_door"],"涂装室");
         ToolTipManager.add(conLevel["repairBtn"],"装备修复机");
         ToolTipManager.add(this._elietCoinBtn,"米币精品手册 ");
         this._elietCoinBtn.addEventListener(MouseEvent.CLICK,this.clickElietCoinHandler);
         this.wbMc = conLevel["hitWbMC"];
         this.wbMc.addEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.addEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         this.halfIcon = MapLibManager.getMovieClip("half_icon");
         this.halfIcon.mouseChildren = false;
         this.halfIcon.mouseEnabled = false;
         if(MainManager.isClothHalfDay)
         {
            this.halfIcon.x = 885;
            this.halfIcon.y = 380;
            conLevel.addChild(this.halfIcon);
         }
         this.wbMc.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this._arrowHeadMC = conLevel["arrowHeadMC"];
         this._arrowHeadMC.visible = false;
         this.initTask_94();
      }
      
      private function clickElietCoinHandler(e:MouseEvent) : void
      {
         BookManager.show(BookId.BOOK_0);
      }
      
      private function enterFrameHandler(e:Event) : void
      {
         if(Boolean(NpcController.curNpc))
         {
            this.wbMc.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         }
      }
      
      public function funHitDoor() : void
      {
         MapManager.changeLocalMap(513);
      }
      
      private function onShopHandler(e:MouseEvent) : void
      {
         this.showShopBook();
      }
      
      private function showShopBook() : void
      {
         if(!this._bookApp)
         {
            this._bookApp = new AppModel(ClientConfig.getBookModule("SeerBookReservationPanel"),"正在打开");
            this._bookApp.setup();
         }
         this._bookApp.show();
      }
      
      private function showDialog(event:TimerEvent) : void
      {
         var box:DialogBox = new DialogBox();
      }
      
      public function showWBTask() : void
      {
         HelpManager.show(0);
      }
      
      private function showTip(e:MouseEvent) : void
      {
         NpcTipDialog.show("这里是 ，机器人赛尔的装备库。你在这里可以购买和修复装备，还可以给自己选一套超炫的涂装。");
      }
      
      private function openRepair(event:MouseEvent) : void
      {
         if(!this.repairPanel)
         {
            this.repairPanel = new AppModel(ClientConfig.getAppModule("RepairItemPanel"),"正在打开修复装置");
            this.repairPanel.setup();
         }
         this.repairPanel.show();
      }
      
      public function buyHandler(event:MouseEvent = null) : void
      {
         BuyClothController.show();
      }
      
      public function changeToGround() : void
      {
      }
      
      public function onColor() : void
      {
         if(this._doodlePanel == null)
         {
            this._doodlePanel = new AppModel(ClientConfig.getAppModule("DoodlePanel"),"正在打开涂装面板");
            this._doodlePanel.setup();
            this._doodlePanel.sharedEvents.addEventListener(Event.OPEN,this.onDoodleOpen);
            this._doodlePanel.sharedEvents.addEventListener(Event.CLOSE,this.onDoodleClose);
         }
         this._doodlePanel.show();
      }
      
      public function buyItem() : void
      {
         ItemAction.buyItem(100014,false);
      }
      
      public function onMachHandler() : void
      {
         LevelManager.appLevel.addChild(this._machPanel);
         DisplayUtil.align(this._machPanel,null,AlignType.MIDDLE_CENTER);
         this._machPanel["close_btn"].addEventListener(MouseEvent.CLICK,this.clickMachCloseHandler);
         this._machPanel["ship_btn"].addEventListener(MouseEvent.CLICK,this.onShipHandler);
         this._machPanel["fire_btn"].addEventListener(MouseEvent.CLICK,this.onFireHandler);
         this._machPanel["wateGameBtn"].addEventListener(MouseEvent.CLICK,this.showWaterGame);
      }
      
      public function onFireHandler(e:MouseEvent) : void
      {
         this.clickMachCloseHandler();
         NpcTipDialog.show("喷火枪的燃料是高纯度的氢气和氧气，只有按照合适比例混合后点燃，才能爆出最大的火焰。你先试用下这个喷火装置，看看你能不能搞定这个危险大家伙！",function():void
         {
            var ho:HOTestTask = new HOTestTask();
         },NpcTipDialog.DOCTOR,-60);
      }
      
      public function onShipHandler(e:MouseEvent) : void
      {
         this.clickMachCloseHandler();
         NpcTipDialog.show("潜水套装可以让赛尔承受海底的巨大压力，潜入深水去寻找矿藏。潜水套装里面有个电路，正确连接电路就可以启动它。你先拿这个模型练练手！",function():void
         {
            var bb:BatteryTestTask = new BatteryTestTask();
         },NpcTipDialog.CICI,-60);
      }
      
      private function clickMachCloseHandler(e:MouseEvent = null) : void
      {
         DisplayUtil.removeForParent(this._machPanel);
      }
      
      public function showWaterGame(e:MouseEvent) : void
      {
         this.clickMachCloseHandler();
         NpcTipDialog.show("喷水装备可以用于灭火，强力水柱还能够击破碎石。你在火山星任务中会用到它。考考你，同一支水枪如何打到最远。",this.startWaterGame,this.xixi,-60);
      }
      
      private function startWaterGame() : void
      {
         WaterGunGame.loadGame();
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
      
      public function showWbAction() : void
      {
         var mc:MovieClip = conLevel["wbNpc"] as MovieClip;
         mc.gotoAndPlay(2);
      }
      
      override public function destroy() : void
      {
         ItemAction.desBuyPanel();
         ToolTipManager.remove(conLevel["itemBtn"]);
         DisplayUtil.removeForParent(this.halfIcon);
         this.halfIcon = null;
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         this.wbMc = null;
         this.mbox = null;
         this.dialogTimer.stop();
         this.dialogTimer.removeEventListener(TimerEvent.TIMER,this.showDialog);
         this.dialogTimer = null;
         clearTimeout(this._inID);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.buyHandler);
         this._repairBtn.removeEventListener(MouseEvent.CLICK,this.openRepair);
         this.xixi = null;
         ToolTipManager.remove(this._buyBtn);
         ToolTipManager.remove(conLevel["wateGameBtn"]);
         ToolTipManager.remove(conLevel["ship_btn"]);
         ToolTipManager.remove(conLevel["buyBtn2"]);
         ToolTipManager.remove(conLevel["color_door"]);
         ToolTipManager.remove(conLevel["repairBtn"]);
         if(Boolean(this._doodlePanel))
         {
            this._doodlePanel.sharedEvents.removeEventListener(Event.OPEN,this.onDoodleOpen);
            this._doodlePanel.sharedEvents.removeEventListener(Event.CLOSE,this.onDoodleClose);
            this._doodlePanel.destroy();
            this._doodlePanel = null;
         }
         if(Boolean(this.repairPanel))
         {
            this.repairPanel.destroy();
            this.repairPanel = null;
         }
         BuyClothController.destroy();
         if(Boolean(this._bookApp))
         {
            this._bookApp.destroy();
            this._bookApp = null;
         }
         conLevel["shopMc"].removeEventListener(MouseEvent.CLICK,this.onShopHandler);
         this._shopSo = null;
         ToolTipManager.remove(conLevel["shopMc"]);
      }
      
      private function onDoodleOpen(e:Event) : void
      {
         this._inID = setTimeout(function():void
         {
            MainManager.actorModel.sprite.x = 225;
            MainManager.actorModel.sprite.y = 90;
         },500);
      }
      
      private function onDoodleClose(e:Event) : void
      {
         this._inID = setTimeout(function():void
         {
            MainManager.actorModel.sprite.x = 332;
            MainManager.actorModel.sprite.y = 115;
         },1000);
      }
      
      private function initTask_94() : void
      {
         if(TasksManager.getTaskStatus(94) == TasksManager.UN_ACCEPT)
         {
            TasksManager.addListener(TaskEvent.ACCEPT,94,0,this.onAcceptTask);
         }
         else
         {
            TasksManager.getProStatusList(94,function(arr:Array):void
            {
               if(!arr[0])
               {
                  onAcceptTask();
               }
               if(Boolean(arr[0]) && !arr[1])
               {
                  _arrowHeadMC.visible = true;
               }
            });
         }
      }
      
      private function onAcceptTask(evt:TaskEvent = null) : void
      {
         TasksManager.removeListener(TaskEvent.ACCEPT,94,0,this.onAcceptTask);
         this.drillInBagMC = MapLibManager.getMovieClip("DrillInBagMC");
         LevelManager.topLevel.addChild(this.drillInBagMC);
         this.drillInBagMC.x = 437;
         this.drillInBagMC.y = 333;
         this.drillInBagMC.gotoAndPlay(2);
         this.drillInBagMC.addEventListener(Event.ENTER_FRAME,function(evt:Event):void
         {
            if(drillInBagMC.currentFrame == drillInBagMC.totalFrames)
            {
               drillInBagMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               DisplayUtil.removeForParent(drillInBagMC);
               ItemManager.addEventListener(ItemEvent.CLOTH_LIST,onHasClothOne);
               ItemManager.getCloth();
            }
         });
      }
      
      private function onHasClothOne(evt:ItemEvent) : void
      {
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onHasClothOne);
         if(ItemManager.containsCloth(100014))
         {
            this.completeTask_0();
         }
         else
         {
            ItemAction.buyItem(100014,false);
            EventManager.addEventListener(ItemAction.BUY_ONE,this.onGetItemOne);
         }
      }
      
      private function onGetItemOne(evt:DynamicEvent) : void
      {
         if(uint(evt.paramObject) == 100014)
         {
            EventManager.removeEventListener(ItemAction.BUY_ONE,this.onGetItemOne);
            this.completeTask_0();
         }
      }
      
      private function completeTask_0() : void
      {
         NpcDialog.show(NPC.CICI,["有些星球还饱含大量的气态能源，需要用0xff0000气体收集器0xffffff才能收集到！如果你有需要，可以在机械室的0xff0000赛尔工厂0xffffff购买哦。当然，天下没有免费的午餐！#8"],["好！我这就去看看！"],[function():void
         {
            TasksManager.complete(94,0,null,true);
            _arrowHeadMC.visible = true;
         }]);
      }
   }
}

