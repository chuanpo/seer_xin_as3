package com.robot.app.exchangeCloth
{
   import com.robot.core.config.xml.ItemTipXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   
   public class ExchangeClothModel
   {
      private var xmlClass:Class = ExchangeClothModel_xmlClass;
      
      private var xml:XML = XML(new this.xmlClass());
      
      private var info_a:Array;
      
      public function ExchangeClothModel()
      {
         super();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.onList);
         ItemManager.getCollection();
      }
      
      private function getInfo() : void
      {
         var obj:Object = null;
         for(var i1:int = 0; i1 < this.xml.item.length(); i1++)
         {
            if(ItemManager.getCollectionInfo(uint(this.xml.item[i1].@id)) != null)
            {
               obj = new Object();
               obj.className = this.xml.item[i1].@className;
               obj.iconName = this.xml.item[i1].@iconName;
               obj.id = this.xml.item[i1].@id;
               obj.exName = this.xml.item[i1].@exName;
               obj.eName = ItemXMLInfo.getName(uint(obj.id));
               obj.des = ItemTipXMLInfo.getItemDes(uint(obj.id));
               this.info_a.push(obj);
            }
         }
      }
      
      public function onList(e:Event) : void
      {
         this.destroy();
         this.info_a = new Array();
         this.getInfo();
         if(this.info_a.length > 0)
         {
            ExchangeClothController.show(this.info_a);
         }
         else
         {
            Alarm.show("你还没有原材料打造装备，快去搜集吧!");
         }
      }
      
      public function destroy() : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onList);
      }
   }
}

