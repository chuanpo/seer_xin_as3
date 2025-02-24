package com.robot.core.info.fbGame
{
   import flash.geom.Point;
   import flash.utils.IDataInput;
   
   public class GameOverUserInfo
   {
      public var id:uint;
      
      public var pos:Point;
      
      public function GameOverUserInfo(data:IDataInput)
      {
         super();
         this.id = data.readUnsignedInt();
         this.pos = new Point(data.readUnsignedInt(),data.readUnsignedInt());
      }
   }
}

