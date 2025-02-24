package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class AimatCmdListener extends BaseBeanController
   {
      public function AimatCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.AIMAT,this.onAimat);
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onPlayEnd);
         finish();
      }
      
      private function onAimat(event:SocketEvent) : void
      {
         var data:ByteArray = event.data as ByteArray;
         var id:uint = data.readUnsignedInt();
         var obj:Object = new Object();
         obj.itemID = data.readUnsignedInt();
         obj.type = data.readUnsignedInt();
         obj.pos = new Point(data.readUnsignedInt(),data.readUnsignedInt());
         UserManager.dispatchAction(id,PeopleActionEvent.AIMAT,obj);
      }
      
      private function onPlayEnd(e:AimatEvent) : void
      {
         var i:BasePeoleModel = null;
         var array:Array = null;
         var info:AimatInfo = e.info;
         for each(i in UserManager.getUserModelList())
         {
            if(i.hitTestPoint(info.endPos.x,info.endPos.y,true))
            {
               array = AimatXMLInfo.getCloths(info.id);
               SocketConnection.send(CommandID.TRANSFORM_USER,i.info.userID,uint(array[0]));
               break;
            }
         }
      }
   }
}

