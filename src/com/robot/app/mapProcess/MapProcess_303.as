package com.robot.app.mapProcess
{
   import com.robot.app.sceneInteraction.MazeController;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.temp.AresiaSpacePrize;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_303 extends BaseMapProcess
   {
      private var axle_0:MovieClip;
      
      private var axle_1:MovieClip;
      
      private var axle_2:MovieClip;
      
      private var chestsDoor:MovieClip;
      
      private var chests:MovieClip;
      
      private var timer_0:Timer;
      
      private var timer_1:Timer;
      
      private var timer_2:Timer;
      
      private var checkArr:Array = [false,false];
      
      private var count_0:uint = 0;
      
      private var count_1:uint = 0;
      
      private var count_2:uint = 0;
      
      private var clickAxle:MovieClip;
      
      public function MapProcess_303()
      {
         super();
      }
      
      override protected function init() : void
      {
         MazeController.setup();
         this.axle_0 = conLevel["axle_0"];
         this.axle_1 = conLevel["axle_1"];
         this.axle_0.buttonMode = true;
         this.axle_1.buttonMode = true;
         this.axle_0.mouseChildren = false;
         this.axle_1.mouseChildren = false;
         this.axle_0.addEventListener(MouseEvent.CLICK,this.onClickAxle);
         this.axle_1.addEventListener(MouseEvent.CLICK,this.onClickAxle);
         this.chestsDoor = conLevel["chestsDoor"];
         this.chests = conLevel["chests"];
         this.chests.visible = false;
         this.chests.addEventListener(MouseEvent.CLICK,this.onGetChests);
         this.timer_0 = new Timer(1000,3);
         this.timer_1 = new Timer(1000,3);
         this.timer_2 = new Timer(1000,3);
         this.timer_0.addEventListener(TimerEvent.TIMER,this.onTimer_0);
         this.timer_1.addEventListener(TimerEvent.TIMER,this.onTimer_1);
         this.timer_0.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer_0_Comp);
         this.timer_1.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer_1_Comp);
         SocketConnection.addCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
      }
      
      override public function destroy() : void
      {
         MazeController.destroy();
         this.timer_0.removeEventListener(TimerEvent.TIMER,this.onTimer_0);
         this.timer_1.removeEventListener(TimerEvent.TIMER,this.onTimer_1);
         this.timer_0.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer_0_Comp);
         this.timer_1.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer_1_Comp);
         this.timer_0 = null;
         this.timer_1 = null;
      }
      
      private function onClickAxle(evt:MouseEvent) : void
      {
         this.clickAxle = evt.currentTarget as MovieClip;
         this.clickAxle.gotoAndStop(2);
         switch(this.clickAxle.name)
         {
            case "axle_0":
               if(this.timer_0.running)
               {
                  this.timer_0.reset();
               }
               this.timer_0.start();
               break;
            case "axle_1":
               if(this.timer_1.running)
               {
                  this.timer_1.reset();
               }
               this.timer_1.start();
         }
      }
      
      private function onTimer_0(evt:TimerEvent) : void
      {
         if(this.count_0 >= 5)
         {
            this.checkArr[0] = true;
         }
         ++this.count_0;
         this.check();
      }
      
      private function onTimer_1(evt:TimerEvent) : void
      {
         if(this.count_1 >= 5)
         {
            this.checkArr[1] = true;
         }
         ++this.count_1;
         this.check();
      }
      
      private function onTimer_0_Comp(evt:TimerEvent) : void
      {
         this.timer_0.stop();
         this.count_0 = 0;
         this.axle_0.gotoAndStop(1);
      }
      
      private function onTimer_1_Comp(evt:TimerEvent) : void
      {
         this.timer_1.stop();
         this.count_1 = 0;
         this.axle_1.gotoAndStop(1);
      }
      
      private function check() : void
      {
         var i:Boolean = false;
         for each(i in this.checkArr)
         {
            if(i == false)
            {
               return;
            }
         }
         this.chestsDoor.gotoAndStop(2);
         this.chests.buttonMode = true;
         this.chests.visible = true;
      }
      
      private function onGetChests(evt:MouseEvent) : void
      {
         this.chests.removeEventListener(MouseEvent.CLICK,this.onGetChests);
         DisplayUtil.removeForParent(this.chests);
         SocketConnection.send(CommandID.PRIZE_OF_ATRESIASPACE,1);
      }
      
      private function getPirze(evt:SocketEvent) : void
      {
         var o:Object = null;
         var itemID:uint = 0;
         var itemCnt:uint = 0;
         var name:String = null;
         var str:String = null;
         SocketConnection.removeCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
         var data:AresiaSpacePrize = evt.data as AresiaSpacePrize;
         var arr:Array = data.monBallList;
         for each(o in arr)
         {
            itemID = uint(o.itemID);
            itemCnt = uint(o.itemCnt);
            name = ItemXMLInfo.getName(itemID);
            str = itemCnt + "个<font color=\'#FF0000\'>" + name + "</font>已经放入了你的储存箱！";
            if(itemCnt != 0)
            {
               LevelManager.tipLevel.addChild(ItemInBagAlert.show(itemID,str));
            }
         }
      }
   }
}

