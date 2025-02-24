package com.robot.core.utils
{
   import flash.geom.Point;
   import org.taomee.utils.GeomUtil;
   
   public class Direction
   {
      public static var UP:String = "up";
      
      public static var DOWN:String = "down";
      
      public static var LEFT:String = "left";
      
      public static var LEFT_UP:String = "leftup";
      
      public static var LEFT_DOWN:String = "leftdown";
      
      public static var RIGHT:String = "right";
      
      public static var RIGHT_UP:String = "rightup";
      
      public static var RIGHT_DOWN:String = "rightdown";
      
      public static var LIST:Array = [RIGHT,RIGHT_DOWN,DOWN,LEFT_DOWN,LEFT,LEFT_UP,UP,RIGHT_UP];
      
      public function Direction()
      {
         super();
      }
      
      public static function indexToStr(index:int) : String
      {
         return LIST[index];
      }
      
      public static function strToIndex(str:String) : int
      {
         return LIST.indexOf(str);
      }
      
      public static function getIndex(p1:Point, p2:Point) : int
      {
         return angleToIndex(GeomUtil.pointAngle(p1,p2));
      }
      
      public static function getStr(p1:Point, p2:Point) : String
      {
         return indexToStr(getIndex(p1,p2));
      }
      
      public static function angleToIndex(angle:Number) : int
      {
         angle = angle + 22.5 + 180;
         if(angle > 360)
         {
            angle = 0;
         }
         return int(angle / 45);
      }
      
      public static function angleToStr(angle:Number) : String
      {
         return indexToStr(angleToIndex(angle));
      }
   }
}

