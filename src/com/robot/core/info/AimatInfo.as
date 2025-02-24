package com.robot.core.info
{
   import com.robot.core.config.xml.AimatXMLInfo;
   import flash.geom.Point;
   
   public class AimatInfo
   {
      public var id:uint;
      
      public var userID:uint;
      
      public var startPos:Point;
      
      public var endPos:Point;
      
      public var speed:Number = 36;
      
      public function AimatInfo(_id:uint, _userID:uint, _startPos:Point = null, _endPos:Point = null)
      {
         super();
         this.id = _id;
         this.userID = _userID;
         this.startPos = _startPos;
         this.endPos = _endPos;
         this.speed = AimatXMLInfo.getSpeed(this.id);
      }
      
      public function clone() : AimatInfo
      {
         return new AimatInfo(this.id,this.userID,this.startPos,this.endPos);
      }
   }
}

