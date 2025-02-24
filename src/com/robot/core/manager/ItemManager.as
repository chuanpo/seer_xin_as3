package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.info.userItem.SoulBeadItemInfo;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   
   [Event(name="petItemList",type="com.robot.core.event.ItemEvent")]
   [Event(name="throwList",type="com.robot.core.event.ItemEvent")]
   [Event(name="collectionList",type="com.robot.core.event.ItemEvent")]
   [Event(name="clothList",type="com.robot.core.event.ItemEvent")]
   public class ItemManager
   {
      private static var _instance:EventDispatcher;
      
      private static var _clothMap:HashMap = new HashMap();
      
      private static var _collectionMap:HashMap = new HashMap();
      
      private static var _throwMap:HashMap = new HashMap();
      
      private static var _petItemMap:HashMap = new HashMap();
      
      private static var _soulBeadMap:HashMap = new HashMap();
      
      private static var _superMap:HashMap = new HashMap();
      
      public function ItemManager()
      {
         super();
      }
      
      public static function containsAll(id:uint) : Boolean
      {
         if(_clothMap.containsKey(id))
         {
            return true;
         }
         if(_collectionMap.containsKey(id))
         {
            return true;
         }
         return false;
      }
      
      public static function getInfo(id:uint) : SingleItemInfo
      {
         var item:SingleItemInfo = _clothMap.getValue(id);
         if(item == null)
         {
            item = _collectionMap.getValue(id);
         }
         return item;
      }
      
      public static function getCloth() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onClothList);
         SocketConnection.send(CommandID.ITEM_LIST,100001,101001,2);
      }
      
      public static function containsCloth(id:uint) : Boolean
      {
         return _clothMap.containsKey(id);
      }
      
      public static function getClothInfo(id:uint) : SingleItemInfo
      {
         return _clothMap.getValue(id);
      }
      
      public static function getClothIDs() : Array
      {
         return _clothMap.getKeys();
      }
      
      public static function getClothInfos() : Array
      {
         return _clothMap.getValues();
      }
      
      public static function upDateCloth(id:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,function(e:SocketEvent):void
         {
            var info:SingleItemInfo = null;
            SocketConnection.removeCmdListener(CommandID.ITEM_LIST,arguments.callee);
            var data:ByteArray = e.data as ByteArray;
            var len:uint = data.readUnsignedInt();
            for(var i:int = 0; i < len; i++)
            {
               info = new SingleItemInfo(data);
               _clothMap.add(info.itemID,info);
            }
            dispatchEvent(new ItemEvent(ItemEvent.CLOTH_LIST));
         });
         SocketConnection.send(CommandID.ITEM_LIST,id,id,2);
      }
      
      private static function onClothList(e:SocketEvent) : void
      {
         var info:SingleItemInfo = null;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onClothList);
         _clothMap.clear();
         var data:ByteArray = e.data as ByteArray;
         var len:uint = data.readUnsignedInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new SingleItemInfo(data);
            _clothMap.add(info.itemID,info);
         }
         dispatchEvent(new ItemEvent(ItemEvent.CLOTH_LIST));
      }
      
      public static function getCollection() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onCollectionList);
         SocketConnection.send(CommandID.ITEM_LIST,300001,500000,2);
      }
      
      public static function containsCollection(id:uint) : Boolean
      {
         return _collectionMap.containsKey(id);
      }
      
      public static function getCollectionInfo(id:uint) : SingleItemInfo
      {
         return _collectionMap.getValue(id);
      }
      
      public static function getCollectionIDs() : Array
      {
         return _collectionMap.getKeys();
      }
      
      public static function getCollectionInfos() : Array
      {
         return _collectionMap.getValues();
      }
      
      public static function upDateCollection(id:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,function(e:SocketEvent):void
         {
            var info:SingleItemInfo = null;
            SocketConnection.removeCmdListener(CommandID.ITEM_LIST,arguments.callee);
            var data:ByteArray = e.data as ByteArray;
            var len:uint = data.readUnsignedInt();
            for(var i:int = 0; i < len; i++)
            {
               info = new SingleItemInfo(data);
               _collectionMap.add(info.itemID,info);
            }
            dispatchEvent(new ItemEvent(ItemEvent.COLLECTION_LIST));
         });
         SocketConnection.send(CommandID.ITEM_LIST,id,id,2);
      }
      
      private static function onCollectionList(e:SocketEvent) : void
      {
         var info:SingleItemInfo = null;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onCollectionList);
         _collectionMap.clear();
         var data:ByteArray = e.data as ByteArray;
         var len:uint = data.readUnsignedInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new SingleItemInfo(data);
            _collectionMap.add(info.itemID,info);
         }
         dispatchEvent(new ItemEvent(ItemEvent.COLLECTION_LIST));
      }
      
      public static function getThrowThing() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onThrowList);
         SocketConnection.send(CommandID.ITEM_LIST,600001,600100,2);
      }
      
      private static function onThrowList(e:SocketEvent) : void
      {
         var info:SingleItemInfo = null;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onThrowList);
         _throwMap.clear();
         var data:ByteArray = e.data as ByteArray;
         var len:uint = data.readUnsignedInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new SingleItemInfo(data);
            _throwMap.add(info.itemID,info);
         }
         dispatchEvent(new ItemEvent(ItemEvent.THROW_LIST));
      }
      
      public static function containsThrow(id:uint) : Boolean
      {
         return _throwMap.containsKey(id);
      }
      
      public static function getThrowInfo(id:uint) : SingleItemInfo
      {
         return _throwMap.getValue(id);
      }
      
      public static function getThrowIDs() : Array
      {
         return _throwMap.getKeys();
      }
      
      public static function getPetItem() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onPetItemList);
         SocketConnection.send(CommandID.ITEM_LIST,300011,300100,2);
      }
      
      private static function onPetItemList(e:SocketEvent) : void
      {
         var info:SingleItemInfo = null;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onPetItemList);
         _petItemMap.clear();
         var data:ByteArray = e.data as ByteArray;
         var len:uint = data.readUnsignedInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new SingleItemInfo(data);
            _petItemMap.add(info.itemID,info);
         }
         dispatchEvent(new ItemEvent(ItemEvent.PET_ITEM_LIST));
      }
      
      public static function containsPetItem(id:uint) : Boolean
      {
         return _petItemMap.containsKey(id);
      }
      
      public static function getPetItemInfo(id:uint) : SingleItemInfo
      {
         return _petItemMap.getValue(id);
      }
      
      public static function getPetItemIDs() : Array
      {
         return _petItemMap.getKeys();
      }
      
      public static function getSoulBead() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_SOUL_BEAD_List,onSoulBeadList);
         SocketConnection.send(CommandID.GET_SOUL_BEAD_List);
      }
      
      private static function onSoulBeadList(evt:SocketEvent) : void
      {
         var obtainTime:uint = 0;
         var itemID:uint = 0;
         var info:SoulBeadItemInfo = null;
         SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_List,arguments.callee);
         _soulBeadMap.clear();
         var by:ByteArray = evt.data as ByteArray;
         var cnt:uint = by.readUnsignedInt();
         for(var i:uint = 0; i < cnt; i++)
         {
            obtainTime = by.readUnsignedInt();
            itemID = by.readUnsignedInt();
            info = new SoulBeadItemInfo();
            info.obtainTime = obtainTime;
            info.itemID = itemID;
            _soulBeadMap.add(obtainTime,info);
         }
         dispatchEvent(new ItemEvent(ItemEvent.SOULBEAD_ITEM_LIST));
      }
      
      public static function containsSoulBead(obtainTime:uint) : Boolean
      {
         return _soulBeadMap.containsKey(obtainTime);
      }
      
      public static function getSoulBeadInfo(obtainTime:uint) : SoulBeadItemInfo
      {
         return _soulBeadMap.getValue(obtainTime);
      }
      
      public static function getSBObtainTms() : Array
      {
         return _soulBeadMap.getKeys();
      }
      
      public static function getSoulBeadInfos() : Array
      {
         return _soulBeadMap.getValues();
      }
      
      public static function getSuper() : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,onSuperList);
         SocketConnection.send(CommandID.ITEM_LIST,100001,500000,2);
      }
      
      public static function containsSuper(id:uint) : Boolean
      {
         return _superMap.containsKey(id);
      }
      
      public static function getSuperInfo(id:uint) : SingleItemInfo
      {
         return _superMap.getValue(id);
      }
      
      public static function getSuperIDs() : Array
      {
         return _superMap.getKeys();
      }
      
      public static function getSuperInfos() : Array
      {
         return _superMap.getValues();
      }
      
      public static function upDateSuper(id:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ITEM_LIST,function(e:SocketEvent):void
         {
            var info:SingleItemInfo = null;
            SocketConnection.removeCmdListener(CommandID.ITEM_LIST,arguments.callee);
            var data:ByteArray = e.data as ByteArray;
            var len:uint = data.readUnsignedInt();
            for(var i:int = 0; i < len; i++)
            {
               info = new SingleItemInfo(data);
               _superMap.add(info.itemID,info);
            }
            dispatchEvent(new ItemEvent(ItemEvent.SUPER_ITEM_LIST));
         });
         SocketConnection.send(CommandID.ITEM_LIST,id,id,2);
      }
      
      private static function onSuperList(e:SocketEvent) : void
      {
         var info:SingleItemInfo = null;
         SocketConnection.removeCmdListener(CommandID.ITEM_LIST,onSuperList);
         _superMap.clear();
         var data:ByteArray = e.data as ByteArray;
         var len:uint = data.readUnsignedInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new SingleItemInfo(data);
            _superMap.add(info.itemID,info);
         }
         dispatchEvent(new ItemEvent(ItemEvent.SUPER_ITEM_LIST));
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getInstance().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         getInstance().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getInstance().hasEventListener(type);
      }
   }
}

