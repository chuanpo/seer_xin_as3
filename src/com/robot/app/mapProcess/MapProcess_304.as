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
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_304 extends BaseMapProcess
   {
      private var btn_0:MovieClip;
      
      private var btn_1:MovieClip;
      
      private var arrowheadMC:MovieClip;
      
      private var chestsMC:MovieClip;
      
      private var direction:uint = 1;
      
      private var count:uint = 1;
      
      public function MapProcess_304()
      {
         super();
      }
      
      override protected function init() : void
      {
         MazeController.setup();
         var ran_0:uint = Math.floor(Math.random() * 5);
         this.arrowheadMC = conLevel["arrowheadMC"];
         this.arrowheadMC.gotoAndStop(ran_0);
         this.direction = ran_0;
         this.btn_0 = conLevel["btn_0"];
         this.btn_1 = conLevel["btn_1"];
         this.btn_0.buttonMode = true;
         this.btn_1.buttonMode = true;
         var ran_1:uint = Math.floor(Math.random() * 5);
         var ran_2:uint = Math.floor(Math.random() * 5);
         this.btn_0.gotoAndStop(ran_1);
         this.btn_1.gotoAndStop(ran_2);
         this.btn_0.addEventListener(MouseEvent.CLICK,this.onClickBox);
         this.btn_1.addEventListener(MouseEvent.CLICK,this.onClickBox);
         this.chestsMC = conLevel["chestsMC"];
         this.chestsMC.gotoAndStop(1);
         SocketConnection.addCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
      }
      
      override public function destroy() : void
      {
         MazeController.destroy();
      }
      
      private function onClickBox(evt:MouseEvent) : void
      {
         var mc:MovieClip = evt.currentTarget as MovieClip;
         this.count = mc.currentFrame;
         if(this.count == mc.totalFrames)
         {
            mc.gotoAndStop(1);
         }
         else
         {
            ++this.count;
            mc.gotoAndStop(this.count);
         }
         if(this.chestsMC == null)
         {
            return;
         }
         if(this.btn_0.currentFrame == this.direction && this.btn_1.currentFrame == this.direction)
         {
            this.chestsMC.gotoAndPlay(2);
            this.chestsMC.addEventListener(Event.ENTER_FRAME,function(evt:Event):void
            {
               if(chestsMC.currentFrame == chestsMC.totalFrames)
               {
                  chestsMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  chestsMC.buttonMode = true;
                  chestsMC.addEventListener(MouseEvent.CLICK,onClickChests);
               }
            });
         }
      }
      
      private function onClickChests(evt:MouseEvent) : void
      {
         this.chestsMC.removeEventListener(MouseEvent.CLICK,this.onClickChests);
         DisplayUtil.removeForParent(this.chestsMC);
         this.chestsMC = null;
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

