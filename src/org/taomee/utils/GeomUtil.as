package org.taomee.utils
{
   import flash.geom.Point;
   
   public class GeomUtil
   {
      public static const R_T_D:Number = 180 / Math.PI;
      
      public static const D_T_R:Number = Math.PI / 180;
      
      public function GeomUtil()
      {
         super();
      }
      
      public static function radiansToDegrees(radians:Number) : Number
      {
         return radians * R_T_D;
      }
      
      public static function pointAngle(p1:Point, p2:Point) : Number
      {
         return Math.atan2(p1.y - p2.y,p1.x - p2.x) * R_T_D;
      }
      
      public static function pointRadians(p1:Point, p2:Point) : Number
      {
         return Math.atan2(p1.y - p2.y,p1.x - p2.x);
      }
      
      public static function getCirclePoint(p:Point, angle:Number, length:Number) : Point
      {
         var radians:Number = angle * D_T_R;
         return p.add(new Point(Math.cos(radians) * length,Math.sin(radians) * length));
      }
      
      public static function degreesToRadians(degrees:Number) : Number
      {
         return degrees * D_T_R;
      }
      
      public static function angleSpeed(p1:Point, p2:Point) : Point
      {
         var radians:Number = Math.atan2(p1.y - p2.y,p1.x - p2.x);
         return new Point(Math.cos(radians),Math.sin(radians));
      }
      
      public static function angleToSpeed(angle:Number) : Point
      {
         var radians:Number = angle * D_T_R;
         return new Point(Math.cos(radians),Math.sin(radians));
      }
      
      public static function radiansToSpeed(radians:Number) : Point
      {
         return new Point(Math.cos(radians),Math.sin(radians));
      }
   }
}

