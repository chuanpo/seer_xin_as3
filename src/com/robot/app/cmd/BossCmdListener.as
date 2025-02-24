package com.robot.app.cmd
{
   import com.robot.app.automaticFight.AutomaticFightManager;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.task.BossMonsterInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.ui.alert.PetInBagAlert;
   import com.robot.core.ui.alert.PetInStorageAlert;
   import org.taomee.events.SocketEvent;
   
   public class BossCmdListener extends BaseBeanController
   {
      public function BossCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_BOSS_MONSTER,this.onGetBossMonster);
         finish();
      }
      
      private function showAwards(info:BossMonsterInfo) : void
      {
         var i:Object = null;
         var itemCnt:uint = 0;
         var itemID:uint = 0;
         var name:String = null;
         var str:String = null;
         for each(i in info.monBallList)
         {
            itemCnt = uint(i["itemCnt"]);
            itemID = uint(i["itemID"]);
            if(itemID == 100096 || itemID == 100097 || itemID == 100098 || itemID == 100099)
            {
               LevelManager.tipLevel.addChild(Alarm.show("<font color=\'#FF0000\'>闪光勇士</font>套装已经放入了你的储存箱！"));
               break;
            }
            if(itemID == 100333)
            {
               LevelManager.tipLevel.addChild(Alarm.show(" 你的实力得到了肯定，这<font color=\'#FF0000\'>试炼勋章</font>送给你，作为你实力的证明。"));
               break;
            }
            name = ItemXMLInfo.getName(itemID);
            if(itemID == 1)
            {
               MainManager.actorInfo.coins += itemCnt;
            }
            if(itemID < 10)
            {
               if(info.bonusID == 5065 || info.bonusID == 5066)
               {
                  if(itemCnt == 100)
                  {
                     str = "看来这样的难度还难不倒你，后面的精灵会更加厉害，这<font color=\'#FF0000\'>" + itemCnt + "</font>个" + name + "是你的奖励。";
                  }
                  else if(itemCnt == 200)
                  {
                     str = "你确实具备了很强大的实力，给你<font color=\'#FF0000\'>" + itemCnt + "</font>个" + name + "做为奖励。";
                  }
                  else
                  {
                     str = "你成功挑战了30关，奖励你<font color=\'#FF0000\'>" + itemCnt + "</font>个" + name + "。";
                  }
               }
               else
               {
                  str = "恭喜你得到了<font color=\'#FF0000\'>" + itemCnt + "</font>个" + name;
               }
               LevelManager.tipLevel.addChild(Alarm.show(str));
            }
            else
            {
               str = itemCnt + "个<font color=\'#FF0000\'>" + name + "</font>已经放入了你的储存箱！";
               LevelManager.tipLevel.addChild(ItemInBagAlert.show(itemID,str));
            }
         }
      }
      
      private function onGetBossMonster(e:SocketEvent) : void
      {
         var info:BossMonsterInfo = null;
         if(AutomaticFightManager.isStart)
         {
            return;
         }
         info = e.data as BossMonsterInfo;
         if(info.bonusID == 5065 || info.bonusID == 5066)
         {
            this.showAwards(info);
            return;
         }
         this.showAwards(info);
         if(info.petID == 0)
         {
            return;
         }
         if(PetManager.length >= 6)
         {
            PetManager.addStorage(info.petID,info.captureTm);
            PetInStorageAlert.show(info.petID,"恭喜你获得了<font color=\'#00CC00\'>" + PetXMLInfo.getName(info.petID) + "</font>，你可以在基地仓库里找到",LevelManager.iconLevel);
            return;
         }
         PetManager.addEventListener(PetEvent.ADDED,function(e:PetEvent):void
         {
            PetManager.removeEventListener(PetEvent.ADDED,arguments.callee);
            PetInBagAlert.show(info.petID,"恭喜你获得了<font color=\'#00CC00\'>" + PetXMLInfo.getName(info.petID) + "</font>，你可以点击右下方的精灵按钮来查看",LevelManager.iconLevel);
         });
         PetManager.setIn(info.captureTm,1);
      }
   }
}

