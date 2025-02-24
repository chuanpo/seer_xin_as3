package com.robot.app.task.publicizeenvoy
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.ui.alert.PetInBagAlert;
   import com.robot.core.ui.alert.PetInStorageAlert;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PublicizeEnvoyDialog extends Sprite
   {
      private static var _instance:PublicizeEnvoyDialog;
      
      private const PATH:String = "module/publicizeenvoy/PublicizeEnvoyDialog.swf";
      
      private var dialogMC:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var acceptBtn:SimpleButton;
      
      public function PublicizeEnvoyDialog()
      {
         super();
      }
      
      public static function getInstance() : PublicizeEnvoyDialog
      {
         if(!_instance)
         {
            _instance = new PublicizeEnvoyDialog();
         }
         return _instance;
      }
      
      public function show() : void
      {
         if(MainManager.actorInfo.dsFlag == 1)
         {
            SocketConnection.addCmdListener(CommandID.PRICE_OF_DS,this.onAcceptRewordHandler);
            SocketConnection.send(CommandID.PRICE_OF_DS);
         }
         else if(Boolean(this.dialogMC))
         {
            this.init();
         }
         else
         {
            this.loadUI();
         }
      }
      
      private function onAcceptRewordHandler(e:SocketEvent) : void
      {
         var by:ByteArray;
         var bonusID:uint;
         var monID:uint;
         var capTm:uint;
         var awardCount:uint;
         var i:int;
         var isBagFull:Boolean = false;
         var id:uint = 0;
         var count:uint = 0;
         var name:String = null;
         var alertStr:String = null;
         SocketConnection.removeCmdListener(CommandID.PRICE_OF_DS,this.onAcceptRewordHandler);
         this.close(null);
         by = e.data as ByteArray;
         bonusID = by.readUnsignedInt();
         monID = by.readUnsignedInt();
         capTm = by.readUnsignedInt();
         awardCount = by.readUnsignedInt();
         if(capTm > 0)
         {
            if(PetManager.length < 6)
            {
               SocketConnection.send(CommandID.PET_RELEASE,capTm,1);
               SocketConnection.send(CommandID.GET_PET_INFO,capTm);
               isBagFull = false;
            }
            else
            {
               isBagFull = true;
            }
            if(!isBagFull)
            {
               SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(event:SocketEvent):void
               {
                  var data:PetInfo = event.data as PetInfo;
                  PetManager.add(data);
               });
               SocketConnection.send(CommandID.GET_PET_INFO,capTm);
               PetInBagAlert.show(monID,"恭喜你获得了<font color=\'#00CC00\'>" + PetXMLInfo.getName(monID) + "</font>，你可以点击右下方的精灵按钮来查看");
            }
            else
            {
               PetManager.addStorage(monID,capTm);
               PetInStorageAlert.show(monID,"恭喜你获得了<font color=\'#00CC00\'>" + PetXMLInfo.getName(monID) + "</font>，你可以在基地仓库里找到",LevelManager.iconLevel);
            }
         }
         for(i = 0; i < awardCount; i++)
         {
            id = by.readUnsignedInt();
            count = by.readUnsignedInt();
            name = ItemXMLInfo.getName(id);
            alertStr = count + "个<font color=\'#ff0000\'>" + name + "</font>已放入了你的储存箱。";
            ItemInBagAlert.show(id,alertStr);
         }
      }
      
      private function loadUI() : void
      {
         var url:String = ClientConfig.getResPath(this.PATH);
         var mcloader:MCLoader = new MCLoader(url,LevelManager.appLevel,1,"正在打开召集令任务程序");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         mcloader.doLoad();
      }
      
      private function onLoadSuccess(event:MCLoadEvent) : void
      {
         var mcloader:MCLoader = event.currentTarget as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         var cls:Class = event.getApplicationDomain().getDefinition("PublicizeEnvoyDialog") as Class;
         this.dialogMC = new cls() as MovieClip;
         this.acceptBtn = this.dialogMC["acceptbtn"];
         this.closeBtn = this.dialogMC["closebtn"];
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.acceptTaskHandler);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         mcloader.clear();
         this.init();
      }
      
      private function init() : void
      {
         this.addChild(this.dialogMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this);
      }
      
      private function acceptTaskHandler(event:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.SET_DS_STATUS,this.backHandler);
         SocketConnection.send(CommandID.SET_DS_STATUS,1);
      }
      
      private function backHandler(e:SocketEvent) : void
      {
         MainManager.actorInfo.dsFlag = 1;
         PublicizeEnvoyIconControl.addIcon();
         this.close(null);
      }
      
      private function close(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
      }
   }
}

