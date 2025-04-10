package com.robot.core.uic
{
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class TextScrollBar
   {
      private var _tf:TextField;
      
      private var _barBlock:Sprite;
      
      private var _barBack:InteractiveObject;
      
      private var _scrollRect:Rectangle;
      
      private var _upBtn:SimpleButton;
      
      private var _downBtn:SimpleButton;
      
      private var _upNum:Number = 0;
      
      private var _downNum:Number = 0;
      
      private var _maxCount:int;
      
      public function TextScrollBar(ui:DisplayObjectContainer, tf:TextField, upBtn:SimpleButton = null, downBtn:SimpleButton = null)
      {
         super();
         this._barBlock = ui["barBall"];
         this._barBack = ui["barBg"];
         this._tf = tf;
         this._upBtn = upBtn;
         this._downBtn = downBtn;
         if(Boolean(this._upBtn))
         {
            this._upNum = this._upBtn.height;
            this._upBtn.x = this._barBack.x;
            this._upBtn.y = this._barBack.y;
            this._upBtn.mouseEnabled = false;
         }
         if(Boolean(this._downBtn))
         {
            this._downNum = this._downBtn.height;
            this._downBtn.x = this._barBack.x;
            this._downBtn.y = this._barBack.y + this._barBack.height - this._downBtn.height;
            this._downBtn.mouseEnabled = false;
         }
         this._barBlock.buttonMode = true;
         this._barBlock.mouseEnabled = false;
         this.upDateScroll();
         this._barBlock.x = this._scrollRect.x;
         this._barBlock.y = this._scrollRect.y;
         this._barBlock.visible = false;
         this._maxCount = this._tf.height / 16;
      }
      
      public function checkScroll() : void
      {
         if(this._tf.maxScrollV > 1)
         {
            this._tf.scrollV = this._tf.maxScrollV;
            this.onTxtScroll(null);
            if(!this._barBlock.mouseEnabled)
            {
               this._barBlock.mouseEnabled = true;
               this._barBlock.visible = true;
               this._barBlock.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarBallDown);
               this._barBack.addEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
               this._tf.addEventListener(Event.SCROLL,this.onTxtScroll);
               if(Boolean(this._upBtn))
               {
                  this._upBtn.mouseEnabled = true;
                  this._upBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
               }
               if(Boolean(this._downBtn))
               {
                  this._downBtn.mouseEnabled = true;
                  this._downBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
               }
            }
         }
         else if(this._barBlock.mouseEnabled)
         {
            this._barBlock.mouseEnabled = false;
            this._barBlock.visible = false;
            this._barBlock.y = this._scrollRect.y;
            this._barBlock.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBallDown);
            this._barBack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
            this._tf.removeEventListener(Event.SCROLL,this.onTxtScroll);
            if(Boolean(this._upBtn))
            {
               this._upBtn.mouseEnabled = false;
               this._upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
               this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
            }
            if(Boolean(this._downBtn))
            {
               this._downBtn.mouseEnabled = false;
               this._downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
               this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
            }
         }
      }
      
      public function destroy() : void
      {
         if(this._tf.maxScrollV > 1)
         {
            this._barBlock.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBallDown);
            this._barBack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
            this._tf.removeEventListener(Event.SCROLL,this.onTxtScroll);
         }
         if(Boolean(this._upBtn))
         {
            this._upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
            this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
            this._upBtn = null;
         }
         if(Boolean(this._downBtn))
         {
            this._downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
            this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
            this._downBtn = null;
         }
         this._tf = null;
         this._barBlock = null;
         this._barBack = null;
         this._scrollRect = null;
      }
      
      private function upDateScroll() : void
      {
         this._scrollRect = new Rectangle(this._barBack.x - (this._barBlock.width - this._barBack.width) / 2,this._barBack.y + this._upNum,0,this._barBack.height - this._barBlock.height - this._upNum - this._downNum);
      }
      
      private function onBarBallDown(e:MouseEvent) : void
      {
         this._barBlock.startDrag(false,this._scrollRect);
         this._barBlock.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onBarBlockMove);
         this._barBlock.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBarBallUp);
         this._barBlock.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBallDown);
         this._tf.removeEventListener(Event.SCROLL,this.onTxtScroll);
      }
      
      private function onBarBlockMove(e:MouseEvent) : void
      {
         this._tf.scrollV = Math.round((this._barBlock.y - this._scrollRect.y) / this._scrollRect.height * this._tf.maxScrollV);
      }
      
      private function onBarBallUp(e:MouseEvent) : void
      {
         this._barBlock.stopDrag();
         this._tf.addEventListener(Event.SCROLL,this.onTxtScroll);
         this._barBlock.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarBallDown);
         this._barBlock.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onBarBlockMove);
         this._barBlock.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBarBallUp);
      }
      
      private function onTxtScroll(e:Event) : void
      {
         var sv:Number = NaN;
         if(this._tf.scrollV == 1)
         {
            sv = 0;
         }
         else
         {
            sv = this._tf.scrollV / this._tf.maxScrollV;
         }
         this._barBlock.y = this._scrollRect.y + this._scrollRect.height * sv;
      }
      
      private function onBackDown(e:MouseEvent) : void
      {
         this._barBlock.y = (this._barBack.parent.mouseY - this._scrollRect.y) / this._barBack.height * this._scrollRect.height + this._scrollRect.y;
         this.onBarBlockMove(null);
      }
      
      private function onUpDown(e:MouseEvent) : void
      {
         this._upBtn.addEventListener(Event.ENTER_FRAME,this.onUpEnter);
         this._upBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
      }
      
      private function onUpUp(e:MouseEvent) : void
      {
         this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
         this._upBtn.removeEventListener(Event.ENTER_FRAME,this.onUpEnter);
      }
      
      private function onUpEnter(e:Event) : void
      {
         if(this._barBlock.y >= this._scrollRect.y)
         {
            this._barBlock.y -= 3;
            this.onBarBlockMove(null);
         }
         else
         {
            this._barBlock.y = this._scrollRect.y;
            this._upBtn.removeEventListener(Event.ENTER_FRAME,this.onUpEnter);
         }
      }
      
      private function onDownDown(e:MouseEvent) : void
      {
         this._downBtn.addEventListener(Event.ENTER_FRAME,this.onDownEnter);
         this._downBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
      }
      
      private function onDownUp(e:MouseEvent) : void
      {
         this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
         this._downBtn.removeEventListener(Event.ENTER_FRAME,this.onDownEnter);
      }
      
      private function onDownEnter(e:Event) : void
      {
         if(this._barBlock.y <= this._scrollRect.bottom)
         {
            this._barBlock.y += 3;
            this.onBarBlockMove(null);
         }
         else
         {
            this._barBlock.y = this._scrollRect.bottom;
            this._downBtn.removeEventListener(Event.ENTER_FRAME,this.onDownEnter);
         }
      }
   }
}

