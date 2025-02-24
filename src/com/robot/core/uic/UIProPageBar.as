package com.robot.core.uic
{
   import flash.display.InteractiveObject;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import org.taomee.events.DynamicEvent;
   
   [Event(name="click",type="flash.events.MouseEvent")]
   public class UIProPageBar extends EventDispatcher
   {
      private static const PAGE_NO:int = 0;
      
      private static const PAGE_PRE:int = 1;
      
      private static const PAGE_NEXT:int = 2;
      
      private static const PAGE_ALL:int = 3;
      
      private var _preBtn:InteractiveObject;
      
      private var _nextBtn:InteractiveObject;
      
      private var _index:int = 0;
      
      private var _totalLength:int = 0;
      
      private var _showMax:int = 0;
      
      public function UIProPageBar(preBtn:InteractiveObject, nextBtn:InteractiveObject, max:int = 0)
      {
         super();
         this._showMax = max;
         this._preBtn = preBtn;
         this._nextBtn = nextBtn;
         this._preBtn.addEventListener(MouseEvent.CLICK,this.onPre);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.onNext);
         this.setBtnStutas(PAGE_NO);
      }
      
      public function set showMax(v:int) : void
      {
         this._showMax = v;
         this.init();
      }
      
      public function get showMax() : int
      {
         return this._showMax;
      }
      
      public function set totalLength(v:int) : void
      {
         this._totalLength = v;
         this.init();
      }
      
      public function get totalLength() : int
      {
         return this._totalLength;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(v:int) : void
      {
         this._index = v;
         if(this._index < 0)
         {
            this._index = 0;
         }
         else if(this._index > this._totalLength - this._showMax)
         {
            this._index = this._totalLength - this._showMax;
         }
         if(this._index > 0 && this._index < this._totalLength - this._showMax)
         {
            this.setBtnStutas(PAGE_ALL);
         }
         else if(this._index > 0)
         {
            this.setBtnStutas(PAGE_PRE);
         }
         else if(this._index < this._totalLength - this._showMax)
         {
            this.setBtnStutas(PAGE_NEXT);
         }
         dispatchEvent(new DynamicEvent(MouseEvent.CLICK,this._index));
      }
      
      public function destroy() : void
      {
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.onPre);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.onNext);
         this._preBtn = null;
         this._nextBtn = null;
      }
      
      public function preIndex(v:int) : void
      {
         this._index -= v;
         dispatchEvent(new DynamicEvent(MouseEvent.CLICK,this._index));
         if(this._index > 0)
         {
            if(this._index < this._totalLength - this._showMax)
            {
               this.setBtnStutas(PAGE_ALL);
            }
            else
            {
               this.setBtnStutas(PAGE_NEXT);
            }
         }
         else
         {
            this.setBtnStutas(PAGE_NEXT);
         }
      }
      
      public function nextIndex(v:int) : void
      {
         this._index += v;
         dispatchEvent(new DynamicEvent(MouseEvent.CLICK,this._index));
         if(this._index < this._totalLength - this._showMax)
         {
            if(this._index > 0)
            {
               this.setBtnStutas(PAGE_ALL);
            }
            else
            {
               this.setBtnStutas(PAGE_PRE);
            }
         }
         else
         {
            this.setBtnStutas(PAGE_PRE);
         }
      }
      
      private function init() : void
      {
         if(this._totalLength > this._showMax)
         {
            if(this._index > this._totalLength - this._showMax)
            {
               this._index = this._totalLength - this._showMax;
               this.setBtnStutas(PAGE_PRE);
            }
            else if(this._index > 0)
            {
               this.setBtnStutas(PAGE_ALL);
            }
            else
            {
               this.setBtnStutas(PAGE_NEXT);
            }
         }
         else
         {
            this._index = 0;
            this.setBtnStutas(PAGE_NO);
         }
      }
      
      private function setBtnStutas(s:int) : void
      {
         switch(s)
         {
            case PAGE_NO:
               this._preBtn.mouseEnabled = false;
               this._nextBtn.mouseEnabled = false;
               this._preBtn.alpha = 0.4;
               this._nextBtn.alpha = 0.4;
               break;
            case PAGE_PRE:
               this._preBtn.mouseEnabled = true;
               this._nextBtn.mouseEnabled = false;
               this._preBtn.alpha = 1;
               this._nextBtn.alpha = 0.4;
               break;
            case PAGE_NEXT:
               this._preBtn.mouseEnabled = false;
               this._nextBtn.mouseEnabled = true;
               this._preBtn.alpha = 0.4;
               this._nextBtn.alpha = 1;
               break;
            case PAGE_ALL:
               this._preBtn.mouseEnabled = true;
               this._nextBtn.mouseEnabled = true;
               this._preBtn.alpha = 1;
               this._nextBtn.alpha = 1;
         }
      }
      
      private function onPre(e:MouseEvent) : void
      {
         this.preIndex(1);
      }
      
      private function onNext(e:MouseEvent) : void
      {
         this.nextIndex(1);
      }
   }
}

