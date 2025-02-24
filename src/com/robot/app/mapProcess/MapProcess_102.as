package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.petKing.PetKingWaitPanel;
   import com.robot.app.sceneInteraction.ArenaController;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.temp.SpaceStationBuyController;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.PetKingPrizeInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.PetInBagAlert;
   import com.robot.core.ui.alert.PetInStorageAlert;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_102 extends BaseMapProcess
   {
      private var justin:MovieClip;
      
      private var confirm:SimpleButton;
      
      private var justinTxt:TextField;
      
      private var closeBt:SimpleButton;
      
      private var waitPanel:MovieClip;
      
      private var closeButton:SimpleButton;
      
      private var grassMC:SimpleButton;
      
      private var fireMC:SimpleButton;
      
      private var waterMC:SimpleButton;
      
      private var mcPet:String;
      
      private var j_npc:MovieClip;
      
      private var pet_mc:MovieClip;
      
      private var timer:Timer;
      
      private var dialogNum:uint = 0;
      
      public function MapProcess_102()
      {
         super();
      }
      
      override protected function init() : void
      {
         ToolTipManager.add(conLevel["enterFight"],"加入精灵王对战");
         ToolTipManager.add(conLevel["buyMC"],"精灵道具购买");
         ToolTipManager.add(conLevel["arenaTouchBtn_1"],"挑战擂台");
         ToolTipManager.add(conLevel["arenaTouchBtn_2"],"挑战擂台");
         ToolTipManager.add(conLevel["arenaTouchBtn_3"],"挑战擂台");
         ToolTipManager.add(conLevel["dou_mc"],"精灵大乱斗");
         ToolTipManager.add(conLevel["door_2"],"暗黑武斗场");
         ArenaController.getInstance().setup(conLevel.getChildByName("arenaMc") as MovieClip);
         this.j_npc = conLevel["npc"];
         this.j_npc.visible = false;
         this.pet_mc = conLevel["pet_mc"];
         this.pet_mc.visible = false;
         this.timer = new Timer(9000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         var box:DialogBox = new DialogBox();
         box.show("使自己的训练精灵的技术更上一个境界吧。",0,-85,conLevel["npc"]);
      }
      
      public function hitNpc() : void
      {
         NpcDialog.show(NPC.JUSTIN,["赛尔号上的每一个小赛尔都由我来守护。"],["我们会让自己变得更强！"],[]);
      }
      
      override public function destroy() : void
      {
         ToolTipManager.remove(conLevel["enterFight"]);
         ToolTipManager.remove(conLevel["buyMC"]);
         ToolTipManager.remove(conLevel["arenaTouchBtn_1"]);
         ToolTipManager.remove(conLevel["arenaTouchBtn_2"]);
         ToolTipManager.remove(conLevel["arenaTouchBtn_3"]);
         ToolTipManager.remove(conLevel["door_2"]);
         ArenaController.getInstance().figth();
         if(Boolean(this.closeBt))
         {
            this.closeBt.removeEventListener(MouseEvent.CLICK,this.closeMC);
            this.closeBt = null;
         }
         if(Boolean(this.confirm))
         {
            this.confirm.removeEventListener(MouseEvent.CLICK,this.closeMC);
            this.confirm.removeEventListener(MouseEvent.CLICK,this.givePetScr);
            this.confirm = null;
         }
         this.justin = null;
         this.justinTxt = null;
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.stop();
         this.timer = null;
      }
      
      public function onPetWarHandler() : void
      {
         PetKingWaitPanel.showPetWar();
      }
      
      private function onPetList(e:PetEvent) : void
      {
         var i:int;
         var cheak:Function = function(i:int):void
         {
            if(i == 1 || i == 2 || i == 3)
            {
               grassMC.filters = [ColorFilter.setGrayscale()];
               grassMC.mouseEnabled = false;
            }
            else if(i == 7 || i == 8 || i == 9)
            {
               fireMC.filters = [ColorFilter.setGrayscale()];
               fireMC.mouseEnabled = false;
            }
            else if(i == 4 || i == 5 || i == 6)
            {
               waterMC.filters = [ColorFilter.setGrayscale()];
               waterMC.mouseEnabled = false;
            }
         };
         PetManager.removeEventListener(PetEvent.STORAGE_LIST,this.onPetList);
         this.waitPanel = MapLibManager.getMovieClip("GetPet");
         LevelManager.appLevel.addChild(this.waitPanel);
         DisplayUtil.align(this.waitPanel,null,AlignType.MIDDLE_CENTER);
         this.closeButton = this.waitPanel["closeBtn"];
         this.closeButton.addEventListener(MouseEvent.CLICK,this.closeMC);
         this.grassMC = this.waitPanel["grassMC"];
         this.waterMC = this.waitPanel["waterMC"];
         this.fireMC = this.waitPanel["fireMC"];
         this.grassMC.addEventListener(MouseEvent.CLICK,this.onGivePet);
         this.waterMC.addEventListener(MouseEvent.CLICK,this.onGivePet);
         this.fireMC.addEventListener(MouseEvent.CLICK,this.onGivePet);
         for(i = 1; i <= 9; i++)
         {
            if(PetManager.containsBagForID(i))
            {
               cheak(i);
            }
            else if(PetManager.containsStorageForID(i))
            {
               cheak(i);
            }
         }
      }
      
      public function enterFight() : void
      {
         PetKingWaitPanel.show();
      }
      
      public function HitJustin() : void
      {
         this.justin = MapLibManager.getMovieClip("JustinGivePet3");
         DisplayUtil.align(this.justin,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         this.confirm = this.justin["ConfirmBtn"];
         this.closeBt = this.justin["closeBtn"];
         this.justinTxt = this.justin["TxtTip"];
         this.closeBt.addEventListener(MouseEvent.CLICK,this.closeMC);
         if(MainManager.actorInfo.monKingWin >= 10)
         {
            SocketConnection.addCmdListener(CommandID.IS_COLLECT,function(e:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.IS_COLLECT,arguments.callee);
               var by:ByteArray = e.data as ByteArray;
               var id:uint = by.readUnsignedInt();
               var isCom:Boolean = Boolean(by.readUnsignedInt());
               LevelManager.topLevel.addChild(justin);
               if(isCom)
               {
                  justinTxt.text = "   精灵王之战考验的是你的战斗技巧，通过自己不懈的努力成为真正的精灵王吧。";
                  confirm.addEventListener(MouseEvent.CLICK,closeMC);
               }
               else
               {
                  justinTxt.htmlText = "    你在精灵王之战中的表现非常出色，请接收我的礼物！";
                  confirm.addEventListener(MouseEvent.CLICK,givePetScr);
               }
            });
            SocketConnection.send(CommandID.IS_COLLECT,301);
         }
         else
         {
            LevelManager.topLevel.addChild(this.justin);
            this.justinTxt.text = "    贾斯汀站长委托我为每个在精灵王之战中获得10场胜利的赛尔送上一份礼物。";
            this.confirm.addEventListener(MouseEvent.CLICK,this.closeMC);
         }
      }
      
      private function givePetScr(e:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.justin,false);
         LevelManager.openMouseEvent();
         PetManager.addEventListener(PetEvent.STORAGE_LIST,this.onPetList);
         PetManager.getStorageList();
      }
      
      private function closeMC(e:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.waitPanel,false);
         DisplayUtil.removeForParent(this.justin,false);
         LevelManager.openMouseEvent();
      }
      
      private function onGivePet(e:MouseEvent) : void
      {
         var id:uint = 0;
         if(e.currentTarget == this.grassMC)
         {
            id = 1;
            this.mcPet = "布布种子精灵";
         }
         else if(e.currentTarget == this.fireMC)
         {
            id = 7;
            this.mcPet = "小火猴精灵";
         }
         else if(e.currentTarget == this.waterMC)
         {
            id = 4;
            this.mcPet = "伊优精灵";
         }
         SocketConnection.addCmdListener(CommandID.PRIZE_OF_PETKING,this.onPrize);
         SocketConnection.send(CommandID.PRIZE_OF_PETKING,301,id);
         var mc:SimpleButton = e.target as SimpleButton;
         DisplayUtil.removeForParent(this.waitPanel,false);
      }
      
      private function onPrize(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PRIZE_OF_PETKING,this.onPrize);
         var data:PetKingPrizeInfo = event.data as PetKingPrizeInfo;
         var name:String = PetXMLInfo.getName(data.petID);
         if(PetManager.length < 6)
         {
            SocketConnection.send(CommandID.PET_RELEASE,data.catchTime,1);
            SocketConnection.send(CommandID.GET_PET_INFO,data.catchTime);
            PetInBagAlert.show(data.petID,name + "已经放入了你的精灵背包！");
         }
         else
         {
            PetManager.addStorage(data.petID,data.catchTime);
            PetInStorageAlert.show(data.petID,name + "已经放入了你的精灵仓库！");
         }
      }
      
      public function buyHandler() : void
      {
         SpaceStationBuyController.show();
      }
      
      public function onArenaHit() : void
      {
         ArenaController.getInstance().strat();
      }
      
      public function onEnterHandler() : void
      {
         if(MainManager.actorInfo.superNono)
         {
            if(Boolean(MainManager.actorModel.nono))
            {
               MapManager.changeMap(110);
            }
            else
            {
               NpcTipDialog.show("你必须带上超能NoNo才能进入暗黑武斗场哦！",null,NpcTipDialog.NONO);
            }
         }
         else if(Boolean(NonoManager.info.func[12]))
         {
            if(Boolean(MainManager.actorModel.nono))
            {
               MapManager.changeMap(110);
            }
            else
            {
               NpcTipDialog.show("你必须带上NoNo才能进入暗黑武斗场哦！",null,NpcTipDialog.NONO_2);
            }
         }
         else
         {
            NpcTipDialog.show("你必须给NoNo装载上反物质芯片才能进入暗黑武斗场哦！",null,NpcTipDialog.NONO_2);
         }
      }
   }
}

