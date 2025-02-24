package com.robot.app.bag
{
   import com.robot.core.config.xml.SuitXMLInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.uic.UIPageBar;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import org.taomee.events.DynamicEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class SuitListPanel extends Sprite
   {
      private static const MAX:int = 6;
      
      private var _dataList:Array;
      
      private var _listCon:Sprite;
      
      private var _dataLen:int = 0;
      
      private var _proPageBar:UIPageBar;
      
      public function SuitListPanel(app:ApplicationDomain, isE:Boolean = false)
      {
         var bg:Sprite;
         var _dataLen:int;
         var len:int;
         var i:int;
         var _preBtn:SimpleButton;
         var _nextBtn:SimpleButton;
         var id:uint = 0;
         var item:BagTypeListItem = null;
         super();
         bg = new (app.getDefinition("suitpanelMc") as Class)() as Sprite;
         bg.width = 120;
         bg.height = 276;
         bg.cacheAsBitmap = true;
         addChild(bg);
         this._listCon = new Sprite();
         this._listCon.x = 10;
         this._listCon.y = 34;
         addChild(this._listCon);
         if(isE)
         {
            this._dataList = SuitXMLInfo.getIsEliteItems(ItemManager.getClothIDs());
         }
         else
         {
            this._dataList = SuitXMLInfo.getIDsForItems(ItemManager.getClothIDs());
         }
         if(BagPanel.currTab == BagTabType.NONO)
         {
            this._dataList = this._dataList.filter(function(item:uint, index:int, array:Array):Boolean
            {
               if(SuitXMLInfo.getIsVip(item))
               {
                  return true;
               }
               return false;
            });
         }
         else
         {
            this._dataList = this._dataList.filter(function(item:uint, index:int, array:Array):Boolean
            {
               if(!SuitXMLInfo.getIsVip(item))
               {
                  return true;
               }
               return false;
            });
         }
         _dataLen = int(this._dataList.length);
         len = Math.min(MAX,_dataLen);
         for(i = 0; i < MAX; i++)
         {
            id = uint(this._dataList[i]);
            item = new BagTypeListItem(app);
            item.width = 96;
            item.y = i * (item.height + 5);
            this._listCon.addChild(item);
            if(i < len)
            {
               item.setInfo(id,SuitXMLInfo.getName(id));
               item.addEventListener(MouseEvent.CLICK,this.onItemClick);
               if(BagShowType.currType == BagShowType.SUIT)
               {
                  if(item.id == BagShowType.currSuitID)
                  {
                     item.select = true;
                  }
               }
            }
         }
         _preBtn = UIManager.getButton("Arrow_Icon");
         _preBtn.x = bg.width / 2 + _preBtn.width / 2;
         _preBtn.y = 5;
         _preBtn.rotation = 90;
         addChild(_preBtn);
         _nextBtn = UIManager.getButton("Arrow_Icon");
         _nextBtn.x = (bg.width - _nextBtn.width) / 2;
         _nextBtn.y = bg.height - 10;
         _nextBtn.rotation = -90;
         addChild(_nextBtn);
         this._proPageBar = new UIPageBar(_preBtn,_nextBtn,new TextField(),MAX);
         this._proPageBar.totalLength = _dataLen;
         this._proPageBar.addEventListener(MouseEvent.CLICK,this.onProPage);
      }
      
      public function destroy() : void
      {
         this._proPageBar.removeEventListener(MouseEvent.CLICK,this.onProPage);
         this._proPageBar.destroy();
         this._proPageBar = null;
         this._dataList = null;
         DisplayUtil.removeAllChild(this);
         this._listCon = null;
      }
      
      private function onItemClick(e:MouseEvent) : void
      {
         var item:BagTypeListItem = e.currentTarget as BagTypeListItem;
         dispatchEvent(new DynamicEvent(Event.SELECT,item.id));
      }
      
      private function onProPage(e:DynamicEvent) : void
      {
         var mc:BagTypeListItem = null;
         var id:uint = 0;
         var item:BagTypeListItem = null;
         var index:uint = e.paramObject as uint;
         for(var i:int = 0; i < MAX; i++)
         {
            mc = this._listCon.getChildAt(i) as BagTypeListItem;
            mc.clear();
         }
         var len:int = Math.min(MAX,this._proPageBar.totalLength - this._proPageBar.index * MAX);
         for(var k:int = 0; k < len; k++)
         {
            id = uint(this._dataList[k + index * MAX]);
            item = this._listCon.getChildAt(k) as BagTypeListItem;
            item.setInfo(id,SuitXMLInfo.getName(id));
            if(BagShowType.currType == BagShowType.SUIT)
            {
               if(item.id == BagShowType.currSuitID)
               {
                  item.select = true;
               }
               else
               {
                  item.select = false;
               }
            }
         }
      }
   }
}

