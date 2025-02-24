package org.taomee.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.taomee.manager.TaomeeManager;
   
   public class DisplayUtil
   {
      private static const MOUSE_EVENT_LIST:Array = [MouseEvent.CLICK,MouseEvent.DOUBLE_CLICK,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_OUT,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_UP,MouseEvent.MOUSE_WHEEL,MouseEvent.ROLL_OUT,MouseEvent.ROLL_OVER];
      
      public function DisplayUtil()
      {
         super();
      }
      
      public static function FillColor(target:DisplayObject, c:uint) : void
      {
         var ctf:ColorTransform = new ColorTransform();
         ctf.color = c;
         target.transform.colorTransform = ctf;
      }
      
      public static function stopAllMovieClip(dis:DisplayObjectContainer) : void
      {
         var child:DisplayObjectContainer = null;
         var mc:MovieClip = dis as MovieClip;
         if(mc != null)
         {
            mc.stop();
            mc = null;
         }
         var num:int = dis.numChildren - 1;
         if(num < 0)
         {
            return;
         }
         for(var i:int = num; i >= 0; i--)
         {
            child = dis.getChildAt(i) as DisplayObjectContainer;
            if(child != null)
            {
               stopAllMovieClip(child);
            }
         }
      }
      
      public static function hasParent(target:DisplayObject) : Boolean
      {
         if(target.parent == null)
         {
            return false;
         }
         return target.parent.contains(target);
      }
      
      public static function localToLocal(from:DisplayObject, _to:DisplayObject, p:Point = null) : Point
      {
         if(p == null)
         {
            p = new Point(0,0);
         }
         p = from.localToGlobal(p);
         return _to.globalToLocal(p);
      }
      
      public static function copyDisplayAsBmp(dis:DisplayObject) : Bitmap
      {
         var bmpdata:BitmapData = new BitmapData(dis.width,dis.height,true,0);
         var rect:Rectangle = dis.getRect(dis);
         var matrix:Matrix = new Matrix();
         matrix.translate(-rect.x,-rect.y);
         bmpdata.draw(dis,matrix);
         var bmp:Bitmap = new Bitmap(bmpdata,PixelSnapping.AUTO,true);
         bmp.x = rect.x;
         bmp.y = rect.y;
         return bmp;
      }
      
      public static function align(target:DisplayObject, bounds:Rectangle = null, align:int = 0, offset:Point = null) : void
      {
         if(bounds == null)
         {
            bounds = new Rectangle(0,0,TaomeeManager.stageWidth,TaomeeManager.stageHeight);
         }
         if(Boolean(offset))
         {
            bounds.offsetPoint(offset);
         }
         var targetRect:Rectangle = target.getRect(target);
         var _hd:Number = bounds.width - target.width;
         var _vd:Number = bounds.height - target.height;
         switch(align)
         {
            case AlignType.TOP_LEFT:
               target.x = bounds.x;
               target.y = bounds.y;
               break;
            case AlignType.TOP_CENTER:
               target.x = bounds.x + _hd / 2 - targetRect.x;
               target.y = bounds.y;
               break;
            case AlignType.TOP_RIGHT:
               target.x = bounds.x + _hd - targetRect.x;
               target.y = bounds.y;
               break;
            case AlignType.MIDDLE_LEFT:
               target.x = bounds.x;
               target.y = bounds.y + _vd / 2 - targetRect.x;
               break;
            case AlignType.MIDDLE_CENTER:
               target.x = bounds.x + _hd / 2 - targetRect.x;
               target.y = bounds.y + _vd / 2 - targetRect.y;
               break;
            case AlignType.MIDDLE_RIGHT:
               target.x = bounds.x + _hd - targetRect.x;
               target.y = bounds.y + _vd / 2 - targetRect.y;
               break;
            case AlignType.BOTTOM_LEFT:
               target.x = bounds.x;
               target.y = bounds.y + _vd - targetRect.y;
               break;
            case AlignType.BOTTOM_CENTER:
               target.x = bounds.x + _hd / 2 - targetRect.x;
               target.y = bounds.y + _vd - targetRect.y;
               break;
            case AlignType.BOTTOM_RIGHT:
               target.x = bounds.x + _hd - targetRect.x;
               target.y = bounds.y + _vd - targetRect.y;
         }
      }
      
      public static function getColor(target:DisplayObject, x:uint = 0, y:uint = 0, getAlpha:Boolean = false) : uint
      {
         var bmp:BitmapData = new BitmapData(target.width,target.height);
         bmp.draw(target);
         var color:uint = !getAlpha ? bmp.getPixel(int(x),int(y)) : bmp.getPixel32(int(x),int(y));
         bmp.dispose();
         return color;
      }
      
      public static function removeForParent(dis:DisplayObject, gc:Boolean = true) : void
      {
         var disc:DisplayObjectContainer = null;
         if(dis == null)
         {
            return;
         }
         if(dis.parent == null)
         {
            return;
         }
         if(!dis.parent.contains(dis))
         {
            return;
         }
         if(gc)
         {
            disc = dis as DisplayObjectContainer;
            if(Boolean(disc))
            {
               stopAllMovieClip(disc);
               disc = null;
            }
         }
         dis.parent.removeChild(dis);
      }
      
      public static function mouseEnabledAll(target:InteractiveObject) : void
      {
         var container:DisplayObjectContainer;
         var i:int = 0;
         var child:InteractiveObject = null;
         var b:Boolean = Boolean(MOUSE_EVENT_LIST.some(function(item:String, index:int, array:Array):Boolean
         {
            if(target.hasEventListener(item))
            {
               return true;
            }
            return false;
         }));
         if(!b)
         {
            target.mouseEnabled = false;
         }
         container = target as DisplayObjectContainer;
         if(Boolean(container))
         {
            for(i = container.numChildren - 1; i >= 0; )
            {
               child = container.getChildAt(i) as InteractiveObject;
               if(Boolean(child))
               {
                  mouseEnabledAll(child);
               }
               i--;
            }
         }
      }
      
      public static function uniformScale(target:DisplayObject, num:Number) : void
      {
         if(target.width >= target.height)
         {
            target.width = num;
            target.scaleY = target.scaleX;
         }
         else
         {
            target.height = num;
            target.scaleX = target.scaleY;
         }
      }
      
      public static function removeAllChild(dis:DisplayObjectContainer) : void
      {
         var child:DisplayObjectContainer = null;
         while(dis.numChildren > 0)
         {
            child = dis.removeChildAt(0) as DisplayObjectContainer;
            if(child != null)
            {
               stopAllMovieClip(child);
               child = null;
            }
         }
      }
   }
}

