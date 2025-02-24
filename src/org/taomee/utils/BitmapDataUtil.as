package org.taomee.utils
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BitmapDataUtil
   {
      public function BitmapDataUtil()
      {
         super();
      }
      
      public static function makeList(data:BitmapData, width:int, height:int, totalFrames:uint, gc:Boolean = false) : Array
      {
         var iw:int = 0;
         var ih:int = 0;
         var bm:BitmapData = null;
         var wLen:int = int(Math.min(data.width,2880) / width);
         var hLen:int = int(Math.min(data.height,2880) / height);
         var count:int = 0;
         var arr:Array = [];
         var rect:Rectangle = new Rectangle(0,0,width,height);
         var pos:Point = new Point();
         for(ih = 0; ih < hLen; ih++)
         {
            for(iw = 0; iw < wLen; iw++)
            {
               if(count >= totalFrames)
               {
                  return arr;
               }
               rect.x = iw * width;
               rect.y = ih * height;
               bm = new BitmapData(width,height);
               bm.copyPixels(data,rect,pos);
               arr[count] = bm;
               count++;
            }
         }
         if(gc)
         {
            data.dispose();
         }
         return arr;
      }
   }
}

