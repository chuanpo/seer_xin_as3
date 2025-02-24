package com.robot.app.buyItem
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.IconAlert;
   import flash.utils.ByteArray;
   
   public class ItemAction
   {
      private static var _buyApp:AppModel;
      
      public static const FLAG_IN_BAG:uint = 0;
      
      public static const FLAG_ON_BODY:uint = 1;
      
      public static const FLAG_ALL:uint = 2;
      
      public static const BUY_ONE:String = "buyOne";
      
      public static const BUY_MUILTY:String = "buyMuilty";
      
      public function ItemAction()
      {
         super();
      }
      
      public static function listItem(startIndex:uint = 100001, endIndex:uint = 101001, flag:uint = 2) : void
      {
         SocketConnection.send(CommandID.ITEM_LIST,startIndex,endIndex,flag);
      }
      
      public static function showBuyPanel(id:uint) : void
      {
         if(!_buyApp)
         {
            _buyApp = new AppModel(ClientConfig.getAppModule("BuyItemTipPanel"),"正在打开购买面板");
            _buyApp.setup();
         }
         _buyApp.init(id);
         _buyApp.show();
      }
      
      public static function desBuyPanel() : void
      {
         if(Boolean(_buyApp))
         {
            _buyApp.destroy();
            _buyApp = null;
         }
      }
      
      public static function buyItem(id:uint, isTip:Boolean = true, count:uint = 1) : void
      {
         var price:uint;
         var name:String;
         var str:String;
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
            SocketConnection.send(CommandID.ITEM_BUY,id,count);
            return;
         }
         price = uint(ItemXMLInfo.getPrice(id));
         name = ItemXMLInfo.getName(id);
         str = "";
         if(count > 1)
         {
            str += count + "个";
         }
         if(price > 0)
         {
            if(MainManager.isClothHalfDay)
            {
               str += "<font color=\'#ff0000\'>" + name + "</font>需要花费" + price.toString() + "赛尔豆，<font color=\'#ff0000\'>（半价日只需要花费" + price / 2 + "赛尔豆）</font>，要确定购买吗？";
            }
            else
            {
               str += "<font color=\'#ff0000\'>" + name + "</font>需要花费" + price * count + "赛尔豆，" + "你现在拥有" + MainManager.actorInfo.coins + "赛尔豆，要确定购买吗？";
            }
         }
         else
         {
            str += "<font color=\'#ff0000\'>" + name + "</font>免费赠送，你确定现在就要领取吗？";
         }
         IconAlert.show(str,id,function():void
         {
            SocketConnection.send(CommandID.ITEM_BUY,id,count);
         });
      }
      
      public static function buyMultiItem(count:uint, name:String, ... args) : void
      {
         var i:uint = 0;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(count);
         for each(i in args)
         {
            byte.writeUnsignedInt(i);
         }
         ItemCmdListener.ITEM_NAME = name;
         SocketConnection.send(CommandID.MULTI_ITEM_BUY,byte);
      }
   }
}

