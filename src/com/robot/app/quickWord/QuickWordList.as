package com.robot.app.quickWord
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class QuickWordList extends Sprite
   {
      private var parentList:QuickWordList;
      
      private var subList:QuickWordList;
      
      private var perHeight:Number;
      
      private var checkTimer:Timer;
      
      private var _totalHeight:Number;
      
      public function QuickWordList(xml:XML, parentList:QuickWordList = null)
      {
         super();
         this.checkTimer = new Timer(2000,1);
         this.checkTimer.addEventListener(TimerEvent.TIMER,this.checkIsHit);
         this.parentList = parentList;
         var xmllist:XMLList = xml.elements("menu");
         if(xmllist.length() > 0)
         {
            this.listMC(xmllist);
         }
      }
      
      public function destroy() : void
      {
         if(!this.parentList)
         {
            dispatchEvent(new Event(Event.CLOSE));
         }
         if(Boolean(this.subList))
         {
            this.subList.destroy();
         }
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this.checkTimer.stop();
         this.checkTimer.removeEventListener(TimerEvent.TIMER,this.checkIsHit);
         this.checkTimer = null;
         this.parentList = null;
         this.subList = null;
      }
      
      private function listMC(xmllist:XMLList) : void
      {
         var i:XML = null;
         var mc:MovieClip = null;
         var txt:TextField = null;
         var count:int = 0;
         var maxW:Number = 0;
         var mcArray:Array = [];
         for each(i in xmllist)
         {
            mc = UIManager.getMovieClip("quickWordListMC");
            mc.gotoAndStop(1);
            this.perHeight = mc.height + 1;
            mc.mouseChildren = false;
            this._totalHeight = this.perHeight * xmllist.length();
            txt = mc["txt"];
            txt.autoSize = TextFieldAutoSize.CENTER;
            txt.text = i.@title;
            maxW = Math.max(maxW,txt.width);
            mc.xml = i;
            mc.y = this._totalHeight - this.perHeight * (count + 1);
            mc.buttonMode = true;
            if(i.children().length() == 0)
            {
               mc["dotMC"].visible = false;
               mc.addEventListener(MouseEvent.CLICK,this.clickHandler);
            }
            mc.addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            mc.addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
            mcArray.push(mc);
            count++;
         }
         this.formatMC(mcArray,maxW);
      }
      
      private function formatMC(array:Array, max:Number) : void
      {
         var i:MovieClip = null;
         var bgMC:MovieClip = null;
         var dotMC:MovieClip = null;
         max = Math.max(100,max);
         for each(i in array)
         {
            bgMC = i["bgMC"];
            dotMC = i["dotMC"];
            bgMC.width = max + dotMC.width + 12;
            i["txt"].x = (bgMC.width - i["txt"].width) / 2;
            dotMC.x = bgMC.width - dotMC.width - 6;
            this.addChild(i);
         }
      }
      
      public function resetPosition() : void
      {
         if(!this.parentList)
         {
            return;
         }
         var p:Point = this.localToGlobal(new Point());
         var c:Number = p.y + this.height - this.getFirst().totalHeight;
         if(c > 0)
         {
            this.y -= this.perHeight;
            this.resetPosition();
         }
      }
      
      public function get totalHeight() : Number
      {
         var p:Point = this.localToGlobal(new Point());
         return p.y + this._totalHeight;
      }
      
      public function getFirst() : QuickWordList
      {
         var ql:QuickWordList = this;
         while(Boolean(ql.parentList))
         {
            ql = ql.parentList;
         }
         return ql;
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         var mc:MovieClip = event.currentTarget as MovieClip;
         mc["bgMC"].gotoAndStop(2);
         mc["dotMC"].gotoAndStop(2);
         if(Boolean(this.subList))
         {
            this.subList.destroy();
         }
         this.subList = null;
         var btn:DisplayObject = event.currentTarget as DisplayObject;
         mc = event.currentTarget as MovieClip;
         var xmllist:XMLList = XML(mc.xml).elements("menu");
         if(xmllist.length() > 0)
         {
            this.subList = new QuickWordList(mc.xml,this);
            this.subList.x = this.width;
            this.subList.y = btn.y;
            this.addChild(this.subList);
            this.subList.resetPosition();
         }
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         var mc:MovieClip = event.currentTarget as MovieClip;
         mc["bgMC"].gotoAndStop(1);
         mc["dotMC"].gotoAndStop(1);
         if(Boolean(this.checkTimer))
         {
            this.checkTimer.stop();
            this.checkTimer.start();
         }
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         var mc:MovieClip = event.currentTarget as MovieClip;
         this.getFirst().destroy();
         MainManager.actorModel.chatAction(mc["txt"].text);
      }
      
      private function checkIsHit(event:TimerEvent) : void
      {
         var ql:QuickWordList = this.getFirst();
         if(!ql.hitTestPoint(MainManager.getStage().mouseX,MainManager.getStage().mouseY,true))
         {
            ql.destroy();
         }
      }
   }
}

