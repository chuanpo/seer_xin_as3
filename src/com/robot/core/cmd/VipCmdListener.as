package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class VipCmdListener extends BaseBeanController
   {
      public static const BE_VIP:String = "beVip";
      
      public static const FIRST_VIP:String = "firstVip";
      
      public function VipCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.VIP_CO,this.onChange);
         finish();
      }
      
      private function onChange(e:SocketEvent) : void
      {
         var um:BasePeoleModel = null;
         var info2:NonoInfo = null;
         var data:ByteArray = e.data as ByteArray;
         var userID:uint = data.readUnsignedInt();
         var flag:uint = data.readUnsignedInt();
         var autoCharge:uint = data.readUnsignedInt();
         var vipEndTime:uint = data.readUnsignedInt();
         if(MainManager.actorID == userID)
         {
            MainManager.actorInfo.autoCharge = autoCharge;
            MainManager.actorInfo.vipEndTime = vipEndTime;
            MainManager.actorInfo.vip = flag;
            if(flag == 1)
            {
               EventManager.dispatchEvent(new Event(FIRST_VIP));
            }
            else if(flag == 2)
            {
               MainManager.actorInfo.viped = 1;
               MainManager.actorInfo.superNono = true;
               EventManager.dispatchEvent(new Event(BE_VIP));
            }
            else if(flag == 0)
            {
               if(MainManager.actorInfo.superNono)
               {
                  MainManager.actorInfo.superNono = false;
                  if(Boolean(NonoManager.info))
                  {
                     NonoManager.info.superNono = false;
                     MainManager.actorModel.hideNono();
                     MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
                  }
               }
            }
         }
         else if(flag == 2)
         {
            um = UserManager.getUserModel(userID);
            if(Boolean(um))
            {
               um.info.superNono = true;
               if(Boolean(um.nono))
               {
                  info2 = um.nono.info;
                  info2.superNono = true;
                  um.hideNono();
                  um.showNono(info2);
               }
            }
         }
      }
   }
}

