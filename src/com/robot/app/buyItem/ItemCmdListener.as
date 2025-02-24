package com.robot.app.buyItem
{
   import com.robot.app.info.item.BuyItemInfo;
   import com.robot.app.info.item.BuyMultiItemInfo;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.GoldProductXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.MoneyProductXMLInfo;
   import com.robot.core.info.moneyAndGold.GoldBuyProductInfo;
   import com.robot.core.info.moneyAndGold.MoneyBuyProductInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.IconAlert;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.events.Event;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class ItemCmdListener extends BaseBeanController
   {
      public static var ITEM_NAME:String;
      
      private static var THROW_THING:uint = 6;
      
      public function ItemCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_BUY,this.onItemBuy);
         SocketConnection.addCmdListener(CommandID.MULTI_ITEM_BUY,this.onMultiItemBuy);
         SocketConnection.addCmdListener(CommandID.GOLD_BUY_PRODUCT,this.onBuyGoldProduct);
         SocketConnection.addCmdListener(CommandID.MONEY_BUY_PRODUCT,this.onBuyMoneyProduct);
         finish();
      }
      
      private function onItemBuy(event:SocketEvent) : void
      {
         var data:BuyItemInfo = null;
         var str:String = null;
         data = event.data as BuyItemInfo;
         var name:String = ItemXMLInfo.getName(data.itemID);
         if(ItemXMLInfo.getCatID(data.itemID) == THROW_THING)
         {
            str = data.itemNum + "个<font color=\'#FF0000\'>" + name + "</font>已经放入你的投掷道具箱中";
            Alarm.show(str,function():void
            {
               EventManager.dispatchEvent(new DynamicEvent(ItemAction.BUY_ONE,data.itemID));
            });
         }
         else
         {
            str = data.itemNum + "个<font color=\'#FF0000\'>" + name + "</font>已经放入你的储存箱";
            ItemInBagAlert.show(data.itemID,str,function():void
            {
               EventManager.dispatchEvent(new DynamicEvent(ItemAction.BUY_ONE,data.itemID));
            });
         }
         MainManager.actorInfo.coins = data.cash;
      }
      
      private function onMultiItemBuy(event:SocketEvent) : void
      {
         var data:BuyMultiItemInfo = event.data as BuyMultiItemInfo;
         Alarm.show("<font color=\'#FF0000\'>" + ITEM_NAME + "</font>已经放入你的储存箱！");
         MainManager.actorInfo.coins = data.cash;
         EventManager.dispatchEvent(new Event(ItemAction.BUY_MUILTY));
      }
      
      private function onBuyGoldProduct(event:SocketEvent) : void
      {
         var i:uint = 0;
         var name:String = null;
         var data:GoldBuyProductInfo = event.data as GoldBuyProductInfo;
         var array:Array = GoldProductXMLInfo.getItemIDs(ProductAction.productID);
         for each(i in array)
         {
            name = ItemXMLInfo.getName(i);
            if(i > 500000)
            {
               IconAlert.show("恭喜你购买成功，" + TextFormatUtil.getRedTxt(name) + "已经放入你的基地仓库中",i);
            }
            else
            {
               ItemInBagAlert.show(i,"恭喜你购买成功，" + TextFormatUtil.getRedTxt(name) + "已经放入你的储存箱中");
            }
         }
      }
      
      private function onBuyMoneyProduct(event:SocketEvent) : void
      {
         var i:uint = 0;
         var name:String = null;
         var data:MoneyBuyProductInfo = event.data as MoneyBuyProductInfo;
         var array:Array = MoneyProductXMLInfo.getItemIDs(ProductAction.productID);
         for each(i in array)
         {
            name = ItemXMLInfo.getName(i);
            if(i == 5)
            {
               name = MoneyProductXMLInfo.getNameByProID(ProductAction.productID);
               IconAlert.show("你获得了" + TextFormatUtil.getRedTxt(name) + "，快去<font color=\'#ff0000\'>《宇宙购物指南》</font>中购物吧！^_^",i);
            }
            else if(i > 500000)
            {
               IconAlert.show("恭喜你购买成功，" + TextFormatUtil.getRedTxt(name) + "已经放入你的基地仓库中",i);
            }
            else
            {
               ItemInBagAlert.show(i,"恭喜你购买成功，" + TextFormatUtil.getRedTxt(name) + "已经放入你的储存箱中");
            }
         }
      }
   }
}

