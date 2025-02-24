package com.robot.app.task.YiyouProEnvironment
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class YiyouTaskTool extends Sprite
   {
      private var _mainUI:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var cleanerBtn:SimpleButton = null;
      
      private var mopBtn:SimpleButton = null;
      
      private var detergentBtn:SimpleButton = null;
      
      private var gumwaterBtn:SimpleButton = null;
      
      private var _cleaner:MovieClip = null;
      
      private var _mop:MovieClip = null;
      
      private var _detergent:MovieClip = null;
      
      private var _gumwater:MovieClip = null;
      
      private var _clearSucMC0:MovieClip;
      
      private var _clearSucMC1:MovieClip;
      
      private var _bClick:Boolean = false;
      
      private var _bUsed:Boolean = false;
      
      private var _eventArr:Array = [];
      
      private var _count:uint = 0;
      
      public function YiyouTaskTool()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._mainUI = MapLibManager.getMovieClip("ui_YiyouProEnvironment_main");
         this.closeBtn = this._mainUI["closeBtn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.cleanerBtn = this._mainUI["cleanerBtn"];
         this.cleanerBtn.addEventListener(MouseEvent.CLICK,this.onCleanerClick);
         this.mopBtn = this._mainUI["mopBtn"];
         this.mopBtn.addEventListener(MouseEvent.CLICK,this.onMopClick);
         this.detergentBtn = this._mainUI["detergentBtn"];
         this.detergentBtn.addEventListener(MouseEvent.CLICK,this.onDetergentClick);
         this.gumwaterBtn = this._mainUI["gumwaterBtn"];
         this.gumwaterBtn.addEventListener(MouseEvent.CLICK,this.onGumwaterClick);
      }
      
      public function showToolPanel() : void
      {
         if(DisplayUtil.hasParent(this._mainUI))
         {
            return;
         }
         if(Boolean(MainManager.actorModel.pet))
         {
            if(this.check(MainManager.actorModel.pet.info.petID))
            {
               LevelManager.appLevel.addChild(this._mainUI);
               this._mainUI.x = 788;
               this._mainUI.y = 198;
            }
            else
            {
               Alarm.show("只有带上你的<font color=\'#ff0000\'>伊优</font>才可以来清洁这里的废物液体和废料罐哦！");
            }
         }
         else
         {
            Alarm.show("只有带上你的<font color=\'#ff0000\'>伊优</font>才可以来清洁这里的废物液体和废料罐哦！");
         }
      }
      
      private function check(id:uint) : Boolean
      {
         var a:Array = [4,5,6,304,305,306];
         var b:Boolean = false;
         for(var i1:int = 0; i1 < a.length; i1++)
         {
            if(a[i1] == id)
            {
               return true;
            }
         }
         return b;
      }
      
      public function destory() : void
      {
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
         this.cleanerBtn.removeEventListener(MouseEvent.CLICK,this.onCleanerClick);
         this.mopBtn.removeEventListener(MouseEvent.CLICK,this.onMopClick);
         this.gumwaterBtn.removeEventListener(MouseEvent.CLICK,this.onGumwaterClick);
         this.removeEvent(this._eventArr);
      }
      
      private function removeEvent(arr:Array) : void
      {
         var i:MovieClip = null;
         for each(i in arr)
         {
            if(i != null)
            {
               DisplayUtil.removeForParent(i);
               i.removeEventListener(Event.ENTER_FRAME,this.onEntFrame);
               i = null;
            }
         }
         Mouse.show();
      }
      
      private function closeHandler(evt:MouseEvent) : void
      {
         this.hide();
      }
      
      private function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
         Mouse.show();
      }
      
      private function onCleanerClick(evt:MouseEvent) : void
      {
         this.removeEvent(this._eventArr);
         this._cleaner = MapLibManager.getMovieClip("CleanerMC");
         LevelManager.appLevel.addChild(this._cleaner);
         this._eventArr.push(this._cleaner);
         this._cleaner.addEventListener(Event.ENTER_FRAME,this.onEntFrame);
         this._cleaner.addEventListener(MouseEvent.CLICK,this.onCleanerMosClick);
      }
      
      private function onMopClick(evt:MouseEvent) : void
      {
         this.removeEvent(this._eventArr);
         this._mop = MapLibManager.getMovieClip("MopMC");
         LevelManager.appLevel.addChild(this._mop);
         this._eventArr.push(this._mop);
         this._mop.addEventListener(Event.ENTER_FRAME,this.onEntFrame);
         this._mop.addEventListener(MouseEvent.CLICK,this.onMopMosClick);
      }
      
      private function onMopMosClick(evt:MouseEvent) : void
      {
         if(this._mop != null)
         {
            this.removeEvent(this._eventArr);
            Mouse.show();
            Alarm.show("咦……这个工具好像不适合用来清理废物液体噢，快选用其它工具试试看吧。");
         }
      }
      
      private function onDetergentClick(evt:MouseEvent) : void
      {
         this.removeEvent(this._eventArr);
         this._detergent = MapLibManager.getMovieClip("DetergentMC");
         LevelManager.appLevel.addChild(this._detergent);
         this._eventArr.push(this._detergent);
         this._detergent.addEventListener(Event.ENTER_FRAME,this.onEntFrame);
         this._detergent.addEventListener(MouseEvent.CLICK,this.onDetergentMosClick);
      }
      
      private function onDetergentMosClick(evt:MouseEvent) : void
      {
         if(this._detergent != null)
         {
            this.removeEvent(this._eventArr);
            Mouse.show();
            Alarm.show("咦……这个工具好像不适合用来清理废物液体噢，快选用其它工具试试看吧。");
         }
      }
      
      private function onGumwaterClick(evt:MouseEvent) : void
      {
         this.removeEvent(this._eventArr);
         this._gumwater = MapLibManager.getMovieClip("GumwaterMC");
         LevelManager.appLevel.addChild(this._gumwater);
         this._eventArr.push(this._gumwater);
         this._gumwater.addEventListener(Event.ENTER_FRAME,this.onEntFrame);
         this._gumwater.addEventListener(MouseEvent.CLICK,this.onGumwaterMosClick);
      }
      
      private function onGumwaterMosClick(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MapManager.currentMap.controlLevel.getChildByName("boxMC") as MovieClip;
         var mc_0:MovieClip = MapManager.currentMap.controlLevel.getChildByName("garbage_0") as MovieClip;
         var mc_1:MovieClip = MapManager.currentMap.controlLevel.getChildByName("garbage_1") as MovieClip;
         if(this._gumwater != null)
         {
            if(mc != null)
            {
               if(this._gumwater.hitTestObject(mc))
               {
                  mc.gotoAndStop(2);
                  DisplayUtil.removeForParent(this._gumwater);
                  this._gumwater.removeEventListener(Event.ENTER_FRAME,this.onEntFrame);
                  this._gumwater = null;
                  TasksManager.getProStatus(404,0,function(b:Boolean):void
                  {
                     if(b)
                     {
                        TasksManager.complete(404,1,function(b:Boolean):void
                        {
                           TasksManager.complete(404,2);
                           mc.buttonMode = false;
                           hide();
                           destory();
                        });
                     }
                     else
                     {
                        TasksManager.complete(404,1);
                        Mouse.show();
                     }
                  });
               }
               else
               {
                  this.removeEvent(this._eventArr);
                  Mouse.show();
               }
            }
         }
      }
      
      private function onEntFrame(evt:Event) : void
      {
         Mouse.hide();
         (evt.currentTarget as MovieClip).x = LevelManager.appLevel.mouseX;
         (evt.currentTarget as MovieClip).y = LevelManager.appLevel.mouseY;
      }
      
      private function onCleanerMosClick(evt:MouseEvent) : void
      {
         var timer:Timer = null;
         var mc:MovieClip = MapManager.currentMap.controlLevel.getChildByName("boxMC") as MovieClip;
         var mc_0:MovieClip = MapManager.currentMap.controlLevel.getChildByName("garbage_0") as MovieClip;
         var mc_1:MovieClip = MapManager.currentMap.controlLevel.getChildByName("garbage_1") as MovieClip;
         if(this._cleaner != null)
         {
            if(mc_0 != null)
            {
               if(this._cleaner.hitTestObject(mc_0))
               {
                  mc_0.gotoAndStop(2);
                  if(this._count == 1)
                  {
                     this._count = 2;
                  }
                  else
                  {
                     this._count = 1;
                  }
               }
            }
            if(mc_1 != null)
            {
               if(this._cleaner.hitTestObject(mc_1))
               {
                  mc_1.gotoAndStop(2);
                  if(this._count == 1)
                  {
                     this._count = 2;
                  }
                  else
                  {
                     this._count = 1;
                  }
               }
            }
            if(this._count == 2)
            {
               TasksManager.getProStatus(404,1,function(b:Boolean):void
               {
                  var timer:Timer = null;
                  if(b)
                  {
                     TasksManager.complete(404,0,function(b:Boolean):void
                     {
                        TasksManager.complete(404,2);
                        hide();
                        destory();
                     });
                  }
                  else
                  {
                     TasksManager.complete(404,0);
                     timer = new Timer(500,1);
                     timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(evt:TimerEvent):void
                     {
                        removeEvent(_eventArr);
                        Mouse.show();
                     });
                     timer.start();
                     _count = 0;
                  }
               });
            }
            else
            {
               timer = new Timer(500,1);
               timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(evt:TimerEvent):void
               {
                  removeEvent(_eventArr);
                  Mouse.show();
               });
               timer.start();
            }
         }
      }
   }
}

