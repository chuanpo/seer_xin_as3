package com.robot.app.games.FerruleGame
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HitTest
   {
      public function HitTest()
      {
         super();
      }
      
      public static function complexHitTestObject(target1:DisplayObject, target2:DisplayObject, accuracy:Number = 1) : Rectangle
      {
         return complexIntersectionRectangle(target1,target2,accuracy);
      }
      
      public static function intersectionRectangle(target1:DisplayObject, target2:DisplayObject) : Rectangle
      {
         if(!target1.root || !target2.root || !target1.hitTestObject(target2))
         {
            return new Rectangle();
         }
         var bounds1:Rectangle = target1.getBounds(target1.root);
         var bounds2:Rectangle = target2.getBounds(target2.root);
         var intersection:Rectangle = new Rectangle();
         intersection.x = Math.max(bounds1.x,bounds2.x);
         intersection.y = Math.max(bounds1.y,bounds2.y);
         intersection.width = Math.min(bounds1.x + bounds1.width - intersection.x,bounds2.x + bounds2.width - intersection.x);
         intersection.height = Math.min(bounds1.y + bounds1.height - intersection.y,bounds2.y + bounds2.height - intersection.y);
         return intersection;
      }
      
      public static function complexIntersectionRectangle(target1:DisplayObject, target2:DisplayObject, accuracy:Number = 1) : Rectangle
      {
         if(accuracy <= 0)
         {
            throw new Error("ArgumentError: Error #5001: Invalid value for accuracy",5001);
         }
         if(!target1.hitTestObject(target2))
         {
            return new Rectangle();
         }
         var hitRectangle:Rectangle = intersectionRectangle(target1,target2);
         if(hitRectangle.width * accuracy < 1 || hitRectangle.height * accuracy < 1)
         {
            return new Rectangle();
         }
         var bitmapData:BitmapData = new BitmapData(hitRectangle.width * accuracy,hitRectangle.height * accuracy,false,0);
         bitmapData.draw(target1,HitTest.getDrawMatrix(target1,hitRectangle,accuracy),new ColorTransform(1,1,1,1,255,-255,-255,255));
         bitmapData.draw(target2,HitTest.getDrawMatrix(target2,hitRectangle,accuracy),new ColorTransform(1,1,1,1,255,255,255,255),BlendMode.DIFFERENCE);
         var intersection:Rectangle = bitmapData.getColorBoundsRect(4294967295,4278255615);
         bitmapData.dispose();
         if(accuracy != 1)
         {
            intersection.x /= accuracy;
            intersection.y /= accuracy;
            intersection.width /= accuracy;
            intersection.height /= accuracy;
         }
         intersection.x += hitRectangle.x;
         intersection.y += hitRectangle.y;
         return intersection;
      }
      
      protected static function getDrawMatrix(target:DisplayObject, hitRectangle:Rectangle, accuracy:Number) : Matrix
      {
         var localToGlobal:Point = null;
         var matrix:Matrix = null;
         var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;
         localToGlobal = target.localToGlobal(new Point());
         matrix = target.transform.concatenatedMatrix;
         matrix.tx = localToGlobal.x - hitRectangle.x;
         matrix.ty = localToGlobal.y - hitRectangle.y;
         matrix.a /= rootConcatenatedMatrix.a;
         matrix.d /= rootConcatenatedMatrix.d;
         if(accuracy != 1)
         {
            matrix.scale(accuracy,accuracy);
         }
         return matrix;
      }
   }
}

