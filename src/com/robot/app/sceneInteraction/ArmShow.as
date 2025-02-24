package com.robot.app.sceneInteraction
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.MapXMLInfo;
   import com.robot.core.event.ArmEvent;
   import com.robot.core.info.team.ArmInfo;
   import com.robot.core.info.team.DonateInfo;
   import com.robot.core.info.team.WorkInfo;
   import com.robot.core.manager.ArmManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.ArmModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.utils.DragTargetType;
   import com.robot.core.utils.SolidType;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.ArrayUtil;
   
   public class ArmShow
   {
      private var _currArm:ArmModel;
      
      private var _useList:Array = [];
      
      private var _upUseList:Array = [];
      
      public function ArmShow()
      {
         super();
         this.onUseArm();
         this.onUpUseArm();
         SocketConnection.addCmdListener(CommandID.ARM_UP_SET_INFO,this.onSetUpInfo);
         SocketConnection.addCmdListener(CommandID.ARM_UP_UPDATE,this.onUpUpdate);
         SocketConnection.addCmdListener(CommandID.ARM_UP_WORK,this.onUpWork);
         SocketConnection.addCmdListener(CommandID.ARM_UP_DONATE,this.onUpDonate);
      }
      
      public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.ARM_UP_SET_INFO,this.onSetUpInfo);
         SocketConnection.removeCmdListener(CommandID.ARM_UP_UPDATE,this.onUpUpdate);
         SocketConnection.removeCmdListener(CommandID.ARM_UP_WORK,this.onUpWork);
         SocketConnection.removeCmdListener(CommandID.ARM_UP_DONATE,this.onUpDonate);
         ArmManager.removeEventListener(ArmEvent.ADD_TO_MAP,this.onAddMap);
         ArmManager.removeEventListener(ArmEvent.REMOVE_TO_MAP,this.onRemoveMap);
         ArmManager.removeEventListener(ArmEvent.REMOVE_ALL_TO_MAP,this.onRemoveAllMap);
         ArmManager.removeEventListener(ArmEvent.UP_USED_LIST,this.onUpUseEvent);
         ArmManager.destroy();
         this._useList = this._useList.concat(this._upUseList);
         this._useList.forEach(function(item:ArmModel, index:int, array:Array):void
         {
            item.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            item.destroy();
            item = null;
         });
         this._useList = null;
         this._upUseList = null;
         if(Boolean(this._currArm))
         {
            this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this._currArm = null;
         }
      }
      
      public function getAllInfoForServer() : void
      {
         ArmManager.addEventListener(ArmEvent.ADD_TO_MAP,this.onAddMap);
         ArmManager.addEventListener(ArmEvent.REMOVE_TO_MAP,this.onRemoveMap);
         ArmManager.addEventListener(ArmEvent.REMOVE_ALL_TO_MAP,this.onRemoveAllMap);
         ArmManager.getAllInfoForServer(MainManager.actorInfo.mapID);
         ArmManager.getAllInfoForServer_Up(MainManager.actorInfo.mapID);
      }
      
      public function openDrag() : void
      {
         var arr:Array = this._useList.concat(this._upUseList);
         arr.forEach(function(item:ArmModel, index:int, array:Array):void
         {
            item.addEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            item.mouseChildren = false;
            item.buttonMode = true;
            item.dragEnabled = true;
         });
      }
      
      public function closeDrag() : void
      {
         var arr:Array = this._useList.concat(this._upUseList);
         arr.forEach(function(item:ArmModel, index:int, array:Array):void
         {
            item.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            item.mouseChildren = true;
            if(item.funID == 0 && item.info.form == 0)
            {
               item.buttonMode = false;
            }
            item.dragEnabled = false;
         });
      }
      
      public function addArm(info:ArmInfo) : void
      {
         var item:ArmModel = new ArmModel();
         item.mouseChildren = false;
         item.buttonMode = true;
         item.dragEnabled = true;
         if(info.buyTime == 0)
         {
            this._useList.push(item);
         }
         else
         {
            this._upUseList.push(item);
         }
         item.addEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
         item.show(info,MapManager.currentMap.depthLevel);
         DepthManager.swapDepth(item,item.y);
      }
      
      public function removeArm(info:ArmInfo) : void
      {
         var item:ArmModel = null;
         var depthLevel:DisplayObjectContainer = MapManager.currentMap.depthLevel;
         var len:int = depthLevel.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            item = depthLevel.getChildAt(i) as ArmModel;
            if(Boolean(item))
            {
               if(info.buyTime == 0)
               {
                  if(item.info == info)
                  {
                     if(this._currArm == item)
                     {
                        this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
                        this._currArm = null;
                     }
                     ArrayUtil.removeValueFromArray(this._useList,item);
                     item.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
                     item.destroy();
                     item = null;
                     return;
                  }
               }
               else if(item.info.buyTime == info.buyTime)
               {
                  if(this._currArm == item)
                  {
                     this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
                     this._currArm = null;
                  }
                  ArrayUtil.removeValueFromArray(this._upUseList,item);
                  item.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
                  item.destroy();
                  item = null;
                  return;
               }
            }
         }
      }
      
      private function onUseArm() : void
      {
         var info:ArmInfo = null;
         var fm:ArmModel = null;
         this._useList = [];
         var arr:Array = ArmManager.getUsedList();
         for each(info in arr)
         {
            fm = new ArmModel();
            fm.show(info,MapManager.currentMap.depthLevel);
            this._useList.push(fm);
         }
      }
      
      private function onUpUseArm() : void
      {
         ArmManager.addEventListener(ArmEvent.UP_USED_LIST,this.onUpUseEvent);
         ArmManager.getUsedInfoForServer_Up(MainManager.actorInfo.mapID);
      }
      
      private function onUpUseEvent(e:ArmEvent) : void
      {
         var info:ArmInfo = null;
         var fm:ArmModel = null;
         ArmManager.removeEventListener(ArmEvent.UP_USED_LIST,this.onUpUseEvent);
         this._upUseList = [];
         var arr:Array = ArmManager.getUsedList_Up();
         for each(info in arr)
         {
            if(info.type == SolidType.HEAD)
            {
               info.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
            }
            fm = new ArmModel();
            this._upUseList.push(fm);
            fm.show(info,MapManager.currentMap.depthLevel);
         }
      }
      
      private function onAddMap(e:ArmEvent) : void
      {
         this.addArm(e.info);
      }
      
      private function onRemoveMap(e:ArmEvent) : void
      {
         this.removeArm(e.info);
      }
      
      private function onRemoveAllMap(e:ArmEvent) : void
      {
         var tempam:ArmModel = null;
         if(Boolean(this._currArm))
         {
            this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this._currArm = null;
         }
         this._useList = this._useList.concat(this._upUseList);
         this._useList.forEach(function(item:ArmModel, index:int, array:Array):void
         {
            if(item.info.type != SolidType.HEAD)
            {
               item.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
               item.destroy();
               item = null;
            }
            else
            {
               tempam = item;
            }
         });
         this._useList = [];
         this._upUseList = [tempam];
      }
      
      private function onFMDown(e:MouseEvent) : void
      {
         var p:Point = null;
         var item:ArmModel = e.currentTarget as ArmModel;
         var obj:Sprite = item.content as Sprite;
         if(Boolean(obj))
         {
            if(item.info.type != SolidType.HEAD)
            {
               p = new Point(e.stageX - item.x,e.stageY - item.y);
               ArmManager.doDrag(obj,item.info,item,DragTargetType.MAP,p);
            }
         }
         this._currArm = item;
         this._currArm.setSelect(true);
         this._currArm.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
      
      private function onFocusOut(e:FocusEvent) : void
      {
         var item:ArmModel = e.currentTarget as ArmModel;
         item.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         item.setSelect(false);
      }
      
      private function onSetUpInfo(e:SocketEvent) : void
      {
         var hasItem:Boolean = false;
         var item:ArmModel = null;
         var t:int = 0;
         var data:ByteArray = e.data as ByteArray;
         var teamID:uint = data.readUnsignedInt();
         if(teamID == MainManager.actorInfo.teamInfo.id)
         {
            if(MainManager.actorInfo.teamInfo.priv == 0)
            {
               return;
            }
         }
         var len:uint = data.readUnsignedInt();
         var tempArr:Array = this._upUseList.slice();
         var arrLen:int = int(tempArr.length);
         var info:ArmInfo = new ArmInfo();
         for(var i:int = 0; i < len; i++)
         {
            hasItem = false;
            ArmInfo.setFor2964(info,data);
            for(t = 0; t < arrLen; t++)
            {
               item = tempArr[t];
               if(info.buyTime == item.info.buyTime)
               {
                  hasItem = true;
                  if(info.id != 1)
                  {
                     item.setBufForInfo(info);
                  }
                  tempArr.splice(t,1);
                  arrLen = int(tempArr.length);
                  break;
               }
            }
            if(!hasItem)
            {
               this.addArm(info);
            }
         }
         if(tempArr.length > 0)
         {
            for each(item in tempArr)
            {
               if(item.info.buyTime == 0)
               {
                  ArrayUtil.removeValueFromArray(this._useList,item);
               }
               else
               {
                  ArrayUtil.removeValueFromArray(this._upUseList,item);
               }
               if(this._currArm == item)
               {
                  this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
                  this._currArm = null;
               }
               item.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
               item.destroy();
               item = null;
            }
            tempArr = null;
         }
      }
      
      private function onUpUpdate(e:SocketEvent) : void
      {
         var item:ArmModel = null;
         var data:ByteArray = e.data as ByteArray;
         var buyTime:uint = data.readUnsignedInt();
         var id:uint = data.readUnsignedInt();
         var form:uint = data.readUnsignedInt();
         for each(item in this._upUseList)
         {
            if(item.info.buyTime == buyTime)
            {
               item.setFormUpDate(form);
               item.info.workCount = 0;
               item.info.donateCount = 0;
               item.info.res.clear();
               item.info.resNum = 0;
               break;
            }
         }
      }
      
      private function onUpWork(e:SocketEvent) : void
      {
         var item:ArmModel = null;
         var info:WorkInfo = e.data as WorkInfo;
         if(info.resID == 400050)
         {
            for each(item in this._upUseList)
            {
               if(item.info.buyTime == info.buyTime)
               {
                  item.setWork(info.workCount,info.totalRes);
                  break;
               }
            }
         }
      }
      
      private function onUpDonate(e:SocketEvent) : void
      {
         var item:ArmModel = null;
         var info:DonateInfo = e.data as DonateInfo;
         for each(item in this._upUseList)
         {
            if(item.info.buyTime == info.buyTime)
            {
               item.info.donateCount = info.donateCount;
               item.info.resNum = info.totalRes;
               break;
            }
         }
      }
   }
}

