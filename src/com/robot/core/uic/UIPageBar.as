package com.robot.core.uic
{
   import flash.display.SimpleButton;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.events.DynamicEvent;
   
   [Event(name="click",type="flash.events.MouseEvent")]
   public class UIPageBar extends EventDispatcher
   {
      public static const PAGE_NO:int = 0;
      
      public static const PAGE_PRE:int = 1;
      
      public static const PAGE_NEXT:int = 2;
      
      public static const PAGE_ALL:int = 3;
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _txt:TextField;
      
      private var _index:uint;
      
      private var _pageLength:uint;
      
      private var _totalLength:uint;
      
      private var _totalPage:uint;
      
      public function UIPageBar(preBtn:SimpleButton, nextBtn:SimpleButton, txt:TextField, max:uint)
      {
         super();
         this._preBtn = preBtn;
         this._nextBtn = nextBtn;
         this._txt = txt;
         this._pageLength = max;
         this._txt.mouseEnabled = false;
         this._preBtn.addEventListener(MouseEvent.CLICK,this.onPre);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.onNext);
         this.setTxt();
         this.setBtnStutas(PAGE_NO);
      }
      
      public function set pageLength(v:uint) : void
      {
         this._pageLength = v;
         this.init();
      }
      
      public function get pageLength() : uint
      {
         return this._pageLength;
      }
      
      public function set totalLength(v:uint) : void
      {
         this._totalLength = v;
         this.init();
      }
      
      public function get totalLength() : uint
      {
         return this._totalLength;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function set index(v:uint) : void
      {
         this._index = v;
         this.init();
      }
      
      public function destroy() : void
      {
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.onPre);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.onNext);
         this._preBtn = null;
         this._nextBtn = null;
         this._txt = null;
      }
      
      private function init() : void
      {
         if(this._pageLength < this._totalLength)
         {
            this._totalPage = Math.ceil(this._totalLength / this._pageLength);
            if(this._index > this._totalPage - 1)
            {
               this._index = this._totalPage - 1;
            }
            if(this._index == this._totalPage - 1)
            {
               this.setBtnStutas(PAGE_PRE);
            }
            else if(this._index == 0)
            {
               this.setBtnStutas(PAGE_NEXT);
            }
            else
            {
               this.setBtnStutas(PAGE_ALL);
            }
         }
         else
         {
            this._totalPage = 1;
            this._index = 0;
            this.setBtnStutas(PAGE_NO);
         }
         this.setTxt();
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
      
      private function setTxt() : void
      {
         this._txt.text = (this._index + 1).toString() + "/" + this._totalPage.toString();
      }
      
      private function onPre(e:MouseEvent) : void
      {
         --this._index;
         if(this._index > 0)
         {
            if(this._index < this._totalPage - 1)
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
         this.setTxt();
         dispatchEvent(new DynamicEvent(MouseEvent.CLICK,this._index));
      }
      
      private function onNext(e:MouseEvent) : void
      {
         ++this._index;
         if(this._index < this._totalPage - 1)
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
         this.setTxt();
         dispatchEvent(new DynamicEvent(MouseEvent.CLICK,this._index));
      }
   }
}

