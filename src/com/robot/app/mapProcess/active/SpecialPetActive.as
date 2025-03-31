package com.robot.app.mapProcess.active
{
   import com.robot.app.mapProcess.active.randomPet.IRandomPet;
   import com.robot.app.mapProcess.active.randomPet.NormalPet;
   import com.robot.app.mapProcess.active.randomPet.PretendPet;
   import com.robot.app.mapProcess.active.randomPet.RunPet;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.info.fightInfo.PetFightModel;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class SpecialPetActive
   {
      private static var pet:IRandomPet;
      
      private static var _petMc:MovieClip;
      
      private static var point:Point;
      
      private static var map:HashMap = new HashMap();
      
      private static var strMap:HashMap = new HashMap();
      
      private static var classMap:HashMap = new HashMap();
      
      private static var date:Date = null;

      private static var ruleHashMap:HashMap = new HashMap();
      
      setup();
      
      public function SpecialPetActive()
      {
         super();
      }
      
      private static function setup() : void
      {
         map.add(15,new Point(808,338));
         map.add(105,new Point(126,217));
         map.add(54,new Point(297,157));
         ruleHashMap.add(0,"以致命一击为终结技");
         ruleHashMap.add(1,"在2回合之内");
         ruleHashMap.add(2,"以致命一击为终结技");
         ruleHashMap.add(3,"承受住我10次攻击后再");
         ruleHashMap.add(4,"以致命一击为终结技");
         ruleHashMap.add(5,"在2回合之内");
         ruleHashMap.add(6,"承受住我10次攻击后再");
      }
      
      private static function onMapSwitch(event:MapEvent) : void
      {
         hide();
      }
      
      public static function getStr(id:uint) : String
      {
         return strMap.getValue(id);
      }
      
      public static function getMC(id:uint) : MovieClip
      {
         var cls:Class = classMap.getValue(id) as Class;
         return new cls() as MovieClip;
      }
      
      public static function show(id:uint) : void
      {
         if(id == 0)
         {
            return;
         }
         point = map.getValue(MainManager.actorInfo.mapID);
         if(Boolean(point))
         {
            ResourceManager.getResource(ClientConfig.getPetSwfPath(id),onLoadPet,"pet");
         }
      }
      
      private static function onLoadPet(o:DisplayObject) : void
      {
         _petMc = o as MovieClip;
         if(Boolean(MapManager.currentMap))
         {
            MapManager.currentMap.depthLevel.addChild(_petMc);
         }
         else
         {
            MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,function(evt:MapEvent):void
            {
               MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,arguments.callee);
               var p:Point = map.getValue(MainManager.actorInfo.mapID);
               if(Boolean(p))
               {
                  MapManager.currentMap.depthLevel.addChild(_petMc);
                  _petMc.x = p.x;
                  _petMc.y = p.y;
               }
            });
         }
         _petMc.x = point.x;
         _petMc.y = point.y;
         _petMc.buttonMode = true;
         _petMc.addEventListener(MouseEvent.CLICK,onClick);
         (_petMc.getChildAt(0) as MovieClip).gotoAndStop(1);
      }
      
      private static function onClick(evt:MouseEvent) : void
      {
         if(Boolean(date))
         {
            talkWithGaiYa();
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,onGetTime);
            SocketConnection.send(CommandID.SYSTEM_TIME);
         }
      }
      
      private static function onGetTime(evt:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,onGetTime);
         date = (evt.data as SystemTimeInfo).date;
         talkWithGaiYa();
      }
      
      private static function talkWithGaiYa() : void
      {
         var str:String = null;
         try
         {
            str="我的目标是成为精灵战斗大师，我对战斗有着独特的见解，只有力量与智慧都达到一定的境界的对手才会得到我的认同。如果你能以0xff00001对1的形式并" + ruleHashMap.getValue(date.day) + "战胜我0xffffff，我就做你的伙伴。";
         }
         catch (error:Error)
         {
            str="我的目标是成为精灵战斗大师，我对战斗有着独特的见解，只有力量与智慧都达到一定的境界的对手才会得到我的认同。如果你能以0xff00001对1的形式并以今天的规则战胜我0xffffff，我就做你的伙伴。";
         }
         NpcDialog.show(NPC.GAIYA,[str],["我接受，一定要让你成为我的伙伴。","等我把精灵训练的更强后再来找你挑战。"],[function():void
         {
            fightWithGaiYa();
         }]);
      }
      
      private static function fightWithGaiYa() : void
      {
         PetFightModel.mode = PetFightModel.SINGLE_MODE;
         PetFightModel.status = PetFightModel.FIGHT_WITH_NPC;
         PetFightModel.enemyName = "盖亚";
         SocketConnection.addCmdListener(CommandID.COMPLETE_TASK,getGaiYa);
         SocketConnection.addCmdListener(CommandID.SPRINT_GIFT_NOTICE,onFightLose);
         EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onFightClose);
         SocketConnection.send(CommandID.FIGHT_SPECIAL_PET);
      }
      
      private static function onFightClose(evt:PetFightEvent) : void
      {
         var info:FightOverInfo;
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onFightClose);
         PetFightModel.mode = PetFightModel.MULTI_MODE;
         info = evt.dataObj["data"] as FightOverInfo;
         if(info.winnerID != MainManager.actorID)
         {
            NpcDialog.show(NPC.GAIYA,["你还需要多多修炼哦，我也再去训练去了，我们下次再见吧。"],["下次我一定要让你成为我的伙伴！"],[function():void
            {
               SocketConnection.removeCmdListener(CommandID.COMPLETE_TASK,getGaiYa);
               SocketConnection.removeCmdListener(CommandID.SPRINT_GIFT_NOTICE,onFightLose);
            }]);
         }
      }
      
      private static function getGaiYa(evt:SocketEvent) : void
      {
         var info:NoviceFinishInfo;
         var o:Object = null;
         SocketConnection.removeCmdListener(CommandID.COMPLETE_TASK,getGaiYa);
         SocketConnection.removeCmdListener(CommandID.SPRINT_GIFT_NOTICE,onFightLose);
         info = evt.data as NoviceFinishInfo;
         if(info.taskID == 99)
         {
            for each(o in info.monBallList)
            {
               if(o["itemID"] == 400126)
               {
                  EventManager.addEventListener(PetFightEvent.ALARM_CLICK,function(evt:PetFightEvent):void
                  {
                     EventManager.removeEventListener(PetFightEvent.ALARM_CLICK,arguments.callee);
                     NpcDialog.show(NPC.GAIYA,["你果然是文武双全、机智英勇的好对手，我履行承诺，做你的伙伴吧。"],["我们一起加油，成为最强吧！"],[function():void
                     {
                        ItemInBagAlert.show(400126,"1个" + TextFormatUtil.getRedTxt("盖亚的精元") + "已经放入你的储存箱中！");
                     }]);
                  });
                  break;
               }
            }
         }
      }
      
      private static function onFightLose(evt:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.COMPLETE_TASK,getGaiYa);
         SocketConnection.removeCmdListener(CommandID.SPRINT_GIFT_NOTICE,onFightLose);
         EventManager.addEventListener(PetFightEvent.ALARM_CLICK,function(evt:PetFightEvent):void
         {
            EventManager.removeEventListener(PetFightEvent.ALARM_CLICK,arguments.callee);
            NpcDialog.show(NPC.GAIYA,["虽然你赢了，但是你没有按照规则战胜我，我们下次再见吧。"],["下次我一定要让你成为我的伙伴！"]);
         });
      }
      
      public static function hide() : void
      {
         if(Boolean(_petMc))
         {
            _petMc.removeEventListener(MouseEvent.CLICK,onClick);
            DisplayUtil.removeForParent(_petMc);
            _petMc = null;
         }
      }
      
      private static function getRandomPet() : IRandomPet
      {
         var pet:IRandomPet = null;
         var count:uint = Math.floor(Math.random() * 3);
         if(count == 0)
         {
            pet = new NormalPet();
         }
         else if(count == 1)
         {
            pet = new RunPet();
         }
         else if(count == 2)
         {
            pet = new PretendPet();
         }
         return pet;
      }
   }
}

