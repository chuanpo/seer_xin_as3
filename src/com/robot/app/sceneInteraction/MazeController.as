package com.robot.app.sceneInteraction
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.temp.AresiaSpacePrize;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MazeController
   {
      private static var _instance:MazeController;
      
      private const mapList:Array = [302,303,304,305,306,307,308,309,310,311,312,313];
      
      private var _bailuen:BailuenModel;
      
      private var _allowArr:Array;
      
      private var _allowLen:int = 0;
      
      private var _time:Timer;
      
      public function MazeController()
      {
         super();
         this._allowArr = MapManager.currentMap.allowData;
         this._allowLen = this._allowArr.length;
      }
      
      public static function setup() : void
      {
         if(_instance == null)
         {
            _instance = new MazeController();
         }
      }
      
      public static function destroy() : void
      {
         if(Boolean(_instance))
         {
            _instance._destroy();
            _instance = null;
         }
      }
      
      private function _destroy() : void
      {
         if(Boolean(this._bailuen))
         {
            this._bailuen.removeEventListener(BailuenModel.FIG,this.onBailuenFig);
            this._bailuen.destroy();
            this._bailuen = null;
         }
         if(Boolean(this._time))
         {
            if(this._time.running)
            {
               this._time.stop();
            }
            this._time.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._time.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this._time = null;
         }
      }
      
      private function onBailuenInfo(e:SocketEvent) : void
      {
         var chests:MovieClip = null;
         var data:ByteArray = e.data as ByteArray;
         var flag:uint = data.readUnsignedInt();
         var mapID:uint = data.readUnsignedInt();
         var hp:uint = data.readUnsignedInt();
         if(flag == 1 || flag == 3)
         {
            if(mapID == MapManager.getMapController().newMapID)
            {
               if(hp > 0)
               {
                  if(this._bailuen == null)
                  {
                     this._bailuen = new BailuenModel();
                     this._bailuen.show(this._allowArr[int(Math.random() * this._allowLen)],Boolean(flag == 1));
                     MapManager.currentMap.depthLevel.addChild(this._bailuen);
                     this._bailuen.addEventListener(BailuenModel.FIG,this.onBailuenFig);
                  }
               }
            }
         }
         else if(flag == 2)
         {
            if(mapID == MapManager.getMapController().newMapID)
            {
               if(Boolean(this._bailuen))
               {
                  this._bailuen.destroy();
                  this._bailuen = null;
               }
            }
         }
         else if(flag == 4)
         {
            if(Boolean(this._bailuen))
            {
               this._bailuen.fight();
            }
         }
         if(Boolean(this._bailuen))
         {
            this._bailuen.hp = hp;
            if(hp == 0)
            {
               chests = TaskIconManager.getIcon("Chests") as MovieClip;
               MapManager.currentMap.controlLevel.addChild(chests);
               chests.x = 450;
               chests.y = 200;
               chests.addEventListener(MouseEvent.CLICK,this.getChests);
               SocketConnection.addCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
            }
         }
      }
      
      private function getChests(evt:MouseEvent) : void
      {
         var mc:MovieClip = evt.currentTarget as MovieClip;
         SocketConnection.send(CommandID.PRIZE_OF_ATRESIASPACE,2);
         mc.removeEventListener(MouseEvent.CLICK,this.getChests);
         DisplayUtil.removeForParent(mc);
      }
      
      private function getPirze(evt:SocketEvent) : void
      {
         var o:Object = null;
         var itemID:uint = 0;
         var itemCnt:uint = 0;
         var name:String = null;
         var str:String = null;
         SocketConnection.removeCmdListener(CommandID.PRIZE_OF_ATRESIASPACE,this.getPirze);
         var data:AresiaSpacePrize = evt.data as AresiaSpacePrize;
         var arr:Array = data.monBallList;
         for each(o in arr)
         {
            itemID = uint(o.itemID);
            itemCnt = uint(o.itemCnt);
            name = ItemXMLInfo.getName(itemID);
            str = itemCnt + "个<font color=\'#FF0000\'>" + name + "</font>已经放入了你的储存箱！";
            if(itemCnt != 0)
            {
               LevelManager.tipLevel.addChild(ItemInBagAlert.show(itemID,str));
            }
         }
      }
      
      private function onBailuenFig(e:Event) : void
      {
         if(this._time == null)
         {
            this._time = new Timer(100,6);
            this._time.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._time.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         }
         this._time.reset();
         this._time.start();
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         if(this._time.currentCount % 2 == 0)
         {
            MapManager.currentMap.root.filters = [ColorFilter.setBrightness(30)];
         }
         else
         {
            MapManager.currentMap.root.filters = [ColorFilter.setInvert(),ColorFilter.setBrightness(30)];
         }
         MapManager.currentMap.root.x = 10 - Math.random() * 5;
         MapManager.currentMap.root.y = 10 - Math.random() * 5;
      }
      
      private function onTimerComplete(e:TimerEvent) : void
      {
         var arr:Array = null;
         var index:int = 0;
         MapManager.currentMap.root.filters = [];
         MapManager.currentMap.root.x = 0;
         MapManager.currentMap.root.y = 0;
         if(Math.random() > 0.85)
         {
            LevelManager.topLevel.addChild(NpcTipDialog.show("你受伤过重，现在已经整备完毕，你可以重新开始你的历险了！",null,NpcTipDialog.CICI));
            MapManager.changeMap(MainManager.actorID);
         }
         else
         {
            arr = this.mapList.concat();
            index = int(arr.indexOf(MapManager.currentMap.id));
            if(index != -1)
            {
               arr.splice(index,1);
            }
            MapManager.changeMap(arr[int(Math.random() * arr.length)]);
         }
      }
   }
}

