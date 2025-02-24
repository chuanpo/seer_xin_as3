package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.mapProcess.active.SuperNonoIndex;
   import com.robot.core.CommandID;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.pet.PetBargeListInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class MapProcess_61 extends BaseMapProcess
   {
      private var _markMc:MovieClip;
      
      private var _openDoor:MovieClip;
      
      public function MapProcess_61()
      {
         super();
      }
      
      override protected function init() : void
      {
         conLevel["hit_1"].visible = false;
         conLevel["door_1"].visible = false;
         conLevel["doorEffect"].gotoAndStop(1);
         this._markMc = depthLevel["markMc"];
         this._openDoor = conLevel["open_door"];
         this._openDoor.buttonMode = true;
         this._openDoor.addEventListener(MouseEvent.CLICK,this.onOpenDoorClickHandler);
         this._markMc.addEventListener(MouseEvent.CLICK,this.onMarkClickHandler);
         SuperNonoIndex.superIndx(this._markMc);
         if(FightInviteManager.isKillBigPetB == false)
         {
            SocketConnection.addCmdListener(CommandID.PET_BARGE_LIST,this.addCmListenrPet);
            SocketConnection.send(CommandID.PET_BARGE_LIST,239,239);
         }
      }
      
      private function onOpenDoorClickHandler(e:MouseEvent) : void
      {
         this._openDoor.removeEventListener(MouseEvent.CLICK,this.onOpenDoorClickHandler);
         conLevel["hit_1"].visible = true;
         conLevel["door_1"].visible = true;
         conLevel["doorEffect"].gotoAndStop(2);
      }
      
      private function addCmListenrPet(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_BARGE_LIST,this.addCmListenrPet);
         var data:PetBargeListInfo = e.data as PetBargeListInfo;
         var arr:Array = data.isKillList;
         if(arr.length != 0)
         {
            FightInviteManager.isKillBigPetB = true;
         }
         else
         {
            EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
         }
      }
      
      private function onCloseFight(e:PetFightEvent) : void
      {
         var fightData:FightOverInfo = e.dataObj["data"];
         if(fightData.winnerID == MainManager.actorInfo.userID)
         {
            EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
            FightInviteManager.isKillBigPetB = true;
         }
      }
      
      override public function destroy() : void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
      }
      
      public function changeMap() : void
      {
         if(MainManager.actorInfo.superNono)
         {
            if(!MainManager.actorModel.nono)
            {
               NpcDialog.show(NPC.SUPERNONO,["哎呀！你没有带上超能NoNo啦！要知道，没它的保护就冒冒然进去那可是很危险的！"],["我这就召唤我的超能NoNo"],[function():void
               {
               }]);
            }
            else
            {
               MapManager.changeMap(64);
            }
         }
         else if(NonoManager.info.ai >= 20)
         {
            if(!MainManager.actorModel.nono)
            {
               NpcDialog.show(NPC.SUPERNONO,["#6快带上你智慧的NoNo来保护你吧！我想只有借助它的智慧，你才能够通过重重困境进入沙漠窑洞哦！"],["我这就回基地带NoNo去！"],[function():void
               {
               }]);
            }
            else
            {
               MapManager.changeMap(64);
            }
         }
         else
         {
            NpcDialog.show(NPC.SUPERNONO,["不行啊！你不能进入！肖恩老师说了！这里可是超级危险的！你不能随便进入哦!不过……如果你的NoNo如果更聪明一些，应该可以带你安全进入吧！"],["确定"],[function():void
            {
               NpcDialog.show(NPC.SUPERNONO,["你可以选择将你的NoNo升级到0xff0000AI200xffffff级之后再来挑战，或者立刻为你的NoNo充能让它加入我们的超能行列，成为0xff0000超能NoNo0xffffff哦！要知道超能NoNo可是无所不能的哦！"],["我想让它成为超能NoNo！","我这就去实验室合成智慧芯片！"],[function():void
               {
                  MapManager.changeMap(107);
               },function():void
               {
                  MapManager.changeMap(107);
               }]);
            }]);
         }
      }
      
      private function onMarkClickHandler(e:MouseEvent) : void
      {
         NpcDialog.show(NPC.SUPERNONO,["哇！前方有危险！有危险！你确定……确定要了解更多关于沙漠窑洞的信息吗？#7"],["无论多危险，我都不怕！","我还是考虑下再来问你吧……"],[function():void
         {
            NpcDialog.show(NPC.SUPERNONO,["我听肖恩老师说了，这里可是超级……超级危险的地方！在这片一望无际的沙漠底下有一个窑洞，根据地形来说，那里很有可能存在着某种精灵……"],["继续！继续！再告诉我点吧！"],[function():void
            {
               NpcDialog.show(NPC.SUPERNONO,["它应该不是一般的精灵，具有极强的攻击性！对了！肖恩老师说这里很不安全！沙漠一点沦陷，窑洞就会淹没！所以一定要有0xff0000超能NoNo0xffffff保护你！（当然充满智慧的NoNo也是可以保护你的噢！）"],["好！我知道啦~"],[function():void
               {
               }]);
            }]);
         }]);
      }
   }
}

