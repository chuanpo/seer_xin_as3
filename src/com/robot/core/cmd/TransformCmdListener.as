package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.transform.TransformInfo;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.TransformSkeleton;
   import org.taomee.events.SocketEvent;
   
   public class TransformCmdListener extends BaseBeanController
   {
      public function TransformCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PEOPLE_TRANSFROM,this.onTransform);
         finish();
      }
      
      private function onTransform(event:SocketEvent) : void
      {
         var skeleton:TransformSkeleton = null;
         var info:TransformInfo = event.data as TransformInfo;
         var people:BasePeoleModel = UserManager.getUserModel(info.userID);
         if(Boolean(people))
         {
            people.stop();
            people.info.changeShape = info.suitID;
            if(info.suitID == 0)
            {
               skeleton = people.skeleton as TransformSkeleton;
               if(Boolean(skeleton))
               {
                  skeleton.untransform();
               }
            }
            else
            {
               people.skeleton = new TransformSkeleton();
            }
         }
      }
   }
}

