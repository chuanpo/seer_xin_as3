package com.robot.app.sceneInteraction
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.FitmentEvent;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.manager.FitmentManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.FitmentModel;
   import com.robot.core.utils.DragTargetType;
   import com.robot.core.utils.SolidType;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.ArrayUtil;
   
   public class RoomFitment
   {
      private var _currFitment:FitmentModel;
      
      private var _useList:Array = [];
      
      public function RoomFitment()
      {
         super();
         this.onUseFitment();
      }
      
      public function destroy() : void
      {
         var item:FitmentModel = null;
         FitmentManager.removeEventListener(FitmentEvent.ADD_TO_MAP,this.onAddMap);
         FitmentManager.removeEventListener(FitmentEvent.REMOVE_TO_MAP,this.onRemoveMap);
         FitmentManager.removeEventListener(FitmentEvent.DRAG_IN_MAP,this.onDragInMap);
         FitmentManager.destroy();
         var len:int = int(this._useList.length);
         for(var i:int = 0; i < len; i++)
         {
            item = this._useList[i] as FitmentModel;
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
         FitmentManager.addEventListener(FitmentEvent.ADD_TO_MAP,this.onAddMap);
         FitmentManager.addEventListener(FitmentEvent.REMOVE_TO_MAP,this.onRemoveMap);
         FitmentManager.addEventListener(FitmentEvent.DRAG_IN_MAP,this.onDragInMap);
         FitmentManager.getStorageInfo();
      }
      
      private function onDragInMap(event:FitmentEvent) : void
      {
         var i:FitmentModel = null;
         for each(i in this._useList)
         {
            if(ItemXMLInfo.getIsFloor(i.info.id))
            {
               i.parent.addChildAt(i,0);
            }
         }
      }
      
      public function openDrag() : void
      {
         this._useList.forEach(function(item:FitmentModel, index:int, array:Array):void
         {
            item.addEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            item.mouseChildren = false;
            item.buttonMode = true;
            item.dragEnabled = true;
         });
      }
      
      public function closeDrag() : void
      {
         this._useList.forEach(function(item:FitmentModel, index:int, array:Array):void
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
         var fm:FitmentModel = null;
         var arr:Array = FitmentManager.getUsedList();
         for each(info in arr)
         {
            if(info.type != SolidType.FRAME)
            {
               fm = new FitmentModel();
               fm.show(info,MapManager.currentMap.depthLevel);
               this._useList.push(fm);
            }
         }
         setTimeout(function():void
         {
            var i:FitmentModel = null;
            for each(i in _useList)
            {
               if(ItemXMLInfo.getIsFloor(i.info.id))
               {
                  i.parent.addChildAt(i,0);
               }
            }
         },500);
      }
      
      private function onAddMap(e:FitmentEvent) : void
      {
         var i:FitmentModel = null;
         var item:FitmentModel = new FitmentModel();
         item.addEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
         item.mouseChildren = false;
         item.buttonMode = true;
         item.dragEnabled = true;
         item.show(e.info,MapManager.currentMap.depthLevel);
         this._useList.push(item);
         DepthManager.swapDepth(item,item.y);
         for each(i in this._useList)
         {
            if(ItemXMLInfo.getIsFloor(i.info.id))
            {
               i.parent.addChildAt(i,0);
            }
         }
      }
      
      private function onRemoveMap(e:FitmentEvent) : void
      {
         var item:FitmentModel = null;
         var len:int = int(MapManager.currentMap.depthLevel.numChildren);
         for(var i:int = 0; i < len; i++)
         {
            item = MapManager.currentMap.depthLevel.getChildAt(i) as FitmentModel;
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
      
      private function onFMDown(e:MouseEvent) : void
      {
         var p:Point = null;
         var item:FitmentModel = e.currentTarget as FitmentModel;
         var obj:Sprite = item.content as Sprite;
         if(Boolean(obj))
         {
            p = new Point(e.stageX - item.x,e.stageY - item.y);
            FitmentManager.doDrag(obj,item.info,item,DragTargetType.MAP,p);
         }
         this._currFitment = item;
         this._currFitment.setSelect(true);
         this._currFitment.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
      
      private function onFocusOut(e:FocusEvent) : void
      {
         var item:FitmentModel = e.currentTarget as FitmentModel;
         item.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         item.setSelect(false);
      }
   }
}

