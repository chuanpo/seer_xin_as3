package com.robot.app.quickWord
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.XmlLoader;
   import com.robot.core.config.XmlConfig;
   
   public class QuickWord
   {
      private var _path:String = "1";
      
      private var xml:XML;
      
      private var menuContainer:Sprite;
      
      private var qw:QuickWordList;
      
      private var timer:Timer;
      
      public function QuickWord()
      {
         super();
         var onLoad:Function = function(_xml:XML):void
         {
            xml = _xml;
            timer = new Timer(500,1);
            timer.addEventListener(TimerEvent.TIMER,addStageListener);
            xmlLoader = null;
         }
         var xmlLoader:XmlLoader =  new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      public function show(dis:DisplayObject) : void
      {
         if(Boolean(this.qw))
         {
            this.hide();
            return;
         }
         var p:Point = dis.localToGlobal(new Point());
         this.qw = new QuickWordList(this.xml);
         this.qw.x = p.x - 50;
         this.qw.y = p.y - this.qw.height - 10;
         this.qw.addEventListener(Event.CLOSE,this.closeQw);
         LevelManager.toolsLevel.addChild(this.qw);
         this.timer.stop();
         this.timer.start();
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this.qw);
         this.closeQw(null);
      }
      
      private function addStageListener(event:TimerEvent) : void
      {
         MainManager.getStage().addEventListener(MouseEvent.CLICK,this.stageClick);
      }
      
      private function stageClick(event:MouseEvent) : void
      {
         if(!this.qw.hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true))
         {
            this.qw.destroy();
         }
      }
      
      private function closeQw(event:Event) : void
      {
         MainManager.getStage().removeEventListener(MouseEvent.CLICK,this.stageClick);
         this.qw.removeEventListener(Event.CLOSE,this.closeQw);
         this.qw = null;
         this.timer.stop();
      }
   }
}

