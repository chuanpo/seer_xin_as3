package com.robot.app.equipStrengthen
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class EquipStrengthenController
   {
      public static var _allIdA:Array;
      
      public static var _listA:Array;
      
      private static var _choicePanel:AppModel;
      
      private static var _curInfo:EquipStrengthenInfo;
      
      private static var _updataPanel:AppModel;
      
      private static const _maxLev:uint = 3;
      
      public function EquipStrengthenController()
      {
         super();
      }
      
      public static function start() : void
      {
         if(Boolean(_updataPanel))
         {
            _updataPanel.hide();
         }
         _allIdA = EquipXmlConfig.getAllEquipId();
         _listA = new Array();
         ItemManager.addEventListener(ItemEvent.CLOTH_LIST,onList);
         ItemManager.getCloth();
      }
      
      private static function onList(e:ItemEvent) : void
      {
         var info:SingleItemInfo = null;
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,onList);
         for(var i1:int = 0; i1 < _allIdA.length; i1++)
         {
            info = ItemManager.getClothInfo(_allIdA[i1]);
            if(Boolean(info))
            {
               if(info.itemLevel < _maxLev && info.itemLevel > 0)
               {
                  _listA.push(info);
               }
            }
         }
         if(_listA.length > 0)
         {
            showChloicePanel(_listA);
         }
         else
         {
            Alarm.show("你没有可以升级的装备哦！");
         }
      }
      
      private static function showChloicePanel(info:Array) : void
      {
         if(!_choicePanel)
         {
            _choicePanel = new AppModel(ClientConfig.getAppModule("EquipStrengthenChoicePanel"),"正在打开");
            _choicePanel.setup();
         }
         _choicePanel.init(info);
         _choicePanel.show();
      }
      
      public static function destory() : void
      {
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,onList);
         if(Boolean(_choicePanel))
         {
            _choicePanel.destroy();
            _choicePanel = null;
         }
         if(Boolean(_updataPanel))
         {
            _updataPanel.destroy();
            _updataPanel = null;
         }
         SocketConnection.removeCmdListener(CommandID.EQUIP_UPDATA,onUpDataHandler);
      }
      
      public static function makeInfo(info:SingleItemInfo) : void
      {
         _choicePanel.hide();
         EquipXmlConfig.getInfo(info.itemID,info.itemLevel + 1,showUpdataPanel);
      }
      
      public static function showUpdataPanel(info:EquipStrengthenInfo) : void
      {
         if(!_updataPanel)
         {
            _updataPanel = new AppModel(ClientConfig.getAppModule("EquipStrengthenPanel"),"正在打开");
            _updataPanel.setup();
         }
         _curInfo = info;
         _updataPanel.init(info);
         _updataPanel.show();
      }
      
      public static function startUpdat(sendId:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.EQUIP_UPDATA,onUpDataHandler);
         SocketConnection.send(CommandID.EQUIP_UPDATA,sendId);
      }
      
      private static function onUpDataHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.EQUIP_UPDATA,onUpDataHandler);
         var by:ByteArray = e.data as ByteArray;
         var isSuc:uint = by.readUnsignedInt();
         if(isSuc != 1)
         {
            Alarm.show("升级失败！");
            return;
         }
         Alarm.show("恭喜你!" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(_curInfo.itemId)) + "强化成功了！");
      }
   }
}

