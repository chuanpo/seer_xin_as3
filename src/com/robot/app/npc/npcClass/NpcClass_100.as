package com.robot.app.npc.npcClass
{
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import com.robot.core.event.NpcEvent;
   import com.robot.core.npc.NpcDialog;
   import com.robot.app.fightNote.FightInviteManager;
   
   public class NpcClass_100 implements INpc
   {
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_100(info:NpcInfo, mc:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(info,mc as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
      }
      private function onClickNpc(e:NpcEvent) : void
      {
         NpcDialog.show(this.npc.npcInfo.npcId,["赛尔号果然名不虚传！这里有很多我未见过的资料数据呢！我可要多加学习……"],
            ["我想挑战你！",this.npc.npcInfo.questionA]
            ,[function():void
            {
               NpcDialog.show(npc.npcInfo.npcId,["小赛尔，现在暂时不接受挑战哟~\r萨格罗斯不知道跑去哪里了……你能帮我找一下他吗？"],
               ["我这就去找他！"]
               );
               // FightInviteManager.fightWithBoss("迪恩")
            }
         ,null]);
      }
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}

