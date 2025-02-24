package com.robot.app.storage
{
   import com.robot.core.event.FitmentEvent;
   import com.robot.core.manager.FitmentManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.ui.alert.Alert;
   import com.robot.core.uic.UIPageBar;
   import com.robot.core.utils.DragTargetType;
   import com.robot.core.utils.SolidType;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import gs.TweenLite;
   import gs.easing.Expo;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class StoragePanel extends Sprite
   {
      private static const MAX:int = 10;
      
      private static const TYPE_LIST:Array = [4,5,1,11];
      
      private var _mainUI:Sprite;
      
      private var _listCon:Sprite;
      
      private var _closeBtn:SimpleButton;
      
      private var _dragBtn:SimpleButton;
      
      private var _dataList:Array;
      
      private var _dataLen:int;
      
      private var _isTween:Boolean = false;
      
      private var _pageBar:UIPageBar;
      
      private var _type:uint = 4;
      
      private var _currTab:MovieClip;
      
      public function StoragePanel()
      {
         var item:StorageListItem = null;
         var tabMC:MovieClip = null;
         super();
         this._mainUI = UIManager.getSprite("Storage_ToolBar");
         this._dragBtn = this._mainUI["dragBtn"];
         this._closeBtn = this._mainUI["closeBtn"];
         this._mainUI.mouseEnabled = false;
         addChild(this._mainUI);
         this._listCon = new Sprite();
         this._listCon.x = 62;
         this._listCon.y = 11;
         addChild(this._listCon);
         for(var i:int = 0; i < MAX; i++)
         {
            item = new StorageListItem();
            item.x = (item.width + 8) * i;
            this._listCon.addChild(item);
         }
         this._pageBar = new UIPageBar(this._mainUI["preBtn"],this._mainUI["nextBtn"],new TextField(),MAX);
         for(var t:int = 0; t < 4; t++)
         {
            tabMC = this._mainUI.getChildByName("tab_" + t.toString()) as MovieClip;
            tabMC.buttonMode = true;
            tabMC.mouseChildren = false;
            tabMC.gotoAndStop(1);
            tabMC.addEventListener(MouseEvent.CLICK,this.onTabClick);
            tabMC.typeID = TYPE_LIST[t];
            if(t == 0)
            {
               this._currTab = tabMC;
            }
         }
         this._currTab.gotoAndStop(2);
         this._currTab.mouseEnabled = false;
         DepthManager.bringToTop(this._currTab);
      }
      
      public function show() : void
      {
         if(this._isTween)
         {
            return;
         }
         y = MainManager.getStageHeight();
         x = (MainManager.getStageWidth() - width) / 2;
         alpha = 1;
         LevelManager.appLevel.addChild(this);
         TweenLite.to(this,0.6,{
            "y":MainManager.getStageHeight() - height + 28,
            "ease":Expo.easeOut
         });
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this._pageBar.addEventListener(MouseEvent.CLICK,this.onProPage);
         FitmentManager.addEventListener(FitmentEvent.ADD_TO_STORAGE,this.onUnUsedFitment);
         FitmentManager.addEventListener(FitmentEvent.REMOVE_TO_STORAGE,this.onUnUsedFitment);
         FitmentManager.addEventListener(FitmentEvent.STORAGE_LIST,this.onUnUsedFitment);
         this.reItem();
      }
      
      public function hide() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this._pageBar.removeEventListener(MouseEvent.CLICK,this.onProPage);
         FitmentManager.removeEventListener(FitmentEvent.ADD_TO_STORAGE,this.onUnUsedFitment);
         FitmentManager.removeEventListener(FitmentEvent.REMOVE_TO_STORAGE,this.onUnUsedFitment);
         FitmentManager.removeEventListener(FitmentEvent.STORAGE_LIST,this.onUnUsedFitment);
         TweenLite.to(this,0.6,{
            "alpha":0,
            "onComplete":this.onFinishTween
         });
         this._isTween = true;
      }
      
      public function destroy() : void
      {
         this.hide();
         this._pageBar.destroy();
         this._pageBar = null;
         this._dataList = null;
         this._listCon = null;
         this._dragBtn = null;
         this._closeBtn = null;
         this._mainUI = null;
      }
      
      public function reItem() : void
      {
         var itemi:StorageListItem = null;
         this._dataList = FitmentManager.getUnUsedListForType(this._type);
         this._dataLen = this._dataList.length;
         this.clearItem();
         if(this._dataLen == 0)
         {
            return;
         }
         this._pageBar.totalLength = this._dataLen;
         var dLen:int = Math.min(MAX,this._dataLen);
         for(var k:int = 0; k < dLen; k++)
         {
            itemi = this._listCon.getChildAt(k) as StorageListItem;
            itemi.info = this._dataList[k + this._pageBar.index];
            itemi.addEventListener(MouseEvent.MOUSE_DOWN,this.onItemDown);
         }
      }
      
      private function clearItem() : void
      {
         var item:StorageListItem = null;
         var num:int = this._listCon.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            item = this._listCon.getChildAt(i) as StorageListItem;
            item.removeEventListener(MouseEvent.MOUSE_DOWN,this.onItemDown);
            item.destroy();
         }
      }
      
      private function onProPage(e:DynamicEvent) : void
      {
         var itemi:StorageListItem = null;
         this.clearItem();
         var index:uint = e.paramObject as uint;
         var len:int = Math.min(MAX,this._pageBar.totalLength - this._pageBar.index * MAX);
         for(var i:int = 0; i < len; i++)
         {
            itemi = this._listCon.getChildAt(i) as StorageListItem;
            itemi.destroy();
            itemi.info = this._dataList[i + this._pageBar.index * MAX];
            itemi.addEventListener(MouseEvent.MOUSE_DOWN,this.onItemDown);
         }
      }
      
      private function onFinishTween() : void
      {
         this._isTween = false;
         DisplayUtil.removeForParent(this);
      }
      
      private function onClose(e:MouseEvent) : void
      {
         this.hide();
      }
      
      private function onDragDown(e:MouseEvent) : void
      {
         startDrag();
      }
      
      private function onDragUp(e:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function onItemDown(e:MouseEvent) : void
      {
         var obj:Sprite;
         var item:StorageListItem = null;
         var p:Point = null;
         var bmd:BitmapData = null;
         item = e.currentTarget as StorageListItem;
         if(item.info.type == SolidType.FRAME)
         {
            Alert.show("你确定换房型吗？",function():void
            {
               LevelManager.closeMouseEvent();
               FitmentManager.saveRoomType(item.info,function():void
               {
                  MapManager.refMap();
               });
            });
            return;
         }
         obj = item.obj as Sprite;
         if(Boolean(obj))
         {
            if(item.info.unUsedCount > 1)
            {
               p = obj.localToGlobal(new Point());
               bmd = new BitmapData(obj.width,obj.height,true,0);
               bmd.draw(obj);
               obj = new Sprite();
               obj.addChild(new Bitmap(bmd));
               obj.x = p.x;
               obj.y = p.y;
            }
            FitmentManager.doDrag(obj,item.info,item,DragTargetType.STORAGE);
         }
      }
      
      private function onUnUsedFitment(e:FitmentEvent) : void
      {
         this.reItem();
      }
      
      private function onTabClick(e:MouseEvent) : void
      {
         var item:MovieClip = e.currentTarget as MovieClip;
         this._type = item.typeID;
         this._currTab.gotoAndStop(1);
         DepthManager.bringToBottom(this._currTab);
         this._currTab.mouseEnabled = true;
         this._currTab = item;
         this._currTab.gotoAndStop(2);
         DepthManager.bringToTop(this._currTab);
         this._currTab.mouseEnabled = false;
         this._pageBar.index = 0;
         this.reItem();
      }
   }
}

