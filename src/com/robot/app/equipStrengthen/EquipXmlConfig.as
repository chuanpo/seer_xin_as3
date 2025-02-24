package com.robot.app.equipStrengthen
{
   import com.robot.core.event.ItemEvent;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   
   public class EquipXmlConfig
   {
      private static var _allIdA:Array;
      
      private static var xmlClass:Class = EquipXmlConfig_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function EquipXmlConfig()
      {
         super();
      }
      
      public static function getAllEquipId() : Array
      {
         var list:XML = null;
         var xmlList:XMLList = xml.elements("equip");
         _allIdA = new Array();
         for each(list in xmlList)
         {
            _allIdA.push(uint(list.@id));
         }
         return _allIdA;
      }
      
      public static function getInfo(id:uint, lev:uint, func:Function) : void
      {
         var xmlList:XMLList = null;
         var xml1:XML = null;
         var xmlList1:XMLList = null;
         var xml2:XML = null;
         var info:EquipStrengthenInfo = null;
         var needA:Array = null;
         var ownA:Array = null;
         xmlList = xml.elements("equip");
         xml1 = xmlList.(@id == id.toString())[0];
         xmlList1 = xml1.elements("level");
         xml2 = xmlList1.(@levelId == lev.toString())[0];
         if(xml2 == null)
         {
            return;
         }
         info = new EquipStrengthenInfo();
         info.itemId = id;
         info.levelId = lev;
         info.sendId = uint(xml2.@sendId);
         needA = String(xml2.@needCatalystId).split("|");
         info.needCatalystId = needA[0];
         info.needCatalystNum = needA[1];
         info.needMatterA = String(xml2.@needMatterId).split("|");
         info.needMatterNumA = String(xml2.@needMatterNum).split("|");
         info.des = xml2.@des;
         info.prob = xml2.@odds;
         ownA = new Array();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,function(e:ItemEvent):void
         {
            var info1:SingleItemInfo = null;
            ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,arguments.callee);
            for(var i1:int = 0; i1 < info.needMatterA.length; i1++)
            {
               info1 = ItemManager.getCollectionInfo(info.needMatterA[i1]);
               if(Boolean(info1))
               {
                  ownA.push(info1.itemNum);
               }
               else
               {
                  ownA.push(0);
               }
            }
            var info2:SingleItemInfo = ItemManager.getCollectionInfo(info.needCatalystId);
            if(Boolean(info2))
            {
               info.ownCatalystNum = info2.itemNum;
            }
            else
            {
               info.ownCatalystNum = 0;
            }
            info.ownNeedA = ownA;
            if(func != null)
            {
               func(info);
            }
         });
         ItemManager.getCollection();
      }
   }
}

