package com.robot.app.bag
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.events.DynamicEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class BagTypePanel extends Sprite
   {
      private var _selectIndex:int = 0;
      
      private var _suitPanel:SuitListPanel;
      
      private var _esuitPanel:SuitListPanel;
      
      private var _app:ApplicationDomain;
      
      private var _selectItem:BagTypeListItem;
      
      private var _listCon:Sprite;
      
      private var _outTime:uint;
      
      public function BagTypePanel(app:ApplicationDomain)
      {
         var i:int = 0;
         var item:BagTypeListItem = null;
         super();
         this._app = app;
         var bg:Sprite = new (app.getDefinition("bagtypepanelMc") as Class)() as Sprite;
         bg.width = 104;
         bg.cacheAsBitmap = true;
         addChild(bg);
         this._listCon = new Sprite();
         this._listCon.x = 12;
         this._listCon.y = 15;
         addChild(this._listCon);
         for(var len:int = int(BagShowType.typeNameList.length); i < len; )
         {
            item = new BagTypeListItem(this._app);
            item.setInfo(i,BagShowType.typeNameList[i]);
            item.y = i * (item.height + 5);
            item.addEventListener(MouseEvent.ROLL_OVER,this.onItemOver);
            item.addEventListener(MouseEvent.ROLL_OUT,this.onItemOut);
            item.addEventListener(MouseEvent.CLICK,this.onItemClick);
            this._listCon.addChild(item);
            i++;
         }
         this._selectItem = this._listCon.getChildAt(BagShowType.currType) as BagTypeListItem;
         this._selectItem.select = true;
         bg.height = this._listCon.height + 35;
      }
      
      public function setSelect(i:int) : void
      {
         this._selectItem.select = false;
         this._selectItem = this._listCon.getChildAt(i) as BagTypeListItem;
         this._selectItem.select = true;
      }
      
      private function suitDestroy() : void
      {
         if(Boolean(this._suitPanel))
         {
            this._suitPanel.removeEventListener(Event.SELECT,this.onSuitSelect);
            this._suitPanel.removeEventListener(MouseEvent.ROLL_OVER,this.onSuitOver);
            this._suitPanel.removeEventListener(MouseEvent.ROLL_OUT,this.onSuitOut);
            this._suitPanel.destroy();
            DisplayUtil.removeForParent(this._suitPanel);
            this._suitPanel = null;
         }
         if(Boolean(this._esuitPanel))
         {
            this._esuitPanel.removeEventListener(Event.SELECT,this.onSuitSelect);
            this._esuitPanel.removeEventListener(MouseEvent.ROLL_OVER,this.onSuitOver);
            this._esuitPanel.removeEventListener(MouseEvent.ROLL_OUT,this.onSuitOut);
            this._esuitPanel.destroy();
            DisplayUtil.removeForParent(this._esuitPanel);
            this._esuitPanel = null;
         }
      }
      
      private function onItemOver(e:MouseEvent) : void
      {
         var item:BagTypeListItem = e.currentTarget as BagTypeListItem;
         if(item.id == BagShowType.SUIT)
         {
            if(this._suitPanel == null)
            {
               this._suitPanel = new SuitListPanel(this._app);
               this._suitPanel.addEventListener(Event.SELECT,this.onSuitSelect);
               this._suitPanel.addEventListener(MouseEvent.ROLL_OVER,this.onSuitOver);
               this._suitPanel.addEventListener(MouseEvent.ROLL_OUT,this.onSuitOut);
               this._suitPanel.x = item.x + item.width + 10;
               this._suitPanel.y = -20;
            }
            addChild(this._suitPanel);
            clearTimeout(this._outTime);
         }
         else if(item.id == BagShowType.ELITE_SUIT)
         {
            if(this._esuitPanel == null)
            {
               this._esuitPanel = new SuitListPanel(this._app,true);
               this._esuitPanel.addEventListener(Event.SELECT,this.onSuitSelect);
               this._esuitPanel.addEventListener(MouseEvent.ROLL_OVER,this.onSuitOver);
               this._esuitPanel.addEventListener(MouseEvent.ROLL_OUT,this.onSuitOut);
               this._esuitPanel.x = item.x + item.width + 10;
               this._esuitPanel.y = -20;
            }
            addChild(this._esuitPanel);
            clearTimeout(this._outTime);
         }
      }
      
      private function onItemOut(e:MouseEvent) : void
      {
         var item:BagTypeListItem = e.currentTarget as BagTypeListItem;
         if(item.id == BagShowType.SUIT)
         {
            if(Boolean(this._suitPanel))
            {
               clearTimeout(this._outTime);
               this._outTime = setTimeout(function():void
               {
                  suitDestroy();
               },500);
            }
         }
         if(item.id == BagShowType.ELITE_SUIT)
         {
            if(Boolean(this._esuitPanel))
            {
               clearTimeout(this._outTime);
               this._outTime = setTimeout(function():void
               {
                  suitDestroy();
               },500);
            }
         }
      }
      
      private function onItemClick(e:MouseEvent) : void
      {
         var item:BagTypeListItem = e.currentTarget as BagTypeListItem;
         if(item.id != BagShowType.SUIT)
         {
            dispatchEvent(new BagTypeEvent(BagTypeEvent.SELECT,item.id));
         }
      }
      
      private function onSuitSelect(e:DynamicEvent) : void
      {
         dispatchEvent(new BagTypeEvent(BagTypeEvent.SELECT,BagShowType.SUIT,e.paramObject as uint));
      }
      
      private function onSuitOver(e:MouseEvent) : void
      {
         clearTimeout(this._outTime);
      }
      
      private function onSuitOut(e:MouseEvent) : void
      {
         this.suitDestroy();
      }
   }
}

