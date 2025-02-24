package com.robot.app.buyItem
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Alert;
   import com.robot.core.ui.alert.IconAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class HeadquartersAction
   {
      public function HeadquartersAction()
      {
         super();
      }
      
      public static function buyItem(id:uint, isTip:Boolean = true, count:uint = 1) : void
      {
         var price:uint;
         var name:String;
         var str:String = null;
         if(ItemXMLInfo.getVipOnly(id))
         {
            if(!MainManager.actorInfo.vip)
            {
               Alarm.show("你还没有开通超能NoNo，不能购买这个装备哦！");
               return;
            }
         }
         if(!isTip)
         {
            SocketConnection.send(CommandID.HEAD_BUY,id,count);
            return;
         }
         price = uint(ItemXMLInfo.getPrice(id));
         name = ItemXMLInfo.getName(id);
         if(price > 0)
         {
            if(MainManager.isRoomHalfDay)
            {
               str = "<font color=\'#ff0000\'>" + name + "</font>需要花费" + price.toString() + "赛尔豆，<font color=\'#ff0000\'>（半价日只需要花费" + price / 2 + "赛尔豆）</font>，要确定购买吗？";
            }
            else
            {
               str = "<font color=\'#ff0000\'>" + name + "</font>需要花费" + price.toString() + "赛尔豆，" + "你现在拥有" + MainManager.actorInfo.coins + "赛尔豆，要确定购买吗？";
            }
         }
         else
         {
            str = "<font color=\'#ff0000\'>" + name + "</font>免费赠送，你确定现在就要领取吗？";
         }
         IconAlert.show(str,id,function():void
         {
            SocketConnection.send(CommandID.HEAD_BUY,id,count);
         });
      }
      
      public static function buySinItem(id:uint, count:uint) : void
      {
         SocketConnection.send(CommandID.ITEM_BUY,id,count);
      }
      
      public static function exchangeSinItem(type:uint, need:uint) : void
      {
         if(MainManager.actorInfo.fightBadge < need)
         {
            Alert.show("你的战斗徽章数不够!");
            return;
         }
         Alert.show("你确定要兑换吗?",function():void
         {
            SocketConnection.addCmdListener(CommandID.EXCHANGE_CLOTH_COMPLETE,onEcHandler);
            SocketConnection.send(CommandID.EXCHANGE_CLOTH_COMPLETE,type);
         });
      }
      
      private static function onEcHandler(e:SocketEvent) : void
      {
         var id:uint = 0;
         var count:uint = 0;
         SocketConnection.removeCmdListener(CommandID.EXCHANGE_CLOTH_COMPLETE,onEcHandler);
         var by:ByteArray = e.data as ByteArray;
         by.readUnsignedInt();
         by.readUnsignedInt();
         MainManager.actorInfo.fightBadge = by.readUnsignedInt();
         var len:uint = by.readUnsignedInt();
         for(var i1:int = 0; i1 < len; i1++)
         {
            id = by.readUnsignedInt();
            count = by.readUnsignedInt();
            Alarm.show(count + "个" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(id)) + "已经放入你的背包。");
         }
      }
      
      public static function exchangePet(type:uint, need:uint) : void
      {
         var f:uint = uint(MainManager.actorInfo.fightBadge);
         if(MainManager.actorInfo.fightBadge < need)
         {
            Alert.show("你的战斗徽章数不够!");
            return;
         }
         Alert.show("你确定要兑换吗?",function():void
         {
            SocketConnection.addCmdListener(CommandID.EXCHANGE_PET_COMPLETE,onExtPetHandler);
            SocketConnection.send(CommandID.EXCHANGE_PET_COMPLETE,type);
         });
      }
      
      private static function onExtPetHandler(e:SocketEvent) : void
      {
         var nameStr:String = null;
         var len:uint = 0;
         var i1:int = 0;
         var id:uint = 0;
         var count:uint = 0;
         var itemName:String = null;
         SocketConnection.removeCmdListener(CommandID.EXCHANGE_PET_COMPLETE,onExtPetHandler);
         var by:ByteArray = e.data as ByteArray;
         MainManager.actorInfo.fightBadge = by.readUnsignedInt();
         var petId:uint = by.readUnsignedInt();
         var capTime:uint = by.readUnsignedInt();
         if(petId != 0)
         {
            nameStr = PetXMLInfo.getName(petId);
            Alarm.show("一个" + TextFormatUtil.getRedTxt(nameStr) + "作为奖励已经放入你的精灵仓库！");
            PetManager.addStorage(petId,capTime);
         }
         else
         {
            len = by.readUnsignedInt();
            for(i1 = 0; i1 < len; i1++)
            {
               id = by.readUnsignedInt();
               count = by.readUnsignedInt();
               itemName = ItemXMLInfo.getName(id);
               Alarm.show(count.toString() + "个" + TextFormatUtil.getRedTxt(itemName) + "作为奖励已经放入你的背包！");
            }
         }
      }
   }
}

