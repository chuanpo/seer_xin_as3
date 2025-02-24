package com.robot.app.petbag.petPropsBag
{
   import com.robot.app.petbag.petPropsBag.ui.PetPropsPanel;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.manager.ItemManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetBagModel
   {
      private var view:PetPropsPanel;
      
      private var idArray:Array;
      
      private var totalPage:uint;
      
      private var currentPage:uint = 1;
      
      private var PET_NUM:uint = 12;
      
      private var doodleAry:Array;
      
      public function PetBagModel(view:Sprite)
      {
         super();
         this.view = view as PetPropsPanel;
         this.addEvent();
         this.onShowCollection();
      }
      
      public function addEvent() : void
      {
         this.view.addEventListener(Event.CLOSE,this.onPanelClose);
         this.view.addEventListener(PetPropsPanel.NEXT_PAGE,this.nextHandler);
         this.view.addEventListener(PetPropsPanel.PREV_PAGE,this.prevHandler);
      }
      
      public function removeEvent() : void
      {
         this.view.removeEventListener(Event.CLOSE,this.onPanelClose);
         this.view.removeEventListener(PetPropsPanel.NEXT_PAGE,this.nextHandler);
         this.view.removeEventListener(PetPropsPanel.PREV_PAGE,this.prevHandler);
      }
      
      private function onPanelClose(event:Event) : void
      {
         this.currentPage = 1;
         this.clear();
      }
      
      public function clear() : void
      {
         ItemManager.removeEventListener(ItemEvent.PET_ITEM_LIST,this.onPetItemList);
      }
      
      private function onShowCollection() : void
      {
         this.currentPage = 1;
         ItemManager.addEventListener(ItemEvent.PET_ITEM_LIST,this.onPetItemList);
         ItemManager.getPetItem();
      }
      
      private function getArray(bCloth:Boolean = true, page:uint = 1, perNum:uint = 12) : Array
      {
         var start:uint = (page - 1) * perNum;
         var end:uint = page * perNum;
         var arr:Array = this.doodleAry;
         return arr.slice(start,end);
      }
      
      private function onPetItemList(evt:ItemEvent) : void
      {
         ItemManager.removeEventListener(ItemEvent.PET_ITEM_LIST,this.onPetItemList);
         this.showItem(ItemManager.getPetItemIDs());
      }
      
      private function showItem(data:Array) : void
      {
         var i:uint = 0;
         this.doodleAry = [];
         for each(i in data)
         {
            if(ItemXMLInfo.getIsShowInPetBag(i))
            {
               this.doodleAry.push(i);
            }
         }
         this.totalPage = Math.ceil(this.doodleAry.length / this.PET_NUM);
         if(this.totalPage == 0)
         {
            this.totalPage = 1;
         }
         this.view.setPageNum(1,this.totalPage);
         this.view.showItem(this.getArray());
      }
      
      private function prevHandler(event:Event) : void
      {
         if(this.currentPage > 1)
         {
            --this.currentPage;
            this.view.showItem(this.getArray(false,this.currentPage));
            this.view.setPageNum(this.currentPage,this.totalPage);
         }
      }
      
      private function nextHandler(event:Event) : void
      {
         if(this.currentPage < this.totalPage)
         {
            ++this.currentPage;
            this.view.showItem(this.getArray(false,this.currentPage));
            this.view.setPageNum(this.currentPage,this.totalPage);
         }
      }
   }
}

