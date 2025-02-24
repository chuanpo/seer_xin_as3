package com.robot.app.sceneInteraction
{
   import com.robot.core.config.xml.MapXMLInfo;
   import com.robot.core.event.FitmentEvent;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.manager.HeadquarterManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.HeadquarterModel;
   import com.robot.core.utils.DragTargetType;
   import com.robot.core.utils.SolidType;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.ArrayUtil;
   
   public class HeadquarterShow
   {
      private var _currFitment:HeadquarterModel;
      
      private var _useList:Array = [];
      
      public function HeadquarterShow()
      {
         super();
         this.onUseFitment();
      }
      
      public function destroy() : void
      {
         var item:HeadquarterModel = null;
         HeadquarterManager.removeEventListener(FitmentEvent.ADD_TO_MAP,this.onAddMap);
         HeadquarterManager.removeEventListener(FitmentEvent.REMOVE_TO_MAP,this.onRemoveMap);
         HeadquarterManager.removeEventListener(FitmentEvent.REMOVE_ALL_TO_MAP,this.onRemoveAllMap);
         HeadquarterManager.destroy();
         var len:int = int(this._useList.length);
         for(var i:int = 0; i < len; i++)
         {
            item = this._useList[i] as HeadquarterModel;
            if(Boolean(item))
            {
               item.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
               item.destroy();
               item = null;
            }
         }
         this._useList = null;
         if(Boolean(this._currFitment))
         {
            this._currFitment.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this._currFitment = null;
         }
      }
      
      public function getStorageInfo() : void
      {
         HeadquarterManager.addEventListener(FitmentEvent.ADD_TO_MAP,this.onAddMap);
         HeadquarterManager.addEventListener(FitmentEvent.REMOVE_TO_MAP,this.onRemoveMap);
         HeadquarterManager.addEventListener(FitmentEvent.REMOVE_ALL_TO_MAP,this.onRemoveAllMap);
         HeadquarterManager.getStorageInfo(MainManager.actorInfo.mapID);
      }
      
      public function openDrag() : void
      {
         this._useList.forEach(function(item:HeadquarterModel, index:int, array:Array):void
         {
            item.addEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            item.mouseChildren = false;
            item.buttonMode = true;
            item.dragEnabled = true;
         });
      }
      
      public function closeDrag() : void
      {
         this._useList.forEach(function(item:HeadquarterModel, index:int, array:Array):void
         {
            item.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            item.mouseChildren = true;
            if(item.funID == 0)
            {
               item.buttonMode = false;
            }
            item.dragEnabled = false;
         });
      }
      
      private function onUseFitment() : void
      {
         var info:FitmentInfo = null;
         var fm:HeadquarterModel = null;
         var arr:Array = HeadquarterManager.getUsedList();
         for each(info in arr)
         {
            if(info.type != SolidType.FRAME)
            {
               if(info.isFixed)
               {
                  info.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
               }
               fm = new HeadquarterModel();
               fm.show(info,MapManager.currentMap.depthLevel);
               this._useList.push(fm);
            }
         }
      }
      
      private function onAddMap(e:FitmentEvent) : void
      {
         var item:HeadquarterModel = new HeadquarterModel();
         item.addEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
         item.mouseChildren = false;
         item.buttonMode = true;
         item.dragEnabled = true;
         item.show(e.info,MapManager.currentMap.depthLevel);
         this._useList.push(item);
         DepthManager.swapDepth(item,item.y);
      }
      
      private function onRemoveMap(e:FitmentEvent) : void
      {
         var item:HeadquarterModel = null;
         var len:int = int(MapManager.currentMap.depthLevel.numChildren);
         for(var i:int = 0; i < len; i++)
         {
            item = MapManager.currentMap.depthLevel.getChildAt(i) as HeadquarterModel;
            if(Boolean(item))
            {
               if(item.info == e.info)
               {
                  if(this._currFitment == item)
                  {
                     this._currFitment.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
                     this._currFitment = null;
                  }
                  ArrayUtil.removeValueFromArray(this._useList,item);
                  item.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
                  item.destroy();
                  item = null;
                  return;
               }
            }
         }
      }
      
      private function onRemoveAllMap(e:FitmentEvent) : void
      {
         if(Boolean(this._currFitment))
         {
            this._currFitment.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this._currFitment = null;
         }
         this._useList.forEach(function(item:HeadquarterModel, index:int, array:Array):void
         {
            item.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            item.destroy();
            item = null;
         });
         this._useList = [];
      }
      
      private function onFMDown(e:MouseEvent) : void
      {
         var p:Point = null;
         var item:HeadquarterModel = e.currentTarget as HeadquarterModel;
         var obj:Sprite = item.content as Sprite;
         if(Boolean(obj))
         {
            p = new Point(e.stageX - item.x,e.stageY - item.y);
            HeadquarterManager.doDrag(obj,item.info,item,DragTargetType.MAP,p);
         }
         this._currFitment = item;
         this._currFitment.setSelect(true);
         this._currFitment.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
      
      private function onFocusOut(e:FocusEvent) : void
      {
         var item:HeadquarterModel = e.currentTarget as HeadquarterModel;
         item.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         item.setSelect(false);
      }
   }
}

