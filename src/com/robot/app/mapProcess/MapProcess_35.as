package com.robot.app.mapProcess
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.dayGift.DayGiftController;
   import com.robot.core.info.task.CateInfo;
   import com.robot.core.info.task.DayTalkInfo;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.events.SocketEvent;
   import com.robot.core.manager.TasksManager;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.task.control.TaskController_42;
   
   public class MapProcess_35 extends BaseMapProcess
   {
      private var gameTrig:MovieClip;
      
      private var panel:AppModel;

      private var inTask42Flag:Boolean = false;
      
      private var makePetPassFlag:Boolean = false;

      public function MapProcess_35()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.gameTrig = conLevel["game_trig"];
         this.gameTrig.visible = false;
         this.gameTrig.buttonMode = true;
         if(TasksManager.getTaskStatus(42) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(42,function(arr:Array):void{
               if((arr[3] && !arr[4])){
                  inTask42Flag = true;
                  gameInit();
               }
            })
         }else if(TasksManager.getTaskStatus(42) == TasksManager.COMPLETE)
         {
            gameInit();
         }else
         {

         }
         conLevel["btn1"].addEventListener(MouseEvent.CLICK,this.onBtn1ClickHandler);
         conLevel["btn2"].addEventListener(MouseEvent.CLICK,this.onBtn2ClickHandler);
      }
      
      private function gameInit():void
      {
         this.gameTrig.visible = true;
         this.gameTrig.addEventListener(MouseEvent.CLICK,this.onGameTrigClickHand);
      }

      private function onGameTrigClickHand(e:MouseEvent) : void
      {
         if(!this.panel)
         {
            this.panel = new AppModel(ClientConfig.getGameModule("SpritePieceTogether"),"正在打开...");
            this.panel.setup();
            this.panel.sharedEvents.addEventListener("GamePass",this.onGamePassHandler);
            this.panel.sharedEvents.addEventListener("GameFail",this.onGameFailHandler);
            this.panel.sharedEvents.addEventListener("GameClose",this.onGameCloseHandler);
         }
         this.panel.show();
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoinGameHandler);
         SocketConnection.send(CommandID.JOIN_GAME,1);
      }
      
      private function onJoinGameHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoinGameHandler);
      }
      
      private function gameOverHandler(percent:uint = 0, score:uint = 0) : void
      {
         SocketConnection.addCmdListener(CommandID.GAME_OVER,this.onGameOverHandler);
         SocketConnection.send(CommandID.GAME_OVER,percent,score);
      }
      
      private function onGameOverHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GAME_OVER,this.onGameOverHandler);
         if(inTask42Flag){
            if(makePetPassFlag){
               NpcTipDialog.show("天！太棒了！你为什么可以制造出这样完美的机械精灵？你究竟是谁？",function():void{
                  NpcTipDialog.show("我只是一个星球旅行者",function():void{
                     NpcTipDialog.show("太棒了！赛尔！这下赫尔卡星就有救了！我们快回去告诉爱丽丝这个好消息吧！",function():void{
                        TasksManager.complete(TaskController_42.TASK_ID,4,function():void{
                        TaskController_42.showPanel();
                     })
                     },NpcTipDialog.NONO)
                  },NpcTipDialog.SEER)
               },NpcTipDialog.ELDER)
            }else
            {
               NpcTipDialog.show("别着急，一定能成功制造出比卡塔精灵更厉害的机械精灵的！",null,NpcTipDialog.NONO)
            }
         }
      }
      
      private function onGameCloseHandler(e:Event) : void
      {
         this.panel.sharedEvents.removeEventListener("GameClose",this.onGameCloseHandler);
         this.panel.destroy();
         this.panel = null;
         this.gameOverHandler();
         this.makePetPassFlag = false;
      }
      
      private function onGameFailHandler(e:Event) : void
      {
         this.panel.sharedEvents.removeEventListener("GameFail",this.onGameFailHandler);
         this.panel.destroy();
         this.panel = null;
         this.gameOverHandler();
         this.makePetPassFlag = false;
         Alarm.show("哦噢！很抱歉，制造机械精灵任务失败！");
      }
      
      private function onGamePassHandler(e:Event) : void
      {
         this.panel.sharedEvents.removeEventListener("GamePass",this.onGamePassHandler);
         this.panel.destroy();
         this.panel = null;
         this.makePetPassFlag = true;
         this.gameOverHandler(100,100);
      }
      
      private function onBtn1ClickHandler(e:MouseEvent) : void
      {
         var gift:DayGiftController = new DayGiftController(1502,1,"你已经领取过胶囊了");
         gift.addEventListener(DayGiftController.COUNT_SUCCESS,this.onCountSuccess);
         gift.getCount();
         conLevel["btn1"].removeEventListener(MouseEvent.CLICK,this.onBtn1ClickHandler);
         conLevel["btn1"].mouseEnabled = false;
      }
      
      private function onCountSuccess(event:Event) : void
      {
         var gift:DayGiftController = null;
         var mc:MovieClip = null;
         gift = event.currentTarget as DayGiftController;
         mc = conLevel["mc2"];
         mc.gotoAndPlay(2);
         mc.addEventListener(Event.ENTER_FRAME,function(e:Event):void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               gift.sendToServer(function(info:DayTalkInfo):void
               {
                  var i:CateInfo = null;
                  var id:uint = 0;
                  var count:uint = 0;
                  for each(i in info.outList)
                  {
                     id = uint(i.id);
                     count = uint(i.count);
                     ItemInBagAlert.show(id,count + "个<font color=\'#ff0000\'>" + ItemXMLInfo.getName(id) + "</font>已经放入你的储存箱中");
                  }
               });
            }
         });
      }
      
      private function onBtn2ClickHandler(e:MouseEvent) : void
      {
         conLevel["btn2"].removeEventListener(MouseEvent.CLICK,this.onBtn2ClickHandler);
         conLevel["btn2"].mouseEnabled = false;
      }
      
      public function onMc3HitHandler() : void
      {
         conLevel["mc3"].gotoAndPlay(2);
      }
      
      override public function destroy() : void
      {
         conLevel["btn1"].removeEventListener(MouseEvent.CLICK,this.onBtn1ClickHandler);
         conLevel["btn2"].removeEventListener(MouseEvent.CLICK,this.onBtn2ClickHandler);
         this.gameTrig.removeEventListener(MouseEvent.CLICK,this.onGameTrigClickHand);
         this.gameTrig = null;
      }
   }
}

