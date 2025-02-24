package com.robot.core.energyExchange
{
   import com.robot.core.CommandID;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   
   public class ExchangeOreModel
   {
      private static var _sucHandler:Function;
      
      private static var _handler:Function;
      
      private static var _desStr:String;
      
      private static var _infoMap:HashMap;
      
      private static var xmlClass:Class = ExchangeOreModel_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function ExchangeOreModel()
      {
         super();
      }
      
      public static function getData(fun:Function, des:String) : void
      {
         _sucHandler = fun;
         _desStr = des;
         _infoMap = new HashMap();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,onList);
         ItemManager.getCollection();
      }
      
      private static function onList(e:ItemEvent) : void
      {
         var info:SingleItemInfo = null;
         var exeInfo:ExchangeItemInfo = null;
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,onList);
         for(var i1:int = 0; i1 < xml.item.length(); i1++)
         {
            info = ItemManager.getCollectionInfo(uint(xml.item[i1].@id));
            if(Boolean(info))
            {
               exeInfo = new ExchangeItemInfo(info);
               _infoMap.add(exeInfo.itemId,exeInfo);
            }
         }
         if(_infoMap.length == 0)
         {
            if(_desStr != "")
            {
               Alarm.show(_desStr);
            }
            _sucHandler(null);
         }
         else
         {
            _sucHandler(_infoMap);
         }
      }
      
      public static function exchangeEnergy(id:uint, amount:uint, fun:Function) : void
      {
         _handler = fun;
         SocketConnection.addCmdListener(CommandID.ITEM_SALE,onSuccess);
         SocketConnection.send(CommandID.ITEM_SALE,id,amount);
      }
      
      private static function onSuccess(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ITEM_SALE,onSuccess);
         _handler();
      }
   }
}

