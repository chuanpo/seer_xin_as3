package com.robot.app.npc.npcClass
{
   import com.robot.core.event.NpcEvent;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import com.robot.core.npc.NpcDialog;
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.event.PetFightEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.events.SocketEvent;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.info.task.MiningCountInfo;
   
   public class NpcClass_90002 implements INpc
   {
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_90002(info:NpcInfo, mc:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(info,mc as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
      }
      
      private function onClickNpc(e:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         NpcDialog.show(90001,["终于潜入赛尔号了#6。嘿嘿，让我来搞下破坏#1"],
            ["受死吧！","装傻"]
            ,[function():void
            {
               FightInviteManager.fightWithBoss("海盗",0);
               EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onFightOver);
            },null]);
      }
      
      private function onFightOver(e:PetFightEvent):void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onFightOver);
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            var oreCountInfo:MiningCountInfo = e.data as MiningCountInfo;
            var count:uint = oreCountInfo.miningCount;
            NpcDialog.show(90001,["留得青山在，不怕没柴烧#4。臭小子你给我记着#5"],
               [count >= 6 ?"(今天的海盗似乎清理干净了)" : "(去其他地方看看还有没有海盗吧)" ]
               ,[function():void{_curNpcModel.npc.visible = false;}]);
         })
         SocketConnection.send(CommandID.TALK_COUNT,600012 - 500000);
      }

      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.removeEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
      }
      
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}

