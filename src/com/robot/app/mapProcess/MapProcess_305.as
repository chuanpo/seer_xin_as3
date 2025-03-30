package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.sceneInteraction.MazeController;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.CommandID;
   import org.taomee.events.SocketEvent;
   import com.robot.core.info.task.MiningCountInfo;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.npc.NPC;
   
   public class MapProcess_305 extends BaseMapProcess
   {
      private var jiantou_0:MovieClip;
      
      private var jiantou_1:MovieClip;
      
      private var qita:MovieClip;
      
      private var oilcanArr:Array = [];
      
      public function MapProcess_305()
      {
         super();
      }
      
      override protected function init() : void
      {
         var name:String = null;
         var mc:MovieClip = null;
         MazeController.setup();
         conLevel["door_0"].visible = false;
         conLevel["door_1"].visible = false;
         this.jiantou_0 = conLevel["jiantou_0"];
         this.jiantou_1 = conLevel["jiantou_1"];
         this.jiantou_0.visible = false;
         this.jiantou_1.visible = false;
         this.qita = conLevel["qita"];
         this.qita.visible = false;
         for(var i:uint = 0; i < 8; i++)
         {
            name = "oilcan_" + i;
            mc = conLevel[name] as MovieClip;
            mc.buttonMode = true;
            mc.gotoAndStop(1);
            mc.addEventListener(MouseEvent.CLICK,this.onClickOilcan);
            this.oilcanArr.push(mc);
         }
      }
      
      private function onClickOilcan(evt:MouseEvent) : void
      {
         var i:MovieClip = null;
         var j:MovieClip = null;
         var mc:MovieClip = evt.currentTarget as MovieClip;
         if(mc.currentFrame == 1)
         {
            mc.gotoAndStop(2);
         }
         else
         {
            mc.gotoAndStop(1);
         }
         for each(i in this.oilcanArr)
         {
            if(i.currentFrame != 2)
            {
               return;
            }
         }
         for each(j in this.oilcanArr)
         {
            j.removeEventListener(MouseEvent.CLICK,this.onClickOilcan);
            j.buttonMode = false;
         }
         conLevel["door_0"].visible = true;
         conLevel["door_1"].visible = true;
         this.jiantou_0.visible = true;
         this.jiantou_1.visible = true;
         if(Math.random() >= 0.5)
         {
            this.qita.visible = true;
            this.qita.buttonMode = true;
            this.qita.addEventListener(MouseEvent.CLICK,this.onFightQita);
         }
      }
      
      override public function destroy() : void
      {
         var i:MovieClip = null;
         for each(i in this.oilcanArr)
         {
            i.removeEventListener(MouseEvent.CLICK,this.onClickOilcan);
            this.qita.removeEventListener(MouseEvent.CLICK,this.onFightQita);
         }
         MazeController.destroy();
      }
      
      private function onFightQita(evt:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            var oreCountInfo:MiningCountInfo = e.data as MiningCountInfo;
            var count:uint = oreCountInfo.miningCount;
            if(count == 0)
            {
               FightInviteManager.fightWithBoss("奇塔");
            }else
            {
               NpcDialog.show(NPC.SEER,["已经达到捕捉上限了哟~"],["……"],null)
            }
         })
         SocketConnection.send(CommandID.TALK_COUNT,700013 - 500000);
      }
   }
}

