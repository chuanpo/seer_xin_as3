package com.robot.app.mapProcess.active
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.manager.ModuleManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   
   public class PetListController
   {
      private var hotBtn:SimpleButton;
      
      private var scoreBtn:SimpleButton;
      
      private var scorePanel:AppModel;
      
      private var hotPanel:AppModel;
      
      public function PetListController(scoreBtn:SimpleButton, hotBtn:SimpleButton)
      {
         super();
         this.scoreBtn = scoreBtn;
         this.hotBtn = hotBtn;
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,function(event:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,arguments.callee);
            var date:Date = (event.data as SystemTimeInfo).date;
            if(date.getFullYear() == 2010)
            {
               addPanelEvent();
            }
            else
            {
               addNormalEvent();
            }
         });
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private function addNormalEvent() : void
      {
         ToolTipManager.add(this.scoreBtn,"精灵战绩榜");
         ToolTipManager.add(this.hotBtn,"精灵人气榜");
         this.scoreBtn.addEventListener(MouseEvent.CLICK,this.showTip);
         this.hotBtn.addEventListener(MouseEvent.CLICK,this.showTip);
      }
      
      private function showTip(event:MouseEvent) : void
      {
         Alarm.show("精灵战绩和人气榜将在1月1日开始公布");
      }
      
      private function addPanelEvent() : void
      {
         this.scoreBtn.addEventListener(MouseEvent.CLICK,this.showScore);
         this.hotBtn.addEventListener(MouseEvent.CLICK,this.showHot);
      }
      
      public function destroy() : void
      {
         ToolTipManager.remove(this.scoreBtn);
         ToolTipManager.remove(this.hotBtn);
         this.scoreBtn.removeEventListener(MouseEvent.CLICK,this.showTip);
         this.hotBtn.removeEventListener(MouseEvent.CLICK,this.showTip);
         this.scoreBtn.removeEventListener(MouseEvent.CLICK,this.showScore);
         this.hotBtn.removeEventListener(MouseEvent.CLICK,this.showHot);
         if(Boolean(this.scorePanel))
         {
            this.scorePanel.destroy();
            this.scorePanel = null;
         }
         if(Boolean(this.hotPanel))
         {
            this.hotPanel.destroy();
            this.hotPanel = null;
         }
      }
      
      private function showScore(event:MouseEvent) : void
      {
         if(!this.scorePanel)
         {
            this.scorePanel = ModuleManager.getModule(ClientConfig.getAppModule("IcePetScroeList"),"正在打开精灵战绩榜");
            this.scorePanel.setup();
         }
         this.scorePanel.show();
      }
      
      private function showHot(event:MouseEvent) : void
      {
         if(!this.hotPanel)
         {
            this.hotPanel = ModuleManager.getModule(ClientConfig.getAppModule("IcePetHotList"),"正在打开精灵人气榜");
            this.hotPanel.setup();
         }
         this.hotPanel.show();
      }
   }
}

