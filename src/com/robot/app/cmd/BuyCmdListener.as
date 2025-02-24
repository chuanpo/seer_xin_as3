package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.FortressItemXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.info.team.ArmInfo;
   import com.robot.core.info.team.HeadquarterInfo;
   import com.robot.core.manager.ArmManager;
   import com.robot.core.manager.FitmentManager;
   import com.robot.core.manager.HeadquarterManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class BuyCmdListener extends BaseBeanController
   {
      public function BuyCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_UP_BUY,this.onArmUpBuy);
         SocketConnection.addCmdListener(CommandID.BUY_FITMENT,this.onFitmentBuy);
         SocketConnection.addCmdListener(CommandID.HEAD_BUY,this.onHeadBuy);
         finish();
      }
      
      private function onArmUpBuy(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var coins:uint = data.readUnsignedInt();
         var id:uint = data.readUnsignedInt();
         var form:uint = data.readUnsignedInt();
         var buyTime:uint = data.readUnsignedInt();
         MainManager.actorInfo.coins = coins;
         var info:ArmInfo = new ArmInfo();
         info.id = id;
         info.form = form;
         info.buyTime = buyTime;
         ArmManager.addInStorage(info);
         Alarm.show("1个" + TextFormatUtil.getRedTxt(FortressItemXMLInfo.getName(id)) + "已经放入你的仓库，你还剩下" + coins + "赛尔豆");
      }
      
      private function onFitmentBuy(e:SocketEvent) : void
      {
         var by:ByteArray = e.data as ByteArray;
         var coins:uint = by.readUnsignedInt();
         var id:uint = by.readUnsignedInt();
         var num:uint = by.readUnsignedInt();
         MainManager.actorInfo.coins = coins;
         var info:FitmentInfo = new FitmentInfo();
         info.id = id;
         FitmentManager.addInStorage(info);
         Alarm.show("1个<font color=\'#FF0000\'>" + ItemXMLInfo.getName(id) + "</font>已经放入你的仓库，你还剩下" + coins + "赛尔豆");
      }
      
      private function onHeadBuy(e:SocketEvent) : void
      {
         var by:ByteArray = e.data as ByteArray;
         var coins:uint = by.readUnsignedInt();
         var id:uint = by.readUnsignedInt();
         var num:uint = by.readUnsignedInt();
         MainManager.actorInfo.coins = coins;
         var info:HeadquarterInfo = new HeadquarterInfo();
         info.id = id;
         HeadquarterManager.addInStorage(info);
         Alarm.show("1个<font color=\'#FF0000\'>" + ItemXMLInfo.getName(id) + "</font>已经放入你的仓库，你还剩下" + coins + "赛尔豆");
      }
   }
}

