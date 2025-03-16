package com.robot.app.nono.featureApp
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.PetEvent;
   import com.robot.core.manager.ModuleManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.PetInBagAlert;
   import com.robot.core.ui.alert.PetInStorageAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;

   public class App_700002
   {
      private var _panel:AppModel;

      public function App_700002(id:uint)
      {
         super();
         this.check();
      }

      private function check():void
      {
         if (SocketConnection.hasCmdListener(CommandID.PET_HATCH_GET))
         {
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_HATCH_GET, function(e:SocketEvent):void
            {
               var data:ByteArray;
               var falg:Boolean;
               var leftTime:uint;
               var captmTime:uint;
               var petID:uint = 0;
               SocketConnection.removeCmdListener(CommandID.PET_HATCH_GET, arguments.callee);
               data = e.data as ByteArray;
               falg = Boolean(data.readUnsignedInt());
               leftTime = data.readUnsignedInt();
               petID = data.readUnsignedInt();
               captmTime = data.readUnsignedInt();
               if (falg)
               {
                  if (leftTime == 0)
                  {
                     if (PetManager.length < 6)
                     {
                        PetManager.addEventListener(PetEvent.ADDED, function(e:PetEvent):void
                           {
                              PetInBagAlert.show(petID, TextFormatUtil.getRedTxt(PetXMLInfo.getName(petID)) + "已经放入你的背包中。");
                           });
                        PetManager.setIn(captmTime, 1);
                     }
                     else
                     {
                        PetManager.addStorage(petID, captmTime);
                        PetInStorageAlert.show(petID, TextFormatUtil.getRedTxt(PetXMLInfo.getName(petID)) + "已经放入你的仓库中。");
                     }
                  }
                  else
                  {
                     var currentTime:uint = getTimer() / 1000; // 当前时间（秒）
                     var hatchCompleteTime:uint = currentTime + leftTime; // 孵化完成时间（秒）
                     var hatchCompleteDate:Date = new Date(hatchCompleteTime * 1000); // 转换为 Date 对象
                     var formattedTime:String = TextFormatUtil.formatDate(hatchCompleteDate, "yyyy-MM-dd HH:mm:ss"); // 格式化时间
                     Alarm.show("分子转化仪中有正在转化的精元，预计孵化完成时间: " + formattedTime);
                  }
               }
               else
               {
                  if (_panel == null)
                  {
                     _panel = ModuleManager.getModule(ClientConfig.getAppModule("MoleculePanel"), "正在打开分子转化仪面板");
                     _panel.setup();
                  }
                  _panel.show();
               }
            });
         SocketConnection.send(CommandID.PET_HATCH_GET);
      }
   }
}
