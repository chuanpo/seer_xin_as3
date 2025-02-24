package com.robot.core.aticon
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimat;
   import com.robot.core.aimat.ThrowController;
   import com.robot.core.aimat.ThrowPropsController;
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.ISprite;
   import com.robot.core.utils.Direction;
   import flash.geom.Point;
   import org.taomee.utils.GeomUtil;
   import org.taomee.utils.Utils;
   
   public class AimatAction
   {
      private static const PATH:String = "com.robot.app.aimat.Aimat_";
      
      public function AimatAction()
      {
         super();
      }
      
      public static function execute(itemID:uint, id:uint, userID:uint, obj:ISprite, endPos:Point) : void
      {
         var cls:Class = null;
         var startPos:Point = null;
         var aimat:IAimat = null;
         var info:AimatInfo = null;
         if(itemID != 0)
         {
            if(itemID == 600001)
            {
               new ThrowController(itemID,userID,obj,endPos);
            }
            else
            {
               new ThrowPropsController(itemID,userID,obj,endPos);
            }
            return;
         }
         var type:uint = AimatXMLInfo.getTypeId(id);
         if(type == 0)
         {
            cls = Utils.getClass(PATH + id.toString());
         }
         else
         {
            cls = Utils.getClass(PATH + type);
         }
         if(Boolean(cls))
         {
            startPos = obj.pos.clone();
            startPos.y -= 40;
            obj.direction = Direction.angleToStr(GeomUtil.pointAngle(startPos,endPos));
            aimat = new cls();
            info = new AimatInfo(id,userID,startPos,endPos);
            AimatController.dispatchEvent(AimatEvent.PLAY_START,info);
            aimat.execute(info);
         }
      }
      
      public static function execute2(id:uint, userID:uint, startPos:Point, endPos:Point) : void
      {
         var aimat:IAimat = null;
         var info:AimatInfo = null;
         var cls:Class = Utils.getClass(PATH + id.toString());
         if(Boolean(cls))
         {
            aimat = new cls();
            info = new AimatInfo(id,userID,startPos,endPos);
            AimatController.dispatchEvent(AimatEvent.PLAY_START,info);
            aimat.execute(info);
         }
      }
   }
}

