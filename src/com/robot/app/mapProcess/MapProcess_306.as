package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.sceneInteraction.MazeController;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.CommandID;
   import org.taomee.events.SocketEvent;
   import com.robot.core.info.task.MiningCountInfo;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.npc.NPC;
   
   public class MapProcess_306 extends BaseMapProcess
   {
      private var btn_0:MovieClip;
      
      private var btn_1:MovieClip;
      
      private var btn_2:MovieClip;
      
      private var btnArr:Array = [];
      
      private var blockStone:MovieClip;
      
      private var blockRoad:MovieClip;
      
      private var xita:MovieClip;
      
      public function MapProcess_306()
      {
         super();
      }
      
      override protected function init() : void
      {
         var m:MovieClip = null;
         MazeController.setup();
         this.btn_0 = conLevel["btn_0"];
         this.btn_1 = conLevel["btn_1"];
         this.btn_2 = conLevel["btn_2"];
         this.btnArr = [this.btn_0,this.btn_1,this.btn_2];
         for each(m in this.btnArr)
         {
            m.buttonMode = true;
            m.gotoAndStop(1);
            m.addEventListener(MouseEvent.CLICK,this.onClickBtn);
         }
         this.blockStone = conLevel["blockStone"];
         this.blockStone.mouseEnabled = false;
         this.xita = conLevel["xita"];
         this.xita.mouseEnabled = false;
         this.blockRoad = typeLevel["blockRoad"];
      }
      
      override public function destroy() : void
      {
         MazeController.destroy();
      }
      
      private function onClickBtn(evt:MouseEvent) : void
      {
         var m:MovieClip = null;
         var mc:MovieClip = evt.currentTarget as MovieClip;
         if(mc.currentFrame == 1)
         {
            mc.gotoAndStop(2);
         }
         else
         {
            mc.gotoAndStop(1);
         }
         if(this.btn_0.currentFrame == 2 && this.btn_1.currentFrame == 2 && this.btn_2.currentFrame == 2)
         {
            for each(m in this.btnArr)
            {
               m.buttonMode = false;
               m.gotoAndStop(2);
               m.removeEventListener(MouseEvent.CLICK,this.onClickBtn);
            }
            this.blockStone.gotoAndPlay(2);
            DisplayUtil.removeForParent(this.blockRoad);
            this.blockRoad = null;
            MapManager.currentMap.makeMapArray();
            this.xita.buttonMode = true;
            this.xita.mouseEnabled = true;
         }
      }
      
      public function fightWithXita() : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            var oreCountInfo:MiningCountInfo = e.data as MiningCountInfo;
            var count:uint = oreCountInfo.miningCount;
            if(count == 0)
            {
               FightInviteManager.fightWithBoss("西塔");
            }else
            {
               NpcDialog.show(NPC.SEER,["已经达到捕捉上限了哟~"],["……"],null)
            }
         })
         SocketConnection.send(CommandID.TALK_COUNT,700014 - 500000);
      }
   }
}

