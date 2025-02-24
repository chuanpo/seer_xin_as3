package org.taomee.component
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import org.taomee.component.manager.MComponentManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MSprite extends Sprite
   {
      private var _height:Number = 0;
      
      private var _width:Number = 0;
      
      protected var containSprite:Sprite;
      
      private var isRecordH:Boolean = false;
      
      private var _isMask:Boolean = true;
      
      private var OH:Number;
      
      protected var bgMC:Sprite;
      
      private var isRecordW:Boolean = false;
      
      private var fillColor:uint = 16777215;
      
      private var _stop:Boolean = false;
      
      private var OW:Number;
      
      protected var bgMaskMC:Shape;
      
      private var maskRect:Rectangle;
      
      public function MSprite()
      {
         super();
         bgMaskMC = new Shape();
         bgMC = new Sprite();
         addChild(bgMC);
         if(MComponentManager.bgAlpha > 0)
         {
            addChild(bgMaskMC);
         }
         bgMC.tabEnabled = false;
         bgMC.mouseEnabled = false;
         bgMC.mouseChildren = false;
         bgMC.cacheAsBitmap = true;
         containSprite = new Sprite();
         containSprite.mouseEnabled = false;
         containSprite.cacheAsBitmap = true;
         this.addChild(containSprite);
         this.cacheAsBitmap = true;
         maskRect = new Rectangle();
         containSprite.scrollRect = maskRect;
         bgMC.scrollRect = scrollRect;
      }
      
      protected function revalidate() : void
      {
      }
      
      override public function getChildByName(name:String) : DisplayObject
      {
         return containSprite.getChildByName(name);
      }
      
      override public function getChildAt(index:int) : DisplayObject
      {
         return containSprite.getChildAt(index);
      }
      
      override public function set width(value:Number) : void
      {
         _width = value;
         initMask();
         if(!isRecordW)
         {
            isRecordW = true;
            OW = value;
         }
      }
      
      public function reSize() : void
      {
         if(isRecordW)
         {
            width = OW;
         }
         if(isRecordH)
         {
            height = OH;
         }
      }
      
      override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         return containSprite.setChildIndex(child,index);
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      private function initMask() : void
      {
         if(MComponentManager.bgAlpha > 0)
         {
            bgMaskMC.graphics.clear();
            bgMaskMC.graphics.beginFill(fillColor,MComponentManager.bgAlpha);
            bgMaskMC.graphics.drawRect(0,0,_width,_height);
            bgMaskMC.graphics.endFill();
         }
         maskRect.width = _width;
         maskRect.height = _height;
         if(_isMask)
         {
            containSprite.scrollRect = maskRect;
            bgMC.scrollRect = scrollRect;
         }
         else
         {
            containSprite.scrollRect = null;
            bgMC.scrollRect = null;
         }
         updateView();
      }
      
      override public function getChildIndex(child:DisplayObject) : int
      {
         return containSprite.getChildIndex(child);
      }
      
      override public function get numChildren() : int
      {
         return containSprite.numChildren;
      }
      
      public function updateView() : void
      {
         if(_stop)
         {
            _stop = false;
            return;
         }
         revalidate();
         if(this.parentComp is Container)
         {
            Container(this.parentComp).updateView();
         }
      }
      
      protected function stopUpdate() : void
      {
         _stop = true;
      }
      
      public function set isMask(b:Boolean) : void
      {
         this._isMask = b;
         if(b)
         {
            containSprite.scrollRect = maskRect;
            bgMC.scrollRect = scrollRect;
         }
         else
         {
            containSprite.scrollRect = null;
            bgMC.scrollRect = null;
         }
      }
      
      public function get parentComp() : UIComponent
      {
         if(Boolean(this.parent))
         {
            return this.parent.parent as UIComponent;
         }
         return null;
      }
      
      public function destroy() : void
      {
         var mc:DisplayObject = null;
         DisplayUtil.removeForParent(this);
         DisplayUtil.removeAllChild(bgMC);
         while(containSprite.numChildren > 0)
         {
            mc = containSprite.getChildAt(0);
            DisplayUtil.removeForParent(mc);
            if(mc is MSprite)
            {
               (mc as MSprite).destroy();
            }
         }
         bgMC = null;
         containSprite = null;
         trace("MSprite destroy");
      }
      
      override public function set height(value:Number) : void
      {
         _height = value;
         initMask();
         if(!isRecordH)
         {
            isRecordH = true;
            OH = value;
         }
      }
      
      override public function get height() : Number
      {
         return _height;
      }
   }
}

