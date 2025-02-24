package org.taomee.component.control
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import org.taomee.component.UIComponent;
   import org.taomee.component.event.LoadPaneEvent;
   import org.taomee.utils.DisplayUtil;
   
   [Event(name="onLoadContent",type="org.taomee.component.event.LoadPaneEvent")]
   public class MLoadPane extends UIComponent
   {
      public static const FIT_NONE:int = 0;
      
      public static const FIT_WIDTH:int = 1;
      
      public static const FIT_HEIGHT:int = 2;
      
      public static const FIT_ALL:int = 3;
      
      public static const CENTER:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const RIGHT:int = 2;
      
      public static const MIDDLE:int = 0;
      
      public static const TOP:int = 1;
      
      public static const BOTTOM:int = 2;
      
      private var icon:*;
      
      private var oldH:Number;
      
      private var oldW:Number;
      
      private var loader:Loader;
      
      private var image:DisplayObject;
      
      private var _valign:int;
      
      private var _fitType:int;
      
      private var _halign:int;
      
      private var _offsetRect:Boolean = true;
      
      public function MLoadPane(icon:* = null, fitType:int = 0, halign:int = 0, valign:int = 0)
      {
         super();
         this._fitType = fitType;
         this._halign = halign;
         this._valign = valign;
         this.icon = icon;
         childMouseEnabled = false;
         getImageInstance(icon);
      }
      
      public function get content() : DisplayObject
      {
         return this.image;
      }
      
      override protected function revalidate() : void
      {
         super.revalidate();
         if(!image)
         {
            return;
         }
         adjustImageSize();
      }
      
      private function onLoadTitleIcon(event:Event) : void
      {
         image = LoaderInfo(event.target).content;
         containSprite.addChild(image);
         oldW = image.width;
         oldH = image.height;
         updateView();
         dispatchEvent(new LoadPaneEvent(LoadPaneEvent.ON_LOAD_CONTENT,image));
      }
      
      public function get valign() : uint
      {
         return this._valign;
      }
      
      public function set halign(i:uint) : void
      {
         if(i != halign)
         {
            this._halign = i;
            updateView();
         }
      }
      
      public function setContentScale(scaleX:Number = 1, scaleY:Number = 1) : void
      {
         image.scaleX = scaleX;
         image.scaleY = scaleY;
         if(image.scaleX != scaleX || image.scaleY != scaleY)
         {
            updateView();
         }
      }
      
      private function loadImage(im:String) : void
      {
         try
         {
            loader.close();
         }
         catch(e:Error)
         {
         }
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadTitleIcon);
         loader.load(new URLRequest(im));
      }
      
      public function set fitType(i:uint) : void
      {
         if(i != fitType)
         {
            this._fitType = i;
            updateView();
         }
      }
      
      public function get halign() : uint
      {
         return this._halign;
      }
      
      public function set valign(i:uint) : void
      {
         if(i != valign)
         {
            this._valign = i;
            updateView();
         }
      }
      
      private function getImageInstance(im:*) : void
      {
         DisplayUtil.removeAllChild(containSprite);
         if(im == null)
         {
            return;
         }
         if(im is String)
         {
            loadImage(im);
         }
         else if(im is DisplayObject)
         {
            image = im;
            oldW = image.width;
            oldH = image.height;
            containSprite.addChild(image);
            updateView();
            dispatchEvent(new LoadPaneEvent(LoadPaneEvent.ON_LOAD_CONTENT,image));
         }
      }
      
      public function get fitType() : uint
      {
         return this._fitType;
      }
      
      private function adjustImageSize() : void
      {
         var px:Number = NaN;
         var py:Number = NaN;
         var rect:Rectangle = null;
         switch(fitType)
         {
            case MLoadPane.FIT_HEIGHT:
               px = py = this.height / oldH;
               image.width = oldW * (this.height / oldH);
               image.height = this.height;
               break;
            case MLoadPane.FIT_WIDTH:
               px = py = this.width / oldW;
               image.height = oldH * (this.width / oldW);
               image.width = this.width;
               break;
            case MLoadPane.FIT_ALL:
               px = this.width / oldW;
               py = this.width / oldH;
               image.height = this.height;
               image.width = this.width;
               break;
            case MLoadPane.FIT_NONE:
            default:
               px = py = 1;
               image.height = oldH;
               image.width = oldW;
         }
         if(_offsetRect)
         {
            rect = image.getRect(image);
         }
         else
         {
            rect = new Rectangle();
         }
         switch(halign)
         {
            case MLoadPane.LEFT:
               image.x = 0 - rect.x * px;
               break;
            case MLoadPane.RIGHT:
               image.x = this.width - image.width - rect.x * px;
               break;
            case MLoadPane.CENTER:
            default:
               image.x = (this.width - image.width) / 2 - rect.x * px;
         }
         switch(valign)
         {
            case MLoadPane.TOP:
               image.y = 0 - rect.y * py;
               break;
            case MLoadPane.BOTTOM:
               image.y = this.height - image.height - rect.y * py;
               break;
            case MLoadPane.MIDDLE:
            default:
               image.y = (this.height - image.height) / 2 - rect.y * py;
         }
      }
      
      public function set childMouseEnabled(b:Boolean) : void
      {
         containSprite.mouseChildren = b;
      }
      
      public function set offsetRect(b:Boolean) : void
      {
         _offsetRect = b;
      }
      
      public function reLoad() : void
      {
         DisplayUtil.removeForParent(image);
         getImageInstance(icon + "?" + Math.random());
      }
      
      override public function destroy() : void
      {
         image = null;
         super.destroy();
      }
      
      public function setIcon(image:*) : void
      {
         getImageInstance(image);
      }
      
      public function unload() : void
      {
         DisplayUtil.removeForParent(image);
      }
   }
}

